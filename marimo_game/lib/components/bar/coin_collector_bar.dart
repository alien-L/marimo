import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../../marimo_game_world.dart';

class CoinCollector extends PositionComponent with HasGameRef<MarimoWorldGame> {
  CoinCollector() {
    positionType = PositionType.viewport;
  }

  late TextComponent _scoreTextComponent;

  @override
  Future<void>? onLoad() async {

    _scoreTextComponent = TextComponent(
      text: '${game.coinBloc.state}',
      textRenderer: TextPaint(
        style: const TextStyle(
          fontFamily: 'NeoDunggeunmoPro',
          fontSize: 13,
          color: Colors.white,
        ),
      ),
      anchor: Anchor.center,
      position: Vector2(95,20),
    );
    add(_scoreTextComponent);

    final coinSprite = await game.loadSprite('coin.png');
    add(
      SpriteComponent(
        sprite: coinSprite,
        position: Vector2(65,20),
        size: Vector2.all(20),
        anchor: Anchor.center,
      ),
    );

    return super.onLoad();
  }

  @override
  void update(double dt) {
    _scoreTextComponent.text = '${game.coinBloc.state}';
    super.update(dt);
  }
}