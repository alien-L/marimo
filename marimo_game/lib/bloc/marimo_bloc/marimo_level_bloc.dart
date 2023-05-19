import 'package:flutter_bloc/flutter_bloc.dart';
import '../../app_manage/local_repository.dart';

enum MarimoLevel { baby, child, child2, teenager, adult, oldMan }

enum Villain {cat,shrimp,snail,dog,shark,marooMarimo}

class MarimoLevelBloc extends Cubit<MarimoLevel> {
  MarimoLevelBloc(super.initialState);

  void levelUp(MarimoLevel level) {
    emit(level);
    updateLocalCoin();
  }

  int getExpAmount(MarimoLevel level) {
    int result = 0;

    switch (level) {
      case MarimoLevel.baby:
        result = 10;
        break;
      case MarimoLevel.child:
        result = 1000;
        break;
      case MarimoLevel.child2:
        result = 2000;
        break;
      case MarimoLevel.teenager:
        result = 3000;
        break;
      case MarimoLevel.adult:
        result = 4000;
        break;
      case MarimoLevel.oldMan:
        result = 5000;
        break;
    }

    return result;
  }

  Villain showVillain (MarimoLevel level){
    Villain result;
    switch (level) {
      case MarimoLevel.baby:
        result =  Villain.cat;
        break;
      case MarimoLevel.child:
        result = Villain.marooMarimo;
        break;
      case MarimoLevel.child2:
        result = Villain.snail;
        break;
      case MarimoLevel.teenager:
        result = Villain.dog;
        break;
      case MarimoLevel.adult:
        result = Villain.shrimp;
        break;
      case MarimoLevel.oldMan:
        result = Villain.shark;
        break;
    }
    return result;
  }

  // // local 저장소에 갱신하기
  Future<void> updateLocalCoin() async {
    await LocalRepository()
        .setKeyValue(key: "marimoLevel", value: state.toString());
  }
}
