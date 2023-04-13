part of 'marimo_bloc.dart';

enum MarimoLevel{baby,child,child2,teenager,adult,oldMan}

enum MarimoLifeCycle{dangerous,good,bad,normal,die,lucky}

class MarimoLevelState extends Equatable {
  final MarimoLevel marimoLevel;
  final MarimoLifeCycle marimoLifeCycle;

  const MarimoLevelState( {
    required this.marimoLifeCycle,
    required this.marimoLevel,
  });

  const MarimoLevelState.empty() : this(marimoLifeCycle:MarimoLifeCycle.normal,marimoLevel: MarimoLevel.baby);

  MarimoLevelState copyWith({
    MarimoLevel? marimoLevel,
    required MarimoLifeCycle marimoLifeCycle,
  }) {
    return MarimoLevelState(marimoLevel: marimoLevel ?? this.marimoLevel, marimoLifeCycle: this.marimoLifeCycle);
  }

  @override
  List<Object?> get props => [marimoLevel,marimoLifeCycle];
}


