import 'package:flutter_bloc/flutter_bloc.dart';
import 'marimo_bloc.dart';
enum MarimoExpState{level1,level2,level3,level4,level5}

class MarimoExpBloc extends Cubit<int>{
  MarimoExpBloc(super.initialState);

  void addScore(MarimoLevel level,int addNum){
    emit(state+addNum);
    changeLifeCycleToExp(level);
    updateLocalScore();
  }

  void initState()=> emit(0);

  MarimoExpState changeLifeCycleToExp(MarimoLevel level){
    MarimoExpState result;
    List expStandardScoreList = _getExpStandardScoreList(level);
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
    // await LocalRepository().setKeyValue(
    //     key: "marimoExp", value: state.toString());

  }

  _getExpStandardScoreList(MarimoLevel level){
    int total = (getExpMaxCount(level)/5).floor();
    List<int> resultList = [total*1,total*2,total*3,total*4,total*5];
    // 계속 반복되는거 체크
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
