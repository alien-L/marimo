import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'environment_event.dart';

part 'environment_state.dart';

class EnvironmentBloc extends Bloc<EnvironmentEvent, EnvironmentState> {
  EnvironmentBloc(super.initialState) {
    on<WaterChangedEvent>(
      (event, emit) => emit(
        state.copyWith(marimoEnvironmentState: _checkEnvironment(event)),
      ),
    );
    on<TemperatureChangedEvent>(
      (event, emit) => emit(
        state.copyWith(marimoEnvironmentState: _checkEnvironment(event)),
      ),
    );
    on<HumidityChangedEvent>(
      (event, emit) => emit(
        state.copyWith(marimoEnvironmentState: _checkEnvironment(event)),
      ),
    );
    on<FoodTrashChangedEvent>(
      (event, emit) => emit(
        state.copyWith(marimoEnvironmentState: _checkEnvironment(event)),
      ),
    );
  }
  double temperature = 0;
  int humidity = 0;

  MarimoEnvironmentState _checkEnvironment(EnvironmentEvent event) {
    // 조건 넣어주기
    MarimoEnvironmentState result;

    if (event is WaterChangedEvent) {
      result = MarimoEnvironmentState.good;
    } else if (event is TemperatureChangedEvent) {
      temperature = event.temperature;
      result = event.temperature>15 && event.temperature<23
    ? MarimoEnvironmentState.good
        : MarimoEnvironmentState.bad;
    } else if (event is HumidityChangedEvent) {
      humidity = event.humidity;
      result =  event.humidity > 40 && event.humidity < 70
          ? MarimoEnvironmentState.good
          : MarimoEnvironmentState.bad;
    } else if (event is FoodTrashChangedEvent) {
      result = MarimoEnvironmentState.good;
    } else {
      result = MarimoEnvironmentState.good;
    }

    return result;
  }
}
