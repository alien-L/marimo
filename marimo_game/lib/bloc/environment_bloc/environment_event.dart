part of 'environment_bloc.dart';

abstract class EnvironmentEvent extends Equatable {
  const EnvironmentEvent();
}

class EnvironmentChangeEvent extends EnvironmentEvent {
  final bool isWaterChanged;
  final double temperature;
  final int humidity;
  final bool isFoodTrashChanged;

  EnvironmentChangeEvent(
      {required this.isWaterChanged,
      required this.temperature,
      required this.humidity,
      required this.isFoodTrashChanged});

  @override
  List<Object?> get props => [];
}
