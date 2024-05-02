import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idute_app/controller/BuisnessLogic/state/iq_state.dart';
import 'package:idute_app/domain/usecases/profile_usercase.dart';
import 'package:idute_app/model/iq_model.dart';

class IqCubit extends Cubit<IqStates> {
  GetIqOfUserUseCase getUserIqUseCase;
  IqCubit({required this.getUserIqUseCase}) : super(IqInitialState());

  Future<void> getIqOfUser(String useruid) async {
    emit(GettingIq());
    try {
      final iqStreamResponse = getUserIqUseCase.call(useruid);
      iqStreamResponse.listen((event) {
        emit(FetchedIq(model: event));
      });
    } catch (e) {
      emit(ErrorIq(err: e.toString()));
    }
  }
}
