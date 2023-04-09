import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

class GlobalContextService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}

class Responsive{
  static double width(double p,BuildContext context)
  {
    return MediaQuery.of(context).size.width*(p/100);
  }
  static double height(double p,BuildContext context)
  {
    return MediaQuery.of(context).size.height*(p/100);
  }
}

class Fish extends SpriteAnimationComponent with HasGameRef {

  final double _speed = 10.0;
  final double _animationSpeed = 0.15;
  late final SpriteAnimation _standingAnimation;
  late Vector2 _pos;
  late Vector2 _worldSize;
  late double _elapsed = 0.0;

  Fish(Vector2 worldSize)
      :super(size: Vector2(100.0, 100.0),){
    _worldSize = worldSize;
  }

  @override
  Future<void>? onLoad() async {
    super.onLoad();

    await _loadAnimations().then((_) => {animation = _standingAnimation});

    final random = Random();
    final posX = random.nextDouble() * _worldSize.x;
    final posY = random.nextDouble() * _worldSize.y;
    _pos = Vector2(posX , posY);
    position = _pos;
  }

  Future<void> _loadAnimations() async {

    final spriteSheet = SpriteSheet(
      image: await gameRef.images.load('e_marimo.png'),
      srcSize: Vector2(100.0, 100.0),
    );

    _standingAnimation =
        spriteSheet.createAnimation(row: 0, stepTime: _animationSpeed, to: 4);
  }

  @override
  void update(double delta) {
    super.update(delta);

    if(_elapsed < 0.3 ){
      _elapsed += delta;
      return;
    }
    else{
      _elapsed = 0.0;
    }

    moveActor(delta);
  }

  void moveActor(double delta) {


    const fishSpeed = 5.0;
    const fishSize = 25.0;

    double posX = position.x;
    double posY = position.y;

    posX += getRandomRange(-fishSpeed, fishSpeed);
    posY += getRandomRange(-fishSpeed, fishSpeed);

    /*if(posX < fishSize / 2){
      posX = fishSize / 2;
    }
    else if(posX > _worldSize.x - fishSize / 2){
      posX = _worldSize.x - fishSize / 2;
    }

    if(posY < fishSize / 2){
      posY = fishSize / 2;
    }
    else if(posY > _worldSize.y - fishSize/2){
      posY = _worldSize.y - fishSize/2;
    }*/

    position = Vector2(posX, posY);

  }

  double getRandomRange(double min, double max){

    final random = Random();

    final temp = random.nextDouble() * (max - min);

    final returnValue = temp + min;

    return returnValue;
  }


}