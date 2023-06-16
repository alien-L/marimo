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
  void addCoin(){
    emit(state+10);
//    _updateLocalCoin();
  }

  // 코인 빼기
  void subtractCoin(int price){
    int tempCoin = state - price;
    emit(tempCoin);
  //  _updateLocalCoin();
  }

  // 코인 local 저장소에 갱신하기
  // Future<void> _updateLocalCoin() async {
  //   await LocalRepository().setKeyValue(
  //       key: "coin", value: state.toString());
  // }
  //


}
