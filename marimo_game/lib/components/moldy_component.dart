import 'dart:math';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/animation.dart';
import 'package:marimo_game/const/effects.dart';
import '../marimo_game_world.dart';

class MoldyComponent extends SpriteComponent with HasGameRef<MarimoWorldGame> {
  late Vector2 _worldSize;
  final Vector2 velocity = Vector2.zero();
  late Vector2 _pos;

  MoldyComponent(Vector2 worldSize)
      : super(size: Vector2.all(64), anchor: Anchor.center) {
    _worldSize = worldSize;
  }

  @override
  Future<void> onLoad() async {
    final moldyImage = await game.images.load('moldy.png');
    sprite = Sprite(moldyImage);

    add(RectangleHitbox()..collisionType = CollisionType.inactive);
    add(CommonEffects.rotateEffect());
    final random = Random();
    final posX = random.nextDouble() * _worldSize.x;
    final posY = random.nextDouble() * _worldSize.y;
    _pos = Vector2(posX, posY);
    position = _pos;
  }

  @override
  void update(double dt) {
    if (!game.environmentHumidityBloc.goMoldy()) removeFromParent();
    super.update(dt);
  }
}
