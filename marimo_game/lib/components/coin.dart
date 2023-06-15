import 'dart:math';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:marimo_game/components/effects/effects.dart';
import '../bloc/component_bloc/coin_bloc.dart';
import '../marimo_game_world.dart';
import 'effects/effects_component.dart';

class Coin extends SpriteComponent
    with HasGameRef<MarimoWorldGame>, CollisionCallbacks {
  late Vector2 _worldSize;
  final Vector2 velocity = Vector2.zero();
  late Vector2 _pos;

  Coin(Vector2 worldSize)
      : super(size: Vector2.all(64), anchor: Anchor.center) {
    _worldSize = worldSize;
  }

  @override
  Future<void> onLoad() async {
    final coinImage = await game.images.load('main/coin.png');
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
    with HasGameRef<MarimoWorldGame>, FlameBlocListenable<CoinBloc, int> {
  CoinController();
  late bool isIncreasing;
  @override
  bool listenWhen(int previousState, int newState) {
    isIncreasing = previousState < newState;
    return previousState != newState;
  }


  @override
  void onNewState(int state) {
    if(isIncreasing){
      parent?.add(gameRef.coinEffectComponent = CoinEffectComponent(
          componentSize: Vector2.all(16),
          componentPosition: Vector2(65, 50),
          movePostion: Vector2(65, 20),
          imageName: 'coin'));
    }
  }
}
