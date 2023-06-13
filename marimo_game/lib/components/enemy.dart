import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/experimental.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/animation.dart';
import 'package:marimo_game/bloc/marimo_bloc/marimo_exp_bloc.dart';
import 'package:marimo_game/const/constant.dart';
import '../bloc/marimo_bloc/marimo_bloc.dart';
import '../marimo_game_world.dart';
import 'alert/game_alert.dart';
import 'marimo.dart';

class EnemyController extends Component
    with
        HasGameRef<MarimoWorldGame>,
        FlameBlocListenable<MarimoExpBloc, int>,
        TapCallbacks {
  bool isFirst = true;

  EnemyController();

  @override
  bool listenWhen(int previousState, int newState) {
    bool isLevel3 = game.marimoExpBloc
            .changeLifeCycleToExp(game.marimoBloc.state.marimoLevel) ==
        MarimoExpState.level3;
    //  final isCheckedVillain = LocalRepository().getValue(key: "isCheckedVillain");
    return isLevel3 && isFirst;
  }

  @override
  Future<void> onNewState(int state) async {
    isFirst = false; // 로컬에 저장하기 ,빌런 블럭에 추가
    game.enemyBloc.showEnemy();
    final enemy = Enemy(
      worldSize: gameRef.size,
        level: game.marimoBloc.state.marimoLevel,
        //animalName: '',
        imageSize: Vector2(64, 64),
        screenSize: Vector2(64, 64));
    //if(game.enemyBloc.state){ // 빌런 나타남
  //  game.enemy.removeFromParent();
    parent?.add(gameRef.enemyComponent = enemy);
    game.marimoComponent.removeFromParent();
    game.marimoBloc.add(MarimoEmotionChanged(MarimoEmotion.cry));
    parent?.add(gameRef.marimoComponent = Marimo(
      levelName: game.marimoBloc.state.marimoLevel.name,
      emotionName: game.marimoBloc.state.marimoEmotion.name,
    ));
    game.soundBloc.effectSoundPlay('music/villain.mp3');
    await GameAlert().showMyDialog(
        text: "꺅!!!빌런이 나타났어요!!!!!",
        assetsName:
            "${CommonConstant.assetsImageEnemy}${enemy.getEnemyInfoMap()["name"]}.png",
        dialogNumber: "02");
  }
}

