import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../../marimo_game_world.dart';

class MarimoHpBar extends PositionComponent
    with HasGameRef<MarimoWorldGame>{
  MarimoHpBar() {
    positionType = PositionType.viewport;
  }

  late TextComponent _scoreTextComponent;
  late SpriteComponent _spriteComponent;

  @override
  Future<void>? onLoad() async {
   final marimoHpBloc =  game.marimoHpBloc;
   final lifeBarSprite = await game.loadSprite('life_bar_${marimoHpBloc.changeLifeCycleToHp().name}.png');

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
    if(game.marimoHpBloc.changeLifeCycleToHp().name!= "die"){
      _spriteComponent.sprite = await game.loadSprite('life_bar_${game.marimoHpBloc.changeLifeCycleToHp().name}.png');
    }
   super.update(dt);
  }
}
