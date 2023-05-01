part of 'environment_bloc.dart';

abstract class EnvironmentEvent extends Equatable {
  const EnvironmentEvent();
}

class EnvironmentChangeEvent extends EnvironmentEvent {
  final bool? isWaterChanged;
  final double? temperature;
  final int? humidity;
  final bool? isFoodTrashChanged;

  EnvironmentChangeEvent(
      {this.isWaterChanged,
      this.temperature,
      this.humidity,
      this.isFoodTrashChanged});

  @override
  List<Object?> get props => [];
}
