part of 'environment_bloc.dart';

enum MarimoEnvironmentState { good, bad }

class EnvironmentState extends Equatable {
  final MarimoEnvironmentState? marimoEnvironmentState;

  const EnvironmentState({this.marimoEnvironmentState});

  const EnvironmentState.empty() : this();

  EnvironmentState copyWith({
    MarimoEnvironmentState? marimoEnvironmentState,
  }) {
    return EnvironmentState(marimoEnvironmentState: this.marimoEnvironmentState);
  }

  @override
  List<Object?> get props => [
        marimoEnvironmentState,
      ];
}


