import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:marimo_game/components/alert/game_alert.dart';
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
            "${game.marimoExpBloc.state}/${game.marimoExpBloc.getExpMaxCount(game.marimoBloc.state.marimoLevel)}",
        color: Color.fromRGBO(93, 164, 255, 1));
  }

  @override
  Future<void>? onLoad() async {
    final lifeBarSprite = await game.images.load(
        '${CommonConstant.assetsImageBar}exp_bar_${game.marimoExpBloc.changeLifeCycleToExp(game.marimoBloc.state.marimoLevel).name}.png');

    sprite = Sprite(
      lifeBarSprite,
    );

    return super.onLoad();
  }

  @override
  Future<void> update(double dt) async {
    sprite = await game.loadSprite(
        '${CommonConstant.assetsImageBar}exp_bar_${game.marimoExpBloc.changeLifeCycleToExp(game.marimoBloc.state.marimoLevel).name}.png');
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
    return previousState != newState;
  }

  @override
  void onRemove() {
    // TODO: implement onRemove
    super.onRemove();
  }

  @override
  void onNewState(int state) {
    parent?.add(gameRef.expEffectComponent = ExpEffectComponent(
      imageName: name,
      componentSize: Vector2.all(16),
      componentPosition: Vector2(game.size.x - 110, 25),
      movePostion: Vector2(game.size.x - 110, 15),
      // componentPosition: Vector2(game.size.x - 190, 25),
      // movePostion: Vector2(game.size.x - 190, 15),
    ));
  }
}
