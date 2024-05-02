import 'package:idute_app/model/user_model.dart';

abstract class AuthStates {}

class InitialAuthState extends AuthStates {}

class DoneAuthState extends AuthStates {
  // UserModel userModel;
  // DoneAuthState({required this.userModel});
}

class LoadingAuthState extends AuthStates {}

class ErrorAuthState extends AuthStates {
  String err;
  ErrorAuthState({required this.err});
}
