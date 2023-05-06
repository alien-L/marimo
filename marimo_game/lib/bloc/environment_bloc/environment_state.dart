part of 'environment_bloc.dart';

abstract class EnvironmentState extends Equatable {
  const EnvironmentState();
}

class Empty extends EnvironmentState {
  @override
  List<Object?> get props => [];
}

class Loaded extends EnvironmentState {
  final bool isWaterChanged;
  final double temperature;
  final int humidity;
  final bool isFoodTrashChanged;

  Loaded(
      {required this.isWaterChanged,
      required this.temperature,
      required this.humidity,
      required this.isFoodTrashChanged});

  @override
  List<Object?> get props => [];
}

class Error extends EnvironmentState {
  @override
  List<Object?> get props => throw UnimplementedError();
}