import 'package:flutter_bloc/flutter_bloc.dart';
class EnvironmentTrashBloc extends Cubit<bool>{
  EnvironmentTrashBloc(super.initialState);

  void updateState(bool currentValue){
    emit(currentValue);
    updateLocalValue();
  }

  //먹이(하루에 한번) , 물갈아주기 추가
  //많이 줄 경우 어항 드러워짐 , 어항 청소기 - 먹이
  Future<void> updateLocalValue() async {
    // await LocalRepository().setKeyValue(
    //     key: "isCleanTrash", value: state?"0":"1");  // null 또는 0이면 true , 1이면 false
  }

}