import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idute_app/components/constants/firebase_constants.dart';
import 'package:idute_app/controller/BuisnessLogic/state/fetch_group_states.dart';
import 'package:idute_app/controller/group_controller.dart';
import 'package:idute_app/model/group_model.dart';

class FetchGroupCubit extends Cubit<FetchGroupsStates> {
  FetchGroupCubit() : super(FetchGroupInitialState()) {
    getAllGroups();
  }

  getAllGroups() async {
    emit(FetchingGroupState());
    try {
      List<GroupModel> allGroups = await GroupController().getAllGroups();
      emit(FetchedGroupState(groups: allGroups));
    } catch (e) {
      print(e.toString());
      emit(ErrorInFetchGroupState(err: "Connectivity Issue"));
    }
  }

  getByCategories(List<String> categories) async {
    emit(FetchingGroupState());
    try {
      List<GroupModel> groupByCategories =
          await GroupController().fetchGroupOfCategory(categories);
      emit(FetchedGroupState(groups: groupByCategories));
    } catch (e) {
      print(e.toString());
      emit(ErrorInFetchGroupState(err: "Connectivity Issue"));
    }
  }
}
