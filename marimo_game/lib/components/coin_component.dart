import 'dart:math';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/animation.dart';
import 'package:marimo_game/const/effects.dart';
import '../bloc/component_bloc/coin_bloc.dart';
import '../marimo_game_world.dart';

class CoinComponent extends SpriteComponent
    with HasGameRef<MarimoWorldGame>, CollisionCallbacks {
  late Vector2 _worldSize;
  final Vector2 velocity = Vector2.zero();
  late Vector2 _pos;

  CoinComponent(Vector2 worldSize)
      : super(size: Vector2.all(64), anchor: Anchor.center) {
    _worldSize = worldSize;
  }

  @override
  Future<void> onLoad() async {
    final coinImage = await game.images.load('coin.png');
    sprite = Sprite(coinImage);

    add(RectangleHitbox()..collisionType = CollisionType.passive);
    add(CommonEffects.sizeEffect());
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
class CoinController extends Component
    with
        HasGameRef<MarimoWorldGame>,
        FlameBlocListenable<CoinBloc, int>{

  CoinController();

  @override
  bool listenWhen(int previousState, int newState) {
    print("coin");
    return previousState != newState;
  }

  @override
  void onNewState(int state) {
    print("coin coin");
    // 로컬 저장소 값 비교 레벨
    // game.marimoComponent.removeFromParent();
    //final coin = CoinDecoComponent();
    // parent?.add(coin );
   // coin.removeFromParent();
      //parent?.removeFromParent();
  }
}

class CoinDecoComponent extends SpriteComponent
    with HasGameRef<MarimoWorldGame>, CollisionCallbacks {
 // late Vector2 _worldSize;
  final Vector2 velocity = Vector2.zero();
  late Vector2 _pos;

  CoinDecoComponent()
      : super(size: Vector2.all(16), anchor: Anchor.center) {
   // _worldSize = worldSize;
  }

  @override
  Future<void> onLoad() async {
    final coinImage = await game.images.load('coin.png');
    sprite = Sprite(coinImage);

    add(RectangleHitbox()..collisionType = CollisionType.passive);
    add(CommonEffects.sequenceEffect([
      MoveToEffect(
        Vector2(70, 20),
        EffectController(
          duration: 1,
          infinite: true,
          curve: Curves.linear,
        ),
      ),
      RemoveEffect()
    ]));
    // final random = Random();
    // final posX = random.nextDouble() * _worldSize.x;
    // final posY = random.nextDouble() * _worldSize.y;
    // _pos = Vector2(posX, posY);
    position = Vector2(70, 50);
  }

  @override
  void update(double dt) {
    super.update(dt);
  }
}
