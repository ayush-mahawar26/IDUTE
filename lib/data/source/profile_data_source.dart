import 'package:firebase_auth/firebase_auth.dart';
import 'package:idute_app/model/iq_model.dart';
import 'package:idute_app/model/user_model.dart';

abstract class ProfileDataSource {
  Stream<List<UserModel>> getProfile(String useruid);
  Future<void> updateProfile(UserModel user);

  Stream<IqModel> getUserIq(String uid);
}
