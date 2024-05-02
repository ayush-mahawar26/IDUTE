import 'package:equatable/equatable.dart';

class CommentEntity extends Equatable {
  String? commentId;
  String? postId;
  String? userId;
  String? userName;
  String? userProfileUrl;
  String? comment;
  DateTime? createdTime;
  List<String>? likes;
  int? totalReply;
  CommentEntity({
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
  @override
  List<Object?> get props => [
        commentId,
        postId,
        userId,
        comment,
        createdTime,
        likes,
        totalReply,
      ];
}
