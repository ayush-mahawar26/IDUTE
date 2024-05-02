import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:idute_app/components/constants/firebase_constants.dart';
import 'package:idute_app/view/auth/auth_screen.dart';
import 'package:idute_app/view/home/components/profile/settings/components/password_sent.dart';

class FirebaseUtils {
  final FirebaseStorage _storage = FirebaseConstants.storage;
  final FirebaseAuth _auth = FirebaseConstants.firebaseAuth;

  Future<String> addProfileImageToStorage(String path) async {
    final Reference storageRef =
        _storage.ref("UserData/${_auth.currentUser!.uid}/profileImage");
    final TaskSnapshot imgUrl = await storageRef.putFile(File(path));
    final String downloadUrl = await imgUrl.ref.getDownloadURL();

    return downloadUrl;
  }

  signOut(BuildContext context) async {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const AuthView()),
        (route) => false);
    await _auth.signOut();
  }

  changePassword(String email, BuildContext context, bool loggedIn) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => SentPasswordView(
                email: email,
                loggedIn: loggedIn,
              )));
    } catch (e) {}
  }
}
