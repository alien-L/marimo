import 'package:flame/components.dart';
import 'package:flutter/material.dart';

// 백그라운드 사이즈는 어떻게 정하지???
class World extends SpriteComponent with HasGameRef {
  @override
  Future<void>? onLoad() async {

    sprite = await gameRef.loadSprite('background.png');
    size = sprite!.originalSize;
        //Vector2(393, 852);
        //gameRef.size;
        //sprite!.originalSize;
    return super.onLoad();
  }
}
