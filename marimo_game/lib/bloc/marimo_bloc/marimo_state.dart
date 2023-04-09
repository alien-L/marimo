part of 'marimo_bloc.dart';

enum MarimoLevel{baby,child,child2,teenager,adult,oldMan}

class MarimoState extends Equatable {
  final MarimoLevel marimoLevel;

  const MarimoState({
    required this.marimoLevel,
  });

  const MarimoState.empty() : this(marimoLevel: MarimoLevel.baby);

  MarimoState copyWith({
    MarimoLevel? marimoLevel,
  }) {
    return MarimoState(marimoLevel: marimoLevel ?? this.marimoLevel);
  }

  @override
  List<Object?> get props => [marimoLevel];
}
