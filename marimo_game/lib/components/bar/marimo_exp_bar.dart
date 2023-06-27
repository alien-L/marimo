import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/material.dart';
import 'package:marimo_game/components/alert/game_alert.dart';
import '../../app_manage/environment/environment.dart';
import '../../bloc/marimo_bloc/marimo_bloc.dart';
import '../../bloc/marimo_bloc/marimo_exp_bloc.dart';
import '../../const/constant.dart';
import '../../marimo_game_world.dart';
import '../effects/effects_component.dart';

class MarimoExpBar extends SpriteComponent
    with HasGameRef<MarimoWorldGame>, TapCallbacks {
  MarimoExpBar(Vector2 worldSize) {
    positionType = PositionType.viewport;
    position = Vector2(worldSize.x - 110, 12);
    //  position = Vector2(worldSize.x - 185, 12);
  }

  @override
  void onTapUp(TapUpEvent event) {
    GameAlert().showInfoDialog(
        title: "경험치",
        contents:
            """레벨:${game.marimoLevelBloc.state} \n${game.marimoExpBloc.state}/${game.marimoExpBloc.maxExp(game.marimoLevelBloc.state)}""",
        color: Color.fromRGBO(93, 164, 255, 1));
  }

  @override
  Future<void>? onLoad() async {
    final name = '${CommonConstant.assetsImageBar}exp_bar_${game.marimoExpBloc.changeLifeCycleToExp(game.marimoLevelBloc.state).name}.png';
    final lifeBarSprite = await game.images.load(name);
    sprite = Sprite(
      lifeBarSprite,
    );

    return super.onLoad();
  }

  @override
  Future<void> update(double dt) async {
    final name = '${CommonConstant.assetsImageBar}exp_bar_${game.marimoExpBloc.changeLifeCycleToExp(game.marimoLevelBloc.state).name}.png';
    sprite = await game.loadSprite(name);
    super.update(dt);
  }
}

class ExpController extends Component
    with HasGameRef<MarimoWorldGame>, FlameBlocListenable<MarimoExpBloc, int> {
  ExpController();

  late String name;

  @override
  bool listenWhen(int previousState, int newState) {
    if (previousState < newState) {
      name = 'exp_plus';
    } else {
      name = 'exp_minus';
    }

    if (newState >= game.marimoExpBloc.maxExp(game.marimoLevelBloc.state)) {
      game.marimoLevelBloc.levelUp();
      game.marimoExpBloc.initState();

      if(game.marimoLevelBloc.state == 21){
        levelUpMarimo();
      }else{
        int previousLevel = game.marimoLevelBloc.state -1;
        int newLevel = game.marimoLevelBloc.state;

        GameAlert()
            .showInfoDialog(color: Colors.indigoAccent, title: "마리모 레벨 [$previousLevel -> $newLevel]", contents: "얏호 >_< ! 마리모 level up!!");
      }

    }

    return previousState != newState;
  }

  @override
  void onRemove() {
    // TODO: implement onRemove
    super.onRemove();
  }

 Future<void> levelUpMarimo() async {
    game.soundBloc.effectSoundPlay('/music/popup.mp3');
    GameAlert().showInfoDialog(
      title: "마리모 성장",
      contents: Environment().config.constant.levelUpMsg,
      assetsName: 'assets/images/one_marimo.png',
      color: Color.fromRGBO(200, 139, 251, 1),
    );

    game.marimoExpBloc.initState();

    game.marimoBloc.add(const MarimoAppearanceStateChanged(MarimoAppearanceState.child));
  }

  @override
  void onNewState(int state) {

    parent?.add(gameRef.expEffectComponent = ExpEffectComponent(
      imageName: name,
      componentSize: Vector2.all(16),
      componentPosition: Vector2(game.size.x - 110, 25),
      movePostion: Vector2(game.size.x - 110, 15),
    ));
  }
}
