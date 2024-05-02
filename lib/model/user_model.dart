// ignore_for_file: must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:idute_app/domain/entity/user_entity.dart';

class UserModel extends UserEntity {
  String? uid;
  String? username;
  String? email;
  String? phone;
  String? name;
  String? profileImage;
  bool? isEmailVerified;
  bool? isPhoneVerified;
  String? password;
  bool? createdOwnGroup;
  String? passwordSalt;
  bool? isFounder;
  String? category;
  String? qualification;
  String? location;
  String? about;
  int? connects;
  int? iq;
  Timestamp? createdTime;
  List<int>? groupId;
  bool? isProfileCompleted;
  String? startupname;
  bool? isActive;
  UserModel({
    this.uid,
    this.createdOwnGroup = false,
    this.username,
    this.email,
    this.phone,
    this.name,
    this.profileImage,
    this.isEmailVerified,
    this.isPhoneVerified,
    this.password,
    this.passwordSalt,
    this.category,
    this.qualification,
    this.location,
    this.about,
    this.isFounder = false,
    this.startupname = "",
    this.connects,
    this.iq,
    this.createdTime,
    this.groupId,
    this.isProfileCompleted,
    this.isActive,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'username': username,
      'email': email,
      'phone': phone,
      'startupname': startupname,
      'name': name,
      'profileImage': profileImage,
      'isFounder': isFounder,
      'isEmailVerified': isEmailVerified,
      'isPhoneVerified': isPhoneVerified,
      'createdOwnGroup': createdOwnGroup,
      'password': password,
      'passwordSalt': passwordSalt,
      'category': category,
      'qualification': qualification,
      'location': location,
      'about': about,
      'connects': connects,
      'iq': iq,
      'createdTime': createdTime,
      'groupId': groupId,
      'isProfileCompleted': isProfileCompleted,
      'status': isActive,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] != null ? map['uid'] as String : null,
      username: map['username'] != null ? map['username'] as String : null,
      startupname:
          map['startupname'] != null ? map['startupname'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      phone: map['phone'] != null ? map['phone'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      isFounder: map['isFounder'] != null ? map['isFounder'] as bool : null,
      createdOwnGroup: map['createdOwnGroup'] != null
          ? map['createdOwnGroup'] as bool
          : null,
      profileImage:
          map['profileImage'] != null ? map['profileImage'] as String : null,
      isEmailVerified: map['isEmailVerified'] != null
          ? map['isEmailVerified'] as bool
          : null,
      isPhoneVerified: map['isPhoneVerified'] != null
          ? map['isPhoneVerified'] as bool
          : null,
      password: map['password'] != null ? map['password'] as String : null,
      passwordSalt:
          map['passwordSalt'] != null ? map['passwordSalt'] as String : null,
      category: map['category'] != null ? (map['category'] as String) : null,
      qualification:
          map['qualification'] != null ? map['qualification'] as String : null,
      location: map['location'] != null ? map['location'] as String : null,
      about: map['about'] != null ? map['about'] as String : null,
      connects: map['connects'] != null ? map['connects'] as int : null,
      iq: map['iq'] != null ? map['iq'] as int : null,
      createdTime:
          map['createdTime'] != null ? map["createdTime"] as Timestamp : null,
      groupId: map['groupId'] != null ? List<int>.from(map['groupId']) : null,
      isProfileCompleted: map['isProfileCompleted'] != null
          ? map['isProfileCompleted'] as bool
          : null,
      isActive: map['status'] != null ? map['status'] as bool : null,
    );
  }
}
