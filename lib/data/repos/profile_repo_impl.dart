import 'package:idute_app/data/source/profile_data_source.dart';
import 'package:idute_app/domain/repository/profile_repo.dart';
import 'package:idute_app/model/iq_model.dart';
import 'package:idute_app/model/user_model.dart';

class UserProfileImplementation implements ProfileRepository {
  final ProfileDataSource profileDataSource;

  UserProfileImplementation({required this.profileDataSource});

  @override
  Stream<List<UserModel>> getUserProfile(String userUid) {
    return profileDataSource.getProfile(userUid);
  }

  @override
  Future<void> updateUserProfile(UserModel userModel) {
    return profileDataSource.updateProfile(userModel);
  }

  @override
  Stream<IqModel> getUserIq(String userUid) =>
      profileDataSource.getUserIq(userUid);
}
