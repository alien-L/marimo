import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import '../marimo_game_world.dart';

class Coin extends SpriteComponent
    with HasGameRef<MarimoWorldGame> {
  late Vector2 _worldSize;
  final Vector2 velocity = Vector2.zero();
  late Vector2 _pos;

  Coin(Vector2 worldSize) : super(size: Vector2.all(64), anchor: Anchor.center){
    _worldSize = worldSize;
  }

  @override
  Future<void> onLoad() async {
    final coinImage = game.images.fromCache('coin.png');
    sprite = Sprite(coinImage);

    add(RectangleHitbox()..collisionType = CollisionType.passive);
    add(
      SizeEffect.by(
        Vector2(-24, -24),
        EffectController(
          duration: .75,
          reverseDuration: .5,
          infinite: true,
          curve: Curves.easeOut,
        ),
      ),
    );
    final random = Random();
    final posX = random.nextDouble() * _worldSize.x;
    final posY = random.nextDouble() * _worldSize.y;
    _pos = Vector2(posX , posY);
    position = _pos;
  }

  @override
  void update(double dt) {
    super.update(dt);
  }
}