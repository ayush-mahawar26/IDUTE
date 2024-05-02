import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  String? uid;
  String? username;
  String? email;
  String? phone;
  String? name;
  String? profileImage;
  bool? isEmailVerified;
  bool? isPhoneVerified;
  String? password;
  String? passwordSalt;
  String? category;
  String? qualification;
  String? location;
  String? about;
  int? connects;
  int? iq;
  Timestamp? createdTime;
  List<int>? groupId;
  bool? isProfileCompleted;
  bool? isActive;
  UserEntity({
    this.uid,
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
    this.connects,
    this.iq,
    this.createdTime,
    this.groupId,
    this.isProfileCompleted,
    this.isActive,
  });

  @override
  List<Object?> get props => [
        uid,
        username,
        email,
        phone,
        name,
        profileImage,
        isEmailVerified,
        isPhoneVerified,
        password,
        passwordSalt,
        category,
        qualification,
        location,
        about,
        connects,
        iq,
        createdTime,
        groupId,
        isProfileCompleted,
        isActive,
      ];
}
