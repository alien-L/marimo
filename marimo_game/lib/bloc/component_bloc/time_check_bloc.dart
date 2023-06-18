import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app_manage/local_data_manager.dart';

class TimeCheckBloc extends Cubit<bool>{
  TimeCheckBloc(super.initialState);
  LocalDataManager localDataManager = LocalDataManager();
  // 시간차 계산하는 로직 추가 -- 하루 출석 체크 나중에

  // 코인 , 환경변화 체크
  // 환경변화 그대로 놔두면 시간 계산 (하루) 경험치 --마이너스

  Future<void> checkForTomorrow() async {
    // 하루만 넘었는지 안넘었는지 체크
    // day가 똑같으면 false , 다르면 무조건 true
    bool? isFirstInstall = await localDataManager.getIsFirstInstall();
    if(isFirstInstall){
      emit(true);
    }else{
      final startDay = DateTime.now().day;
      final endDay = await localDataManager.getValue<int>(key: "endDay");
      if(endDay == null){
        emit(true);
      }else{
        final result = startDay != endDay;
        emit(result);
      }
    }
    //2번 불러지는 것도 체크
  }

  Future<void> updateLocalLastTime(DateTime dateTime) async {
    final endDay =  await localDataManager.getValue<int>(key:"endDay");
    final value = dateTime.day == endDay;
     await localDataManager.setValue<bool>(key: "isToday", value: value);
  }

}