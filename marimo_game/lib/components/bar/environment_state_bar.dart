// import 'package:flame/components.dart';
// import 'package:flutter/material.dart';
// import 'package:marimo_game/bloc/component_bloc/background_bloc.dart';
// import '../../app_manage/environment/environment.dart';
// import '../../marimo_game_world.dart';
//
// class EnvironmentStateBar extends PositionComponent
//     with HasGameRef<MarimoWorldGame> {
//   EnvironmentStateBar({
//     super.position,
//     super.size,
//     super.scale,
//     super.angle,
//     super.anchor,
//     super.children,
//     super.priority = 5,
//   }) {
//     positionType = PositionType.viewport;
//   }
//
//   late TextComponent _humidityTextComponent;
//   late TextComponent _temperatureTextComponent;
//  // late SpriteComponent _trashChangedSpriteComponent;
//   final constant = Environment().config.constant;
//
//   @override
//   Future<void>? onLoad() async {
//     //final bool isCleanTrash = game.environmentTrashBloc.state;
//     final int humidity = game.environmentHumidityBloc.state;
//     final double temperature = game.environmentTemperatureBloc.state;
//
//     _temperatureTextComponent = _textComponent(constant.temperature+temperature.toString()+constant.celsius, Vector2(90, 40));
//     add(_temperatureTextComponent);
//
//     _humidityTextComponent = _textComponent(constant.humidity+humidity.toString()+constant.percent, Vector2(150, 40));
//     add(_humidityTextComponent);
//
//     // final foodTrashSprite = await game.loadSprite('${CommonConstant.assetsImageWaterManagement}${!isCleanTrash ?  "dirty":"clean" }.png');
//     // add(_textComponent(constant.environment,Vector2(205, 40),));
//     // _trashChangedSpriteComponent  =  SpriteComponent(
//     //   sprite: foodTrashSprite,
//     //   position: Vector2(250, 40),
//     //   size: Vector2(30, 30),
//     //   anchor: Anchor.center,
//     // );
//     // add(_trashChangedSpriteComponent);
//
//     return super.onLoad();
//   }
//
//   TextComponent _textComponent(String txt, Vector2 vector2) {
//     return TextComponent(
//       text: txt,
//       textRenderer: TextPaint(
//         style: const TextStyle(
//             fontFamily: 'NeoDunggeunmoPro',
//             fontSize: 12,
//             color: Colors.black,
//             locale: Locale('ko', 'KO')),
//       ),
//       anchor: Anchor.center,
//       position: vector2, //game.size.x - (60)
//     );
//   }
//
//   @override
//   Future<void> update(double dt) async {
//
//     if(game.environmentTemperatureBloc.isHotWater()){
//       game.backgroundBloc.backgroundChange(BackgroundState.red);
//     }else{
//       game.backgroundBloc.backgroundChange(BackgroundState.normal);
//     }
//
//     _temperatureTextComponent.text = constant.temperature+game.environmentTemperatureBloc.state.toString()+constant.celsius;
//     _humidityTextComponent.text = constant.humidity+game.environmentHumidityBloc.state.toString()+constant.percent;
//   //  _trashChangedSpriteComponent.sprite = await game.loadSprite('water_management/${!game.environmentTrashBloc.state?  "dirty":"clean" }.png');
//     super.update(dt);
//   }
// }
