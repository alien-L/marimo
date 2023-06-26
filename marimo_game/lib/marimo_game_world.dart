import 'dart:convert';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:marimo_game/app_manage/language.dart';
import 'package:marimo_game/bloc/component_bloc/background_bloc.dart';
import 'package:marimo_game/bloc/component_bloc/coin_bloc.dart';
import 'package:marimo_game/bloc/component_bloc/time_check_bloc.dart';
import 'package:marimo_game/bloc/shop_bloc.dart';
import 'package:marimo_game/components/bar/marimo_exp_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_manage/local_data_manager.dart';
import 'bloc/component_bloc/language_manage_bloc.dart';
import 'bloc/marimo_bloc/marimo_exp_bloc.dart';
import 'bloc/marimo_bloc/marimo_bloc.dart';
import 'bloc/component_bloc/sound_bloc.dart';
import 'bloc/marimo_bloc/marimo_level_bloc.dart';
import 'components/bar/coin_collector_bar.dart';
import 'components/effects/effects_component.dart';
import 'components/food.dart';
import 'components/marin_animal.dart';
import 'components/item.dart';
import 'components/world.dart' as marimoWorld;
import 'helpers/direction.dart';
import 'components/coin.dart';
import 'components/marimo.dart';

class MarimoWorldGame extends FlameGame
    with PanDetector, HasCollisionDetection {
  late Marimo marimoComponent;
  late Food food;
  late Item shopComponent;
  late MarinAnimal marinAnimalsComponent;

  // late EnvironmentStateBar environmentStateBar;
  late CoinEffectComponent coinEffectComponent;

  late ExpEffectComponent expEffectComponent;
  late ShopBloc shopBloc;

  final MarimoBloc marimoBloc;
  final MarimoLevelBloc marimoLevelBloc;
  final MarimoExpBloc marimoExpBloc;

  final LanguageManageBloc languageManageBloc;

  final BackgroundBloc backgroundBloc;

  final SoundBloc soundBloc;
  final CoinBloc coinBloc;
  final TimeCheckBloc timeCheckBloc;

  //final EnemyBloc enemyBloc;

  final List<Coin> _coinList = List<Coin>.empty(growable: true);

  // final List<MoldyComponent> moldyList =
  //     List<MoldyComponent>.empty(growable: true);

  final CoinCollector _coinCollector = CoinCollector();

  late MarimoExpBar _marimoExpBar;

  MarimoWorldGame({
    required this.marimoLevelBloc,
    required this.shopBloc,
    required this.marimoExpBloc,
    required this.languageManageBloc,
    // required this.marimoHpBloc,
    required this.marimoBloc,
    // required this.environmentHumidityBloc,
    // required this.environmentTemperatureBloc,
    //required this.environmentTrashBloc,
    required this.soundBloc,
    required this.coinBloc,
    required this.backgroundBloc,
    required this.timeCheckBloc,
    //  required this.enemyBloc,
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
    soundBloc.bgmPlay();
    final marimoAppearanceState = marimoBloc.state.marimoAppearanceState;
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
          // FlameBlocProvider<MarimoHpBloc, int>.value(
          //   value: marimoHpBloc,
          // ),
          FlameBlocProvider<MarimoExpBloc, int>.value(
            value: marimoExpBloc,
          ),
          FlameBlocProvider<MarimoLevelBloc, int>.value(
            value: marimoLevelBloc,
          ),
          FlameBlocProvider<SoundBloc, bool>.value(value: soundBloc),
          FlameBlocProvider<CoinBloc, int>.value(value: coinBloc),
          FlameBlocProvider<TimeCheckBloc, bool>.value(value: timeCheckBloc),
        ],
        children: [
          shopComponent = Item(),
          marinAnimalsComponent = MarinAnimal(
              worldSize: size,
              animalName: "zero",
              screenSize: Vector2.all(10),
              imageSize: Vector2.all(10),
              totalNum: 1),
          marimoComponent = Marimo(
              marimoAppearanceStateName: marimoAppearanceState.name,
              emotionName: marimoEmotion.name),
          _marimoExpBar = MarimoExpBar(size),
          coinEffectComponent = CoinEffectComponent(
            componentSize: Vector2.all(16),
            componentPosition: Vector2(65, 50),
            movePostion: Vector2(65, 20),
            imageName: 'coin',
          ),
          MarimoController(),
          ItemController(),
          CoinController(),
          ExpController(),
        ],
      ),
    );

    add(_coinCollector);
    int num = 20;
    // soundBloc.bgmPlay();

    for (var i = 0; i < num; i++) {
      final tempCoin = Coin(size);
      _coinList.add(tempCoin);
      add(tempCoin);
    }

    final shopData = await LocalDataManager().getValue<String>(key: "shopData");
    List list = json.decode(shopData).cast<Map<String, dynamic>>().toList();

    for (var item in list) {
      bool boughtItem = item["bought"];
      if (boughtItem) {
        Map<String, dynamic> _map =
            list.firstWhere((element) => element["name"] == item["name"]);

        for (var i = 0; i < item["su"]; i++) {
          if (item["name_en"] == "bubble") {
            add(marinAnimalsComponent = MarinAnimal(
              worldSize: size,
              animalName: _map["name_en"],
              screenSize: Vector2.all(30),
              imageSize: Vector2.all(300),
              totalNum: 6,
              key: UniqueKey(),
            ));
            add(marinAnimalsComponent = MarinAnimal(
              worldSize: size,
              animalName: _map["name_en"],
              screenSize: Vector2.all(30),
              imageSize: Vector2.all(300),
              totalNum: 11,
              key: UniqueKey(),
            ));
          }else {
            if(item["name_en"] == "marimofood"){
              if(item["su"] < 0){
                return;
              }else{
                print("su   === ${item["su"]}");
                add(food = Food(size, key: UniqueKey(),));
              }
            }else{
              add(marinAnimalsComponent = MarinAnimal(
                worldSize: size,
                animalName: _map["image_name"],
                screenSize:
                Vector2.all(double.parse(_map["screenSize"].toString())),
                imageSize: Vector2.all(double.parse(_map["size"].toString())),
                totalNum: _map["totalNum"],
                key: UniqueKey(),
              ));
            }
          }
        }
        marimoComponent.position = Vector2(100, 300);
      }
    }
  }
}
