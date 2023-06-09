import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../app_manage/local_repository.dart';

enum MarimoLevel { zero, baby, child, child2, teenager, adult, oldMan }

enum MarimoEmotion { normal, cry }

enum Villain { cat, shrimp, snail, dog, shark, marooMarimo }

class MarimoBloc extends Bloc<MarimoEvent, MarimoState> {
  MarimoBloc(super.initialState) {
    on<MarimoLevelChanged>((event, emit) {
      emit(MarimoState(
          marimoLevel: event.marimoLevel, marimoEmotion: state.marimoEmotion));
      updateLocalLevel(event.marimoLevel.name);
    });
    on<MarimoEmotionChanged>((event, emit) {
      emit(MarimoState(
          marimoLevel: state.marimoLevel, marimoEmotion: event.marimoEmotion));
      updateEmotion(event.marimoEmotion.name);
    });
  }

  Future<void> updateLocalLevel(String level) async {
    await LocalRepository().setKeyValue(key: "marimoLevel", value: level);
  }

  Future<void> updateEmotion(String emotion) async {
    await LocalRepository().setKeyValue(key: "marimoEmotion", value: emotion);
  }
}

class MarimoState extends Equatable {
  final MarimoLevel marimoLevel;
  final MarimoEmotion marimoEmotion;

  const MarimoState({
    required this.marimoLevel,
    required this.marimoEmotion,
  });

  @override
  List<Object?> get props => [marimoLevel, marimoEmotion];
}

abstract class MarimoEvent extends Equatable {
  const MarimoEvent();
}

class MarimoLevelChanged extends MarimoEvent {

  final MarimoLevel marimoLevel;

  const MarimoLevelChanged(this.marimoLevel);

  @override
  List<Object?> get props => [marimoLevel];
}

class MarimoEmotionChanged extends MarimoEvent {
  final MarimoEmotion marimoEmotion;

  MarimoEmotionChanged(this.marimoEmotion);

  @override
  List<Object?> get props => [marimoEmotion];
}
