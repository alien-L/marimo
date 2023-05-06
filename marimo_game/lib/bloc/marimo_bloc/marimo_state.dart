part of 'marimo_bloc.dart';

enum MarimoLevel{baby,child,child2,teenager,adult,oldMan}

enum MarimoLifeCycle{dangerous,good,bad,normal,die,lucky}

abstract class MarimoBlocState extends Equatable {
  const MarimoBlocState();
}

class MarimoStateEmpty extends MarimoBlocState {
  @override
  List<Object?> get props => [];
}

class MarimoLevelState extends MarimoBlocState {
  final MarimoLevel? marimoLevel;
  final MarimoLifeCycle? marimoLifeCycle;
  final int? stateScore;

  const MarimoLevelState({
    this.marimoLifeCycle,
    this.marimoLevel,
    this.stateScore,
  });
  //
  // const MarimoLevelState.empty() : this(marimoLifeCycle:MarimoLifeCycle.normal,marimoLevel: MarimoLevel.baby,stateScore: state);

  // MarimoLevelState copyWith({
  //   MarimoLevel? marimoLevel,
  //   required MarimoLifeCycle marimoLifeCycle,
  //   required  int stateScore,
  // }) {
  //   return MarimoLevelState(marimoLevel: marimoLevel ?? this.marimoLevel, marimoLifeCycle: this.marimoLifeCycle, stateScore: this.stateScore);
  // }

  @override
  List<Object?> get props => [marimoLevel,marimoLifeCycle,stateScore];
}


