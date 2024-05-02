import 'package:idute_app/model/iq_model.dart';
import 'package:idute_app/model/user_model.dart';

abstract class ProfileRepository {
  // User Profile Data
  Stream<List<UserModel>> getUserProfile(String userUid);
  Future<void> updateUserProfile(UserModel userModel);

  // Iq
  Stream<IqModel> getUserIq(String userUid);
}
