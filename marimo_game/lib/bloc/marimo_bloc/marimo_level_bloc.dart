import 'package:flutter_bloc/flutter_bloc.dart';
import '../../app_manage/local_repository.dart';

enum MarimoLevel{baby,child,child2,teenager,adult,oldMan}

class MarimoLevelBloc extends Cubit<MarimoLevel>{
  MarimoLevelBloc(super.initialState);


  void levelUp(MarimoLevel level){
    emit(level);
    updateLocalCoin();
  }

  // // local 저장소에 갱신하기
  Future<void> updateLocalCoin() async {
    await LocalRepository().setKeyValue(
        key: "marimoLevel", value: state.toString());
  }

}
