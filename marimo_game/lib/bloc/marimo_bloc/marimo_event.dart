part of 'marimo_bloc.dart';

abstract class MarimoEvent extends Equatable {
  const MarimoEvent();
}

class MarimoEquipped extends MarimoEvent {
  final MarimoLevel marimoLevel;

  const MarimoEquipped(this.marimoLevel);

  @override
  List<Object?> get props => [marimoLevel];
}

class NextMarimoEquipped extends MarimoEvent {
  const NextMarimoEquipped();

  @override
  List<Object?> get props => [];
}
