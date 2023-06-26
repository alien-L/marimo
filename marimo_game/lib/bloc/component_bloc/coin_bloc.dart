import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app_manage/local_data_manager.dart';


class CoinBloc extends Cubit<int>{
  CoinBloc(super.initialState);

  // 코인 ui 컨트롤? 다이아몬드 ???

  bool canBuyCoinState(int price){
    if(price < state){
      return true;
    }else{
      return false;
    }
  }

  // 코인 더하기
  void addCoin(){
    emit(state+1);
  }

  // 코인 빼기
  void subtractCoin(int price){
    int tempCoin = state - price;
    emit(tempCoin);
  }


}
