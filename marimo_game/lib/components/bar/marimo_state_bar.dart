import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/material.dart';
import '../../bloc/marimo_bloc/marimo_score_bloc.dart';
import '../../marimo_game_world.dart';

// class MarimoStateBarController extends Component
//     with
//         HasGameRef<MarimoWorldGame>,
//         FlameBlocListenable<MarimoScoreBloc,int> {
//   final BuildContext context;
//
//   MarimoStateBarController(this.context);
//
//   @override
//   bool listenWhen(int previousState,int newState) {
//     print("score 상태");
//     return previousState != newState;
//   }
//
//   @override
//   void onNewState(int state) {
//     print("score 상태 ===> $state ");
//     //parent?.add(MarimoComponent(name: state.name, context: context));
//     //parent?.addToParent(MarimoComponent(name: state.name, context: context));
//     // parent?.add(gameRef.marimoComponent =
//     //     MarimoComponent(name: state.name, context: context));
//
//   }
// }

class MarimoStateBar extends PositionComponent
    with HasGameRef<MarimoWorldGame>{
  MarimoStateBar() {
    positionType = PositionType.viewport;
  }

  late TextComponent _scoreTextComponent;
  late SpriteComponent _spriteComponent;

  @override
  Future<void>? onLoad() async {
   final marimoScoreBloc =  game.marimoScoreBloc;
   final marimoLifeCycleBloc = game.marimoLifeCycleBloc;

    final lifeBarSprite = await game.loadSprite('life_bar_${marimoLifeCycleBloc.state.name}.png');

   _scoreTextComponent = TextComponent(
     text: "${marimoScoreBloc.state}",
     textRenderer: TextPaint(
       style: const TextStyle(
           fontFamily: 'NeoDunggeunmoPro',
           fontSize: 12,
           color: Colors.black,
           locale: Locale('ko', 'KO')
       ),
     ),
     anchor: Anchor.center,
     position: Vector2(game.size.x-120,20), //game.size.x - (60)
   );

   _spriteComponent = SpriteComponent(
     sprite: lifeBarSprite,
     position: Vector2(game.size.x -70,20),
     anchor: Anchor.center,
   );

    add(_scoreTextComponent);
    add(_spriteComponent);

    return super.onLoad();
  }

  @override
  Future<void> update(double dt) async {
    _scoreTextComponent.text = '${game.marimoScoreBloc.state}';
    _spriteComponent.sprite = await game.loadSprite('life_bar_${game.marimoLifeCycleBloc.state.name}.png');
    super.update(dt);
  }
}
