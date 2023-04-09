import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'marimo_event.dart';
part 'marimo_state.dart';

class MarimoBloc extends Bloc<MarimoEvent, MarimoState> {
  MarimoBloc() : super(const MarimoState.empty()) {
    on<MarimoEquipped>(
      (event, emit) => emit(
        state.copyWith(marimoLevel: event.marimoLevel),
      ),
    );

    // on<NextMarimoEquipped>((event, emit) {
    //   const values = MarimoLevel.values;
    //   final i = values.indexOf(state.marimoLevel);
    //   // if (i == values.length - 1) {
    //   //   emit(state.copyWith(marimoLevel: Mar));
    //   // } else {
    //   //   emit(state.copyWith(marimoLevel: values[i + 1]));
    //   // }
    // });
  }
}
