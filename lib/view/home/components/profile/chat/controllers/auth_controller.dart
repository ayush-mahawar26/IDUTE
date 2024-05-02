// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../model/user_model.dart';
import '../repositories/auth_repository.dart';


final authControllerProvider = Provider(
  (ref) {
    final authRepository = ref.watch(authRepositoryProvider);
    return AuthController(
      authRepository: authRepository,
      ref: ref,
    );
  },
);

final userDataProvider = FutureProvider(
  (ref) {
    final authController = ref.watch(authControllerProvider);
    return authController.getCurrentUserData();
  },
);

class AuthController {
  final AuthRepository authRepository;
  final ProviderRef ref;

  AuthController({
    required this.authRepository,
    required this.ref,
  });

  Future<UserModel?> getCurrentUserData() async {
    UserModel? user = await authRepository.getCurrentUserData();
    return user;
  }

  // void signInWithPhoneNumber(BuildContext context, String phoneNumber) =>
  //     authRepository.signInWithPhoneNumber(context, phoneNumber);

  // void verifyOTP(
  //   BuildContext context,
  //   String verificationId,
  //   String userOTP,
  // ) =>
  //     authRepository.verifyOTP(
  //       context,
  //       verificationId,
  //       userOTP,
  //     );

  // void saveUserDataToFirebase({
  //   required String name,
  //   required File? profilePic,
  //   required BuildContext context,
  // }) =>
  //     authRepository.saveUserDataToFirebase(
  //       name: name,
  //       profilePic: profilePic,
  //       ref: ref,
  //       context: context,
  //     );

  Stream<UserModel> userDataById({required String userId}) =>
      authRepository.userData(userId);

  void userState(bool isOnline) => authRepository.setUserState(isOnline);
}
