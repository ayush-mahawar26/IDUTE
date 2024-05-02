import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:idute_app/components/constants/firebase_constants.dart';
import 'package:idute_app/data/source/profile_data_source.dart';
import 'package:idute_app/model/iq_model.dart';
import 'package:idute_app/model/user_model.dart';

class ProfileDataSourceImplementation implements ProfileDataSource {
  final FirebaseAuth _auth = FirebaseConstants.firebaseAuth;
  final FirebaseFirestore _store = FirebaseConstants.store;

  @override
  Stream<List<UserModel>> getProfile(String useruid) {
    final profile = _store.collection("User").where("uid", isEqualTo: useruid);

    return profile.snapshots().map((event) {
      List<UserModel> user = [];
      for (var document in event.docs) {
        user.add(UserModel.fromMap(document.data()));
      }

      return user;
    });
  }

  @override
  Future<void> updateProfile(UserModel user) async {
    _auth.currentUser!.updateDisplayName(user.name!);
    _auth.currentUser!.updatePhotoURL(user.profileImage);
    await _store
        .collection("Users")
        .doc(user.uid)
        .set(user.toMap(), SetOptions(merge: true));
  }

  @override
  Stream<IqModel> getUserIq(String uid) {
    final iq = _store.collection("iq").doc(uid);

    return iq.snapshots().map((event) {
      IqModel iq = IqModel.fromMap(event.data()!);
      return iq;
    });
  }
}
