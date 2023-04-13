import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'app_manage/local_repository.dart';
import 'bloc/marimo_bloc/marimo_bloc.dart';
import 'components/world.dart';
import 'components/world_collidable.dart';
import 'helpers/direction.dart';
import 'components/coin_component.dart';
import 'components/marimo_component.dart';


class MarimoWorldGame extends FlameGame
    with PanDetector, HasCollisionDetection{
  late MarimoComponent marimoComponent;
  int coinsCollected = 0;
  final MarimoBloc marimoBloc;
  late Timer bulletCreator;
  final List<CoinComponent> _coinList = List<CoinComponent>.empty(growable: true);
  final World _world = World();
  LocalRepository localRepository = LocalRepository();

  MarimoWorldGame({
    required this.marimoBloc,
  });

  void onJoypadDirectionChanged(Direction direction) {
   print("🦄🦄 ${marimoComponent.position}");
  // if(marimoComponent.position.x  != null){
    //  if(marimoComponent.position.x  < 10){
    //   print("🦄🦄 ${marimoComponent.position.x}");
     //  marimoComponent.direction = Direction.none;
 //    } else{
        marimoComponent.direction = direction;
 //    }
  // }
  }

  @override
  Future<void> onLoad() async {
    final marimoLevel = await localRepository.getValue(key: "MarimoLevel");
    await add(_world);
    await add(
      FlameMultiBlocProvider(
        providers: [
          FlameBlocProvider<MarimoBloc, MarimoLevelState>.value(
            value: marimoBloc,
          ),
        ],
        children: [
          marimoComponent = MarimoComponent(name: marimoLevel!),
          MarimoController(),
        ],
      ),
    );

   // 코인 조건 넣어주기
    for (var i = 0; i < 10; i++) {
      final tempCoin = CoinComponent(size);
      _coinList.add(tempCoin);
      add(tempCoin);
    }

    marimoComponent.position = _world.size / 2;

    // camera.followComponent(marimoComponent,
    //     worldBounds: Rect.fromLTRB(0, 0, _world.size.x, _world.size.y));

  }

  WorldCollidable createWorldCollidable(Rect rect) {
    final collidable = WorldCollidable();
    collidable.position = Vector2(rect.left, rect.top);
    collidable.width = rect.width;
    collidable.height = rect.height;

    return collidable;
  }

}

