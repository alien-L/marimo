import 'package:flutter_bloc/flutter_bloc.dart';

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
  void addCoin(int coin){
    emit(state+coin);
  }

  // 코인 빼기
  void subtractCoin(int price){
    int tempCoin = state - price;
    emit(tempCoin);
  }


}
