import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app_manage/local_data_manager.dart';

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
        result = "bg_red";
        break;
    }
    updateLocalBg();
    return result;
  }

  Future<void> updateLocalBg() async {
    await LocalDataManager().setValue<String>(
        key: "background", value: state.toString());
  }
}
