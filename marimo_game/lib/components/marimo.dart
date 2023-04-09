
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:marimo_game/marimo_game_world.dart';
import '../app_manage/local_repository.dart';
import '../bloc/game_stats/bloc/game_stats_bloc.dart';
import '../const/constant.dart';
import '../helpers/direction.dart';
import 'package:flame/sprite.dart';

import 'coin.dart';

class PlayerController extends Component
    with
        HasGameRef<MarimoWorldGame>,
        FlameBlocListenable<GameStatsBloc, GameStatsState> {
  @override
  bool listenWhen(GameStatsState previousState, GameStatsState newState) {
    return true;
  }

  @override
  void onNewState(GameStatsState state) {
    print("state ==> $state");
    // if (state.status == GameStatus.respawn ||
    //     state.status == GameStatus.initial) {
    // gameRef.statsBloc.add(const PlayerRespawned());
      parent?.add(gameRef.marimo =Marimo());
 //   }
  }
}


class Marimo extends SpriteAnimationComponent
    with HasGameRef<MarimoWorldGame>, CollisionCallbacks, FlameBlocListenable<GameStatsBloc, GameStatsState>{
  final double _playerSpeed = 300.0;
  final double _animationSpeed = 0.15;

  late final SpriteAnimation _runDownAnimation ;
  late final SpriteAnimation _runLeftAnimation;
  late final SpriteAnimation _runUpAnimation;
  late final SpriteAnimation _runRightAnimation;
  late final SpriteAnimation _standingAnimation;

  Direction direction = Direction.none;
  Direction _collisionDirection = Direction.none;
  bool _hasCollided = false;
  LocalRepository localRepository = LocalRepository();

  Marimo()
      : super(
          size: Vector2.all(64.0), position: Vector2(100, 500)
        ) {
    add(RectangleComponent());
  }

  // @override
  // void onNewState(InventoryState state) {
  //   this.state = state;
  // }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    add(CircleHitbox(),);
    String fileName = await getMarimoLevleImage();
     _loadAnimations(fileName).then((_) => {animation = _standingAnimation});
  }

  @override
  void update(double delta) {
    super.update(delta);
    movePlayer(delta);
  }

  @override
  Future<void> onCollision(Set<Vector2> intersectionPoints, PositionComponent other) async {
  //  print("충돌 !! $intersectionPoints , $other");
    final marimoLevel = await localRepository.getValue(key: "MarimoLevel");

    if (other is Coin) {
    //  other.removeFromParent();
     // game.coinsCollected++;
    }

    if( game.coinsCollected == 10 && marimoLevel == MarimoLevel.baby.name){
      print("충돌 !! $intersectionPoints , $other");
     // removeFromParent();
     // gameRef.statsBloc.add(const PlayerDied());
      // final spriteSheet = SpriteSheet(
      //   image: await game.images.fromCache('marimo_child.png'),
      //   srcSize: Vector2(64.0, 64.0),
      // );
      // _standingAnimation = spriteSheet.createAnimation(row: 0, stepTime: _animationSpeed, to: 1);
      // // 마리모 상태 변경
    }

    super.onCollision(intersectionPoints, other);
  }


  getMarimoLevleImage() async {
    final marimoLevel = await localRepository.getValue(key: "MarimoLevel");
    print("marimoLevel $marimoLevel");
    String marimoImageFileName = 'marimo_$marimoLevel.png';

    return marimoImageFileName;
  }


// String fileName = await getMarimoLevleImage();
  Future<void> _loadAnimations(String fileName) async {

    final spriteSheet = SpriteSheet(
      image: await game.images.fromCache(fileName),
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
