import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/material.dart';
import 'package:marimo_game/const/constant.dart';
import '../../bloc/marimo_bloc/marimo_hp_bloc.dart';
import '../../marimo_game_world.dart';
import '../effects/effects_component.dart';

class MarimoHpBar extends PositionComponent with HasGameRef<MarimoWorldGame> {
  MarimoHpBar() {
    positionType = PositionType.viewport;
  }

  late TextComponent _scoreTextComponent;
  late SpriteComponent _spriteComponent;

  @override
  Future<void>? onLoad() async {
    final marimoHpBloc = game.marimoHpBloc;
    final lifeBarSprite = await game.loadSprite(
        '${CommonConstant.assetsImageBar}life_bar_${marimoHpBloc.changeLifeCycleToHp().name}.png');

    _scoreTextComponent = TextComponent(
      text: "hp",
      textRenderer: TextPaint(
        style: const TextStyle(
            fontFamily: 'NeoDunggeunmoPro',
            fontSize: 12,
            color: Colors.black,
            locale: Locale('ko', 'KO')),
      ),
      anchor: Anchor.center,
      position: Vector2(game.size.x - 110, 20), //game.size.x - (60)
    );

    _spriteComponent = SpriteComponent(
      sprite: lifeBarSprite,
      position: Vector2(game.size.x - 70, 20),
      anchor: Anchor.center,
    );

    add(_scoreTextComponent);
    add(_spriteComponent);

    return super.onLoad();
  }

  @override
  Future<void> update(double dt) async {
    if (game.marimoHpBloc.changeLifeCycleToHp().name != "die") {
      _spriteComponent.sprite = await game.loadSprite(
          '${CommonConstant.assetsImageBar}life_bar_${game.marimoHpBloc.changeLifeCycleToHp().name}.png');
    }
    super.update(dt);
  }
}

class HpController extends Component
    with HasGameRef<MarimoWorldGame>, FlameBlocListenable<MarimoHpBloc, int> {
  HpController();

 late String name;

  @override
  bool listenWhen(int previousState, int newState) {
    if (previousState < newState) {
      name = 'hp_plus';
    } else {
      name = 'hp_minus';
    }
    return previousState != newState;
  }

  @override
  void onRemove() {
    // TODO: implement onRemove
    super.onRemove();
  }

  @override
  void onNewState(int state) {
    parent?.add(gameRef.hpEffectComponent = HpEffectComponent(
      imageName: name,
      componentSize: Vector2.all(16),
      componentPosition: Vector2(game.size.x - 95, 50),
      movePostion: Vector2(game.size.x - 95, 20),
    ));
  }
}
