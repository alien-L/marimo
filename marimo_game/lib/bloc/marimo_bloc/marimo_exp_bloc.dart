import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app_manage/local_repository.dart';
import 'marimo_level_bloc.dart';
enum MarimoExpLifeCycle{dangerous,good,bad,normal,die,lucky}

class MarimoExpBloc extends Cubit<int>{
  MarimoExpBloc(super.initialState);


  //  더하기
  void addScore(int addNum){
    emit(state+addNum);
    updateLocalScore();
  }

  // 빼기
  void subtractScore(int subNum){
    int tempScore = state - subNum;
    emit(tempScore);
    updateLocalScore();
  }

  MarimoExpLifeCycle changeLifeCycleToExp(MarimoLevel level){
    MarimoExpLifeCycle result;
    List expStandardScoreList = _getExpStandardScoreList(level);
    int caseNum = (state/10).round();

    //print("caseNum===> $caseNum");
   // expStandardScoreList
    if(caseNum<0){
      emit(0);
      // 게임 엔딩 초기화 시키기

      return MarimoExpLifeCycle.die;
    }

    if(caseNum>10){
      //컨트롤 추가
      emit(100);
      return MarimoExpLifeCycle.lucky;
    }

    switch(caseNum)
    {
      case 10:
        result =  MarimoExpLifeCycle.lucky;
        break;
      case 9: case 8: case 7:
      result =  MarimoExpLifeCycle.good;
      break;
      case 6: case 5: case 4:
      result =  MarimoExpLifeCycle.normal;
      break;
      case 3: case 2: case 1:
      result =  MarimoExpLifeCycle.bad;
      break;
      case 0:
        result =  MarimoExpLifeCycle.dangerous;
        break;
      case 0:
        result =  MarimoExpLifeCycle.die;
        break;
      default:
        result = MarimoExpLifeCycle.die;
        break;
    }
    return result;
  }
  // local 저장소에 갱신하기
  Future<void> updateLocalScore() async {
    await LocalRepository().setKeyValue(
        key: "marimoExp", value: state.toString());

  }

  _getExpStandardScoreList(MarimoLevel level){
    int total = _getExpTotalCount(level);
    List<int> resultList = [];

    for(var i =1; i<6; i++ ){
      resultList.add(total*i);
    }
    print("@@@@@ resultList==> $resultList");
    return resultList;
  }

  int _getExpTotalCount(MarimoLevel level){
    int result = 0;
    switch (level) {
      case MarimoLevel.baby:
        result = 100;
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

}
