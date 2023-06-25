import 'package:equatable/equatable.dart';
import 'package:flame/components.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShopBloc extends Bloc<ShopEvent, ItemState> {
  ShopBloc(super.initialState) {
    on<BuyEvent>((event, emit) {
      emit(ItemState(
          name: event.name,
          isCheckedMoving: event.isCheckedMoving,
          buyItem: event.buyItem,
          key: event.key
      ));

    });
  }
}

class ItemState extends Equatable {
  final String? name;
  final Vector2? position;
  final Vector2? size;
  final bool? isCheckedMoving;
  final bool? buyItem;
  final dynamic key;

  const ItemState({
    this.name,
    this.position,
    this.size,
    this.isCheckedMoving,
    this.buyItem,
    this.key,
  });

  @override
  List<Object?> get props => [name, position, size, isCheckedMoving,buyItem,key];
}

abstract class ShopEvent extends Equatable {
  const ShopEvent();
}

class BuyEvent extends ShopEvent {
  BuyEvent(
      {required this.name,
      required this.isCheckedMoving,
        required this.buyItem,
        required this.key, });

  final String name;
  final bool isCheckedMoving;
  final bool? buyItem;
  final dynamic key;

  @override
  List<Object?> get props => [name,isCheckedMoving,buyItem,key];
}
