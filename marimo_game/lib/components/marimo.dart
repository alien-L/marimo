import 'dart:convert';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/sprite.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../app_manage/local_data_manager.dart';
import '../bloc/marimo_bloc/marimo_bloc.dart';
import '../helpers/direction.dart';
import '../marimo_game_world.dart';
import 'coin.dart';
import 'food.dart';

class MarimoController extends Component
    with
        HasGameRef<MarimoWorldGame>,
        FlameBlocListenable<MarimoBloc, MarimoState>{

  @override
  bool listenWhen(MarimoState previousState, MarimoState newState) {
    return previousState != newState;
  }

  @override
  void onNewState(MarimoState state) {
    // 로컬 저장소 값 비교 레벨
    game.marimoComponent.removeFromParent();
    parent?.add(gameRef.marimoComponent =
        Marimo(marimoAppearanceStateName: state.marimoAppearanceState.name, emotionName: state.marimoEmotion.name,));
  }
}

class Marimo extends SpriteAnimationComponent
    with
        HasGameRef<MarimoWorldGame>,
        CollisionCallbacks,
        KeyboardHandler,
        FlameBlocListenable<MarimoBloc, MarimoState>,TapCallbacks {
  final Vector2 lastPosition = Vector2.zero();
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
  Direction _collisionDirection = Direction.none;
  bool _hasCollided = false;
  final String? emotionName;
  final String? marimoAppearanceStateName;

  Marimo({required this.marimoAppearanceStateName,required this.emotionName})
      : super(size: Vector2.all(64.0), position: Vector2(100, 500)) {
    add(RectangleComponent());
    add(RectangleHitbox());
  }

  late SpriteSheet _spriteSheet;


  @override
  Future<void> onTapUp(TapUpEvent event) async {

    await getCoin();
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
  }
  @override
  void onTapCancel(TapCancelEvent event) {
    super.onTapCancel(event);
  }
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    // final
      _spriteSheet = SpriteSheet(
        image: await game.images.load('marimo/marimo_${marimoAppearanceStateName}_$emotionName.png'),
        srcSize: Vector2(64.0, 64.0),
      ); 

    _runDownAnimation =
        _spriteSheet.createAnimation(row: 0, stepTime: _animationSpeed, to: 4);

    _runLeftAnimation =
        _spriteSheet.createAnimation(row: 1, stepTime: _animationSpeed, to: 4);

    _runUpAnimation =
        _spriteSheet.createAnimation(row: 2, stepTime: _animationSpeed, to: 4);

    _runRightAnimation =
        _spriteSheet.createAnimation(row: 3, stepTime: _animationSpeed, to: 4);

    _standingAnimation =
        _spriteSheet.createAnimation(row: 0, stepTime: _animationSpeed, to: 1);
  }

  @override
  Future<void> update(double dt) async {
    super.update(dt);
    _controlMovePlayer();
    movePlayer(dt);
  }

  _controlMovePlayer(){
    final screenPoint = gameRef.marimoComponent.position;
    final screenSize = gameRef.size;
    if (game.marimoComponent.y < 0) {
      game.marimoComponent.x =  game.marimoComponent.x;
      game.marimoComponent.y = - game.marimoComponent.y;
    }else if(game.marimoComponent.x < 0){
      game.marimoComponent.x = -game.marimoComponent.x;
      game.marimoComponent.y =  game.marimoComponent.y;
    }else if(screenPoint.x > screenSize.x-70){
      game.marimoComponent.x = screenSize.x-70;
      game.marimoComponent.y =  game.marimoComponent.y;
    }else if(screenPoint.y > screenSize.y-70){
      game.marimoComponent.x =  game.marimoComponent.x;
      game.marimoComponent.y = screenSize.y-70;
    }
  }

  getCoin() async {
    game.marimoExpBloc.addScore(game.marimoLevelBloc.state, 10);
    game.coinBloc.addCoin(1);
    game.soundBloc.effectSoundPlay('music/coin_1.mp3');
  }


  @override
  Future<void> onCollision(Set<Vector2> points, PositionComponent other) async {
    super.onCollision(points, other);
    if (other is Coin) {
      other.removeFromParent();
     await getCoin();
    }else if(other is Food){
      other.removeFromParent();
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final shopData = await LocalDataManager().getValue<String>(key: "shopData");
      List list = json.decode(shopData).cast<Map<String,dynamic>>().toList();
      Map<String, dynamic> _map = list.firstWhere((element) => element["name_en"] == "marimofood");
      if(_map["su"]>0){
        _map["su"] = _map["su"]-1;
      }
      int index =  list.indexWhere((element) =>  element["name_en"] == "marimofood");
      list[index] = _map;
      await prefs.setString("shopData", jsonEncode(list));
      game.marimoExpBloc.addScore(game.marimoLevelBloc.state, 10);
      game.soundBloc.effectSoundPlay('music/food.mp3'); //소리 바꾸기
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
    if (_hasCollided && _collisionDirection == Direction.up ) {
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
