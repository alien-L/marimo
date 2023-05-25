import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app_manage/local_repository.dart';
import 'marimo_level_bloc.dart';
enum MarimoExpState{level1,level2,level3,level4,level5}

class MarimoExpBloc extends Cubit<int>{
  MarimoExpBloc(super.initialState);


  //  더하기
  void addScore(MarimoLevel level,int addNum){
    emit(state+addNum);
    changeLifeCycleToExp(level);
   // print("경험치 레벨@@@@@@@@@@@@@ $state");
    updateLocalScore();
  }

  // 빼기
  void subtractScore(MarimoLevel level,int subNum){
    int tempScore = state - subNum;
    emit(tempScore);
    changeLifeCycleToExp(level);
    updateLocalScore();
  }

  void initState()=> emit(0);

  MarimoExpState changeLifeCycleToExp(MarimoLevel level){
    MarimoExpState result;
    List expStandardScoreList = _getExpStandardScoreList(level);
    //int total = (getExpMaxCount(level)).floor();
    //int caseNum = (state/total).floor();

   // print("state==> $state, caseNum  ===> $caseNum,expStandardScoreList[0]=> ${expStandardScoreList[0]},");
   //expStandardScoreList
   //  if(caseNum<0){
   //    emit(0);
   //    // 게임 엔딩 초기화 시키기
   //
   //    return MarimoExpLifeCycle.die;
   //  }

    // if(caseNum>10){
    //   //컨트롤 추가
    //  // emit(100);
    //   //레벨업 시켜주기
    //  // return MarimoExpLifeCycle.lucky;
    //   caseNum = 10;
    // }

    // switch(caseNum)
    // {
    //   case 10:
    //
    //     result =  MarimoExpState.level5;
    //    // initState();
    //    // emit(0);
    //     break;
    //   case 9: case 8: case 7:
    //   result =  MarimoExpState.level2;
    //   break;
    //   case 6: case 5: case 4:
    //   result =  MarimoExpState.level4;
    //   break;
    //   case 3: case 2: case 1:
    //   result =  MarimoExpState.level3;
    //   break;
    //   case 0:r
    //     result =  MarimoExpState.level1;
    //     break;
    //   default:
    //     result =  MarimoExpState.level1;
    //     break;
    // }

    if (state >= expStandardScoreList[4]) {
      result =  MarimoExpState.level5;
    }else if (state >= 0 && state < expStandardScoreList[0]) {
      result =  MarimoExpState.level1;
    }else if (state >= expStandardScoreList[0] && state < expStandardScoreList[1]) {
      result =  MarimoExpState.level2;
    } else if (state >= expStandardScoreList[1] && state < expStandardScoreList[2]) {
      result =  MarimoExpState.level3;
    } else if (state >= expStandardScoreList[2] && state < expStandardScoreList[3]) {
      result =  MarimoExpState.level4;
    } else if (state >= expStandardScoreList[3] && state < expStandardScoreList[4]) {
      result =  MarimoExpState.level4;
    }else{
      result =  MarimoExpState.level1;
    }
    return result;
  }
  // local 저장소에 갱신하기
  Future<void> updateLocalScore() async {
    await LocalRepository().setKeyValue(
        key: "marimoExp", value: state.toString());

  }

  _getExpStandardScoreList(MarimoLevel level){
    int total = (getExpMaxCount(level)/5).floor();
    List<int> resultList = [];

    for(var i =1; i<6; i++ ){
      resultList.add(total*i);
    //  print("@@@@@ resultList==> ${total*i}");
    }
  //  print("@@@@@ resultList==> $resultList");
    return resultList;
  }

  int getExpMaxCount(MarimoLevel level){
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
