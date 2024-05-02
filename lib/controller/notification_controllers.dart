import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:idute_app/components/constants/firebase_constants.dart';
import 'package:idute_app/controller/push_notification_controller.dart';
import 'package:idute_app/controller/user_profile_controller.dart';
import 'package:idute_app/domain/entity/post_entity.dart';
import 'package:idute_app/model/group_model.dart';
import 'package:idute_app/model/notification_model.dart';
import 'package:idute_app/model/user_model.dart';

class NotificationControllers {
  final FirebaseFirestore _store = FirebaseConstants.store;
  final FirebaseAuth _auth = FirebaseConstants.firebaseAuth;

  putNotification(NotificationModel notificationModel) async {
    DocumentReference notiDoc = _store
        .collection("Users")
        .doc(notificationModel.userUid)
        .collection("Notifications")
        .doc();
    if (notificationModel.type == "onReact") {
      QuerySnapshot<Map<String, dynamic>> getNotificationSameForPost =
          await _store
              .collection("Users")
              .doc(notificationModel.userUid)
              .collection("Notifications")
              .where("anyUserConnected",
                  isEqualTo: notificationModel.anyUserConnected)
              .where("type", isEqualTo: "onReact")
              .get();
      if (getNotificationSameForPost.docs.isNotEmpty) {
        notificationModel.notificationId =
            getNotificationSameForPost.docs[0].data()["notificationId"];
        await _store
            .collection("Users")
            .doc(notificationModel.userUid)
            .collection("Notifications")
            .doc(notificationModel.notificationId)
            .set(notificationModel.toMap());
      } else {
        notificationModel.notificationId = notiDoc.id;
        await notiDoc.set(notificationModel.toMap());
      }
    } else {
      notificationModel.notificationId = notiDoc.id;
      await notiDoc.set(notificationModel.toMap());
    }
  }

  // notificationOnAcceptInviteInGroup(GroupModel group, String useruid) async {
  //   NotificationModel model = NotificationModel(
  //       userUid: useruid,
  //       notificationTitle: "Your request is Accepted in ${group.title}",
  //       createdAt: Timestamp.now(),
  //       type: "onAcceptRequest");
  //   await putNotification(model);
  // }

  // notificationOnReceiveInviteInGroup(GroupModel group, String useruid) async {
  //   NotificationModel model = NotificationModel(
  //       userUid: useruid,
  //       notificationTitle: "You are invited in ${group.title}",
  //       createdAt: Timestamp.now(),
  //       type: "onSendRequestGroup");
  //   await putNotification(model);
  // }

  createNotificationOnComment(PostEntity post, String byUser) async {
    UserModel? commentedBy =
        await ProfileController().fetchUserProfileByUid(byUser);
    NotificationModel commentNotification = NotificationModel(
        userUid: post.userId!,
        read: false,
        notificationTitle: "${commentedBy!.name!} commented on you post",
        createdAt: Timestamp.now(),
        type: "onComment");
    if (post.userId != _auth.currentUser!.uid) {
      await putNotification(commentNotification);
      await PushNotification()
          .notificationOnComment(post.postId!, post.userId!);
    }
  }

  declineRequest(
      String notificationId, UserModel byUser, UserModel toUser) async {
    // remove notification
    await _store
        .collection("Users")
        .doc(byUser.uid)
        .collection("Notifications")
        .doc(notificationId)
        .delete();

    // remove user request
    await _store
        .collection("Users")
        .doc(byUser.uid)
        .collection("requests")
        .doc(toUser.uid)
        .delete();
  }

  replaceNotification(String notificationId, NotificationModel model) async {
    model.read = false;
    model.notificationId = notificationId;
    await _store
        .collection("Users")
        .doc(model.userUid)
        .collection("Notifications")
        .doc(notificationId)
        .set(model.toMap(), SetOptions(merge: true));
  }

