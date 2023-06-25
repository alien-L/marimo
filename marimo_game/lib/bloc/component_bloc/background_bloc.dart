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
   // updateLocalBg();
    return result;
  }

  Future<void> updateLocalBg() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    GameDataInfo gameDataInfo = GameDataInfo();
    gameDataInfo.background = state.toString();
   // gameDataInfo.endDay =
   //  gameDataInfo.endDay =
   //  gameDataInfo.marimoAppearanceState =
   //  gameDataInfo.marimoExp =
   //  gameDataInfo.coin =
   //  gameDataInfo.isCheckedOnOffSound =
   //  gameDataInfo.humidity =
   //  gameDataInfo.temperature =
   //  gameDataInfo.isToday =
   //  gameDataInfo.marimoLevel =
    prefs.setString("gameDataInfo", json.encode(gameDataInfo));
    // final SharedPreferences prefs = await SharedPreferences.getInstance();
    //
    // Map<String, dynamic> gameDataInfoMap = {};
    // final String? gameDataInfoStr = prefs.getString('gameDataInfo');
    // if (gameDataInfoStr != null) {
    //   gameDataInfoMap = jsonDecode(gameDataInfoStr) as Map<String, dynamic>;
    //  // gameDataInfoMap["background"] =
    // }
    // await LocalDataManager().setValue<String>(
    //    key: 'gameDataInfo', value: state.toString());
  //  final SharedPreferences prefs = await SharedPreferences.getInstance();
   // prefs.
   // GameDataInfo.fromJson(json);
    //await prefs.setString(key, jsonEncode(modelData));
  }
}
