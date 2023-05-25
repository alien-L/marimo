import 'package:flutter_bloc/flutter_bloc.dart';
import '../../app_manage/local_repository.dart';

enum MarimoLevel { zero,baby, child, child2, teenager, adult, oldMan }

enum Villain {cat,shrimp,snail,dog,shark,marooMarimo}

class MarimoLevelBloc extends Cubit<MarimoLevel> {
  MarimoLevelBloc(super.initialState);

  void levelUp(MarimoLevel level) {
    emit(level);
    print("level up ===> $level");
    updateLocalLevel();
  }

  Villain? showVillain (MarimoLevel level){
  //  Villain? result;
    switch (level) {
      case MarimoLevel.baby:
        return Villain.cat;
        break;
      case MarimoLevel.child:
        return  Villain.marooMarimo;
        break;
      case MarimoLevel.child2:
        return  Villain.snail;
        break;
      case MarimoLevel.teenager:
        return  Villain.dog;
        break;
      case MarimoLevel.adult:
        return  Villain.shrimp;
        break;
      case MarimoLevel.oldMan:
        return  Villain.shark;
        break;
    }
    //return result;
  }

  // // local 저장소에 갱신하기
  Future<void> updateLocalLevel() async {
    await LocalRepository()
        .setKeyValue(key: "marimoLevel", value: state.toString());
  }

  // @override
  // void addError(Object error, [StackTrace? stackTrace]) {
  //   // TODO: implement addError
  // }
  //
  // @override
  // Future<void> close() {
  //   // TODO: implement close
  //   throw UnimplementedError();
  // }
  //
  // @override
  // void emit(MarimoLevel state) {
  //   // TODO: implement emit
  // }
  //
  // @override
  // // TODO: implement isClosed
  // bool get isClosed => throw UnimplementedError();

  @override
  void onChange(Change<MarimoLevel> change) {
    var cu = change.currentState;
    var next = change.nextState;
    print("change ===> $cu , $next");
    // TODO: implement onChange
  }

  // @override
  // void onError(Object error, StackTrace stackTrace) {
  //   // TODO: implement onError
  // }
  //
  // @override
  // // TODO: implement state
  // MarimoLevel get state => throw UnimplementedError();
  //
  // @override
  // // TODO: implement stream
  // Stream<MarimoLevel> get stream => throw UnimplementedError();
}
