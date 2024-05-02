// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';

class ReplyEntity extends Equatable {
  String? replyId;
  String? commentId;
  String? postId;
  String? userId;
  String? userName;
  String? userProfileUrl;
  String? reply;
  List<String>? likes;
  DateTime? createdTime;
  ReplyEntity({
    this.replyId,
    this.postId,
    this.commentId,
    this.userId,
    this.userName,
    this.userProfileUrl,
    this.reply,
    this.likes,
    this.createdTime,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
        replyId,
        postId,
        commentId,
        userId,
        userName,
        userProfileUrl,
        reply,
        likes,
        createdTime,
      ];
}
