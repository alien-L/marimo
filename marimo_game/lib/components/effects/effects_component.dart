import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:marimo_game/components/effects/effects.dart';

import '../../marimo_game_world.dart';
class HpEffectComponent extends EffectComponent {
  HpEffectComponent(
      {required super.componentSize,
        required super.componentPosition,
        required super.movePostion,
        required super.imageName});

  @override
  void update(double dt) {
    if (y < 21) {
      game.coinEffectComponent.removeFromParent();
    }
  }
}

class ExpEffectComponent extends EffectComponent {
  ExpEffectComponent(
      {required super.imageName,
      required super.componentSize,
      required super.componentPosition,
      required super.movePostion});

  @override
  void update(double dt) {
    // TODO: implement update
    if (y < 21) {
      game.coinEffectComponent.removeFromParent();
    }
  }
}

class CoinEffectComponent extends EffectComponent {
  CoinEffectComponent(
      {required super.componentSize,
      required super.componentPosition,
      required super.movePostion,
      required super.imageName});

  @override
  void update(double dt) {
    if (y < 21) {
      game.coinEffectComponent.removeFromParent();
    }
  }
}

abstract class EffectComponent extends SpriteComponent
    with HasGameRef<MarimoWorldGame>, CollisionCallbacks {
  final String? imageName;

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
 //   String name  = imageName == null?'zero.png':'main/$imageName.png';
    final spriteImage = await game.images.load('main/$imageName.png');
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
