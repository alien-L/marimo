import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app_manage/local_repository.dart';

enum MarimoHpState{level1,level2,level3,level4,level5}

class MarimoHpBloc extends Cubit<int>{
  MarimoHpBloc(super.initialState);


  //  더하기
  void addScore(int addNum){
    emit(state+addNum);
    print("hp hp ==> ${state+addNum}");
    changeLifeCycleToHp();
    updateLocalScore();
  }

  // 빼기
  void subtractScore(int subNum){
    int tempScore = state - subNum;
    emit(tempScore);
    changeLifeCycleToHp();
    updateLocalScore();
  }

  // local 저장소에 갱신하기
  Future<void> updateLocalScore() async {
    await LocalRepository().setKeyValue(
        key: "marimoHp", value: state.toString());

  }

  MarimoHpState changeLifeCycleToHp(){
    MarimoHpState result;
    
   int caseNum = (state/10).round();

   //print("caseNum===> $caseNum");

   if(caseNum<0){
     emit(0);
     // 게임 엔딩 초기화 시키기

    return MarimoHpState.level1;
   }

   if(caseNum>10){
     //컨트롤 추가
     //emit(100);
     caseNum = 10;
     return MarimoHpState.level5;
   }

    switch(caseNum)
    {
      case 10:
        result =  MarimoHpState.level5;
        break;
      case 9: case 8: case 7:
      result =  MarimoHpState.level2;
        break;
      case 6: case 5: case 4:
      result =  MarimoHpState.level4;
        break;
      case 3: case 2: case 1:
      result =  MarimoHpState.level3;
        break;
      case 0:
        result =  MarimoHpState.level1;
        break;
      default:
        result = MarimoHpState.level1;
      break;
    }
      return result;
  }
}
