import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../../app_manage/local_repository.dart';
import '../../marimo_game_world.dart';

class MarimoStateBar extends PositionComponent with HasGameRef<MarimoWorldGame> {
  MarimoStateBar({
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
    String? marimoStateScoreLocalValue = await LocalRepository().getValue(
        key: "marimoStateScore");

    _scoreTextComponent = TextComponent(
      text: ' ${marimoStateScoreLocalValue}',
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 20,
          color: Colors.white,
        ),
      ),
      anchor: Anchor.center,
      position: Vector2(20, 65), //game.size.x - (60)
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
  Future<void> update(double dt) async {
    String? marimoStateScoreLocalValue = await LocalRepository().getValue(
        key: "marimoStateScore");
    _scoreTextComponent.text = '${marimoStateScoreLocalValue}';

    super.update(dt);
  }
}