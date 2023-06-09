import 'dart:math';
import 'dart:ui';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/experimental.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/animation.dart';

import '../marimo_game_world.dart';
import '../page/drag_event.dart';

class SpriteSheetWidget extends SpriteAnimationComponent
    with HasGameRef<MarimoWorldGame> {

  SpriteSheetWidget():super(){}
  @override
  void onTapDown(TapDownInfo info) {
    print(info.eventPosition.game);
  }

  @override
  Future<void> onLoad() async {
    final spriteSheet = SpriteSheet(
      image: await game.images.load('shop/octopus_sprite.png'),
      srcSize: Vector2(48.0, 48.0),
    );
    final spriteSize = Vector2(96.0, 96.0);

    final animation =
        spriteSheet.createAnimation(row: 0, stepTime: 0.2, to: 5);
    final component1 = SpriteAnimationComponent(
      animation: animation,
      scale: Vector2(0.4, 0.4),
      position: Vector2(100, 500),
      size: spriteSize,

    );
    final effect = SequenceEffect([
      // ScaleEffect.by(
      //   Vector2.all(1.5),
      //   EffectController(
      //     duration: 0.2,
      //     alternate: true,
      //   ),
      // ),
      // MoveEffect.by(
      //   Vector2(30, -50),
      //     InfiniteEffectController(ReverseCurvedEffectController(5, Curves.easeInOutCirc,))
      // ),
      // MoveEffect.by(
      //     Vector2(50, 0),
      //     InfiniteEffectController(ReverseCurvedEffectController(5, Curves.easeInOutCirc,))
      // ),
      // MoveToEffect(
      //   Vector2(100, 500),
      //   EffectController(duration: 3),
      // ),
      MoveAlongPathEffect(
        Path()..quadraticBezierTo(100, 0, 50, -50),
          InfiniteEffectController(ReverseCurvedEffectController(5, Curves.easeInOutCirc,))
      ),
      // OpacityEffect.to(
      //   0,
      //   EffectController(
      //     duration: 0.3,
      //   ),
    //  ),
     // RemoveEffect(),
    ]);
    add(
      component1
      ..add(effect)
        // ..add(RectangleHitbox()..collisionType = CollisionType.passive)
      //   ..add(
      //       MoveEffect.by(
      //         Vector2(50, 0),
      //        // InfiniteEffectController(ReverseCurvedEffectController(5, Curves.easeInOutCirc,))
      //         EffectController(
      //           duration: 5,
      //              infinite: true,
      //           curve: Curves.easeInOutCirc,
      //         ),
      //       ),
      //   ) ..add(
      //   MoveEffect.by(
      //     Vector2(50, 0),
      //     // InfiniteEffectController(ReverseCurvedEffectController(5, Curves.easeInOutCirc,))
      //       ReverseCurvedEffectController(5, Curves.easeInOutCirc,)
      //   ),
      // ),

    );
  }
}

