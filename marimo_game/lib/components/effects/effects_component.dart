import 'dart:math';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/animation.dart';
import 'package:marimo_game/components/effects/effects.dart';

import '../../marimo_game_world.dart';

class ConinEffectComponent extends EffectComponent {
  ConinEffectComponent(
      {required super.componentSize,
      required super.componentPosition,
      required super.movePostion,
      required super.imageName});

  @override
  void update(double dt) {
    if (y < 21) {
      game.coinEffectComponent.removeFromParent();
      position = Vector2(70, 50);
    }
  }
}

abstract class EffectComponent extends SpriteComponent
    with HasGameRef<MarimoWorldGame>, CollisionCallbacks {
  final String imageName;

  final Vector2 componentSize; //Vector2.all(16)
  final Vector2 componentPosition; //Vector2(65, 50)
  final Vector2 movePostion; //Vector2(65, 20)

  EffectComponent({
    required this.imageName,
    required this.componentSize,
    required this.componentPosition,
    required this.movePostion,
  }) : super(size: componentSize, anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    final spriteImage = await game.images.load('$imageName.png');
    sprite = Sprite(spriteImage);

    add(RectangleHitbox()..collisionType = CollisionType.passive);
    add(CommonEffects.sequenceEffect([
      MoveToEffect(
        movePostion,
        EffectController(
          duration: 1,
          infinite: false,
          curve: Curves.linear,
        ),
      ),
      RemoveEffect()
    ]));
    position = componentPosition;
  }

  @override
  void update(double dt) {}
}
