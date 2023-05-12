import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/material.dart';
import 'package:marimo_game/app_manage/local_repository.dart';
import '../../marimo_game_world.dart';

// class EnvironmentStatController extends Component
//     with
//         HasGameRef<MarimoWorldGame>,
//         FlameBlocListenable<EnvironmentBloc, EnvironmentState> {
//   @override
//   bool listenWhen(EnvironmentState previousState, EnvironmentState newState) {
//     return true;
//   }
//
//   @override
//   void onNewState(EnvironmentState state) {
//     if(state is Loaded){
//       if(state.isCleanWater){
//         print("마리모 환경 이벤트 발생이요 ");
//      //   game.marimoBloc.add(MarimoStateScoreCalculatedEvent(isPlus: true,score: 5));
//       }
//     }
//    // print("${state as Loaded}");
//    // game.marimoBloc.add();
//
//   }
// }

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
  late SpriteComponent _waterChangedSpriteComponent;
  late SpriteComponent _trashChangedSpriteComponent;
  LocalRepository localRepository = LocalRepository();

  @override
  Future<void>? onLoad() async {
    final bool isCleanTrash = game.environmentTrashBloc.state;
    final bool isCleanWater = game.environmentWaterBloc.state;
    final int humidity = game.environmentHumidityBloc.state;
    final double temperature = game.environmentTemperatureBloc.state;

    _temperatureTextComponent = _textComponent("온도:$temperature°C", Vector2(90, 40));
    add(_temperatureTextComponent);

    _humidityTextComponent = _textComponent('습도:$humidity%', Vector2(150, 40));
    add(_humidityTextComponent);

    final waterDropSprite = await game.loadSprite('water_dop_${isCleanWater?"good":"bad"}.png');
    _waterChangedSpriteComponent =  SpriteComponent(
      sprite: waterDropSprite,
      position: Vector2(370, 40),
      size: Vector2(20, 20),
      anchor: Anchor.center,
    );
    add(_textComponent('물 갈아주기',Vector2(320, 40)));
    add(_waterChangedSpriteComponent);

    final foodTrashSprite = await game.loadSprite('${!isCleanTrash ?  "dirty":"clean" }.png');
    _trashChangedSpriteComponent  =  SpriteComponent(
      sprite: foodTrashSprite,
      position: Vector2(270, 40),
      size: Vector2(30, 30),
      anchor: Anchor.center,
    );
    add(_textComponent('쓰레기 버리기',Vector2(220, 40),));
    add(_trashChangedSpriteComponent);

    return super.onLoad();
  }

  TextComponent _textComponent(String txt, Vector2 vector2) {
    return TextComponent(
      text: txt,
      textRenderer: TextPaint(
        style: const TextStyle(
            fontFamily: 'NeoDunggeunmoPro',
            fontSize: 12,
            color: Colors.black,
            locale: Locale('ko', 'KO')),
      ),
      anchor: Anchor.center,
      position: vector2, //game.size.x - (60)
    );
  }

  @override
  Future<void> update(double dt) async {
    _temperatureTextComponent.text = '온도:${game.environmentTemperatureBloc.state}°C';
    _humidityTextComponent.text = '습도:${game.environmentHumidityBloc.state}%';
    _trashChangedSpriteComponent.sprite = await game.loadSprite('${!game.environmentTrashBloc.state?  "dirty":"clean" }.png');
    _waterChangedSpriteComponent.sprite = await game.loadSprite('water_dop_${game.environmentWaterBloc.state?"good":"bad"}.png');
    super.update(dt);
  }
}
