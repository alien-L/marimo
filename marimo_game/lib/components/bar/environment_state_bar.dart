import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/material.dart';
import 'package:marimo_game/bloc/environment_bloc/environment_bloc.dart';

import '../../marimo_game_world.dart';

class  EnvironmentStatController extends Component
    with
        HasGameRef<MarimoWorldGame>,
        FlameBlocListenable< EnvironmentBloc, EnvironmentState> {
  @override
  bool listenWhen(EnvironmentState previousState,EnvironmentState newState) {
    return true;
  }

  @override
  void onNewState(EnvironmentState state) {
   print("🦄 state ===> $state");
  //  parent?.add(gameRef.marimoComponent = MarimoComponent(name:state.marimoLevel.name));
  }
}

class EnvironmentStateBar extends PositionComponent with HasGameRef<MarimoWorldGame> {
  EnvironmentStateBar({
    super.position,
    super.size,
    super.scale,
    super.angle,
    super.anchor,
    super.children,
    super.priority = 5,
  }) {
    positionType = PositionType.viewport;
  }

  late TextComponent _scoreTextComponent;


  @override
  Future<void>? onLoad() async {
    final environmentBloc = game.environmentBloc;
    _scoreTextComponent = TextComponent(
      text: '${environmentBloc.humidity}',
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 20,
          color: Colors.white,
        ),
      ),
      anchor: Anchor.center,
      position: Vector2(game.size.x - (20), 65), //game.size.x - (60)
    );
    add(_scoreTextComponent);

    // final coinSprite = await game.loadSprite('coin.png');
    // add(
    //   SpriteComponent(
    //     sprite: coinSprite,
    //     position: Vector2(game.size.x - 100, 20),
    //     size: Vector2.all(32),
    //     anchor: Anchor.center,
    //   ),
    // );

    return super.onLoad();
  }

  @override
  void update(double dt) {
    final environmentBloc = game.environmentBloc;
    _scoreTextComponent.text = '${environmentBloc.humidity}';
    super.update(dt);
  }
}