import 'package:flame/components.dart';
import '../bloc/component_bloc/background_bloc.dart';
import '../const/constant.dart';
class World extends SpriteComponent with HasGameRef {
  World(this.backgroundBloc);
  final BackgroundBloc backgroundBloc;

  @override
  Future<void>? onLoad() async {
    String backgroundName = backgroundBloc.getBackgroundName();
    sprite = await gameRef.loadSprite('${CommonConstant.assetsImageBackground}$backgroundName.png');
    size = gameRef.size;
  }

  @override
  Future<void> update(double dt) async {
    String backgroundName = backgroundBloc.getBackgroundName();
    sprite = await gameRef.loadSprite('${CommonConstant.assetsImageBackground}$backgroundName.png');
    size = gameRef.size;
  }
}
