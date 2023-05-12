import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app_manage/local_repository.dart';

class CoinBloc extends Cubit<int>{
  CoinBloc(super.initialState);

  // 코인 ui 컨트롤?

  // 코인 더하기
  void addCoin(){
    emit(state+1);
    updateLocalCoin();
  }

  // 코인 빼기
  void subtractCoin(int price){
    int tempCoin = state - price;
    emit(tempCoin);
    updateLocalCoin();
  }

  // 코인 local 저장소에 갱신하기
  Future<void> updateLocalCoin() async {
    await LocalRepository().setKeyValue(
        key: "coin", value: state.toString());
  }

}
