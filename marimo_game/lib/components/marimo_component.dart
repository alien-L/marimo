import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/material.dart';
import 'package:marimo_game/app_manage/environment/environment.dart';
import 'package:marimo_game/bloc/marimo_bloc/marimo_exp_bloc.dart';
import 'package:marimo_game/components/villian_component.dart';
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

  MarimoController();

  @override
  bool listenWhen(MarimoLevel previousState, MarimoLevel newState) {
    return previousState != newState;
  }

  @override
  void onNewState(MarimoLevel state) {
    game.marimoComponent.removeFromParent();
    parent?.add(gameRef.marimoComponent =
        MarimoComponent(name: state.name,));
  }
}

class MarimoComponent extends SpriteAnimationComponent
    with
        HasGameRef<MarimoWorldGame>,
        CollisionCallbacks,
        KeyboardHandler,
        FlameBlocListenable<MarimoLevelBloc, MarimoLevel> {
  bool destroyed = false;
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

  MarimoComponent({required this.name,})
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
      game.marimoExpBloc.addScore(game.marimoLevelBloc.state, 10);
      game.coinBloc.addCoin();
      int totalCoinCount = await game.coinBloc.getTotalCoinCount();
      totalCoinCount--;
      tempCoin++;
      game.coinBloc.updateLocaltotalCoinCount(totalCoinCount);
      bool isPulledExp =
          game.marimoExpBloc.changeLifeCycleToExp(game.marimoLevelBloc.state) ==
              MarimoExpState.level5;
      if (isPulledExp) {
        await levelUpMarimo(game, game.marimoLevelBloc.state);
      }
      game.soundBloc.effectSoundPlay('/music/coin_1.mp3');
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

levelUpMarimo(MarimoWorldGame game, level) async {
  game.soundBloc.effectSoundPlay('/music/popup.mp3');
  //game.removeFromParent();
  //game.marimoComponent.removeFromParent();
  //game.remove(game.marimoComponent);
  await GameAlert().showMyDialog(
    text: Environment().config.constant.levelUpMsg,
    assetsName: "assets/images/one_marimo.png",
  );
  game.marimoExpBloc.initState();
  //game.marimoExpBloc.emit(0);
  // 이미지 필요 one_marimo

  switch (level) {
    case MarimoLevel.baby: // 경험치로 변경하기 , 어린이 마리모 레벨 체크하기 초기값
      game.marimoLevelBloc.levelUp(MarimoLevel.child);
      break;
    case MarimoLevel.child:
      game.marimoLevelBloc.levelUp(MarimoLevel.child2);
      break;
    case MarimoLevel.child2:
      game.marimoLevelBloc.levelUp(MarimoLevel.teenager);
      break;
    case MarimoLevel.teenager:
      game.marimoLevelBloc.levelUp(MarimoLevel.adult);
      break;
    case MarimoLevel.adult:
      game.marimoLevelBloc.levelUp(MarimoLevel.oldMan);
      break;
    case MarimoLevel.oldMan:
      // 흠??
      break;
  }
}
