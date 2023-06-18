import 'dart:math';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/animation.dart';
import 'package:marimo_game/components/effects/effects.dart';
import '../const/constant.dart';
import '../marimo_game_world.dart';

// class Trash extends SpriteComponent with HasGameRef<MarimoWorldGame> {
//   late Vector2 _worldSize;
//   final Vector2 velocity = Vector2.zero();
//   late Vector2 _pos;
//
//   Trash(Vector2 worldSize)
//       : super(size: Vector2.all(64), anchor: Anchor.center) {
//     _worldSize = worldSize;
//   }
//
//   @override
//   Future<void> onLoad() async {
//     final bool isCleanTrash = game.environmentTrashBloc.state;
//     if(isCleanTrash){
//       final moldyImage = await game.images.load('${CommonConstant.assetsImageWaterManagement}trash.png');
//       sprite = Sprite(moldyImage);
//       add(RectangleHitbox()..collisionType = CollisionType.inactive);
//       add(
//         RotateEffect.by(90,
//           EffectController(
//             duration: 40,
//             infinite: true,
//             curve: Curves.easeOutQuad,
//           ),),
//       );
//       final random = Random();
//       final posX = random.nextDouble() * _worldSize.x;
//       final posY = random.nextDouble() * _worldSize.y;
//       _pos = Vector2(posX, posY);
//       position = _pos;
//     }
//   }
//
//   @override
//   Future<void> update(double dt) async {
//     final bool isCleanTrash = game.environmentTrashBloc.state;
//     if(isCleanTrash){
//       final moldyImage = await game.images.load('${CommonConstant.assetsImageWaterManagement}trash.png');
//       sprite = Sprite(moldyImage);
//       add(RectangleHitbox()..collisionType = CollisionType.inactive);
//       add(CommonEffects.rotateEffect());
//       final random = Random();
//       final posX = random.nextDouble() * _worldSize.x;
//       final posY = random.nextDouble() * _worldSize.y;
//       _pos = Vector2(posX, posY);
//       position = _pos;
//     }
//     super.update(dt);
//   }
// }
