import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app_manage/local_repository.dart';

class EnvironmentTrashBloc extends Cubit<bool>{
  EnvironmentTrashBloc(super.initialState);

  void updateState(bool currentValue){
    emit(currentValue);
    updateLocalValue();
  }

  //먹이(하루에 한번)
  //많이 줄 경우 어항 드러워짐 , 어항 청소기 - 먹이
  Future<void> updateLocalValue() async {
    await LocalRepository().setKeyValue(
        key: "isCleanTrash", value: state.toString());
  }

}