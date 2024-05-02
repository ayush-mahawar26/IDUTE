import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:idute_app/components/constants/firebase_constants.dart';
import 'package:idute_app/controller/group_controller.dart';
import 'package:idute_app/controller/user_profile_controller.dart';
import 'package:idute_app/domain/entity/post_entity.dart';
import 'package:idute_app/model/group_model.dart';
import 'package:idute_app/model/post/post_model.dart';
import 'package:idute_app/model/user_model.dart';

import "package:http/http.dart" as http;
import 'package:idute_app/view/home/components/main/components/card_details.dart';
import 'package:idute_app/view/home/components/profile/group/mystartup_groupinfo.dart';
import 'package:idute_app/view/profile/profile_screen_widget.dart';
import 'package:idute_app/view/profile/visit_profile.dart';

class PushNotification {
  final FirebaseAuth _auth = FirebaseConstants.firebaseAuth;
  final FirebaseFirestore _store = FirebaseConstants.store;

  handleNotificationNavigation(
      BuildContext context, RemoteMessage message) async {
    if (message.data.containsKey("useruid")) {
      UserModel? user = await ProfileController()
          .fetchUserProfileByUid(message.data["useruid"]);
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => VisitUserProfile(userModel: user!)));
    }
    if (message.data.containsKey("groupid")) {
      GroupModel group =
          await GroupController().getGroupById(message.data["groupid"]);
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => MyStartUpGroupInfo(groupInfo: group)));
    }
    if (message.data.containsKey("postid")) {
      DocumentSnapshot<Map<String, dynamic>> post = await FirebaseConstants
          .store
          .collection("posts")
          .doc(message.data["postid"])
          .get();
      PostModel userPost = PostModel.fromMap(post.data()!);
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => CardDetails(
              post: userPost,
              currentUid: FirebaseConstants.firebaseAuth.currentUser!.uid,
              index: 1)));
    }
  }

  notificationOnValidate(PostEntity post) async {
    DocumentSnapshot<Map<String, dynamic>> docSnapshot =
        await _store.collection("Users").doc(post.userId).get();
    String fcmToken = docSnapshot.data()!["fcm"];
    var data = {
      'to': fcmToken,
      'priority': 'high',
      'notification': {'title': 'Idute', 'body': 'Someone validate your post'},
      'data': {'type': 'onReact', 'postid': post.postId}
    };
    if (fcmToken.isNotEmpty) {
      await http.post(Uri.parse("https://fcm.googleapis.com/fcm/send"),
          body: jsonEncode(data),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization':
                'key=AAAAJb8TQDk:APA91bGhYq69Uz6acFnHB0DEs-8Ne6YyM1kSZrTyUuKBartGAKghGnFnqWK9M5FMNjJy4RvhTYH3_hIz601Qmz1ay8eGRWa0lZsY6GmbGBMGyOsPEF079mfxnJxMfFAhN07RfGn9R_Wd'
          });
    }
  }

  notificationOnYouSendRequestToSomeOne(
      String reqSentTo, String reqSendBy) async {
    UserModel? user =
        await ProfileController().fetchUserProfileByUid(reqSendBy);
    DocumentSnapshot<Map<String, dynamic>> docSnapshot =
        await _store.collection("Users").doc(reqSentTo).get();
    String fcmToken = docSnapshot.data()!["fcm"];
    var data = {
      'to': fcmToken,
      'priority': 'high',
      'notification': {
        'title': 'Idute',
        'body': '${user!.name} sent you connection request.'
      },
      'data': {'type': "onSendRequest", "useruid": reqSendBy}
    };
    if (fcmToken.isNotEmpty) {
      await http.post(Uri.parse("https://fcm.googleapis.com/fcm/send"),
          body: jsonEncode(data),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization':
                'key=AAAAJb8TQDk:APA91bGhYq69Uz6acFnHB0DEs-8Ne6YyM1kSZrTyUuKBartGAKghGnFnqWK9M5FMNjJy4RvhTYH3_hIz601Qmz1ay8eGRWa0lZsY6GmbGBMGyOsPEF079mfxnJxMfFAhN07RfGn9R_Wd'
          });
    }
  }

  notificationOnSomeoneAcceptedGroupInvite(
      String acceptedByUser, GroupModel group) async {
    UserModel? user =
        await ProfileController().fetchUserProfileByUid(acceptedByUser);
    DocumentSnapshot<Map<String, dynamic>> docSnapshot =
        await _store.collection("Users").doc(group.createdBy).get();
    String fcmToken = docSnapshot.data()!["fcm"];
    var data = {
      'to': fcmToken,
      'priority': 'high',
      'notification': {
        'title': 'Idute',
        'body': '${user!.name} accept invite in ${group.title}'
      },
      'data': {'type': "onAcceptRequestGroup", "useruid": acceptedByUser}
    };

    if (fcmToken.isNotEmpty) {
      await http.post(Uri.parse("https://fcm.googleapis.com/fcm/send"),
          body: jsonEncode(data),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization':
                'key=AAAAJb8TQDk:APA91bGhYq69Uz6acFnHB0DEs-8Ne6YyM1kSZrTyUuKBartGAKghGnFnqWK9M5FMNjJy4RvhTYH3_hIz601Qmz1ay8eGRWa0lZsY6GmbGBMGyOsPEF079mfxnJxMfFAhN07RfGn9R_Wd'
          });
    }
  }

  notificationOnSomeoneRequestToJoinGroup(
      String requestBy, GroupModel group) async {
    UserModel? user =
        await ProfileController().fetchUserProfileByUid(requestBy);
    DocumentSnapshot<Map<String, dynamic>> docSnapshot =
        await _store.collection("Users").doc(group.createdBy).get();
    String fcmToken = docSnapshot.data()!["fcm"];
    var data = {
      'to': fcmToken,
      'priority': 'high',
      'notification': {
        'title': 'Idute',
        'body': '${user!.username} sent request to join ${group.title}'
      },
      'data': {'type': "onSendRequestGroup", "useruid": user.uid}
    };
    if (fcmToken.isNotEmpty) {
      await http.post(Uri.parse("https://fcm.googleapis.com/fcm/send"),
          body: jsonEncode(data),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization':
                'key=AAAAJb8TQDk:APA91bGhYq69Uz6acFnHB0DEs-8Ne6YyM1kSZrTyUuKBartGAKghGnFnqWK9M5FMNjJy4RvhTYH3_hIz601Qmz1ay8eGRWa0lZsY6GmbGBMGyOsPEF079mfxnJxMfFAhN07RfGn9R_Wd'
          });
    }
  }

  notificationOnYouSendRequestToJoinGroup(
      String reqSentTo, String reqSendBy, GroupModel group) async {
    UserModel? user =
        await ProfileController().fetchUserProfileByUid(reqSendBy);
    DocumentSnapshot<Map<String, dynamic>> docSnapshot =
        await _store.collection("Users").doc(reqSentTo).get();
    String fcmToken = docSnapshot.data()!["fcm"];
    var data = {
      'to': fcmToken,
      'priority': 'high',
      'notification': {
        'title': 'Idute',
        'body': '${user!.name} sent you request to join ${group.title}.'
      },
      'data': {'type': "onSendRequestGroup", "useruid": reqSendBy}
    };
    if (fcmToken.isNotEmpty) {
      await http.post(Uri.parse("https://fcm.googleapis.com/fcm/send"),
          body: jsonEncode(data),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization':
                'key=AAAAJb8TQDk:APA91bGhYq69Uz6acFnHB0DEs-8Ne6YyM1kSZrTyUuKBartGAKghGnFnqWK9M5FMNjJy4RvhTYH3_hIz601Qmz1ay8eGRWa0lZsY6GmbGBMGyOsPEF079mfxnJxMfFAhN07RfGn9R_Wd'
          });
    }
  }

  notificationOnAcceptRequestPersonal(
      String acceptedBy, String acceptedOf) async {
    UserModel? user =
        await ProfileController().fetchUserProfileByUid(acceptedBy);
    DocumentSnapshot<Map<String, dynamic>> docSnapshot =
        await _store.collection("Users").doc(acceptedOf).get();

    String fcmToken = docSnapshot.data()!["fcm"];
    var data = {
      'to': fcmToken,
      'priority': 'high',
      'notification': {
        'title': 'Idute',
        'body': '${user!.name} accepted your connection request.'
      },
      'data': {'type': "onAcceptRequest", "useruid": acceptedBy}
    };
    if (fcmToken.isNotEmpty) {
      await http.post(Uri.parse("https://fcm.googleapis.com/fcm/send"),
          body: jsonEncode(data),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization':
                'key=AAAAJb8TQDk:APA91bGhYq69Uz6acFnHB0DEs-8Ne6YyM1kSZrTyUuKBartGAKghGnFnqWK9M5FMNjJy4RvhTYH3_hIz601Qmz1ay8eGRWa0lZsY6GmbGBMGyOsPEF079mfxnJxMfFAhN07RfGn9R_Wd'
          });
    }
  }

  notificationOnAcceptRequestInGroup(GroupModel group, String useruid) async {
    DocumentSnapshot<Map<String, dynamic>> docSnapshot =
        await _store.collection("Users").doc(useruid).get();

    String fcmToken = docSnapshot.data()!["fcm"];
    var data = {
      'to': fcmToken,
      'priority': 'high',
      'notification': {
        'title': 'Idute',
        'body': 'Your request is accepted in ${group.title}.'
      },
      'data': {'type': "onAcceptRequestGroup", "groupid": group.groupId}
    };
    if (fcmToken.isNotEmpty) {
      await http.post(Uri.parse("https://fcm.googleapis.com/fcm/send"),
          body: jsonEncode(data),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization':
                'key=AAAAJb8TQDk:APA91bGhYq69Uz6acFnHB0DEs-8Ne6YyM1kSZrTyUuKBartGAKghGnFnqWK9M5FMNjJy4RvhTYH3_hIz601Qmz1ay8eGRWa0lZsY6GmbGBMGyOsPEF079mfxnJxMfFAhN07RfGn9R_Wd'
          });
    }
  }

  notificationOnComment(String postId, String commentOn) async {
    DocumentSnapshot<Map<String, dynamic>> docSnapshot =
        await _store.collection("Users").doc(commentOn).get();

    String fcmToken = docSnapshot.data()!["fcm"];
    var data = {
      'to': fcmToken,
      'priority': 'high',
      'notification': {
        'title': 'Idute',
        'body': 'Someone commented on your post'
      },
      'data': {'type': "onComment", "postid": postId}
    };
    if (fcmToken.isNotEmpty) {
      await http.post(Uri.parse("https://fcm.googleapis.com/fcm/send"),
          body: jsonEncode(data),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization':
                'key=AAAAJb8TQDk:APA91bGhYq69Uz6acFnHB0DEs-8Ne6YyM1kSZrTyUuKBartGAKghGnFnqWK9M5FMNjJy4RvhTYH3_hIz601Qmz1ay8eGRWa0lZsY6GmbGBMGyOsPEF079mfxnJxMfFAhN07RfGn9R_Wd'
          });
    }
  }
}
