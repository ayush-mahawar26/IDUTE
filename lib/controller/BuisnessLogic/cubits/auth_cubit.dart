import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:idute_app/components/constants/firebase_constants.dart';
import 'package:idute_app/controller/BuisnessLogic/state/auth_states.dart';
import 'package:idute_app/model/user_model.dart';

class AuthCubit extends Cubit<AuthStates> {
  AuthCubit() : super(InitialAuthState());

  final FirebaseAuth _auth = FirebaseConstants.firebaseAuth;
  final FirebaseFirestore _store = FirebaseConstants.store;

  // update user in fireabase
  Future<void> addUserInFirebase(UserModel userModel) async {
    emit(LoadingAuthState());
    try {
      User user = FirebaseConstants.firebaseAuth.currentUser!;
      user.updateDisplayName(userModel.username);
      user.updateEmail(userModel.email!);
      user.updatePhotoURL(userModel.profileImage);

      await FirebaseConstants.store
          .collection("Users")
          .doc(user.uid)
          .set(userModel.toMap(), SetOptions(merge: true));
      emit(DoneAuthState());
    } catch (e) {
      emit(ErrorAuthState(err: e.toString()));
    }
  }

  Future<bool> userExist(String uid) async {
    DocumentSnapshot<Map<String, dynamic>> docSnap =
        await _store.collection("User").doc(uid).get();
    return docSnap.exists;
  }

  // signup user
  Future createUserWithEmailPassword(String email, String password) async {
    emit(LoadingAuthState());
    try {
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = cred.user!;
      UserModel userModel = UserModel(
          email: email,
          createdTime: Timestamp.now(),
          isEmailVerified: false,
          isPhoneVerified: false,
          connects: 0,
          iq: 0,
          groupId: [],
          uid: user.uid);
      await addUserInFirebase(userModel);

      emit(DoneAuthState());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        emit(ErrorAuthState(err: "Password is weak"));
      } else if (e.code == 'email-already-in-use') {
        emit(ErrorAuthState(err: "User Already Exist"));
      }
    } catch (e) {
      emit(ErrorAuthState(err: e.toString()));
    }
  }

  //Login user
  Future loginWithEmailPassword(String email, String pass) async {
    emit(LoadingAuthState());
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: pass);
      emit(DoneAuthState());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'invalid-credential') {
        emit(ErrorAuthState(err: "Invalid email or password"));
      }
    } catch (e) {
      emit(ErrorAuthState(err: e.toString()));
    }
  }
}
