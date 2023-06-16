import 'package:flutter_bloc/flutter_bloc.dart';

class EnemyBloc extends Cubit<bool>{
  EnemyBloc(super.initialState);

  showEnemy(){
    emit(true);
    updateEnemyState();
  }

  hideEnemy(){
    emit(false);
    updateEnemyState();
  }

  // local 저장소에 갱신하기
  Future<void> updateEnemyState() async {
    // await LocalRepository().setKeyValue(
    //     key: "isCheckedEnemy", value: state?'0':'1');

  }
}