  notificationOnLike(PostEntity post) async {
    UserModel? user = await ProfileController().fetchUserProfile();
    NotificationModel notification = NotificationModel(
        profileUrl: (post.userProfileUrl == null) ? "" : post.userProfileUrl!,
        userUid: post.userId!,
        read: false,
        notificationTitle: "Someone validate your post",
        anyUserConnected: post.postId,
        createdAt: Timestamp.now(),
        type: "onReact");
    if (user!.uid != post.userId) {
      await putNotification(notification);
      await PushNotification().notificationOnValidate(post);
    }
  }

  notificatonOnAcceptInvitationInGroup(
      String acceptOf, GroupModel group) async {
    UserModel? userOfAcceptedOf =
        await ProfileController().fetchUserProfileByUid(acceptOf);
    if (userOfAcceptedOf != null) {
      NotificationModel notificationModel = NotificationModel(
          userUid: acceptOf,
          anyUserConnected: group.groupId,
          read: false,
          notificationTitle: "Your request in accepted in ${group.title}",
          createdAt: Timestamp.now(),
          type: "onAcceptRequestGroup");
      await putNotification(notificationModel);
      await PushNotification()
          .notificationOnAcceptRequestInGroup(group, acceptOf);
    }
  }

  notificationOnRequestInGroup(String reqBy, GroupModel group) async {
    String notificationTo = group.createdBy;
    UserModel? requestedBy =
        await ProfileController().fetchUserProfileByUid(reqBy);

    NotificationModel notificationModel = NotificationModel(
        userUid: notificationTo,
        anyUserConnected: reqBy,
        read: false,
        notificationTitle:
            "${requestedBy!.name} send request to join ${group.title}",
        createdAt: Timestamp.now(),
        type: "onGettingRequestGroup");
    putNotification(notificationModel);
    await PushNotification()
        .notificationOnSomeoneRequestToJoinGroup(requestedBy.uid!, group);
  }

  notificationOnInviteInGroup(
      String invitedby, String invitedTo, GroupModel group) async {
    UserModel? invitedByUser =
        await ProfileController().fetchUserProfileByUid(invitedby);
    NotificationModel notificationModel = NotificationModel(
        read: false,
        userUid: invitedTo,
        anyUserConnected: group.groupId,
        profileUrl: invitedByUser!.profileImage!,
        notificationTitle:
            "${invitedByUser.name} invited you in ${group.title}",
        createdAt: Timestamp.now(),
        type: "onSendRequestGroup");
    await putNotification(notificationModel);
    await PushNotification()
        .notificationOnYouSendRequestToJoinGroup(invitedTo, invitedby, group);
  }

  notificationOnReport(String reportOnUser) async {}

  // notificationOnGettingRequest(String sentByUser, String sendToUser) async {
  //   UserModel? sendBy =
  //       await ProfileController().fetchUserProfileByUid(sentByUser);
  //   NotificationModel notificationModel = NotificationModel(
  //       profileUrl: (sendBy!.profileImage == null) ? "" : sendBy.profileImage!,
  //       userUid: sendToUser,
  //       notificationTitle: "${sendBy.name} requested you to connect",
  //       createdAt: Timestamp.now(),
  //       type: "onGettingRequest");
  //   await putNotification(notificationModel);
  // }

