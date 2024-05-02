import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../model/user_model.dart';


final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
    auth: FirebaseAuth.instance,
    firestore: FirebaseFirestore.instance,
  ),
);

class AuthRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  AuthRepository({
    required this.auth,
    required this.firestore,
  });

  Future<UserModel?> getCurrentUserData() async {
    var userData =
        await firestore.collection('users').doc(auth.currentUser?.uid).get();

    UserModel? user;
    if (userData.data() != null) {
      user = UserModel.fromMap(userData.data()!);
    }
    return user;
  }

  // void signInWithPhoneNumber(BuildContext context, String phoneNumber) async {
  //   try {
  //     await auth.verifyPhoneNumber(
  //       phoneNumber: phoneNumber,
  //       verificationCompleted: (phoneAuthCredential) async {
  //         await auth.signInWithCredential(phoneAuthCredential);
  //       },
  //       verificationFailed: (error) {
  //         throw Exception(error.message);
  //       },
  //       codeSent: (verificationId, forceResendingToken) async {
  //         await Navigator.pushNamed(context, otpRoute,
  //             arguments: {'verificationId': verificationId});
  //       },
  //       codeAutoRetrievalTimeout: (verificationId) {},
  //     );
  //   } on FirebaseAuthException catch (e) {
  //     showSnackBar(context: context, content: e.message!);
  //   }
  // }

  // void verifyOTP(
  //   BuildContext context,
  //   String verificationId,
  //   String userOTP,
  // ) async {
  //   try {
  //     PhoneAuthCredential credential = PhoneAuthProvider.credential(
  //       verificationId: verificationId,
  //       smsCode: userOTP,
  //     );
  //     await auth.signInWithCredential(credential);
  //     Navigator.of(context)
  //         .pushNamedAndRemoveUntil(userInfoRoute, (route) => false);
  //   } on FirebaseAuthException catch (e) {
  //     showSnackBar(context: context, content: e.message!);
  //   }
  // }

  // void saveUserDataToFirebase({
  //   required String name,
  //   required File? profilePic,
  //   required ProviderRef ref,
  //   required BuildContext context,
  // }) async {
  //   try {
  //     String uid = auth.currentUser!.uid;
  //     String photoUrl = 'assets/images/profile_img.png';

  //     if (profilePic != null) {
  //       photoUrl = await ref
  //           .read(firebaseStorageRepositoryProvider)
  //           .storeFileToFirebase(
  //             'profilePic/$uid',
  //             profilePic,
  //           );
  //     }

  //     var user = UserModel(
  //       name: name,
  //       uid: uid,
  //       profilePic: photoUrl,
  //       isOnline: true,
  //       phoneNumber: auth.currentUser!.phoneNumber!,
  //       groupId: [],
  //     );

  //     firestore.collection('users').doc(uid).set(user.toMap());

  //     Navigator.of(context)
  //         .pushNamedAndRemoveUntil(mobileLayoutRoute, (route) => false);
  //   } catch (e) {
  //     showSnackBar(context: context, content: e.toString());
  //   }
  // }

  Stream<UserModel> userData(String userId) {
    return firestore.collection('users').doc(userId).snapshots().map(
          (event) => UserModel.fromMap(
            event.data()!,
          ),
        );
  }

  void setUserState(bool isOnline) async {
    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .update({'isOnline': isOnline});
  }
}
