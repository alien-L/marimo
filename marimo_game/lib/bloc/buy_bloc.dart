import 'package:flutter_bloc/flutter_bloc.dart';

class BuyBloc extends Cubit<bool>{
  BuyBloc(super.initialState);

  buyItem()=>emit(true);

}