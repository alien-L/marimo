import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../../marimo_game_world.dart';

class CoinCollector extends PositionComponent with HasGameRef<MarimoWorldGame> {
  CoinCollector({
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

    _scoreTextComponent = TextComponent(
      text: '${game.coinsCollected}',
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 15,
          color: Colors.white,
        ),
      ),
      anchor: Anchor.center,
      position: Vector2(game.size.x - (60), 20),
    );
    add(_scoreTextComponent);

    final coinSprite = await game.loadSprite('coin.png');
    add(
      SpriteComponent(
        sprite: coinSprite,
        position: Vector2(game.size.x - 100, 20),
        size: Vector2.all(32),
        anchor: Anchor.center,
      ),
    );

    return super.onLoad();
  }

  @override
  void update(double dt) {
    _scoreTextComponent.text = '${game.coinsCollected}';
    super.update(dt);
  }
}