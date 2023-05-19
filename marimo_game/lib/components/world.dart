import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../bloc/component_bloc/background_bloc.dart';

// 백그라운드 사이즈는 어떻게 정하지???
class World extends SpriteComponent with HasGameRef {
  World(this.backgroundBloc);
  final BackgroundBloc backgroundBloc;

  @override
  Future<void>? onLoad() async {
    String backgroundTxt = backgroundBloc.getBackgroundName();
    sprite = await gameRef.loadSprite('$backgroundTxt.png');
    size = gameRef.size;
    return super.onLoad();
  }

  @override
  Future<void> update(double dt) async {
    String backgroundTxt = backgroundBloc.getBackgroundName();
    sprite = await gameRef.loadSprite('$backgroundTxt.png');

    super.update(dt);
  }
}
