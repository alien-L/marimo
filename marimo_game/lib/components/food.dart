import 'dart:math';
import 'package:flame/collisions.dart';
import 'package:flame/game.dart';

import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/cupertino.dart';

import '../marimo_game_world.dart';
import 'effects/effects.dart';

class Food extends SpriteComponent
    with HasGameRef<MarimoWorldGame>, CollisionCallbacks {
  late Vector2 _worldSize;
  final Vector2 velocity = Vector2.zero();
  late Vector2 _pos;

  Food(Vector2 worldSize,{Key? key})
      : super(size: Vector2.all(35), anchor: Anchor.center) {
    _worldSize = worldSize;
  }

  @override
  Future<void> onLoad() async {
    final coinImage = await game.images.load('shop/food.png');
    sprite = Sprite(coinImage);

    add(RectangleHitbox()..collisionType = CollisionType.passive);
    add(CommonEffects.rotateEffect());
    final random = Random();
    final posX = random.nextDouble() * _worldSize.x;
    final posY = random.nextDouble() * _worldSize.y;
    _pos = Vector2(posX, posY);
    position = _pos;
  }

  @override
  void update(double dt) {
    super.update(dt);
  }
}