class OctopusComponent extends SpriteAnimationComponent
    with HasGameRef<MarimoWorldGame>, CollisionCallbacks, TapCallbacks {
  late Vector2 _worldSize;
  final Vector2 velocity = Vector2.zero();
  late Vector2 _pos;

  OctopusComponent(Vector2 worldSize)
      : super(size: Vector2.all(64), anchor: Anchor.center) {
    _worldSize = worldSize;
  }

  @override
  void onTapUp(TapUpEvent event) {
    // print("event ==> $event");
    // GameAlert().showMyDialog(text: "${VillainComponent(game.marimoBloc.state.marimoLevel).getVillianInfoList().last}",
    //     assetsName: "assets/images/${VillainComponent(game.marimoBloc.state.marimoLevel).getVillianInfoList().first}.png",
    //     dialogNumber: "02");
    // Do something in response to a tap event
  }

  @override
  Future<void> onLoad() async {
    final spriteSheet = SpriteSheet(
      image: await game.images.load('shop/octopus_sprite.png'),
      srcSize: Vector2(48.0, 48.0),
    );
    final animation = spriteSheet.createAnimationWithVariableStepTimes(
      row: 1,
      to: 6,
      stepTimes: [1, 1, 0.3, 0.3, 0.5, 0.3],
    );
    final random = Random();
    final posX = random.nextDouble() * _worldSize.x;
    final posY = random.nextDouble() * _worldSize.y;
    _pos = Vector2(posX, posY);
    position = _pos;
    final component = SpriteAnimationComponent(
      animation: animation,
      position: Vector2(100, 500),
      size: Vector2(48, 48),
    );
    add(component);
    // final coinImage = await game.images.load('shop/octopus_sprite.png');
    // sprite = Sprite(coinImage);
    //
    // add(RectangleHitbox()..collisionType = CollisionType.passive);
    // add(
    //   SizeEffect.by(
    //     Vector2(-24, -24),
    //     EffectController(
    //       duration: .75,
    //       reverseDuration: .5,
    //       infinite: true,
    //       curve: Curves.easeOut,
    //     ),
    //   ),
    // );
  }

  @override
  void update(double dt) {
    super.update(dt);
    position = Vector2(x + 10, y + 10);
  }
}

class FrogComponent extends SpriteComponent
    with HasGameRef<MarimoWorldGame>, CollisionCallbacks, TapCallbacks {
  late Vector2 _worldSize;
  final Vector2 velocity = Vector2.zero();
  late Vector2 _pos;

  FrogComponent(Vector2 worldSize)
      : super(size: Vector2.all(64), anchor: Anchor.center) {
    _worldSize = worldSize;
  }

  @override
  void onTapUp(TapUpEvent event) {
    // print("event ==> $event");
    // GameAlert().showMyDialog(text: "${VillainComponent(game.marimoBloc.state.marimoLevel).getVillianInfoList().last}",
    //     assetsName: "assets/images/${VillainComponent(game.marimoBloc.state.marimoLevel).getVillianInfoList().first}.png",
    //     dialogNumber: "02");
    // Do something in response to a tap event
  }

  @override
  Future<void> onLoad() async {
    final coinImage = await game.images.load('shop/frog.png');
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
    _pos = Vector2(posX, posY);
    position = _pos;
  }

  @override
  void update(double dt) {
    super.update(dt);
  }
}

