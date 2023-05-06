import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'environment_event.dart';

part 'environment_state.dart';

class EnvironmentBloc extends Bloc<EnvironmentEvent, EnvironmentState> {
  EnvironmentBloc(super.initialState) {
    on<EnvironmentChangeEvent>((event, emit) {
      return emit(Loaded(
        isWaterChanged: event.isWaterChanged,
        temperature: event.temperature,
        humidity: event.humidity,
        isFoodTrashChanged: event.isFoodTrashChanged
      ));
    });
  }
}
