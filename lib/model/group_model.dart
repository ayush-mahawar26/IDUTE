// To parse this JSON data, do
//
//     final groupModel = groupModelFromMap(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

GroupModel groupModelFromMap(String str) =>
    GroupModel.fromMap(json.decode(str));

String groupModelToMap(GroupModel data) => json.encode(data.toMap());

class GroupModel {
  String? groupId;
  String title;
  String description;
  Timestamp createdAt;
  String category;
  int level;
  String createdBy;
  String createdByName;
  String groupImg;

  GroupModel({
    this.groupId,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.category,
    required this.level,
    required this.createdBy,
    required this.createdByName,
    required this.groupImg,
  });

  factory GroupModel.fromMap(Map<String, dynamic> json) => GroupModel(
        groupId: (json["groupId"] == null) ? null : json["groupId"],
        title: json["title"],
        description: json["description"],
        createdAt: json["createdAt"],
        category: json["category"],
        level: json["level"],
        createdBy: json["createdBy"],
        createdByName: json["createdByName"],
        groupImg: json["groupImg"],
      );

  Map<String, dynamic> toMap() => {
        "groupId": groupId,
        "title": title,
        "description": description,
        "createdAt": createdAt,
        "category": category,
        "level": level,
        "createdBy": createdBy,
        "createdByName": createdByName,
        "groupImg": groupImg,
      };
}
