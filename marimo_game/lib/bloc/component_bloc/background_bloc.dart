import 'package:flutter_bloc/flutter_bloc.dart';

enum BackgroundState { normal, red, }
//
//  물 , 온도 갈아주기  상태 관리

class BackgroundBloc extends Cubit<BackgroundState> {
  BackgroundBloc(super.initialState);

  void backgroundChange(BackgroundState backgroundState) =>
      emit(backgroundState);

  String getBackgroundName() {
    String result = '';

    switch (state) {
      case BackgroundState.normal:
        result = "bg";
        break;
      case BackgroundState.red:
        result = "background_01_red";
        break;
    }
   // _updateLocalBg();
    return result;
  }

  // Future<void> _updateLocalBg() async {
  //   await LocalRepository().setKeyValue(
  //       key: "background", value: state.toString());
  // }
}
