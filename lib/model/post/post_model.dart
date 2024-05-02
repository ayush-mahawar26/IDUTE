// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
import 'dart:convert';

import 'package:idute_app/components/enums/category_enums.dart';
import 'package:idute_app/domain/entity/post_entity.dart';

class PostModel extends PostEntity {
  String? postId;
  String? userId;
  String? problem;
  String? userName;
  String? userProfileUrl;
  String? audio;
  List<String>? validate;
  List<String>? commentsList = [];
  int? totalValidates;
  int? views;
  int? comments;
  CategoryEnum? category;
  DateTime? createdTime;
  PostModel({
    this.postId,
    this.userId,
    this.problem,
    this.commentsList,
    this.userName,
    this.userProfileUrl,
    this.audio,
    this.validate,
    this.totalValidates,
    this.comments,
    this.category,
    this.createdTime,
    this.views,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'postId': postId,
      'userId': userId,
      'commentsList': commentsList,
      'problem': problem,
      'userName': userName,
      'userProfileUrl': userProfileUrl,
      'audio': audio,
      'views': views,
      'validate': validate,
      'totalValidates': totalValidates,
      'comments': comments,
      'category': category?.category,
      'createdTime': createdTime?.millisecondsSinceEpoch,
    };
  }

  // factory PostModel.fromSnapshot(DocumentSnapshot snap) {
  //   var snapshot = snap.data() as Map<String, dynamic>;

  //   return PostModel(
  //     postId: snapshot['postId'],
  //     userId: snapshot['userId'],
  //     problem: snapshot['problem'],
  //     audio: snapshot['audio'],
  //     totalValidates: snapshot['totalValidates'],
  //     comments: snapshot['comments'],
  //     category: snapshot['category'],
  //     createdTime: snapshot['createdTime'],
  //     l: List.from(snap.get("validate")),
  //   );
  // }

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      postId: map['postId'] != null ? map['postId'] as String : null,
      userId: map['userId'] != null ? map['userId'] as String : null,
      problem: map['problem'] != null ? map['problem'] as String : null,
      userName: map['userName'] != null ? map['userName'] as String : null,
      userProfileUrl: map['userProfileUrl'] != null
          ? map['userProfileUrl'] as String
          : null,
      audio: map['audio'] != null ? map['audio'] as String : null,
      views: map['views'] != null ? map['views'] as int : null,
      validate:
          map['validate'] != null ? List<String>.from(map['validate']) : null,
      commentsList: map['commentsList'] != null
          ? List<String>.from(map['commentsList'])
          : null,
      totalValidates:
          map['totalValidates'] != null ? map['totalValidates'] as int : null,
      comments: map['comments'] != null ? map['comments'] as int : null,
      category: map['category'] != null
          ? (map['category'] as String).toCategoryEnum()
          : null,
      createdTime: map['createdTime'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['createdTime'] as int)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PostModel.fromJson(String source) =>
      PostModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
