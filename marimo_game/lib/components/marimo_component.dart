import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/material.dart';
import 'package:marimo_game/app_manage/environment/environment.dart';
import '../app_manage/local_repository.dart';
import '../bloc/marimo_bloc/marimo_level_bloc.dart';
import '../helpers/direction.dart';
import '../marimo_game_world.dart';
import 'coin_component.dart';
import 'game_alert.dart';

class MarimoController extends Component
    with
        HasGameRef<MarimoWorldGame>,
        FlameBlocListenable<MarimoLevelBloc, MarimoLevel> {
  final BuildContext context;

  MarimoController(this.context);

  @override
  bool listenWhen(MarimoLevel previousState, MarimoLevel newState) {
    return previousState != newState;
  }

  @override
  void onNewState(MarimoLevel state) {
    parent?.add(gameRef.marimoComponent =
        MarimoComponent(name: state.name, context: context));
  }
}

class MarimoComponent extends SpriteAnimationComponent
    with
        HasGameRef<MarimoWorldGame>,
        CollisionCallbacks,
        KeyboardHandler,
        FlameBlocListenable<MarimoLevelBloc, MarimoLevel> {
  bool destroyed = false;
  final BuildContext context;
  final double _playerSpeed = 300.0;
  final double _animationSpeed = 0.15;
  int tempCoin = 0;
  late final SpriteAnimation _runDownAnimation;

  late final SpriteAnimation _runLeftAnimation;
  late final SpriteAnimation _runUpAnimation;
  late final SpriteAnimation _runRightAnimation;
  late final SpriteAnimation _standingAnimation;

  Direction direction = Direction.none;
  final Direction _collisionDirection = Direction.none;
  final bool _hasCollided = false;
  final String? name;

  MarimoComponent({required this.name, required this.context})
      : super(size: Vector2.all(64.0), position: Vector2(100, 500)) {
    add(RectangleComponent());
    add(RectangleHitbox());
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final spriteSheet = SpriteSheet(
      image: await game.images.load('marimo/marimo_${name}.png'),
      srcSize: Vector2(64.0, 64.0),
    );

    _runDownAnimation =
        spriteSheet.createAnimation(row: 0, stepTime: _animationSpeed, to: 4);

    _runLeftAnimation =
        spriteSheet.createAnimation(row: 1, stepTime: _animationSpeed, to: 4);

    _runUpAnimation =
        spriteSheet.createAnimation(row: 2, stepTime: _animationSpeed, to: 4);

    _runRightAnimation =
        spriteSheet.createAnimation(row: 3, stepTime: _animationSpeed, to: 4);

    _standingAnimation =
        spriteSheet.createAnimation(row: 0, stepTime: _animationSpeed, to: 1);
  }

  @override
  void update(double dt) {
    super.update(dt);
    movePlayer(dt);
  }

  @override
  Future<void> onCollision(Set<Vector2> points, PositionComponent other) async {
    super.onCollision(points, other);
    if (other is CoinComponent) {
      other.removeFromParent();
      game.coinBloc.addCoin();
      String? totalCoinCountLocalValue =
          await LocalRepository().getValue(key: "totalCoinCount");
      int totalCoinCount = int.parse(totalCoinCountLocalValue ?? "20");
      totalCoinCount --;
      tempCoin++;
      await LocalRepository().setKeyValue(
          key: "totalCoinCount", value: totalCoinCount.toString());

      game.soundBloc.effectSoundPlay('/music/coin_1.mp3');

      if (name == "baby" && tempCoin == 3) { // 경험치로 변경하기 , 어린이 마리모 레벨 체크하기 초기값
        game.soundBloc.effectSoundPlay('/music/popup.mp3');
        removeFromParent();
        gameRef.marimoLevelBloc.levelUp(MarimoLevel.child);
        await GameAlert().showMyDialog(
          text: Environment().config.constant.levelUpMsg,
          assetsName: "assets/images/one_marimo.png",
        );
      }
    }
  }

  void movePlayer(double delta) {
    switch (direction) {
      case Direction.up:
        if (canPlayerMoveUp()) {
          animation = _runUpAnimation;
          moveUp(delta);
        }
        break;
      case Direction.down:
        if (canPlayerMoveDown()) {
          animation = _runDownAnimation;
          moveDown(delta);
        }
        break;
      case Direction.left:
        if (canPlayerMoveLeft()) {
          animation = _runLeftAnimation;
          moveLeft(delta);
        }
        break;
      case Direction.right:
        if (canPlayerMoveRight()) {
          animation = _runRightAnimation;
          moveRight(delta);
        }
        break;
      case Direction.none:
        animation = _standingAnimation;
        break;
    }
  }

  bool canPlayerMoveUp() {
    if (_hasCollided && _collisionDirection == Direction.up) {
      return false;
    }
    return true;
  }

  bool canPlayerMoveDown() {
    if (_hasCollided && _collisionDirection == Direction.down) {
      return false;
    }
    return true;
  }

  bool canPlayerMoveLeft() {
    if (_hasCollided && _collisionDirection == Direction.left) {
      return false;
    }
    return true;
  }

  bool canPlayerMoveRight() {
    if (_hasCollided && _collisionDirection == Direction.right) {
      return false;
    }
    return true;
  }

  void moveUp(double delta) {
    position.add(Vector2(0, delta * -_playerSpeed));
  }

  void moveDown(double delta) {
    position.add(Vector2(0, delta * _playerSpeed));
  }

  void moveLeft(double delta) {
    position.add(Vector2(delta * -_playerSpeed, 0));
  }

  void moveRight(double delta) {
    position.add(Vector2(delta * _playerSpeed, 0));
  }
}
