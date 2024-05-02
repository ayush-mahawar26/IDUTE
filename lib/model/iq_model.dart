// To parse this JSON data, do
//
//     final iqModel = iqModelFromMap(jsonString);

import 'dart:convert';

class IqModel {
  int postCount;
  int validationCount;
  int commentCount;
  int replyCount;
  int likeOnCommentCount;
  int likeOnReplyCount;
  int connectionCount;
  int connectionWithHigherIq;

  IqModel({
    required this.postCount,
    required this.validationCount,
    required this.commentCount,
    required this.replyCount,
    required this.likeOnCommentCount,
    required this.likeOnReplyCount,
    required this.connectionCount,
    required this.connectionWithHigherIq,
  });

  factory IqModel.fromMap(Map<String, dynamic> json) => IqModel(
        postCount: json["postCount"],
        validationCount: json["validationCount"],
        commentCount: json["commentCount"],
        replyCount: json["ReplyCount"],
        likeOnCommentCount: json["likeOnCommentCount"],
        likeOnReplyCount: json["likeOnReplyCount"],
        connectionCount: json["connectionCount"],
        connectionWithHigherIq: json["connectionWithHigherIq"],
      );

  Map<String, dynamic> toMap() => {
        "postCount": postCount,
        "validationCount": validationCount,
        "commentCount": commentCount,
        "ReplyCount": replyCount,
        "likeOnCommentCount": likeOnCommentCount,
        "likeOnReplyCount": likeOnReplyCount,
        "connectionCount": connectionCount,
        "connectionWithHigherIq": connectionWithHigherIq,
      };
}
