import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marimo_game/app_manage/language.dart';
import 'package:marimo_game/bloc/component_bloc/time_check_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../bloc/component_bloc/background_bloc.dart';
import '../bloc/component_bloc/coin_bloc.dart';
import '../bloc/component_bloc/language_manage_bloc.dart';
import '../bloc/component_bloc/sound_bloc.dart';
import '../bloc/environment_bloc/environment_humity_bloc.dart';
import '../bloc/environment_bloc/environment_temperature_bloc.dart';
import '../bloc/marimo_bloc/marimo_bloc.dart';
import '../bloc/marimo_bloc/marimo_exp_bloc.dart';
import '../bloc/marimo_bloc/marimo_level_bloc.dart';
import '../bloc/shop_bloc.dart';
import '../model/game_data_info.dart';
import '../model/marimo_shop.dart';
import 'local_data_manager.dart';

///
/// Created by ahhyun [ah2yun@gmail.com] on 2023. 03. 30
///

// 앱 상태 체크 옵저버 클래스
class AppStatusObserver extends StatefulWidget {
  final Widget child;
  final TimeCheckBloc timeCheckBloc;
  final MarimoBloc marimoBloc;
  final MarimoLevelBloc marimoLevelBloc;
  final MarimoExpBloc marimoExpBloc;

  final LanguageManageBloc languageManageBloc;
  //final EnvironmentHumidityBloc environmentHumidityBloc;
 // final EnvironmentTemperatureBloc environmentTemperatureBloc;

  // final EnvironmentTrashBloc environmentTrashBloc;

  final BackgroundBloc backgroundBloc;

  final SoundBloc soundBloc;
  final CoinBloc coinBloc;
  final ShopBloc shopBloc;

  const AppStatusObserver({
    required this.child,
    Key? key,
    required this.timeCheckBloc,
    required this.marimoBloc,
    required this.marimoLevelBloc,
    required this.marimoExpBloc,
    required this.languageManageBloc,
 //   required this.environmentHumidityBloc,
 //   required this.environmentTemperatureBloc,
    required this.backgroundBloc,
    required this.soundBloc,
    required this.coinBloc,
    required this.shopBloc,
  }) : super(key: key);

  @override
  State<AppStatusObserver> createState() => _AppStatusObserverState();
}

class _AppStatusObserverState extends State<AppStatusObserver>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    widget.timeCheckBloc.checkForTomorrow();
    WidgetsBinding.instance.addObserver(this);
  }

  GameDataInfo gameDataInfo = GameDataInfo();
  List<Shop> shopDataList = <Shop>[];

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.paused:
        print("paused 상태 앱 종료 ");
        widget.timeCheckBloc.updateLocalLastTime(DateTime.now());
        saveGameDataInfo();
        // 종료했을때 시간체크 close time
        break;
      case AppLifecycleState.resumed:
        print("resumed 포그라운드  상태 ");
        widget.timeCheckBloc.checkForTomorrow();
        saveGameDataInfo();
        // 시작 했을때 시간체크 start time current time
        break;
      case AppLifecycleState.detached:
        // 종료했을때 시간체크 close time
        widget.timeCheckBloc.updateLocalLastTime(DateTime.now());
        saveGameDataInfo();
        print("detached 상태 앱 종료 ");
        // 앱 종료 상태
        break;
      case AppLifecycleState.inactive:
        // 종료했을때 시간체크 close time
        widget.timeCheckBloc.updateLocalLastTime(DateTime.now());
        saveGameDataInfo();
        print("inactive 백그라운드 상태 ");
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
  saveGameDataInfo() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("gameDataInfo", json.encode(gameDataInfo));
  }


  @override
  Widget build(BuildContext context) {
    Widget result() => MultiBlocListener(
          listeners: [
            BlocListener<TimeCheckBloc, bool>(
              listener: (context, state) async {
                // final SharedPreferences prefs = await SharedPreferences.getInstance();
                //    prefs.setString("gameDataInfo", json.encode(gameDataInfo));
                setState(() {
                  gameDataInfo.isToday = state;
                });
              },
            ),
            BlocListener<MarimoBloc, MarimoState>(
              listener: (context, state) {
                setState(() {
                  gameDataInfo.marimoAppearanceState =
                      state.marimoAppearanceState.name;
                });
              },
            ),
            BlocListener<MarimoLevelBloc, int>(
              listener: (context, state) {
                setState(() {
                  gameDataInfo.marimoLevel = state;
                });
              },
            ),
            BlocListener<MarimoExpBloc, int>(
              listener: (context, state) {
               setState(() {
                 gameDataInfo.marimoExp = state;
               });
              },
            ),
            BlocListener<LanguageManageBloc, Language>(
              listener: (context, state) {
                setState(() {
                  gameDataInfo.language = state.name;
                });
              },
            ),
            // BlocListener<EnvironmentTemperatureBloc, double>(
            //   listener: (context, state) {
            //     setState(() {
            //       gameDataInfo.temperature = state;
            //     });
            //   },
            // ),
            // BlocListener<EnvironmentHumidityBloc, int>(
            //   listener: (context, state) {
            //     setState(() {
            //       gameDataInfo.humidity = state;
            //     });
            //   },
            // ),
            BlocListener<BackgroundBloc, BackgroundState>(
              listener: (context, state) {
                setState(() {
                  print("state ==> $state");
                  gameDataInfo.background = state.name;
                });
              },
            ),
            BlocListener<SoundBloc, bool>(
              listener: (context, state) {
                setState(() {
                  // gameDataInfo.isCheckedOnOffSound = state;
                  // if(!state){
                  //   widget.soundBloc.bgmPlay();
                  // }else{
                  //   print("여기 $state");
                  // }
                });
              },
            ),
            BlocListener<CoinBloc, int>(
              listener: (context, state) {
                setState(() {
                  gameDataInfo.coin = state;
                });
              },
            ),
            // BlocListener<ShopBloc, ItemState>(
            //   listener: (context, state) {
            //     print("shop state==> $state");
            //     setState(() async {
            //       final shopData = await LocalDataManager().getValue<String>(key: "shopData");
            //       List<Shop> list = json.decode(shopData).cast<Map<String,dynamic>>().toList();
            //       Iterable<dynamic> result = list.where((element) => element.name == state.name);
            //       //state.name
            //      // state.buyItem
            //       print("result ====> ${result.toList()}");
            //    //   result = list.where((element) => element["category"] == categoryName);
            //     //  shopDataList.
            //       // final prefs = await SharedPreferences.getInstance();
            //       // prefs.setString("gameDataInfo", json.encode(gameDataInfo));
            //
            //      // gameDataInfo.isCheckedOnOffSound = state;
            //     });
            //   },
            // ),
          ],
          child: widget.child,
        );
    return result();
  }
}

// getList() async {
//   KBox box = KBox(keys: KT_SCODE().toMap().keys.toList());
//   List<KT_SCODE> data = List<KT_SCODE>();
//   setState(ViewState.Busy);
//   // print("--------> ");
//   total = -1;
//   data.clear();
//
//   dynamic result = await init()
//       .add(box.map)
//       .add({
//     "CLSNAME" : getBean("admin.AdminCP"),
//     "ACT": "GET_PAGELIST",
//     "TBL": "T_SCODE",
//     "CP": cp,
//     "PageSize": pageSize,
//     "Order": "scode ASC",
//     "mcode": "ADJUST"
//   }).post();
//
//   result.forEach((json) {
//     // print("--------> $json");
//     if(total == -1)
//       total = int.parse(json['Total']);
//     data.add(KT_SCODE.fromJson(json));
//   });
//   setState(ViewState.Idle);
// }