import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../../app_manage/local_repository.dart';
import '../../bloc/marimo_bloc/marimo_bloc.dart';
import '../../marimo_game_world.dart';

class MarimoStateBar extends PositionComponent
    with HasGameRef<MarimoWorldGame> {
  MarimoStateBar() {
    positionType = PositionType.viewport;
  }

  @override
  Future<void>? onLoad() async {

    MarimoLifeCycle _marimoLifeCycleValue =
        game.marimoBloc.state.marimoLifeCycle;
    print("_ ==> ${_marimoLifeCycleValue.name}");
    print("_ ==> ${game.marimoBloc.state.stateScore}");
    final lifeBarSprite =
        await game.loadSprite('life_bar_${_marimoLifeCycleValue.name}.png');
    add(TextComponent(
      text: "${game.marimoBloc.state.stateScore}",
      textRenderer: TextPaint(
        style: const TextStyle(
            fontFamily: 'NeoDunggeunmoPro',
            fontSize: 12,
            color: Colors.black,
            locale: Locale('ko', 'KO')
        ),
      ),
      anchor: Anchor.center,
      position: Vector2(game.size.x-120,20), //game.size.x - (60)
    ));
    add(
      SpriteComponent(
        sprite: lifeBarSprite,
        position: Vector2(game.size.x -70,20),
        anchor: Anchor.center,
      ),
    );

    return super.onLoad();
  }

  @override
  Future<void> update(double dt) async {

    super.update(dt);
  }
}
