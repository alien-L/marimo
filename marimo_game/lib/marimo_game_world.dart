import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:marimo_game/bloc/component_bloc/coin_bloc.dart';
import 'package:marimo_game/components/trash_component.dart';
import 'app_manage/local_repository.dart';
import 'bloc/environment_bloc/environment_humity_bloc.dart';
import 'bloc/environment_bloc/environment_temperature_bloc.dart';
import 'bloc/environment_bloc/environment_trash_bloc.dart';
import 'bloc/environment_bloc/environment_water_bloc.dart';
import 'bloc/marimo_bloc/marimo_level_bloc.dart';
import 'bloc/marimo_bloc/marimo_lifecycle_bloc.dart';
import 'bloc/marimo_bloc/marimo_score_bloc.dart';
import 'bloc/component_bloc/sound_bloc.dart';
import 'components/bar/coin_collector_bar.dart';
import 'components/bar/environment_state_bar.dart';
import 'components/bar/marimo_state_bar.dart';
import 'components/moldy_component.dart';
import 'components/world.dart';
import 'components/world_collidable.dart';
import 'helpers/direction.dart';
import 'components/coin_component.dart';
import 'components/marimo_component.dart';

class MarimoWorldGame extends FlameGame
    with PanDetector, HasCollisionDetection {
  late MarimoComponent marimoComponent;
  late EnvironmentStateBar environmentStateBar;

  // int marimoStateScore = 50;

  final MarimoLevelBloc marimoLevelBloc;
  final MarimoScoreBloc marimoScoreBloc;
  final MarimoLifeCycleBloc marimoLifeCycleBloc;

  final EnvironmentHumidityBloc environmentHumidityBloc;
  final EnvironmentTemperatureBloc environmentTemperatureBloc;
  final EnvironmentTrashBloc environmentTrashBloc;
  final EnvironmentWaterBloc environmentWaterBloc;

  final SoundBloc soundBloc;
  final CoinBloc coinBloc;

  late Timer bulletCreator;
  final List<CoinComponent> _coinList =
      List<CoinComponent>.empty(growable: true);
  final List<MoldyComponent> moldyList =
      List<MoldyComponent>.empty(growable: true);
  final List<TrashComponent> trashList =
      List<TrashComponent>.empty(growable: true);

  late World _world;
  final CoinCollector _coinCollector = CoinCollector();
  final MarimoStateBar _marimoStateBar = MarimoStateBar();
  LocalRepository localRepository = LocalRepository();
  final BuildContext context;

  MarimoWorldGame({
    required this.marimoScoreBloc,
    required this.marimoLevelBloc,
    required this.marimoLifeCycleBloc,
    required this.environmentHumidityBloc,
    required this.environmentTemperatureBloc,
    required this.environmentTrashBloc,
    required this.environmentWaterBloc,
    required this.context,
    required this.soundBloc,
    required this.coinBloc,
  });

  void onJoypadDirectionChanged(Direction direction) {
    marimoComponent.direction = direction;
  }

  @override
  void update(double dt) {
    super.update(dt);
  }

  @override
  Future<void> onLoad() async {
    bool isHotWater = environmentTemperatureBloc.isHotWater();
    _world = World(isHotWater);
    final marimoLevel = await localRepository.getValue(key: "MarimoLevel");
    await add(_world);
    await add(
      FlameMultiBlocProvider(
        providers: [
          FlameBlocProvider<MarimoLifeCycleBloc, MarimoLifeCycle>.value(
            value: marimoLifeCycleBloc,
          ),
          FlameBlocProvider<MarimoLevelBloc, MarimoLevel>.value(
            value: marimoLevelBloc,
          ),
          FlameBlocProvider<MarimoScoreBloc, int>.value(
            value: marimoScoreBloc,
          ),
          FlameBlocProvider<EnvironmentTemperatureBloc, double>.value(
            value: environmentTemperatureBloc,
          ),
          FlameBlocProvider<EnvironmentHumidityBloc, int>.value(
            value: environmentHumidityBloc,
          ),
          FlameBlocProvider<EnvironmentTrashBloc, bool>.value(
            value: environmentTrashBloc,
          ),
          FlameBlocProvider<EnvironmentWaterBloc, bool>.value(
            value: environmentWaterBloc,
          ),
          FlameBlocProvider<SoundBloc, bool>.value(value: soundBloc),
          FlameBlocProvider<CoinBloc, int>.value(value: coinBloc),
        ],
        children: [
          marimoComponent =
              MarimoComponent(name: marimoLevel ?? "baby", context: context),
          environmentStateBar = EnvironmentStateBar(),
          MarimoController(context),
          //EnvironmentStatController(),
        ],
      ),
    );
    // 로컬저장소에 값이 있나 없나 체크

    add(_coinCollector);

    // 코인 조건 넣어주기
    for (var i = 0; i < 10; i++) {
      final tempCoin = CoinComponent(size);
      _coinList.add(tempCoin);
      add(tempCoin);
    }

    print(
        "humidity ===> ${environmentHumidityBloc.state}, ${environmentHumidityBloc.goMoldy()}");

    if (environmentHumidityBloc.goMoldy()) {
      for (var i = 0; i < 10; i++) {
        final tempMoldy = MoldyComponent(size);
        moldyList.add(tempMoldy);
        add(tempMoldy);
      }
    }

    if (!environmentTrashBloc.state) {
      for (var i = 0; i < 10; i++) {
        final tempTrash = TrashComponent(size);
        trashList.add(tempTrash);
        add(tempTrash);
      }
    }

    // 동전 남아있게 만들기
    add(_marimoStateBar); // 마리모 상태바

    marimoComponent.position = _world.size / 2;

    camera.followComponent(marimoComponent,
        worldBounds: Rect.fromLTRB(0, 0, _world.size.x, _world.size.y));

    soundBloc.bgmPlay();
  }

  WorldCollidable createWorldCollidable(Rect rect) {
    final collidable = WorldCollidable();
    collidable.position = Vector2(rect.left, rect.top);
    collidable.width = rect.width;
    collidable.height = rect.height;

    return collidable;
  }
}
