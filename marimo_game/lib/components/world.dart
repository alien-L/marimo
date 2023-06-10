import 'package:flame/components.dart';
import '../bloc/component_bloc/background_bloc.dart';
class World extends SpriteComponent with HasGameRef {
  World(this.backgroundBloc);
  final BackgroundBloc backgroundBloc;

  @override
  Future<void>? onLoad() async {
    String backgroundTxt = backgroundBloc.getBackgroundName();
    sprite = await gameRef.loadSprite('$backgroundTxt.png');
    size = gameRef.size;
  }

  @override
  Future<void> update(double dt) async {
    String backgroundTxt = backgroundBloc.getBackgroundName();
    sprite = await gameRef.loadSprite('$backgroundTxt.png');
    size = gameRef.size;
  }
}
