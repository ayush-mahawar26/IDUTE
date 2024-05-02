import 'package:idute_app/model/group_model.dart';

abstract class FetchGroupsStates {}

class FetchGroupInitialState extends FetchGroupsStates {}

class FetchingGroupState extends FetchGroupsStates {}

class FetchedGroupState extends FetchGroupsStates {
  List<GroupModel> groups;
  FetchedGroupState({required this.groups});
}

class ErrorInFetchGroupState extends FetchGroupsStates {
  String err;
  ErrorInFetchGroupState({required this.err});
}
