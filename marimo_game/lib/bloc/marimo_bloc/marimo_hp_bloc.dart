import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app_manage/local_repository.dart';

enum MarimoHpLifeCycle{dangerous,good,bad,normal,die,lucky}

class MarimoHpBloc extends Cubit<int>{
  MarimoHpBloc(super.initialState);


  //  더하기
  void addScore(int addNum){
    emit(state+addNum);
    print("hp hp ==> ${state+addNum}");
    updateLocalScore();
  }

  // 빼기
  void subtractScore(int subNum){
    int tempScore = state - subNum;
    emit(tempScore);
    updateLocalScore();
  }

  // local 저장소에 갱신하기
  Future<void> updateLocalScore() async {
    await LocalRepository().setKeyValue(
        key: "marimoHp", value: state.toString());

  }

  MarimoHpLifeCycle changeLifeCycleToHp(){
    MarimoHpLifeCycle result;
    
   int caseNum = (state/10).round();

   //print("caseNum===> $caseNum");

   if(caseNum<0){
     emit(0);
     // 게임 엔딩 초기화 시키기

    return MarimoHpLifeCycle.die;
   }

   if(caseNum>10){
     //컨트롤 추가
     emit(100);
     return MarimoHpLifeCycle.lucky;
   }

    switch(caseNum)
    {
      case 10:
        result =  MarimoHpLifeCycle.lucky;
        break;
      case 9: case 8: case 7:
      result =  MarimoHpLifeCycle.good;
        break;
      case 6: case 5: case 4:
      result =  MarimoHpLifeCycle.normal;
        break;
      case 3: case 2: case 1:
      result =  MarimoHpLifeCycle.bad;
        break;
      case 0:
        result =  MarimoHpLifeCycle.dangerous;
        break;
      case 0:
        result =  MarimoHpLifeCycle.die;
        break;
      default:
        result = MarimoHpLifeCycle.die;
      break;
    }
      return result;
  }

  // Future<void> updateLocalLifeCycle(MarimoHpLifeCycle _marimoHpLifeCycle) async {
  //   await LocalRepository().setKeyValue(
  //       key: "marimoLifeCycle", value: _marimoHpLifeCycle.toString());
  // }

}
