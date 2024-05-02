// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:idute_app/domain/entity/reply_entity.dart';

class CommentRepliesModel extends ReplyEntity {
  String? replyId;
  String? commentId;
  String? postId;
  String? userId;
   String? userName;
  String? userProfileUrl;
  String? reply;
  List<String>? likes;
  DateTime? createdTime;
  CommentRepliesModel({
    this.replyId,
    this.commentId,
    this.postId,
    this.userId,
    this.userName,
    this.userProfileUrl, 
    this.reply,
    this.likes,
    this.createdTime,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'replyId': replyId,
      'commentId': commentId,
      'postId': postId,
      'userId': userId,
      'userName': userName,
      'userProfileUrl': userProfileUrl,
      'reply': reply,
      'likes': likes,
      'createdTime': createdTime?.millisecondsSinceEpoch,
    };
  }

  factory CommentRepliesModel.fromMap(Map<String, dynamic> map) {
    return CommentRepliesModel(
      replyId: map['replyId'] != null ? map['replyId'] as String : null,
      commentId: map['commentId'] != null ? map['commentId'] as String : null,
      postId: map['postId'] != null ? map['postId'] as String : null,
      userId: map['userId'] != null ? map['userId'] as String : null,
    userName: map['userName'] != null ? map['userName'] as String : null,
      userProfileUrl: map['userProfileUrl'] != null
          ? map['userProfileUrl'] as String
          : null,
             reply: map['reply'] != null ? map['reply'] as String : null,
      likes: map['likes'] != null ? List<String>.from((map['likes'])) : null,
      createdTime: map['createdTime'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['createdTime'] as int)
          : null,
    );
  }

  CommentRepliesModel copyWith({
    String? replyId,
    String? commentId,
    String? postId,
    String? userId,
    String? reply,
    List<String>? likes,
    DateTime? createdTime,
  }) {
    return CommentRepliesModel(
      replyId: replyId ?? this.replyId,
      commentId: commentId ?? this.commentId,
      postId: postId ?? this.postId,
      userId: userId ?? this.userId,
      reply: reply ?? this.reply,
      likes: likes ?? this.likes,
      createdTime: createdTime ?? this.createdTime,
    );
  }

  String toJson() => json.encode(toMap());

  factory CommentRepliesModel.fromJson(String source) =>
      CommentRepliesModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CommentRepliesModel(replyId: $replyId, commentId: $commentId, postId: $postId, userId: $userId, reply: $reply, likes: $likes, createdTime: $createdTime)';
  }

  @override
  bool operator ==(covariant CommentRepliesModel other) {
    if (identical(this, other)) return true;

    return other.replyId == replyId &&
        other.commentId == commentId &&
        other.postId == postId &&
        other.userId == userId &&
        other.reply == reply &&
        listEquals(other.likes, likes) &&
        other.createdTime == createdTime;
  }

  @override
  int get hashCode {
    return replyId.hashCode ^
        commentId.hashCode ^
        postId.hashCode ^
        userId.hashCode ^
        reply.hashCode ^
        likes.hashCode ^
        createdTime.hashCode;
  }
}
