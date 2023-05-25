import 'package:flutter_bloc/flutter_bloc.dart';
import '../../app_manage/local_repository.dart';

enum MarimoLevel { zero,baby, child, child2, teenager, adult, oldMan }

enum Villain {cat,shrimp,snail,dog,shark,marooMarimo}

class MarimoLevelBloc extends Cubit<MarimoLevel> {
  MarimoLevelBloc(super.initialState);

  void levelUp(MarimoLevel level) {
    emit(level);
    updateLocalLevel();
  }

  Villain? showVillain (MarimoLevel level){
    switch (level) {
      case MarimoLevel.baby:
        return Villain.cat;
      case MarimoLevel.child:
        return  Villain.marooMarimo;
      case MarimoLevel.child2:
        return  Villain.snail;
      case MarimoLevel.teenager:
        return  Villain.dog;
      case MarimoLevel.adult:
        return  Villain.shrimp;
      case MarimoLevel.oldMan:
        return  Villain.shark;
    }
  }

  // // local 저장소에 갱신하기
  Future<void> updateLocalLevel() async {
    await LocalRepository()
        .setKeyValue(key: "marimoLevel", value: state.toString());
  }

}
