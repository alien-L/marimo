import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
enum MarimoAppearanceState { zero, baby, child, }
//child2, teenager, adult, oldMan
enum MarimoEmotion { normal, cry }

class MarimoBloc extends Bloc<MarimoEvent, MarimoState> {
  MarimoBloc(super.initialState) {
    on<MarimoAppearanceStateChanged>((event, emit) {
      emit(MarimoState(
          marimoAppearanceState: event.marimoAppearanceState, marimoEmotion: state.marimoEmotion));
    });
    on<MarimoEmotionChanged>((event, emit) {
      emit(MarimoState(
          marimoAppearanceState: state.marimoAppearanceState, marimoEmotion: event.marimoEmotion));
    });
  }

}

class MarimoState extends Equatable {
  final MarimoAppearanceState marimoAppearanceState;
  final MarimoEmotion marimoEmotion;

  const MarimoState({
    required this.marimoAppearanceState,
    required this.marimoEmotion,
  });

  @override
  List<Object?> get props => [marimoAppearanceState, marimoEmotion];
}

abstract class MarimoEvent extends Equatable {
  const MarimoEvent();
}

class MarimoAppearanceStateChanged extends MarimoEvent {

  final MarimoAppearanceState marimoAppearanceState;

  const MarimoAppearanceStateChanged(this.marimoAppearanceState);

  @override
  List<Object?> get props => [marimoAppearanceState];
}

class MarimoEmotionChanged extends MarimoEvent {
  final MarimoEmotion marimoEmotion;

  MarimoEmotionChanged(this.marimoEmotion);

  @override
  List<Object?> get props => [marimoEmotion];
}
