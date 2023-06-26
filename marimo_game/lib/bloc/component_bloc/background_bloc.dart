import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../app_manage/local_data_manager.dart';
import '../../model/game_data_info.dart';

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
    return result;
  }

}
