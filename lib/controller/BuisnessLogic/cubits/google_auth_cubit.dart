import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:idute_app/components/constants/firebase_constants.dart';
import 'package:idute_app/controller/BuisnessLogic/state/google_auth_state.dart';
import 'package:idute_app/model/user_model.dart';

class GoogleAuthCubit extends Cubit<GoogleAuthStates> {
  GoogleAuthCubit() : super(InitialGoogleAuthState());

  final FirebaseAuth _auth = FirebaseConstants.firebaseAuth;
  final FirebaseFirestore _store = FirebaseConstants.store;

  Future<bool> userExist(String uid) async {
    DocumentSnapshot<Map<String, dynamic>> docSnap =
        await _store.collection("Users").doc(uid).get();
    return docSnap.exists;
  }

  Future updateIntoFirebase(UserModel userModel) async {
    await _store
        .collection("Users")
        .doc(userModel.uid)
        .set(userModel.toMap(), SetOptions(merge: true));
  }

  Future<void> signInUsingGoogle() async {
    emit(LoadingGoogleAuthState());

    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      UserCredential userCred = await _auth.signInWithCredential(credential);

      emit(DoneGoogleAuthState());
    } catch (e) {
      emit(ErrorGoogleAuthState(err: e.toString()));
    }
  }
}
