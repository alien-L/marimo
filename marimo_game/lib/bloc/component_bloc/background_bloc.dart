import 'package:flutter_bloc/flutter_bloc.dart';

enum BackgroundState{normal,red,dirty}

//  물 , 온도 갈아주기  상태 관리

class BackgroundBloc extends Cubit<BackgroundState>{
  BackgroundBloc(super.initialState);

  void changeBackground(String txt){
   // emit(txt);
  }
}
