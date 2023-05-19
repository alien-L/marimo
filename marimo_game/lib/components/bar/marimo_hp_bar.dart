import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/material.dart';
import '../../bloc/marimo_bloc/marimo_hp_bloc.dart';
import '../../marimo_game_world.dart';


class MarimoHpBar extends PositionComponent
    with HasGameRef<MarimoWorldGame>{
  MarimoHpBar() {
    positionType = PositionType.viewport;
  }

  late TextComponent _scoreTextComponent;
  late SpriteComponent _spriteComponent;

  // shop이랑 환경 35 도 이상이면 죽음
  @override
  Future<void>? onLoad() async {
   final marimoHpBloc =  game.marimoHpBloc;
   final marimoLifeCycleBloc = game.marimoLifeCycleBloc;

    final lifeBarSprite = await game.loadSprite('life_bar_${marimoLifeCycleBloc.state.name}.png');
    //${marimoScoreBloc.state}
   _scoreTextComponent = TextComponent(
     text: "hp",
     textRenderer: TextPaint(
       style: const TextStyle(
           fontFamily: 'NeoDunggeunmoPro',
           fontSize: 12,
           color: Colors.black,
           locale: Locale('ko', 'KO')
       ),
     ),
     anchor: Anchor.center,
     position: Vector2(game.size.x-110,20), //game.size.x - (60)
   );

   _spriteComponent = SpriteComponent(
     sprite: lifeBarSprite,
     position: Vector2(game.size.x -70,20),
     anchor: Anchor.center,
   );

    add(_scoreTextComponent);
    add(_spriteComponent);

    return super.onLoad();
  }

  @override
  Future<void> update(double dt) async {
   // _scoreTextComponent.text = '${game.marimoScoreBloc.state}';
    _spriteComponent.sprite = await game.loadSprite('life_bar_${game.marimoLifeCycleBloc.state.name}.png');
    super.update(dt);
  }
}
