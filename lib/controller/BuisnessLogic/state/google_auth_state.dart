abstract class GoogleAuthStates {}

class InitialGoogleAuthState extends GoogleAuthStates {}

class DoneGoogleAuthState extends GoogleAuthStates {
  // UserModel userModel;
  // DoneAuthState({required this.userModel});
}

class LoadingGoogleAuthState extends GoogleAuthStates {}

class ErrorGoogleAuthState extends GoogleAuthStates {
  String err;
  ErrorGoogleAuthState({required this.err});
}
