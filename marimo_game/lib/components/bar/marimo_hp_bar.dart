import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/material.dart';
import 'package:marimo_game/const/constant.dart';
import '../../bloc/marimo_bloc/marimo_hp_bloc.dart';
import '../../marimo_game_world.dart';
import '../alert/game_alert.dart';
import '../effects/effects_component.dart';

// class MarimoHpBar extends SpriteComponent with HasGameRef<MarimoWorldGame>, TapCallbacks {
//   MarimoHpBar(Vector2 worldSize) {
//     positionType = PositionType.viewport;
//     position = Vector2(worldSize.x - 110, 12);
//   }
//
//   @override
//   void onTapUp(TapUpEvent event) {
//     GameAlert().showInfoDialog(title:"체력",
//         contents:"${game.marimoHpBloc.state}/100",color:Color.fromRGBO(224, 112, 178,1) );
//   }
//
//
//
//   @override
//   Future<void>? onLoad() async {
//     final hpSprite = await game.images.load(
//         '${CommonConstant.assetsImageBar}life_bar_${game.marimoExpBloc.changeLifeCycleToExp(game.marimoBloc.state.marimoLevel).name}.png');
//
//     sprite = Sprite(
//       hpSprite,
//     );
//
//     return super.onLoad();
//   }
//
//   @override
//   Future<void> update(double dt) async {
//     if (game.marimoHpBloc.changeLifeCycleToHp().name != "die") {
//       sprite = await game.loadSprite(
//           '${CommonConstant.assetsImageBar}life_bar_${game.marimoHpBloc.changeLifeCycleToHp().name}.png');
//     }
//     super.update(dt);
//   }
// }

//
// class HpController extends Component
//     with HasGameRef<MarimoWorldGame>, FlameBlocListenable<MarimoHpBloc, int> {
//   HpController();
//
//  late String name;
//
//   @override
//   bool listenWhen(int previousState, int newState) {
//     if (previousState < newState) {
//       name = 'hp_plus';
//     } else {
//       name = 'hp_minus';
//     }
//     return previousState != newState;
//   }
//
//   @override
//   void onRemove() {
//     // TODO: implement onRemove
//     super.onRemove();
//   }
//
//   @override
//   void onNewState(int state) {
//     parent?.add(gameRef.hpEffectComponent = HpEffectComponent(
//       imageName: name,
//       componentSize: Vector2.all(16),
//       componentPosition: Vector2(game.size.x - 110, 25),
//       movePostion: Vector2(game.size.x - 110, 15),
//     ));
//   }
// }
