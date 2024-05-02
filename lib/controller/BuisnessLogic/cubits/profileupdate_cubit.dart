import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idute_app/components/constants/firebase_constants.dart';
import 'package:idute_app/controller/BuisnessLogic/state/profile_update_state.dart';
import 'package:idute_app/model/user_model.dart';
import 'package:idute_app/utils/firebase_utils.dart';

class ProfileUpdateCubit extends Cubit<ProfileUpdateStates> {
  ProfileUpdateCubit() : super(ProfileInitialState());

  final FirebaseFirestore _store = FirebaseConstants.store;
  final FirebaseAuth _auth = FirebaseConstants.firebaseAuth;

  updateProfile(UserModel user) async {
    emit(ProfileUpdatingState());
    try {
      await _auth.currentUser!.updateDisplayName(user.name);
      await _auth.currentUser!.updateEmail(user.email!);
      // if (user.profileImage != null) {
      //   String profile =
      //       await FirebaseUtils().addProfileImageToStorage(user.profileImage!);
      //   await _auth.currentUser!.updatePhotoURL(profile);
      // }

      await _store
          .collection("Users")
          .doc(user.uid!)
          .set(user.toMap(), SetOptions(merge: true));
      emit(ProfileUpdatedState());
    } catch (e) {
      emit(ProfileUpdationErrorState(err: e.toString()));
    }
  }
}
