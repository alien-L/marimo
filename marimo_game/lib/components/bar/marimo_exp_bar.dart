import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../../marimo_game_world.dart';
class MarimoExpBar extends PositionComponent
    with HasGameRef<MarimoWorldGame>{
  MarimoExpBar() {
    positionType = PositionType.viewport;
  }

  late TextComponent _scoreTextComponent;
  late SpriteComponent _spriteComponent;

  @override
  Future<void>? onLoad() async {
    final lifeBarSprite = await game.loadSprite('exp_bar_${game.marimoExpBloc.changeLifeCycleToExp(game.marimoLevelBloc.state).name}.png');

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
    _spriteComponent.sprite = await game.loadSprite('exp_bar_${game.marimoExpBloc.changeLifeCycleToExp(game.marimoLevelBloc.state).name}.png');
    super.update(dt);
  }
}
