import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app_manage/local_repository.dart';

class VillainBloc extends Cubit<bool>{
  VillainBloc(super.initialState);

  showVillain(){
    emit(true);
    updateVillainState();
  }

  hideVillain(){
    emit(false);
    updateVillainState();
  }

  // local 저장소에 갱신하기
  Future<void> updateVillainState() async {
    await LocalRepository().setKeyValue(
        key: "isCheckedVillain", value: state?'0':'1');

  }
}