import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marimo_game/app_manage/local_repository.dart';

part 'marimo_event.dart';

part 'marimo_state.dart';

class MarimoBloc extends Bloc<MarimoEvent, MarimoLevelState> {
  MarimoBloc() : super(const MarimoLevelState.empty()) {
    on<MarimoLevelUpEvent>(
          (event, emit) =>
          emit(
            state.copyWith(marimoLevel: event.marimoLevel,
                marimoLifeCycle: MarimoLifeCycle.normal ,stateScore: 50),
          ),
    );
    on<MarimoStateScoreCalculatedEvent>(getScore);
  }

  Future<void> getScore(MarimoStateScoreCalculatedEvent event,
      Emitter<MarimoLevelState> emit,) async {
    String? marimoStateScoreLocalValue = await LocalRepository().getValue(
        key: "marimoStateScore");
    // if(marimoStateScoreLocalValue == null){
    //   LocalRepository().setKeyValue(key: "marimoStateScore", value: "50");
    // }

    int stateScore = int.parse(marimoStateScoreLocalValue??"50");
    late MarimoLifeCycle marimoLifeCycle;

    bool isPlus = event.isPlus;
    int num = event.score;

    if(isPlus){
      stateScore = stateScore + num;
    }else{
      stateScore = stateScore = num;
    }

     if(stateScore == 0){
       marimoLifeCycle = MarimoLifeCycle.die;
     }else if(stateScore >0 && stateScore <=20){
       marimoLifeCycle = MarimoLifeCycle.dangerous;
     }else if(stateScore >20 && stateScore <=50){
       marimoLifeCycle = MarimoLifeCycle.bad;
     }else if(stateScore >50 && stateScore <=90){
       marimoLifeCycle = MarimoLifeCycle.normal;
     }else if(stateScore >90 && stateScore <100){
       marimoLifeCycle = MarimoLifeCycle.good;
     }else if(stateScore ==100){
       marimoLifeCycle = MarimoLifeCycle.lucky;
     }else{
       marimoLifeCycle = MarimoLifeCycle.normal;
     }

     await LocalRepository().setKeyValue(key: "marimoStateScore", value: "$stateScore");

    print("stateScore ===> $stateScore");
    return emit(state.copyWith(marimoLifeCycle: marimoLifeCycle,stateScore: stateScore));
  }

}



