import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:marimo_game/components/game_alert.dart';
import '../bloc/component_bloc/background_bloc.dart';

// 백그라운드 사이즈는 어떻게 정하지???
class World extends SpriteComponent with HasGameRef {
  World(this.backgroundBloc);
  final BackgroundBloc backgroundBloc;

  @override
  Future<void>? onLoad() async {
    String backgroundTxt = backgroundBloc.getBackgroundName();
    sprite = await gameRef.loadSprite('$backgroundTxt.png');
    size = gameRef.size;
   // GameAlert().showErrorDialog(text: "size ==> $size");
  }

  @override
  Future<void> update(double dt) async {
    String backgroundTxt = backgroundBloc.getBackgroundName();
    sprite = await gameRef.loadSprite('$backgroundTxt.png');
    size = gameRef.size;
  }
}
