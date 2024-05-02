import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:idute_app/components/constants/firebase_constants.dart';
import 'package:idute_app/controller/notification_controllers.dart';
import 'package:idute_app/controller/push_notification_controller.dart';
import 'package:idute_app/controller/user_profile_controller.dart';
import 'package:idute_app/model/group_model.dart';
import 'package:idute_app/model/notification_model.dart';
import 'package:idute_app/model/user_model.dart';

class GroupController {
  final FirebaseAuth _auth = FirebaseConstants.firebaseAuth;
  final FirebaseFirestore _firestore = FirebaseConstants.store;

  Future<void> addNewGroup(GroupModel groupModel, UserModel userModel) async {
    DocumentReference groupRef =
        _firestore.collection("Groups").doc(); // group id
    groupModel.groupId = groupRef.id;
    await _firestore
        .collection("Users")
        .doc(userModel.uid!)
        .set({"createdOwnGroup": true}, SetOptions(merge: true));
    await groupRef.set(groupModel.toMap(), SetOptions(merge: true));
    await groupRef
        .collection("members")
        .doc(userModel.uid)
        .set(userModel.toMap(), SetOptions(merge: true));

    await _firestore
        .collection("Users")
        .doc(_auth.currentUser!.uid)
        .collection("Groups")
        .doc(groupRef.id)
        .set(groupModel.toMap(), SetOptions(merge: true));

    // await groupRef.collection("members").doc(groupModel.createdBy).set({
    //   // set The information of users
    //   "isFounder": true
    // });
  }

  updateLevelOfGroup(GroupModel group, int level) async {
    await _firestore
        .collection("Groups")
        .doc(group.groupId)
        .set({"level": level}, SetOptions(merge: true));
  }

  Future<List<GroupModel>> getAllGroups() async {
    QuerySnapshot<Map<String, dynamic>> allGroups =
        await _firestore.collection("Groups").get();
    List<GroupModel>? groupModel = [];
    for (int i = 0; i < allGroups.docs.length; i++) {
      if (allGroups.docs[i].data()["createdBy"] != _auth.currentUser!.uid) {
        QuerySnapshot<Map<String, dynamic>> allmembers =
            await allGroups.docs[i].reference.collection("members").get();
        List<String> allMembersList = [];
        for (int mem = 0; mem < allmembers.docs.length; mem++) {
          allMembersList.add(allmembers.docs[mem].id);
        }
        // print(allMembersList);
        if (!allMembersList.contains(_auth.currentUser!.uid)) {
          groupModel.add(GroupModel.fromMap(allGroups.docs[i].data()));
        }
      }
    }

    return groupModel;
  }

  Future<List<GroupModel>> fetchGroupOfCategory(List<String> category) async {
    List<GroupModel> groupsOfcategory = [];
    QuerySnapshot<Map<String, dynamic>> groups =
        await _firestore.collection("Groups").get();

    for (int i = 0; i < groups.docs.length; i++) {
      if (category.contains(groups.docs[i].data()["category"]) &&
          groups.docs[i].data()["createdBy"] != _auth.currentUser!.uid) {
        groupsOfcategory.add(GroupModel.fromMap(groups.docs[i].data()));
      }
    }
    return groupsOfcategory;
  }

  Future<List<GroupModel>> groupByUser(String userUid) async {
    print(_auth.currentUser!.uid);
    QuerySnapshot<Map<String, dynamic>> groups = await _firestore
        .collection("Groups")
        .where("createdBy", isEqualTo: _auth.currentUser!.uid)
        .get();

    List<GroupModel> groupByUser = [];
    for (int i = 0; i < groups.docs.length; i++) {
      groupByUser.add(GroupModel.fromMap(groups.docs[i].data()));
    }
    return groupByUser;
  }

  Future<void> createRequestForGroup(String userUid, GroupModel group) async {
    UserModel? user = await ProfileController().fetchUserProfileByUid(userUid);
    if (user != null) {
      await _firestore
          .collection("Groups")
          .doc(group.groupId)
          .collection("requests")
          .doc(userUid)
          .set(user.toMap(), SetOptions(merge: true));
      NotificationControllers().notificationOnRequestInGroup(user.uid!, group);
    }
  }

  Future<void> sendInviteToUser(
      String invitedBy, UserModel user, GroupModel group) async {
    print("invited");
    await _firestore
        .collection("Groups")
        .doc(group.groupId)
        .collection("requested")
        .doc(user.uid)
        .set(user.toMap(), SetOptions(merge: true));
    await NotificationControllers()
        .notificationOnInviteInGroup(invitedBy, user.uid!, group);
  }

