import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:idute_app/components/constants/firebase_constants.dart';
import 'package:idute_app/controller/notification_controllers.dart';
import 'package:idute_app/model/user_model.dart';

class ConnectionController {
  final FirebaseAuth _auth = FirebaseConstants.firebaseAuth;
  final FirebaseFirestore _store = FirebaseConstants.store;

  Stream isAlreadyConnectionSent(String toUser, String byUser) {
    return _store
        .collection("Users")
        .doc(toUser)
        .collection("requests")
        .where("uid", isEqualTo: byUser)
        .snapshots();
  }

  Future<void> unconnect(String user1, String user2) async {
    try {
      await _store
          .collection("Users")
          .doc(user1)
          .collection("connects")
          .doc(user2)
          .delete();
      await _store
          .collection("Users")
          .doc(user2)
          .collection("connects")
          .doc(user1)
          .delete();
      DocumentSnapshot<Map<String, dynamic>> user1connects =
          await _store.collection("Users").doc(user1).get();
      DocumentSnapshot<Map<String, dynamic>> user2connects =
          await _store.collection("Users").doc(user2).get();
      int connect1 = user1connects.data()!["connects"];
      int connect2 = user2connects.data()!["connects"];
      await _store
          .collection("Users")
          .doc(user1)
          .set({"connects": connect1 - 1}, SetOptions(merge: true));
      await _store
          .collection("Users")
          .doc(user2)
          .set({"connects": connect2 - 1}, SetOptions(merge: true));
    } catch (e) {
      print(e);
    }
  }

  Stream areWeConnected(String user1, String user2) {
    return _store
        .collection("Users")
        .doc(user1)
        .collection("connects")
        .where("uid", isEqualTo: user2)
        .snapshots();
  }

  Stream isAlreadyConnected(String touser, String byuser) {
    return _store
        .collection("Users")
        .doc(touser)
        .collection("connects")
        .where("uid", isEqualTo: byuser)
        .snapshots();
  }

  Stream isThatSentReqToMe(String myUid, String userUid) {
    return _store
        .collection("Users")
        .doc(myUid)
        .collection("requests")
        .where("uid", isEqualTo: userUid)
        .snapshots();
  }

  Future<void> sendRequest(String touser, UserModel byUser) async {
    try {
      await _store
          .collection("Users")
          .doc(touser)
          .collection("requests")
          .doc(byUser.uid)
          .set(byUser.toMap(), SetOptions(merge: true));
      // create notification for touser
      NotificationControllers().notificationOnSendRequest(touser, byUser.uid!);
    } catch (e) {
      print(e);
    }
  }

  Future<void> acceptRequest(UserModel user1, UserModel user2) async {
    try {
      await _store
          .collection("Users")
          .doc(user1.uid!)
          .collection("connects")
          .doc(user2.uid!)
          .set(user2.toMap(), SetOptions(merge: true));
      await _store
          .collection("Users")
          .doc(user2.uid!)
          .collection("connects")
          .doc(user1.uid!)
          .set(user1.toMap(), SetOptions(merge: true));
      DocumentSnapshot<Map<String, dynamic>> user1connects =
          await _store.collection("Users").doc(user1.uid!).get();
      DocumentSnapshot<Map<String, dynamic>> user2connects =
          await _store.collection("Users").doc(user2.uid!).get();
      int connect1 = user1connects.data()!["connects"];
      int connect2 = user2connects.data()!["connects"];
      await _store
          .collection("Users")
          .doc(user1.uid!)
          .set({"connects": connect1 + 1}, SetOptions(merge: true));
      await _store
          .collection("Users")
          .doc(user2.uid!)
          .set({"connects": connect2 + 1}, SetOptions(merge: true));
      await _store
          .collection("Users")
          .doc(user1.uid)
          .collection("requests")
          .doc(user2.uid)
          .delete();
      await _store
          .collection("Users")
          .doc(user2.uid)
          .collection("requests")
          .doc(user1.uid)
          .delete();
      NotificationControllers()
          .notificationOnAcceptRequest(user1.uid!, user2.uid!);
    } catch (e) {
      print(e);
    }
  }
}
