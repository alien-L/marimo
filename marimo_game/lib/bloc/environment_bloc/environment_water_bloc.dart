import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app_manage/local_repository.dart';

class EnvironmentWaterBloc extends Cubit<bool>{
  EnvironmentWaterBloc(super.initialState);

  void updateState(bool currentValue){
    emit(currentValue);
    updateLocalValue();
  }

  // 물 ( 물 갈아주기 7일에 1번 )
  //기간 체크해서 물 갈아주기 버튼 추가  - 썩은 물
  Future<void> updateLocalValue() async {
    await LocalRepository().setKeyValue(
        key: "isCleanWater", value: state.toString());
  }

}