class BlueMarlinComponent extends SpriteComponent
    with HasGameRef<MarimoWorldGame>, CollisionCallbacks {
  late Vector2 _worldSize;
  final Vector2 velocity = Vector2.zero();
  late Vector2 _pos;

  BlueMarlinComponent(Vector2 worldSize)
      : super(size: Vector2.all(64), anchor: Anchor.center) {
    _worldSize = worldSize;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    // TODO: implement onCollision
    super.onCollision(intersectionPoints, other);
    // if(other is ScreenHitbox){
    //    print("other ===> $other");
    //  }
  }

  @override
  Future<void> onLoad() async {
    final coinImage = await game.images.load('shop/blue_marlin.png');
    sprite = Sprite(coinImage);

    add(RectangleHitbox()..collisionType = CollisionType.passive);
    final random = Random();
    final posX = random.nextDouble() * _worldSize.x;
    final posY = random.nextDouble() * _worldSize.y;
    _pos = Vector2(posX, posY);
    position = _pos;
    final ec = SequenceEffectController([
      EffectController(
        duration: 5,
        //   infinite: true,
        curve: Curves.linear,
      ),
      // ZigzagEffectController(period: 1),
      //   LinearEffectController(1),
      //  PauseEffectController(0.2),
      ReverseLinearEffectController(1),
      EffectController(
        duration: 5,
        //   infinite: true,
        curve: Curves.linear,
      ),
    ]);
    final effect = //SequenceEffect([
        // ScaleEffect.by(
        //   Vector2.all(1.5),
        //   EffectController(
        //     duration: 0.2,
        //     alternate: true,
        //   ),
        // ),
        MoveEffect.by(
      Vector2(_worldSize.x, 0),
      EffectController(
        duration: 5,
        //   infinite: true,
        curve: Curves.linear,
      ),
      //ZigzagEffectController(period: 10),
      //      RandomEffectController.uniform(
      //        LinearEffectController(10),  // duration here is irrelevant
      //        min: 0.5,
      //        max: 1.5,
      //      ),
      //    EffectController(
      //      duration: 5,
      //      infinite: true,
      //      curve: Curves.linear,
      //    ),
    );
    // MoveEffect.by(
    //   Vector2(0, _worldSize.y),
    //   //     ZigzagEffectController(period: 2),
    //   //      RandomEffectController.uniform(
    //   //        LinearEffectController(10),  // duration here is irrelevant
    //   //        min: 0.5,
    //   //        max: 1.5,
    //   //      ),
    //   EffectController(
    //     duration: 5,
    //     infinite: true,
    //     curve: Curves.linear,
    //   ),
    // ),
    // ]);
    add(effect);
    // add(
    //   MoveEffect.by(
    //     Vector2(0, 0),
    //     EffectController(
    //       duration: 5,
    //       infinite: true,
    //       curve: Curves.linear,
    //     ),
    //   ),
    // );
  }

  @override
  void update(double dt) {
    super.update(dt);
    final screenPoint = position;
    final screenSize = gameRef.size;
    if (x < 0) {
      //  print("test111");
      //  game.marimoComponent.x = -game.marimoComponent.x;
      // game.marimoComponent.y =  game.marimoComponent.y;
    } else if (screenPoint.x > screenSize.x - 70) {
      //   print("test222");
      // add(
      //   MoveEffect.by(
      //     Vector2(0, 0),
      //     EffectController(
      //       duration: 5,
      //       infinite: true,
      //       curve: Curves.linear,
      //     ),
      //   ),
      // );
      // game.marimoComponent.x = screenSize.x-70;
      // game.marimoComponent.y =  game.marimoComponent.y;
    }
  }
}

class CrabMarlinComponent extends SpriteComponent
    with HasGameRef<MarimoWorldGame>, CollisionCallbacks {
  late Vector2 _worldSize;
  final Vector2 velocity = Vector2.zero();
  late Vector2 _pos;

  CrabMarlinComponent(Vector2 worldSize)
      : super(size: Vector2.all(64), anchor: Anchor.center) {
    _worldSize = worldSize;
  }

  @override
  Future<void> onLoad() async {
    final coinImage = await game.images.load('shop/crab.png');
    sprite = Sprite(coinImage);

    add(RectangleHitbox()..collisionType = CollisionType.passive);

    add(MoveAlongPathEffect(
      Path()..quadraticBezierTo(100, 0, 50, -50),
      EffectController(duration: 1.5, infinite: true),
    )
        // SizeEffect.by(
        //   Vector2(-24, -24),
        //   EffectController(
        //     duration: .75,
        //     reverseDuration: .5,
        //     infinite: true,
        //     curve: Curves.easeOut,
        //   ),
        // ),
        );
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

class DeepSeaFishComponent extends SpriteComponent
    with HasGameRef<MarimoWorldGame>, CollisionCallbacks {
  late Vector2 _worldSize;
  final Vector2 velocity = Vector2.zero();
  late Vector2 _pos;

  DeepSeaFishComponent(Vector2 worldSize)
      : super(size: Vector2.all(64), anchor: Anchor.center) {
    _worldSize = worldSize;
  }

  @override
  Future<void> onLoad() async {
    final coinImage = await game.images.load('shop/deep_sea_fish.png');
    sprite = Sprite(coinImage);

    add(RectangleHitbox()..collisionType = CollisionType.passive);
    add(RotateEffect.by(tau / 4, EffectController(duration: 2, infinite: true),
        onComplete: () {
      print("oncomplete");
    }));
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
