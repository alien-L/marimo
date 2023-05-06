part of 'marimo_bloc.dart';

abstract class MarimoEvent extends Equatable {
  const MarimoEvent();
}

class MarimoGetInitStateEvent extends MarimoEvent{
  const MarimoGetInitStateEvent(this.marimoLevel, this.marimoLifeCycle, this.stateScore);
  final MarimoLevel? marimoLevel;
  final MarimoLifeCycle? marimoLifeCycle;
  final int? stateScore;

  @override
  List<Object?> get props => [marimoLevel,marimoLifeCycle,stateScore];

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

class MarimoStateScoreCalculatedEvent extends MarimoEvent{
  final bool isPlus;
  final int score;
  MarimoStateScoreCalculatedEvent({required this.isPlus, required this.score});

  @override
  List<Object?> get props => [];
}
