import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app_manage/local_repository.dart';

class MarimoScoreBloc extends Cubit<int>{
  MarimoScoreBloc(super.initialState);


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

  // local 저장소에 갱신하기
  Future<void> updateLocalScore() async {
    await LocalRepository().setKeyValue(
        key: "marimoScore", value: state.toString());

  }

}
