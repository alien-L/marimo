import 'dart:math';
import 'package:flame/game.dart';

import 'package:flame/components.dart';
import 'package:flame/sprite.dart';


class MarinAnimalsComponent extends SpriteAnimationComponent with HasGameRef {
  final double speed = 0.8;
  final double changeInterval = 2.5;
  final _time = DateTime.now().millisecondsSinceEpoch / 1000.0;
  int _direction = 0;
  double _directionRad = 0.0;
  double _lastChangeDir = 0.0;
  final String animalName;
  final Vector2 imageSize;
  final Vector2 screenSize;
  final int totalNum;

  //
  final double _animationSpeed = 0.15;
  late final SpriteAnimation _standingAnimation;
  late Vector2 _worldSize;

  MarinAnimalsComponent(
      {required Vector2 worldSize,
      required this.animalName,
      required this.screenSize,
      required this.imageSize,
      required this.totalNum,
      }) : super(size: screenSize,) {
    _worldSize = worldSize;
    _lastChangeDir = _time;

    // 방향
    final random = Random();
    final tempNum = (random.nextDouble() * random.nextInt(10) * 10000.0) % 361;
    final degree = tempNum.abs();
    _directionRad = radians(degree);

    if ((degree <= 90) || (degree >= 270)) {
      _setDirection(1);
    } else {
      _setDirection(0);
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
    final _name = animalName.replaceAll(".png", "");
    final spriteSheet = SpriteSheet(
      image: await game.images.load('shop/${_name}_sprite.png'),
      srcSize: imageSize,
    );

    _standingAnimation =
        spriteSheet.createAnimation(row: 0, stepTime: _animationSpeed, to: totalNum);
  }

  @override
  void update(double delta) {
    super.update(delta);
    moveRandom();
  }

  void moveRandom() {
    final _name = animalName.replaceAll(".png", "");
    double moveX;
    double moveY;
    double newRad;

    if (_isTimeToChangeDirection()) {
      newRad = _createDirection();

      _directionRad = newRad;
      _lastChangeDir = game.currentTime();
      moveX = speed * cos(newRad);
      moveY = speed * sin(newRad);
      if (moveX > 0) {
        _setDirection(1);
      } else {
        _setDirection(0);
      }
    } else {
      moveX = speed * cos(_directionRad);
      moveY = speed * sin(_directionRad);

      if (!_isInsideAquarium(position.x + moveX, position.y + moveY)) {
        newRad = _createDirection();

        _directionRad = newRad;
        _lastChangeDir = game.currentTime();
        moveX = speed * cos(newRad);
        moveY = speed * sin(newRad);
        if (moveX > 0) {
          _setDirection(1);
        } else {
          _setDirection(0);
        }
      }
    }

    if(_name == "frog" ||_name == "earthworm"){
      position.x += moveX;
    }else{
      position.x += moveX;
      position.y += moveY;
    }

  }

  void _setDirection(int direction) {
    _direction = direction;

    if (_direction == 1) {
      scale.x = scale.x.abs() * 1.0;
    } else if (_direction == 0) {
      scale.x = scale.x.abs() * -1.0;
    }
  }

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
    return (interval >= changeInterval);
  }

  bool _isInsideAquarium(double x, double y) {
    return x >= 0.0 && x <= _worldSize.x  && y >= 0.0 && y <= _worldSize.y;
  }

}
