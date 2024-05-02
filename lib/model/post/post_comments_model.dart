// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable

import 'package:flutter/material.dart';
import 'package:idute_app/domain/entity/comment_entity.dart';

@immutable
class PostCommentsModel extends CommentEntity {
  String? commentId;
  String? postId;
  String? userId;
  String? userName;
  String? userProfileUrl;
  String? comment;
  DateTime? createdTime;
  List<String>? likes;
  int? totalReply;
  PostCommentsModel({
    this.commentId,
    this.postId,
    this.userId,
    this.userName,
    this.userProfileUrl,
    this.comment,
    this.createdTime,
    this.likes,
    this.totalReply,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'commentId': commentId,
      'postId': postId,
      'userId': userId,
      'userName': userName,
      'userProfileUrl': userProfileUrl,
      'comment': comment,
      'createdTime': createdTime?.millisecondsSinceEpoch,
      'likes': likes,
      'totalReply': totalReply,
    };
  }

  factory PostCommentsModel.fromMap(Map<String, dynamic> map) {
    return PostCommentsModel(
      commentId: map['commentId'] != null ? map['commentId'] as String : null,
      postId: map['postId'] != null ? map['postId'] as String : null,
      userId: map['userId'] != null ? map['userId'] as String : null,
      userName: map['userName'] != null ? map['userName'] as String : null,
      userProfileUrl: map['userProfileUrl'] != null
          ? map['userProfileUrl'] as String
          : null,
      comment: map['comment'] != null ? map['comment'] as String : null,
      likes: map['likes'] != null ? List<String>.from(map['likes']) : null,
      createdTime: map['createdTime'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['createdTime'] as int)
          : null,
      totalReply: map['totalReply'] != null ? map['totalReply'] as int : null,
    );
  }
}
