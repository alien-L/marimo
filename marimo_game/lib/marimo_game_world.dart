import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:marimo_game/app_manage/language.dart';
import 'package:marimo_game/bloc/component_bloc/background_bloc.dart';
import 'package:marimo_game/bloc/component_bloc/coin_bloc.dart';
import 'package:marimo_game/bloc/component_bloc/time_check_bloc.dart';
import 'package:marimo_game/bloc/component_bloc/enemy_bloc.dart';
import 'package:marimo_game/bloc/shop_bloc.dart';
import 'package:marimo_game/components/bar/marimo_exp_bar.dart';
import 'bloc/environment_bloc/environment_humity_bloc.dart';
import 'bloc/environment_bloc/environment_temperature_bloc.dart';
import 'bloc/environment_bloc/environment_trash_bloc.dart';
import 'bloc/component_bloc/language_manage_bloc.dart';
import 'bloc/marimo_bloc/marimo_exp_bloc.dart';
import 'bloc/marimo_bloc/marimo_bloc.dart';
import 'bloc/marimo_bloc/marimo_hp_bloc.dart';
import 'bloc/component_bloc/sound_bloc.dart';
import 'components/bar/coin_collector_bar.dart';
import 'components/bar/environment_state_bar.dart';
import 'components/bar/marimo_hp_bar.dart';
import 'components/effects/effects_component.dart';
import 'components/marin_animal.dart';
import 'components/moldy.dart';
import 'components/item.dart';
import 'components/enemy.dart';
import 'components/world.dart' as marimoWorld;
import 'helpers/direction.dart';
import 'components/coin.dart';
import 'components/marimo.dart';

class MarimoWorldGame extends FlameGame
    with PanDetector, HasCollisionDetection {
  late Marimo marimoComponent;
  late Enemy enemyComponent;
  late Item shopComponent;
  late MarinAnimal marinAnimalsComponent;

  late EnvironmentStateBar environmentStateBar;
  late EffectComponent coinEffectComponent;
  late HpEffectComponent hpEffectComponent;
  late ExpEffectComponent expEffectComponent;
  late ShopBloc shopBloc;

  final MarimoBloc marimoBloc;
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

  final EnemyBloc enemyBloc;

  late Timer bulletCreator;
  final List<Coin> _coinList = List<Coin>.empty(growable: true);
  final List<MoldyComponent> moldyList =
      List<MoldyComponent>.empty(growable: true);

  final CoinCollector _coinCollector = CoinCollector();
  final MarimoHpBar _marimoHpBar = MarimoHpBar();
  final MarimoExpBar _marimoExpBar = MarimoExpBar();

  //final coin = CoinDecoComponent();

  MarimoWorldGame({
    required this.shopBloc,
    required this.marimoExpBloc,
    required this.languageManageBloc,
    required this.marimoHpBloc,
    required this.marimoBloc,
    required this.environmentHumidityBloc,
    required this.environmentTemperatureBloc,
    required this.environmentTrashBloc,
    required this.soundBloc,
    required this.coinBloc,
    required this.backgroundBloc,
    required this.timeCheckBloc,
    required this.enemyBloc,
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
    await add(marimoWorld.World(backgroundBloc));
    add(ScreenHitbox());

    final marimoLevel = marimoBloc.state.marimoLevel;
    final marimoEmotion = marimoBloc.state.marimoEmotion;

    await add(
      FlameMultiBlocProvider(
        providers: [
          FlameBlocProvider<ShopBloc, ItemState>.value(
            value: shopBloc,
          ),
          FlameBlocProvider<LanguageManageBloc, Language>.value(
            value: languageManageBloc,
          ),
          FlameBlocProvider<MarimoBloc, MarimoState>.value(
            value: marimoBloc,
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
          shopComponent = Item(),
          marimoComponent = Marimo(
              levelName: marimoLevel.name, emotionName: marimoEmotion.name),
          environmentStateBar = EnvironmentStateBar(),
          MarimoController(),
          ItemController(),
          EnemyController(),
          CoinController(),
          HpController(),
        ],
      ),
    );

    add(_coinCollector);
    //add(CoinDecoComponent(size));
    int totalCoinCount = await coinBloc.getTotalCoinCount();
    int num = timeCheckBloc.state ? 20 : totalCoinCount;

    for (var i = 0; i < num; i++) {
      final tempCoin = Coin(size);
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

    marimoComponent.position = Vector2(100, 300);
    soundBloc.bgmPlay();
  }
}