class Enemy extends SpriteComponent
    with
        HasGameRef<MarimoWorldGame>,
        CollisionCallbacks,
        FlameBlocListenable<MarimoBloc, MarimoState>,
        TapCallbacks {
  late Vector2 _worldSize;
  final Vector2 velocity = Vector2.zero();
  final MarimoLevel level;
  final double speed = 0.8;
  final double chanRgeInterval = 2.5;
  final _time = DateTime.now().millisecondsSinceEpoch / 1000.0;
  int _direction = 0;
  double _directionRad = 0.0;
  double _lastChangeDir = 0.0;
  //final String animalName;
  final Vector2 imageSize;
  final Vector2? screenSize;
  final int? totalNum;

  Enemy(
      {required Vector2 worldSize,
      required this.imageSize,
      this.screenSize,
      this.totalNum,
      required this.level})
      : super(size: Vector2.all(100), anchor: Anchor.center) {
    _worldSize = worldSize;
    _lastChangeDir = _time;

    // 방향
    final random = Random();
    final tempNum = (random.nextDouble() * random.nextInt(10) * 10000.0) % 361;
    final degree = tempNum.abs();
    _directionRad = radians(degree);

    // if ((degree <= 90) || (degree >= 270)) {
    //   _setDirection(1);
    // } else {
    //   _setDirection(0);
    // }

    // 위치
    final posX = random.nextDouble() * _worldSize.x;
    final posY = random.nextDouble() * _worldSize.y;
    position = Vector2(posX, posY);

    anchor = Anchor.center;
  }

  @override
  void onTapUp(TapUpEvent event) {
    GameAlert().showMyDialog(
        text: getEnemyInfoMap()["message"],
        assetsName: "${CommonConstant.assetsImageEnemy}${getEnemyInfoMap()["name"]}.png",
        dialogNumber: "02");
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    final name = getEnemyInfoMap()["name"];
    final coinSprite = await game.images.load('enemy/$name.png');
    sprite = Sprite(coinSprite);
  }

  Map<String, dynamic> getEnemyInfoMap() {
    //List<String> result = [];
    Map<String, dynamic> result = {
      "name": "cat",
      "message": "이 냐옹이는 생선이 먹고싶다옹!!\n생선을 달라옹!!! =ㅅ=!!!",
      "screenSize": 64,
      "imageSize": 64,
      "totalNum": 0,
    };
    switch (level) {
      case MarimoLevel.zero:
        result = {"name": "zero"};
        break;
      case MarimoLevel.baby:
        result = {
          "name": "cat",
          "message": "이 냐옹이는 생선이 먹고싶다옹!!\n생선을 달라옹!!! =ㅅ=!!!",
          "screenSize": 64,
          "imageSize": 64,
          "totalNum": 0,
        }; //fish
        break;
      case MarimoLevel.child:
        result = {
          "name": "rabbit",
          "message": "울 엄마가 계란후라이 먹고싶대 0ㅅ0",
          "screenSize": 64,
          "imageSize": 64,
          "totalNum": 0,
        };
        break;
      case MarimoLevel.child2:
        result = {
          "name": "shark",
          "message": "난 감성적인 F 상어 .\n 육지에 있는 체리를 구해줘 >_<",
          "screenSize": 64,
          "imageSize": 64,
          "totalNum": 0,
        };
        break;
      case MarimoLevel.teenager:
        result = {
          "name": "shrimp",
          "message": "나 곧 피자 재료로 쓰일거 같아....\n 고기와 함께 구워지겠지...",
          "screenSize": 64,
          "imageSize": 64,
          "totalNum": 0,
        };
        break;
      case MarimoLevel.adult:
        result = {
          "name": "snail",
          "message": "밤하늘의 펄얼~~~~~~\n나랑 별보러 가지않을래~~~~^0^",
          "screenSize": 64,
          "imageSize": 64,
          "totalNum": 0,
        };
        break;
      case MarimoLevel.oldMan:
        result = {
          "name": "mouse",
          "message": "아이엠 마우스 유노????\n 아이워너치즈 -3-",
          "screenSize": 64,
          "imageSize": 64,
          "totalNum": 0,
        };
        break;
    }
    return result;
  }

  @override
  void update(double delta) {
    super.update(delta);
    moveRandom();
  }

  void moveRandom() {
    double moveX;
    double moveY;
    double newRad;

    if (_isTimeToChangeDirection()) {
      newRad = _createDirection();

      _directionRad = newRad;
      _lastChangeDir = game.currentTime();
      moveX = speed * cos(newRad);
      moveY = speed * sin(newRad);
      // if (moveX > 0) {
      //   _setDirection(1);
      // } else {
      //   _setDirection(0);
      // }
    } else {
      moveX = speed * cos(_directionRad);
      moveY = speed * sin(_directionRad);

      if (!_isInsideAquarium(position.x + moveX, position.y + moveY)) {
        newRad = _createDirection();

        _directionRad = newRad;
        _lastChangeDir = game.currentTime();
        moveX = speed * cos(newRad);
        moveY = speed * sin(newRad);
        // if (moveX > 0) {
        //   _setDirection(1);
        // } else {
        //   _setDirection(0);
        // }
      }
    }

   // if (animalName == "frog" || animalName == "earthworm") {
   //   position.x += moveX;
    //} else {
      position.x += moveX;
      position.y += moveY;
   // }
  }
  //
  // void _setDirection(int direction) {
  //   _direction = direction;
  //
  //   if (_direction == 1) {
  //     scale.x = scale.x.abs() * 1.0;
  //   } else if (_direction == 0) {
  //     scale.x = scale.x.abs() * -1.0;
  //   }
  // }

  double _createDirection() {
    final random = Random();
    var rDegree = (random.nextDouble() * random.nextInt(10) * 10000.0) % 361;
    var rad = radians(rDegree.abs());

    final moveX = speed * cos(rad);
    final moveY = speed * sin(rad);

    if (!_isInsideAquarium(position.x + moveX, position.y + moveY)) {
      rDegree = (random.nextDouble() * random.nextInt(10) * 10000.0) % 361;
      rad = radians(rDegree.abs());
    }

    return rad;
  }

  bool _isTimeToChangeDirection() {
    final interval = game.currentTime() - _lastChangeDir;
    return (interval >= chanRgeInterval);
  }

  bool _isInsideAquarium(double x, double y) {
    return x >= 0.0 && x <= _worldSize.x && y >= 0.0 && y <= _worldSize.y;
  }
}
