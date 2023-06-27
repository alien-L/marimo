import 'package:flutter_bloc/flutter_bloc.dart';

enum MarimoExpState{exp1,exp2,exp3,exp4,exp5}

class MarimoExpBloc extends Cubit<int>{
  MarimoExpBloc(super.initialState);

  void addScore(int marimoLevel,int addNum){
    emit(state+addNum);
    changeLifeCycleToExp(marimoLevel);
  }

  void initState()=> emit(0);

  MarimoExpState changeLifeCycleToExp(int marimoLevel){
    MarimoExpState result;
    List expStandardScoreList = _getExpStandardScoreList(marimoLevel);
    if (state >= expStandardScoreList[4]) {
      result =  MarimoExpState.exp5;
    }else if (state >= 0 && state < expStandardScoreList[0]) {
      result =  MarimoExpState.exp1;
    }else if (state >= expStandardScoreList[0] && state < expStandardScoreList[1]) {
      result =  MarimoExpState.exp2;
    } else if (state >= expStandardScoreList[1] && state < expStandardScoreList[2]) {
      result =  MarimoExpState.exp3;
    } else if (state >= expStandardScoreList[2] && state < expStandardScoreList[3]) {
      result =  MarimoExpState.exp4;
    } else if (state >= expStandardScoreList[3] && state < expStandardScoreList[4]) {
      result =  MarimoExpState.exp4;
    }else{
      result =  MarimoExpState.exp1;
    }
    return result;
  }

  _getExpStandardScoreList(int marimoLevel){
    int total = (maxExp(marimoLevel)~/5);
    List<int> resultList = [total*1,total*2,total*3,total*4,total*5];
    return resultList;
  }

  int maxExp(int marimoLevel) {
    return marimoLevel * 1000;
  }


}
