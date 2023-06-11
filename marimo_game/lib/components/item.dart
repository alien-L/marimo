import 'dart:convert';

import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../marimo_game_world.dart';
import '../bloc/shop_bloc.dart';
import 'marin_animal.dart';
class ItemController extends Component
    with
        HasGameRef<MarimoWorldGame>,
        FlameBlocListenable<ShopBloc, ItemState>{

  ItemController();

  @override
  bool listenWhen(ItemState previousState,ItemState newState) {
    return previousState != newState;
  }

  @override
  Future<void> onNewState(ItemState state) async {
    // 로컬 저장소 값 비교 레벨
    final dynamicButtonList = await rootBundle
        .loadString('assets/marimo_shop.json')
        .then((jsonStr) => jsonStr);
    final data = await json.decode(dynamicButtonList);
    List<dynamic> list = data["data"];
    print(list);
    Map<String,dynamic> _map = list.firstWhere((element)=>element["name"] == state.name );

    if(state.isCheckedMoving??false){
      parent?.add(gameRef.marinAnimalsComponent =MarinAnimal(worldSize: gameRef.size,
          animalName: _map["image_name"], screenSize: Vector2.all(double.parse(_map["screenSize"]??_map["size"])), imageSize: Vector2.all(double.parse(_map["size"])), totalNum:_map["totalNum"]));
    }else {
      parent?.add(gameRef.shopComponent = Item(name:_map["image_name"],
          componentPosition: Vector2(double.parse(_map["position_x"]),game.size.y-double.parse(_map["position_y"])),
          componentSize: Vector2.all(double.parse(_map["size"]))));
    }
  }
}

class Item extends PositionComponent with HasGameRef<MarimoWorldGame>,
    FlameBlocListenable<ShopBloc, ItemState> {
  Item({this.name, this.componentPosition, this.componentSize}) {
    positionType = PositionType.viewport;
  }

  final String? name;
  final Vector2? componentPosition;
  final Vector2? componentSize;

  @override
  Future<void>? onLoad() async {
    String imageName = name == null ? 'zero.png' : 'shop/$name';

    final componentName = await game.loadSprite(imageName);
    add(
      SpriteComponent(
        sprite: componentName,
        position: componentPosition,
        size: componentSize,
        anchor: Anchor.center,
      ),
    );

    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
  }
}
