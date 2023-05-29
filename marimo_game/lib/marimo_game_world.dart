import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:marimo_game/app_manage/language.dart';
import 'package:marimo_game/bloc/component_bloc/background_bloc.dart';
import 'package:marimo_game/bloc/component_bloc/coin_bloc.dart';
import 'package:marimo_game/bloc/component_bloc/time_check_bloc.dart';
import 'package:marimo_game/components/bar/marimo_exp_bar.dart';
import 'bloc/environment_bloc/environment_humity_bloc.dart';
import 'bloc/environment_bloc/environment_temperature_bloc.dart';
import 'bloc/environment_bloc/environment_trash_bloc.dart';
import 'bloc/component_bloc/language_manage_bloc.dart';
import 'bloc/marimo_bloc/marimo_exp_bloc.dart';
import 'bloc/marimo_bloc/marimo_level_bloc.dart';
import 'bloc/marimo_bloc/marimo_hp_bloc.dart';
import 'bloc/component_bloc/sound_bloc.dart';
import 'components/bar/coin_collector_bar.dart';
import 'components/bar/environment_state_bar.dart';
import 'components/bar/marimo_hp_bar.dart';
import 'components/moldy_component.dart';
import 'components/villian_component.dart';
import 'components/world.dart';
import 'components/world_collidable.dart';
import 'helpers/direction.dart';
import 'components/coin_component.dart';
import 'components/marimo_component.dart';

class MarimoWorldGame extends FlameGame
    with PanDetector, HasCollisionDetection{
  late MarimoComponent marimoComponent;
  late VillainComponent villainComponent;
  late EnvironmentStateBar environmentStateBar;

  final MarimoLevelBloc marimoLevelBloc;
  final MarimoHpBloc marimoHpBloc;
  final MarimoExpBloc marimoExpBloc;

  final LanguageManageBloc languageManageBloc;
  final EnvironmentHumidityBloc environmentHumidityBloc;
  final EnvironmentTemperatureBloc environmentTemperatureBloc;
  final EnvironmentTrashBloc environmentTrashBloc;

  final BackgroundBloc backgroundBloc;

  final SoundBloc soundBloc;
  final CoinBloc coinBloc;
  final TimeCheckBloc timeCheckBloc;

  late Timer bulletCreator;
  final List<CoinComponent> _coinList =
      List<CoinComponent>.empty(growable: true);
  final List<MoldyComponent> moldyList =
      List<MoldyComponent>.empty(growable: true);

  late World _world;

  final CoinCollector _coinCollector = CoinCollector();
  final MarimoHpBar _marimoHpBar = MarimoHpBar();
  final MarimoExpBar _marimoExpBar = MarimoExpBar();

  MarimoWorldGame({
    required this.marimoExpBloc,
    required this.languageManageBloc,
    required this.marimoHpBloc,
    required this.marimoLevelBloc,
    required this.environmentHumidityBloc,
    required this.environmentTemperatureBloc,
    required this.environmentTrashBloc,

    required this.soundBloc,
    required this.coinBloc,
    required this.backgroundBloc,
    required this.timeCheckBloc,
  });

  void onJoypadDirectionChanged(Direction direction) {
    marimoComponent.direction = direction;
  }

  @override
  Future<void> update(double dt) async {
    super.update(dt);
  }

  @override
  Future<void> onLoad() async {
    add(ScreenHitbox());
    _world = World(backgroundBloc);
    final marimoLevel = marimoLevelBloc.state;
    await add(_world);

    await add(
      FlameMultiBlocProvider(
        providers: [
          FlameBlocProvider<LanguageManageBloc, Language>.value(
            value: languageManageBloc,
          ),
          FlameBlocProvider<MarimoLevelBloc, MarimoLevel>.value(
            value: marimoLevelBloc,
          ),
          FlameBlocProvider<MarimoHpBloc, int>.value(
            value: marimoHpBloc,
          ),
          FlameBlocProvider<MarimoExpBloc, int>.value(
            value: marimoExpBloc,
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
          FlameBlocProvider<SoundBloc, bool>.value(value: soundBloc),
          FlameBlocProvider<CoinBloc, int>.value(value: coinBloc),
          FlameBlocProvider<TimeCheckBloc, bool>.value(value: timeCheckBloc),
        ],
        children: [
          villainComponent = VillainComponent(MarimoLevel.zero),
          marimoComponent = MarimoComponent(name: marimoLevel.name,),
          environmentStateBar = EnvironmentStateBar(),
          MarimoController(),
          VillainController(),
        ],
      ),
    );

    add(_coinCollector);

    int totalCoinCount = await coinBloc.getTotalCoinCount();
    int num = timeCheckBloc.state ? 20 : totalCoinCount;

    for (var i = 0; i < num; i++) {
      final tempCoin = CoinComponent(size);
      _coinList.add(tempCoin);
      add(tempCoin);
    }

    if (environmentHumidityBloc.goMoldy()) {
      for (var i = 0; i < 10; i++) {
        final tempMoldy = MoldyComponent(size);
        moldyList.add(tempMoldy);
        add(tempMoldy);
      }
    }

    // if (!environmentTrashBloc.state) {
    //   for (var i = 0; i < 10; i++) {
    //     final tempTrash = TrashComponent(size);
    //     trashList.add(tempTrash);
    //     add(tempTrash);
    //   }
    // }

    // 동전 남아있게 만들기
    add(_marimoHpBar); // 마리모 상태바
    add(_marimoExpBar);
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
