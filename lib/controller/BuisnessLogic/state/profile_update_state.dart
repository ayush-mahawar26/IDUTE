abstract class ProfileUpdateStates {}

class ProfileInitialState extends ProfileUpdateStates {}

class ProfileUpdatedState extends ProfileUpdateStates {}

class ProfileUpdationErrorState extends ProfileUpdateStates {
  String err;
  ProfileUpdationErrorState({required this.err});
}

class ProfileUpdatingState extends ProfileUpdateStates {}
