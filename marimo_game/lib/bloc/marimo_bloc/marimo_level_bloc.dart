import 'package:flutter_bloc/flutter_bloc.dart';

class MarimoLevelBloc extends Cubit<int> {
  MarimoLevelBloc(super.initialState);

  levelUp() => emit(state + 1);


  // 로컬 저장 관리
}
