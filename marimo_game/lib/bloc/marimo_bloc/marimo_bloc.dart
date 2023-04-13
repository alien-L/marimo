import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'marimo_event.dart';

part 'marimo_state.dart';

class MarimoBloc extends Bloc<MarimoEvent, MarimoLevelState> {
  MarimoBloc() : super(const MarimoLevelState.empty()) {
    on<MarimoLevelUpEvent>(
      (event, emit) => emit(
        state.copyWith(marimoLevel: event.marimoLevel, marimoLifeCycle: MarimoLifeCycle.normal),
      ),
    );

    on<MarimoStateChangedEvent>((event, emit) {
    late MarimoLifeCycle marimoLifeCycle;

    if(event.stateScore == 0){
      marimoLifeCycle = MarimoLifeCycle.die;
    }else if(event.stateScore >0 && event.stateScore <=20){
      marimoLifeCycle = MarimoLifeCycle.dangerous;
    }else if(event.stateScore >20 && event.stateScore <=50){
      marimoLifeCycle = MarimoLifeCycle.bad;
    }else if(event.stateScore >50 && event.stateScore <=90){
      marimoLifeCycle = MarimoLifeCycle.normal;
    }else if(event.stateScore >90 && event.stateScore <100){
      marimoLifeCycle = MarimoLifeCycle.good;
    }else if(event.stateScore ==100){
      marimoLifeCycle = MarimoLifeCycle.lucky;
    }else{
      marimoLifeCycle = MarimoLifeCycle.normal;
    }

   emit(state.copyWith(marimoLifeCycle: marimoLifeCycle));

    });
  }
}
