import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app_manage/local_repository.dart';

class EnvironmentHumidityBloc extends Cubit<int>{
  EnvironmentHumidityBloc(super.initialState);

  void updateState(int currentValue){
    emit(currentValue);
    updateLocalValue();
  }

  bool goMoldy()=> state>=70;// 습도 (40%~70%) ,  습기 제거제 - 곰팡이

  Future<void> updateLocalValue() async {
    await LocalRepository().setKeyValue(
        key: "humidity", value: state.toString());
  }

}