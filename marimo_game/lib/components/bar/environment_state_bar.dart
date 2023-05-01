import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/material.dart';
import 'package:marimo_game/app_manage/local_repository.dart';
import 'package:marimo_game/bloc/environment_bloc/environment_bloc.dart';

import '../../bloc/marimo_bloc/marimo_bloc.dart';
import '../../marimo_game_world.dart';

class EnvironmentStatController extends Component
    with
        HasGameRef<MarimoWorldGame>,
        FlameBlocListenable<EnvironmentBloc, EnvironmentState> {
  @override
  bool listenWhen(EnvironmentState previousState, EnvironmentState newState) {
    return true;
  }

  @override
  void onNewState(EnvironmentState state) {
    if(state is Loaded){
      if(state.isWaterChanged!){
        print("마리모 환경 이벤트 발생이요 ");
        game.marimoBloc.add(MarimoStateScoreCalculatedEvent(isPlus: true,score: 5));
      }
    }
   // print("${state as Loaded}");
   // game.marimoBloc.add();

  }
}

class EnvironmentStateBar extends PositionComponent
    with HasGameRef<MarimoWorldGame> {
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

  late TextComponent _humidityTextComponent;
  late TextComponent _temperatureTextComponent;
  late TextComponent _waterChangedTextComponent;
  late TextComponent _foodTrashChangedTextComponent;
  LocalRepository localRepository  = LocalRepository();

  @override
  Future<void>? onLoad() async {
    String? humidity = await localRepository .getValue(key: "humidity");
    String? temperature = await localRepository .getValue(key: "temperature");
    String? isWaterChanged =  await localRepository .getValue(key: "isWaterChanged");
    String? isFoodTrashChanged =  await localRepository .getValue(key: "isFoodTrashChanged");

    _humidityTextComponent =
        _textComponent("$humidity", Vector2(game.size.x - (20), 65));
     _temperatureTextComponent =
    _textComponent("$temperature", Vector2(game.size.x - (60), 65));
    _waterChangedTextComponent =
        _textComponent("${isWaterChanged=="0"?true:false}", Vector2(game.size.x - (90), 65));
    _foodTrashChangedTextComponent =
        _textComponent("${isFoodTrashChanged=="0"?true:false}", Vector2(game.size.x - (130), 65));

    add(_humidityTextComponent);
    add(_temperatureTextComponent);
    add(_waterChangedTextComponent);
    add(_foodTrashChangedTextComponent);

    return super.onLoad();
  }

  TextComponent _textComponent(String txt, Vector2 vector2) {
    return TextComponent(
      text: txt,
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 15,
          color: Colors.black,
        ),
      ),
      anchor: Anchor.center,
      position: vector2, //game.size.x - (60)
    );
  }

  @override
  void update(double dt) {
    final environmentBloc = game.environmentBloc.state;

    if (environmentBloc is Loaded) {
      _humidityTextComponent.text = '${environmentBloc.humidity}';
      _temperatureTextComponent.text = '${environmentBloc.temperature}';
      _waterChangedTextComponent.text = '${environmentBloc.isWaterChanged}';
      _foodTrashChangedTextComponent.text = '${environmentBloc.isFoodTrashChanged}';
    }

    super.update(dt);
  }
}
