part of 'environment_bloc.dart';

abstract class EnvironmentEvent extends Equatable {
  const EnvironmentEvent();
}

class WaterChangedEvent extends EnvironmentEvent{
 final bool  isWaterChanged;
  WaterChangedEvent(this.isWaterChanged);

  @override
  List<Object?> get props => [isWaterChanged];
}

class TemperatureChangedEvent extends EnvironmentEvent{
 final double temperature;
  TemperatureChangedEvent(this.temperature);

  @override
  List<Object?> get props => [temperature];
}

class HumidityChangedEvent extends EnvironmentEvent{
  final int humidity;
  HumidityChangedEvent(this.humidity);

  @override
  List<Object?> get props => [humidity];
}

class FoodTrashChangedEvent extends EnvironmentEvent{
  FoodTrashChangedEvent(this. isFoodTrashChanged);
  final bool  isFoodTrashChanged;

  @override
  List<Object?> get props => [ isFoodTrashChanged];
}