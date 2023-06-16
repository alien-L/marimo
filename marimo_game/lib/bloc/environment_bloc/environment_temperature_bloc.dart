import 'package:flutter_bloc/flutter_bloc.dart';
class EnvironmentTemperatureBloc extends Cubit<double>{
  EnvironmentTemperatureBloc(super.initialState);

  void updateState(double currentValue){
    emit(currentValue);
    updateLocalValue();
  }

  bool isHotWater()=> state >=23;

  //온도 (15-20도 사이 적당 ,
  // 20-23사이 , 35도 넘으면 죽음 )
 // 얼음 추가  - 더운물
  Future<void> updateLocalValue() async {
    // await LocalRepository().setKeyValue(
    //     key: "temperature", value: state.toString());
  }

}