  Future<void> declineRquestForGroup(
      UserModel user, GroupModel group, NotificationModel model) async {
    await _firestore
        .collection("Groups")
        .doc(group.groupId)
        .collection("requested")
        .doc(user.uid!)
        .delete();
    await _firestore
        .collection("User")
        .doc(user.uid!)
        .collection("Notifications")
        .doc(model.notificationId)
        .delete();
  }

  Future<void> completeGroupDiscussion(GroupModel model) async {
    QuerySnapshot<Map<String, dynamic>> members = await _firestore
        .collection("Groups")
        .doc(model.groupId)
        .collection("members")
        .get();

    for (int i = 0; i < members.docs.length; i++) {
      String userid = members.docs[i].id;
      await _firestore
          .collection("Users")
          .doc(userid)
          .collection("Groups")
          .doc(model.groupId)
          .delete();
    }
    await _firestore
        .collection("Users")
        .doc(model.createdBy)
        .collection("completedidea")
        .doc(model.groupId)
        .set(model.toMap(), SetOptions(merge: true));
    await _firestore.collection("Groups").doc(model.groupId).delete();
    await _firestore
        .collection("Users")
        .doc(model.createdBy)
        .set({"createdOwnGroup": false}, SetOptions(merge: true));
  }

  Future<void> acceptInviteForGroup(
      UserModel user, GroupModel group, NotificationModel notification) async {
    await _firestore
        .collection("Groups")
        .doc(group.groupId)
        .collection("requested")
        .doc(user.uid!)
        .delete();

    await _firestore
        .collection("Users")
        .doc(user.uid)
        .collection("Groups")
        .doc(group.groupId)
        .set(group.toMap(), SetOptions(merge: true));

    await _firestore
        .collection("Groups")
        .doc(group.groupId)
        .collection("members")
        .doc(user.uid!)
        .set(user.toMap(), SetOptions(merge: true));

    NotificationModel newNotification = NotificationModel(
        read: false,
        userUid: user.uid!,
        notificationTitle: "You are now the member of ${group.title}",
        createdAt: Timestamp.now(),
        type: "onAcceptRequestGroup");
    await NotificationControllers()
        .replaceNotification(notification.notificationId, newNotification);
    // await PushNotification()
    //     .notificationOnSomeoneAcceptedGroupInvite(user.uid!, group);
  }

  Future<bool> checkForRequestAlreadySent(
      String userUid, GroupModel group) async {
    DocumentSnapshot<Map<String, dynamic>> userInfo = await _firestore
        .collection("Groups")
        .doc(group.groupId!)
        .collection("requests")
        .doc(userUid)
        .get();
    return userInfo.exists;
  }

  Future<void> acceptRequestForSomeone(GroupModel group, String useruid) async {
    UserModel? user = await ProfileController().fetchUserProfileByUid(useruid);
    if (user != null) {
      await _firestore
          .collection("Groups")
          .doc(group.groupId)
          .collection("members")
          .doc(useruid)
          .set(user.toMap(), SetOptions(merge: true));
      await _firestore
          .collection("Users")
          .doc(useruid)
          .collection("Groups")
          .doc(group.groupId)
          .set(group.toMap());
      await _firestore
          .collection("Groups")
          .doc(group.groupId)
          .collection("requests")
          .doc(useruid)
          .delete();
      await NotificationControllers()
          .notificatonOnAcceptInvitationInGroup(useruid, group);
    }
  }

  Future<void> declineTheRequestForSomeOne(
      String groupId, String userUid) async {
    UserModel? user = await ProfileController().fetchUserProfileByUid(userUid);
    if (user != null) {
      await _firestore
          .collection("Groups")
          .doc(groupId)
          .collection("requests")
          .doc(userUid)
          .delete();
    }
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>>
      getAllTheMemberOfGroup(String groupId) async {
    QuerySnapshot<Map<String, dynamic>> members = await _firestore
        .collection("Groups")
        .doc(groupId)
        .collection("members")
        .get();

    return members.docs;
  }

  Future<GroupModel> getGroupById(String groupId) async {
    DocumentSnapshot<Map<String, dynamic>> groupData =
        await _firestore.collection("Groups").doc(groupId).get();

    GroupModel group = GroupModel.fromMap(groupData.data()!);

    return group;
  }

  Future<void> deleteGroup(String groupId) async {
    await _firestore.collection("Groups").doc(groupId).delete();
  }
}
