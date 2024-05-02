import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:idute_app/model/enums/notification_enum.dart';

NotificationModel notificationModelFromMap(String str) =>
    NotificationModel.fromMap(json.decode(str));

String notificationModelToMap(NotificationModel data) =>
    json.encode(data.toMap());

class NotificationModel {
  String notificationId;
  String profileUrl;
  String userUid;
  String notificationTitle;
  Timestamp createdAt;
  String type;
  String? anyUserConnected;
  bool read;

  NotificationModel({
    this.notificationId = "",
    this.profileUrl = "",
    required this.userUid,
    required this.read,
    required this.notificationTitle,
    required this.createdAt,
    required this.type,
    this.anyUserConnected,
  });

  factory NotificationModel.fromMap(Map<String, dynamic> json) =>
      NotificationModel(
          notificationId: json["notificationId"],
          read: json["read"],
          profileUrl: json["profileUrl"],
          userUid: json["userUid"],
          notificationTitle: json["notificationTitle"],
          createdAt: json["createdAt"],
          anyUserConnected: json["anyUserConnected"],
          type: json["type"]);

  Map<String, dynamic> toMap() => {
        "notificationId": notificationId,
        "userUid": userUid,
        "read": read,
        "profileUrl": profileUrl,
        "notificationTitle": notificationTitle,
        "createdAt": createdAt,
        "anyUserConnected":
            (anyUserConnected == null) ? null : anyUserConnected,
        "type": type
      };
}
