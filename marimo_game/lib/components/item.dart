import 'dart:convert';
import 'dart:developer';

import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../marimo_game_world.dart';
import '../app_manage/local_data_manager.dart';
import '../bloc/shop_bloc.dart';
import 'food.dart';
import 'marin_animal.dart';

class ItemController extends Component
    with HasGameRef<MarimoWorldGame>, FlameBlocListenable<ShopBloc, ItemState> {
  ItemController();

  @override
  bool listenWhen(ItemState previousState, ItemState newState) {
    return previousState != newState;
  }

  @override
  Future<void> onNewState(ItemState state) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final shopData = await LocalDataManager().getValue<String>(key: "shopData");
    List list = json.decode(shopData).cast<Map<String,dynamic>>().toList();
    Map<String, dynamic> _map = list.firstWhere((element) => element["name"] == state.name);

    if(_map["name_en"] == "bubble"){
      parent?.add(gameRef.marinAnimalsComponent = MarinAnimal(
          worldSize: gameRef.size,
          animalName: _map["name_en"],
          screenSize:
          Vector2.all(30),
          imageSize: Vector2.all(300),
          totalNum: 6,
         key: UniqueKey(),
      ));
        parent?.add(gameRef.marinAnimalsComponent = MarinAnimal(
            worldSize: gameRef.size,
            animalName: _map["name_en"],
            screenSize:
            Vector2.all(30),
            imageSize: Vector2.all(300),
            totalNum: 11,
            key: UniqueKey(),
        ));
    }else if(_map["name_en"] == "marimofood"){
      parent?.add(gameRef.food = Food(
        gameRef.size,
        key: UniqueKey(),
      ));
    }else{
      parent?.add(gameRef.marinAnimalsComponent = MarinAnimal(
          worldSize: gameRef.size,
          animalName: _map["image_name"],
          screenSize:
              Vector2.all(double.parse(_map["screenSize"].toString())),
          imageSize: Vector2.all(double.parse(_map["size"].toString())),
          totalNum: _map["totalNum"],
         key: UniqueKey(),
      ));
    }
    _map["bought"] = true;
    _map["su"] = _map["su"]+1;
    int index =  list.indexWhere((element) => element["name"] == state.name);
    list[index] = _map;
    await prefs.setString("shopData", jsonEncode(list));
    }
  }


class Item extends PositionComponent
    with HasGameRef<MarimoWorldGame>, FlameBlocListenable<ShopBloc, ItemState> {
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
