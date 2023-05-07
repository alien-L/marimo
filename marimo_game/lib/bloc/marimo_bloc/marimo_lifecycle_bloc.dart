import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app_manage/local_repository.dart';

enum MarimoLifeCycle{dangerous,good,bad,normal,die,lucky}

class MarimoLifeCycleBloc extends Cubit<MarimoLifeCycle>{
  MarimoLifeCycleBloc(super.initialState);

  void changeLifeCycle(MarimoLifeCycle lifeCycle){
    emit(lifeCycle);
    updateLocalLifeCycle();
  }

  void changeLifeCycleToScore(int stateScore){

   // MarimoLifeCycle marimoLifeCycle;
    if (stateScore == 0) {
    //  marimoLifeCycle = MarimoLifeCycle.bad;
    } else if (stateScore > 0 && stateScore <= 15) {
    //  marimoLifeCycle = MarimoLifeCycle.bad;
      emit(MarimoLifeCycle.dangerous);
    } else if (stateScore > 20 && stateScore <= 50) {
    //  marimoLifeCycle = MarimoLifeCycle.dangerous;
      emit(MarimoLifeCycle.bad);
    } else if (stateScore > 50 && stateScore <= 60) {
   //   marimoLifeCycle = MarimoLifeCycle.normal;
      emit(MarimoLifeCycle.normal);
    } else if (stateScore > 70 && stateScore <= 90) {
   //   marimoLifeCycle = MarimoLifeCycle.good;
      emit(MarimoLifeCycle.good);
    } else if (stateScore > 90 && stateScore <= 100) {
   //   marimoLifeCycle = MarimoLifeCycle.lucky;
      emit(MarimoLifeCycle.lucky);
    }else {
    //  marimoLifeCycle = MarimoLifeCycle.normal;
    }

  //  emit(marimoLifeCycle);
    print("$stateScore @@@@@@@@@@@@state ====> $state");
    updateLocalLifeCycle();
  }

  // // local 저장소에 갱신하기
  Future<void> updateLocalLifeCycle() async {
    await LocalRepository().setKeyValue(
        key: "marimoLifeCycle", value: state.toString());
  }

}