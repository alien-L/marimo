import 'package:equatable/equatable.dart';
import 'package:flame/components.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../app_manage/local_repository.dart';

class ShopBloc extends Bloc<ShopEvent, ItemState> {
  ShopBloc(super.initialState) {
    on<BuyEvent>((event, emit) {
      emit(ItemState(
          name: event.name,
          isCheckedMoving: event.isCheckedMoving));
      updateLocalItemValue(event.name);
    });
  }

  // 초기에 설정 해주기 world에
  // 값이 null이 아니면 shop disabled 처리하기
  Future<void> updateLocalItemValue(String name) async {
    await LocalRepository()
        .setKeyValue(key: name, value: "1"); // 1 존재함
  }
}

class ItemState extends Equatable {
  final String? name;
  final Vector2? position;
  final Vector2? size;
  final bool? isCheckedMoving;
  final bool? buyItem;

  const ItemState( {
    this.name,
    this.position,
    this.size,
    this.isCheckedMoving,
    this.buyItem,
  });

  @override
  List<Object?> get props => [name, position, size, isCheckedMoving,buyItem];
}

abstract class ShopEvent extends Equatable {
  const ShopEvent();
}

class BuyEvent extends ShopEvent {
  BuyEvent(
      {required this.name,
  //    required this.position,
   //   required this.size,
      required this.isCheckedMoving});

  final String name;
 // final Vector2 position;
 // final Vector2 size;
  final bool isCheckedMoving;

  @override
  List<Object?> get props => [name,  isCheckedMoving];
}