  Future<void> acceptRequest(UserModel reqByUser, UserModel requestToUser,
      {String? notificationId}) async {
    try {
      await _store
          .collection("Users")
          .doc(reqByUser.uid!)
          .collection("connects")
          .doc(requestToUser.uid!)
          .set(requestToUser.toMap(), SetOptions(merge: true));
      await _store
          .collection("Users")
          .doc(requestToUser.uid!)
          .collection("connects")
          .doc(reqByUser.uid!)
          .set(reqByUser.toMap(), SetOptions(merge: true));
      DocumentSnapshot<Map<String, dynamic>> user1connects =
          await _store.collection("Users").doc(reqByUser.uid!).get();
      DocumentSnapshot<Map<String, dynamic>> user2connects =
          await _store.collection("Users").doc(requestToUser.uid!).get();
      int connect1 = user1connects.data()!["connects"];
      int connect2 = user2connects.data()!["connects"];
      await _store
          .collection("Users")
          .doc(reqByUser.uid!)
          .set({"connects": connect1 + 1}, SetOptions(merge: true));
      await _store
          .collection("Users")
          .doc(requestToUser.uid!)
          .set({"connects": connect2 + 1}, SetOptions(merge: true));
      await _store
          .collection("Users")
          .doc(reqByUser.uid)
          .collection("requests")
          .doc(requestToUser.uid)
          .delete();
      await _store
          .collection("Users")
          .doc(reqByUser.uid)
          .collection("requests")
          .doc(requestToUser.uid)
          .delete();

      // print("Ho gaya yaha tk");
      String? id = notificationId;
      print(id);
      await NotificationControllers().notificationOnAcceptRequest(
          reqByUser.uid!, requestToUser.uid!,
          notificationId: id);
    } catch (e) {
      print(e);
    }
  }

  Future<NotificationModel> getNotificationById(
      String notificationId, UserModel updateAtUser) async {
    DocumentSnapshot<Map<String, dynamic>> data = await _store
        .collection("Users")
        .doc(updateAtUser.uid)
        .collection("Notifications")
        .doc(notificationId)
        .get();
    return NotificationModel.fromMap(data.data()!);
  }

  notificationOnAcceptRequest(String reqBy, String reqTo,
      {String? notificationId}) async {
    UserModel? toUser = await ProfileController().fetchUserProfileByUid(reqTo);
    UserModel? byUser = await ProfileController().fetchUserProfileByUid(reqBy);
    print(toUser!.name);
    print(byUser!.name);
    print("creating model");
    NotificationModel notificationForRequestedBy = NotificationModel(
        profileUrl: (toUser.profileImage == null || toUser.profileImage == "")
            ? ""
            : toUser.profileImage!,
        userUid: byUser.uid!,
        read: false,
        anyUserConnected: toUser.uid!,
        notificationTitle: "You accepted the request of ${toUser.name}",
        createdAt: Timestamp.now(),
        type: "onAcceptRequest");
    NotificationModel notificationForRequestedTo = NotificationModel(
        read: false,
        profileUrl: (byUser.profileImage == null || byUser.profileImage == "")
            ? ""
            : byUser.profileImage!,
        userUid: toUser.uid!,
        anyUserConnected: byUser.uid,
        notificationTitle: "Your request is accepted by ${byUser.name}",
        createdAt: Timestamp.now(),
        type: "onAcceptRequest");
    if (notificationId == null) {
      await putNotification(notificationForRequestedTo);
      await putNotification(notificationForRequestedBy);
    } else {
      await putNotification(notificationForRequestedTo);
      await replaceNotification(notificationId, notificationForRequestedBy);
      await PushNotification()
          .notificationOnAcceptRequestPersonal(byUser.uid!, toUser.uid!);
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getAllNotifications(
      String useruid) {
    return _store
        .collection("Users")
        .doc(useruid)
        .collection("Notifications")
        .orderBy("createdAt", descending: true)
        .snapshots();
  }

  notificationOnSendRequest(String touser, String byuser) async {
    UserModel? sendBy = await ProfileController().fetchUserProfileByUid(byuser);
    if (sendBy != null) {
      NotificationModel notificationModel = NotificationModel(
          read: false,
          profileUrl: (sendBy.profileImage == null) ? "" : sendBy.profileImage!,
          userUid: touser,
          notificationTitle: "${sendBy.name} send you connection request",
          createdAt: Timestamp.now(),
          type: "onSendRequest",
          anyUserConnected: sendBy.uid!);
      await putNotification(notificationModel);
      PushNotification().notificationOnYouSendRequestToSomeOne(touser, byuser);
    }
  }
}
