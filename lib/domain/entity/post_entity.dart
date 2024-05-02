// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import '../../components/enums/category_enums.dart';

class PostEntity extends Equatable {
  String? postId;
  String? userId;
  String? problem;
  String? userName;
  String? userProfileUrl;
  String? audio;
  List<String>? validate;
  List<String>? commentsList;
  int? totalValidates;
  int? views;
  int? comments;
  CategoryEnum? category;
  DateTime? createdTime;
  PostEntity({
    this.postId,
    this.views,
    this.userId,
    this.commentsList,
    this.problem,
    this.userName,
    this.userProfileUrl,
    this.audio,
    this.validate,
    this.totalValidates,
    this.comments,
    this.category,
    this.createdTime,
  });

  @override
  List<Object?> get props => [
        postId,
        userId,
        views,
        problem,
        userName,
        userProfileUrl,
        audio,
        commentsList,
        validate,
        totalValidates,
        comments,
        category,
        createdTime,
      ];
}
