import 'dart:math';
import 'package:flame/game.dart';

import 'package:flame/components.dart';
import 'package:flame/sprite.dart';

final double FISH_SPEED = 0.8;
final double FISH_CHANGE_DIR_INTERVAL = 2.5;

class MarinAnimialsComponent extends SpriteAnimationComponent with HasGameRef {
  int _direction = 0;
  double _lastEaten = 0.0;
  double _directionRad = 0.0;
  double _lastChangeDir = 0.0;
  double _lastDropCoin = 0.0;
  final String imageName;
  final Vector2 imageSize;
  final Vector2 screenSize;
  final int totalNum;

  //
  final double _animationSpeed = 0.15;
  late final SpriteAnimation _standingAnimation;
  late Vector2 _worldSize;
  late double _elapsed = 0.0;

  MarinAnimialsComponent(
      {required Vector2 worldSize,
      required double time,
      required this.imageName,
      required this.screenSize,
      required this.imageSize,
      required this.totalNum
      })
      : super(
          size: screenSize,
        ) {
    _worldSize = worldSize;

    //Constants.FISH_SPEED;
    //Constants.FISH_HUNGRY_CONSTRAINT;
    //Constants.FISH_FULL_CONSTRAINT;
    //Constants.FISH_CHANGE_DIR_INTERVAL;
    _lastEaten = time;
    _lastChangeDir = time;
    _lastDropCoin = time;

    // 방향
    final random = Random();
    final tempNum = (random.nextDouble() * random.nextInt(10) * 10000.0) % 361;
    final degree = tempNum.abs();
    _directionRad = radians(degree);

    if ((degree <= 90) || (degree >= 270)) {
      setDirection(1);
    } else {
      setDirection(0);
    }

    // 위치
    final posX = random.nextDouble() * _worldSize.x;
    final posY = random.nextDouble() * _worldSize.y;
    position = Vector2(posX, posY);

    anchor = Anchor.center;
  }

  @override
  Future<void>? onLoad() async {
    super.onLoad();

    await _loadAnimations().then((_) => {animation = _standingAnimation});
  }

  Future<void> _loadAnimations() async {
    final spriteSheet = SpriteSheet(
      image: await game.images.load('shop/$imageName.png'),
      srcSize: imageSize,
    );

    _standingAnimation =
        spriteSheet.createAnimation(row: 0, stepTime: _animationSpeed, to: totalNum);
  }

  @override
  void update(double delta) {
    super.update(delta);

    moveRandom();

    //moveRandom2(delta);

    if (isTimeToDropCoin()) {
      _lastDropCoin = game.currentTime();

      //final coin = Coin(position);
      // game.add(coin);
    }
  }

  void moveRandom() {
    double moveX;
    double moveY;
    double newRad;

    if (isTimeToChangeDirection()) {
      newRad = createDirection();

      _directionRad = newRad;
      _lastChangeDir = game.currentTime();
      moveX = FISH_SPEED * cos(newRad);
      moveY = FISH_SPEED * sin(newRad);
      if (moveX > 0) {
        setDirection(1);
      } else {
        setDirection(0);
      }
    } else {
      moveX = FISH_SPEED * cos(_directionRad);
      moveY = FISH_SPEED * sin(_directionRad);

      if (!isInsideAquarium(position.x + moveX, position.y + moveY)) {
        newRad = createDirection();

        _directionRad = newRad;
        _lastChangeDir = game.currentTime();
        moveX = FISH_SPEED * cos(newRad);
        moveY = FISH_SPEED * sin(newRad);
        if (moveX > 0) {
          setDirection(1);
        } else {
          setDirection(0);
        }
      }
    }

    position.x += moveX;
    position.y += moveY;
  }

  void setDirection(int direction) {
    _direction = direction;

    if (_direction == 1)
      scale.x = scale.x.abs() * 1.0;
    else if (_direction == 0) scale.x = scale.x.abs() * -1.0;
  }

  double createDirection() {
    final random = Random();
    var rDegree = (random.nextDouble() * random.nextInt(10) * 10000.0) % 361;
    var rad = radians(rDegree.abs());

    final moveX = FISH_SPEED * cos(rad);
    final moveY = FISH_SPEED * sin(rad);

    //while(!isInsideAquarium(position.x+moveX, position.y+moveY)){
    if (!isInsideAquarium(position.x + moveX, position.y + moveY)) {
      rDegree = (random.nextDouble() * random.nextInt(10) * 10000.0) % 361;
      rad = radians(rDegree.abs());
    }

    return rad;
  }

  bool isTimeToChangeDirection() {
    final interval = game.currentTime() - _lastChangeDir;
    return (interval >= FISH_CHANGE_DIR_INTERVAL);
  }

  bool isTimeToDropCoin() {
    final interval = game.currentTime() - _lastDropCoin;
    return (interval >= 5);
  }

  bool isInsideAquarium(double x, double y) {
    return x >= 0.0 && x <= _worldSize.x && y >= 0.0 && y <= _worldSize.y;
  }

/*void moveRandom2(double delta) {
    if (_elapsed < 0.3) {
      _elapsed += delta;
      return;
    } else {
      _elapsed = 0.0;
    }

    const fishSpeed = 5.0;

    final moveX = getRandomRange(-fishSpeed, fishSpeed);
    final moveY = getRandomRange(-fishSpeed, fishSpeed);

    if(moveY >= 0)
      setDirection(1);
    else
      setDirection(0);

    position.x += moveX;
    position.y += moveY;
  }

  double getRandomRange(double min, double max) {
    final random = Random();

    final temp = random.nextDouble() * (max - min);

    final returnValue = temp + min;

    return returnValue;
  }*/
}
