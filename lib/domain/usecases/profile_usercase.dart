import 'package:idute_app/domain/repository/profile_repo.dart';
import 'package:idute_app/model/iq_model.dart';
import 'package:idute_app/model/user_model.dart';

class UserProfileUseCase {
  final ProfileRepository repo;

  UserProfileUseCase({required this.repo});

  Stream<List<UserModel>> call(String userUid) {
    return repo.getUserProfile(userUid);
  }
}

class UpdateUserProfile {
  final ProfileRepository repo;

  UpdateUserProfile({required this.repo});
  Future<void> call(UserModel usermodel) {
    return repo.updateUserProfile(usermodel);
  }
}

class GetIqOfUserUseCase {
  final ProfileRepository repo;

  GetIqOfUserUseCase({required this.repo});
  Stream<IqModel> call(String useruid) {
    return repo.getUserIq(useruid);
  }
}
