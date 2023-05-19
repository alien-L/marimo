import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/material.dart';
import '../../bloc/marimo_bloc/marimo_hp_bloc.dart';
import '../../marimo_game_world.dart';


class MarimoExpBar extends PositionComponent
    with HasGameRef<MarimoWorldGame>{
  MarimoExpBar() {
    positionType = PositionType.viewport;
  }

  late TextComponent _scoreTextComponent;
  late SpriteComponent _spriteComponent;

  // 레벨에 따라 수치 변화 계산
  // 방해꾼들 변화
  // shop , hp 계산 ( hp가 100 이면 경험치 주기 )


  @override
  Future<void>? onLoad() async {
   final marimoHpBloc =  game.marimoHpBloc;
  // final marimoLifeCycleBloc = game.marimoLifeCycleBloc;

    final lifeBarSprite = await game.loadSprite('exp_bar_100.png');
    //marimoScoreBloc.state
   _scoreTextComponent = TextComponent(
     text: "exp",
     textRenderer: TextPaint(
       style: const TextStyle(
           fontFamily: 'NeoDunggeunmoPro',
           fontSize: 12,
           color: Colors.black,
           locale: Locale('ko', 'KO')
       ),
     ),
     anchor: Anchor.center,
     position: Vector2(game.size.x-195,20), //game.size.x - (60)
   );

   _spriteComponent = SpriteComponent(
     sprite: lifeBarSprite,
     position: Vector2(game.size.x -150,20),
     anchor: Anchor.center,
   );

    add(_scoreTextComponent);
    add(_spriteComponent);

    return super.onLoad();
  }

  @override
  Future<void> update(double dt) async {
    _spriteComponent.sprite = await game.loadSprite('exp_bar_100.png');
    super.update(dt);
  }
}
