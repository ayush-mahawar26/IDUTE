import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idute_app/controller/BuisnessLogic/state/bottombar_states.dart';

class LandingPageCubit extends Cubit<LandingPageState> {
  LandingPageCubit()
      : super(
          LandingPageInitial(tabIndex: 0),
        );

  static bool changed = false;

  void toggle(int value) {
    emit(
      LandingPageInitial(tabIndex: value),
    );
  }
}
