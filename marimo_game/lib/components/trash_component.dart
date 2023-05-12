import 'dart:math';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/animation.dart';
import '../marimo_game_world.dart';

class TrashComponent extends SpriteComponent with HasGameRef<MarimoWorldGame> {
  late Vector2 _worldSize;
  final Vector2 velocity = Vector2.zero();
  late Vector2 _pos;

  TrashComponent(Vector2 worldSize)
      : super(size: Vector2.all(64), anchor: Anchor.center) {
    _worldSize = worldSize;
  }

  @override
  Future<void> onLoad() async {
    final moldyImage = await game.images.load('trash.png');
    sprite = Sprite(moldyImage);

    add(RectangleHitbox()..collisionType = CollisionType.inactive);
    add(
        MoveAlongPathEffect(
          Path()..quadraticBezierTo(100, 0, 50, -50),
          EffectController(duration: 1.5),
        ),
      // RotateEffect.by(90,
      //     EffectController(
      //       duration: 40,
      //       infinite: true,
      //       curve: Curves.easeOutQuad,
      //     ),),
    );
    final random = Random();
    final posX = random.nextDouble() * _worldSize.x;
    final posY = random.nextDouble() * _worldSize.y;
    _pos = Vector2(posX, posY);
    position = _pos;
  }

  @override
  void update(double dt) {
    if (game.environmentTrashBloc.state){
      removeFromParent();
    }else{}
    // parent?.add(gameRef.marimoComponent =
    //     MarimoComponent(name: state.name, context: context));
    super.update(dt);
  }
}
