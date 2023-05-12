import 'package:flame/components.dart';
import 'package:flutter/material.dart';

// 백그라운드 사이즈는 어떻게 정하지???
class World extends SpriteComponent with HasGameRef {
  World(this.isBackGroundChange);
  final bool isBackGroundChange;

  @override
  Future<void>? onLoad() async {
    print("isBackGroundChange===> ${isBackGroundChange}");
    sprite = await gameRef.loadSprite('background_01${isBackGroundChange?"_red":""}.png');
    size = gameRef.size;
        //Vector2(393, 852);
        //gameRef.size;
        //sprite!.originalSize;
    return super.onLoad();
  }

  @override
  Future<void> update(double dt) async {
    sprite = await gameRef.loadSprite('background_01${isBackGroundChange?"_red":""}.png');

    super.update(dt);
  }
}
