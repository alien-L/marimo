import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/material.dart';
import 'package:marimo_game/app_manage/local_repository.dart';
import 'package:marimo_game/bloc/environment_bloc/environment_bloc.dart';
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
      if(state.isWaterChanged){
        print("마리모 환경 이벤트 발생이요 ");
     //   game.marimoBloc.add(MarimoStateScoreCalculatedEvent(isPlus: true,score: 5));
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
 // late TextComponent _waterChangedTextComponent;
//  late TextComponent _foodTrashChangedTextComponent;
  LocalRepository localRepository  = LocalRepository();

  @override
  Future<void>? onLoad() async {
    final environmentBlocState = game.environmentBloc.state as Loaded;
    String foodTrashState = environmentBlocState.isFoodTrashChanged?"clean":"dirty";
    String isWaterChanged = environmentBlocState.isWaterChanged?"good":"bad";
    String humidity = environmentBlocState.humidity.toString();
    String temperature = environmentBlocState.temperature.toString();

    //String? humidity = await localRepository .getValue(key: "humidity");
   //String? temperature = await localRepository .getValue(key: "temperature");
   // String? isWaterChanged =  await localRepository .getValue(key: "isWaterChanged");
   // String? isFoodTrashChanged =  await localRepository .getValue(key: "isFoodTrashChanged");

   _humidityTextComponent =
       _textComponent('$humidity%', Vector2(100, 40));
    add(_humidityTextComponent);

    final waterDropSprite = await game.loadSprite('water_dop_$isWaterChanged.png');
    add(
      SpriteComponent(
        sprite: waterDropSprite,
        position:  Vector2(290, 40),
        size: Vector2(20,20),
        anchor: Anchor.center,
      ),
    );
    _temperatureTextComponent =
   _textComponent("$temperature°C", Vector2(180, 40));
    add(_temperatureTextComponent);

    final foodTrashSprite = await game.loadSprite('$foodTrashState.png');
    add(
      SpriteComponent(
        sprite: foodTrashSprite,
        position:  Vector2(250, 40),
        size: Vector2(30,30),
        anchor: Anchor.center,
      ),
    );

  //  _waterChangedTextComponent =
   //     _textComponent("${isWaterChanged=="0"?true:false}", Vector2(game.size.x - (90), 65));
   // _foodTrashChangedTextComponent =
     //   _textComponent("${isFoodTrashChanged=="0"?true:false}", Vector2(game.size.x - (130), 65));


 //   add(_waterChangedTextComponent);
  //  add(_foodTrashChangedTextComponent);

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
          locale: Locale('ko', 'KO')
        ),
      ),
      anchor: Anchor.center,
      position: vector2, //game.size.x - (60)
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
  }
}
