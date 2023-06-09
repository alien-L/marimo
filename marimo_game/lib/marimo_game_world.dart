import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:marimo_game/app_manage/language.dart';
import 'package:marimo_game/bloc/component_bloc/background_bloc.dart';
import 'package:marimo_game/bloc/component_bloc/coin_bloc.dart';
import 'package:marimo_game/bloc/component_bloc/time_check_bloc.dart';
import 'package:marimo_game/bloc/component_bloc/villian_bloc.dart';
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
import 'components/frog_component.dart';
import 'components/marin_animals_component.dart';
import 'components/moldy_component.dart';
import 'components/shop_component.dart';
import 'components/villain_component.dart';
import 'components/world.dart' as marimoWorld;
import 'helpers/direction.dart';
import 'components/coin_component.dart';
import 'components/marimo_component.dart';

class MarimoWorldGame extends FlameGame
    with PanDetector, HasCollisionDetection {
  late MarimoComponent marimoComponent;
  late VillainComponent villainComponent;
  late ShopComponent shopComponent;
  late EnvironmentStateBar environmentStateBar;

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

  final VillainBloc villainBloc;

  late Timer bulletCreator;
  final List<CoinComponent> _coinList =
      List<CoinComponent>.empty(growable: true);
  final List<MoldyComponent> moldyList =
      List<MoldyComponent>.empty(growable: true);

//  late World _world;

  final CoinCollector _coinCollector = CoinCollector();
  final MarimoHpBar _marimoHpBar = MarimoHpBar();
  final MarimoExpBar _marimoExpBar = MarimoExpBar();

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
    required this.villainBloc,
  });

  //final List<MarinAnimialsComponent> _fishList = List<MarinAnimialsComponent>.empty(growable: true);

  void onJoypadDirectionChanged(Direction direction) {
    marimoComponent.direction = direction;
  }

  @override
  Future<void> update(double dt) async {
    super.update(dt);
    //    bool isLevel2 = marimoExpBloc.changeLifeCycleToExp(marimoBloc.state.marimoLevel) ==  MarimoExpState.level2;
    //   if(isLevel2){
    //     print("level 2");
    //     // await add(ShopComponent(
    //     //     name: 'tree',
    //     //     componentPosition: Vector2(100,size.y-210),
    //     //     componentSize: Vector2.all(200)));
    //   }
  }

  @override
  Future<void> onLoad() async {
    // super.onLoad();
    await add(marimoWorld.World(backgroundBloc));
    // await add(ShopComponent(
    //     name: 'tree',
    //     componentPosition: Vector2(100,size.y-210),
    //     componentSize: Vector2.all(200)));
    // await add(ShopComponent(
    //     name: 'flower',
    //     componentPosition: Vector2(270,size.y-150),
    //     componentSize: Vector2.all(50)));
    // await add(ShopComponent(
    //     name: 'coral',
    //     componentPosition: Vector2(size.x -50,size.y-180),
    //     componentSize: Vector2.all(100)));
    // await add(ShopComponent(
    //     name: 'mushroom',
    //     componentPosition: Vector2(170,size.y-150),
    //     componentSize: Vector2.all(50)));

    //  add(SpriteSheetWidget());
    //  for (var i = 0; i < 10; i++) {
    final creationTime = DateTime.now().millisecondsSinceEpoch / 1000.0;
    final tempFish = MarinAnimialsComponent(
      worldSize: size,
      time: creationTime,
      imageName: "octopus_sprite",
      screenSize: Vector2(48, 48),
      imageSize: Vector2(48, 48),
      totalNum: 5,
    );
    final tempFish2 = MarinAnimialsComponent(
      worldSize: size,
      time: creationTime,
      imageName: "deep_sea_fish_sprite",
      screenSize: Vector2(48, 48),
      imageSize: Vector2(48, 48),
      totalNum: 3,
    );
    final tempFish3 = MarinAnimialsComponent(
      worldSize: size,
      time: creationTime,
      imageName: "turtle_sprite",
      screenSize: Vector2(48, 48),
      imageSize: Vector2(48, 48),
      totalNum: 5,
    );

    final tempFish4 = MarinAnimialsComponent(
      worldSize: size,
      time: creationTime,
      imageName: "frog_sprite",
      screenSize: Vector2(32, 32),
      imageSize: Vector2(16, 16),
      totalNum: 3,
    );
    final tempFish5 = MarinAnimialsComponent(
      worldSize: size,
      time: creationTime,
      imageName: "blue_marlin_sprite",
      screenSize: Vector2(48, 48),
      imageSize: Vector2(48, 48),
      totalNum: 3,
    );
    final tempFish6 = MarinAnimialsComponent(
      worldSize: size,
      time: creationTime,
      imageName: "earthworm_sprite",
      screenSize: Vector2(48, 48),
      imageSize: Vector2(48, 48),
      totalNum: 5,
    );
    final tempFish7 = MarinAnimialsComponent(
      worldSize: size,
      time: creationTime,
      imageName: "crab_sprites",
      screenSize: Vector2(48, 48),
      imageSize: Vector2(48, 48),
      totalNum: 3,
    );
    add(tempFish7);
    add(tempFish6);
    add(tempFish5);
    add(tempFish4);
    add(tempFish3);
    add(tempFish2);
    add(tempFish);
    //   }
    // add(DeepSeaFishComponent(size));
    // add(CrabMarlinComponent(size));
    add(ScreenHitbox());
    // _world = World(backgroundBloc);
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
          villainComponent = VillainComponent(size, MarimoLevel.zero),
          shopComponent = ShopComponent(),
          marimoComponent = MarimoComponent(
              levelName: marimoLevel.name, emotionName: marimoEmotion.name),
          environmentStateBar = EnvironmentStateBar(),
          MarimoController(),
          ShopItemController(),
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
    marimoComponent.position = Vector2(100, 300);
    // marimoComponent.position = _world.size / 2;
    //add(VillainComponent(size,MarimoLevel.zero));
    soundBloc.bgmPlay();
  }
}
