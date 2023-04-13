part of 'marimo_bloc.dart';

abstract class MarimoEvent extends Equatable {
  const MarimoEvent();
}

class MarimoLevelUpEvent extends MarimoEvent {
  final MarimoLevel marimoLevel;

  const MarimoLevelUpEvent(this.marimoLevel);

  @override
  List<Object?> get props => [marimoLevel];
}

class MarimoStateChangedEvent extends MarimoEvent {
  final int stateScore;

  const MarimoStateChangedEvent(this.stateScore);

  @override
  List<Object?> get props => [];
}
