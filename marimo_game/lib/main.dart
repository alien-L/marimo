/** Copyright (c) 2021 Razeware LLC

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in
    all copies or substantial portions of the Software.

    Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
    distribute, sublicense, create a derivative work, and/or sell copies of the
    Software in any work that is designed, intended, or marketed for pedagogical or
    instructional purposes related to programming, coding, application development,
    or information technology.  Permission for such use, copying, modification,
    merger, publication, distribution, sublicensing, creation of derivative works,
    or sale is expressly withheld.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
    THE SOFTWARE. **/
import 'dart:io';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marimo_game/page/game_setting_page.dart';
import 'package:marimo_game/page/init_setting_page.dart';
import 'package:marimo_game/page/shop_page.dart';
import 'app_manage/app_status_observer.dart';
import 'app_manage/environment/environment.dart';
import 'app_manage/language.dart';
import 'app_manage/network_check_widget.dart';
import 'app_manage/restart_widget.dart';
import 'bloc/component_bloc/coin_bloc.dart';
import 'bloc/environment_bloc/environment_humity_bloc.dart';
import 'bloc/environment_bloc/environment_temperature_bloc.dart';
import 'bloc/environment_bloc/environment_trash_bloc.dart';
import 'bloc/environment_bloc/environment_water_bloc.dart';
import 'bloc/marimo_bloc/marimo_level_bloc.dart';
import 'bloc/marimo_bloc/marimo_lifecycle_bloc.dart';
import 'bloc/marimo_bloc/marimo_score_bloc.dart';
import 'bloc/component_bloc/sound_bloc.dart';
import 'marimo_game_world.dart';
import 'model/marimo_items.dart';
import 'page/main_game_page.dart';
import 'main_view.dart';

final navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();

  Environment().initConfig(Language.ko); // 언어 환경 세팅

  final marimoItems =  await getInitLocalMarimoItems();
  final marimoItemsMap =  marimoItems.toJson();

  String initRoute = marimoItemsMap["marimoName"]!= null ?'/main_scene' : '/init_setting';
  print("marimoItems ===> ${marimoItems.toJson()}");

  runApp(RestartWidget(
      child: MultiBlocProvider(
          providers: [
        // BlocProvider<BackgroundBloc>(create: (_) => BackgroundBloc("background_01.png")),
        BlocProvider<MarimoLevelBloc>(create: (_) => MarimoLevelBloc(marimoItemsMap["marimoLevel"]??MarimoLevel.baby)),
        BlocProvider<MarimoScoreBloc>(create: (_) => MarimoScoreBloc(marimoItemsMap["marimoScore"]??50)),
        BlocProvider<MarimoLifeCycleBloc>(create: (_) => MarimoLifeCycleBloc(marimoItemsMap["marimoLifeCycle"]??MarimoLifeCycle.normal)),

        BlocProvider<CoinBloc>(create: (_) => CoinBloc(int.parse(marimoItemsMap["coin"]?? "0"))),
        BlocProvider<SoundBloc>(create: (_) => SoundBloc(marimoItemsMap["isCheckedOnOffSound"]??false)), // booleen 형 바꿔주기

        BlocProvider<EnvironmentTrashBloc>(create: (_) => EnvironmentTrashBloc(marimoItemsMap["isCleanTrash"] == null ||marimoItemsMap["isCleanTrash"] == "0")), // null 또는 0이면 true , 1이면 false
        BlocProvider<EnvironmentWaterBloc>(create: (_) => EnvironmentWaterBloc(marimoItemsMap["isCleanWater"] == null ||marimoItemsMap["isCleanWater"] == "0")),
        BlocProvider<EnvironmentHumidityBloc>(create: (_) => EnvironmentHumidityBloc(int.parse(marimoItemsMap["humidity"]??"50"))),
        BlocProvider<EnvironmentTemperatureBloc>(create: (_) => EnvironmentTemperatureBloc(double.parse(marimoItemsMap["temperature"]??"16"))),
      ],
          child: App(
            initRoute: initRoute,
          ))));
  // FlutterNativeSplash.remove();
}

class App extends StatelessWidget {
  App({Key? key, required this.initRoute}) : super(key: key);
  final String initRoute;

  Widget initWidget(Widget child) => AppStatusObserver(
          // 앱 백그라운드 , 포그라운드 상태 체크
          child: NetWorkCheckWidget(
        //네트워크 상태 체크
        MainView(
          child: child,
        ),
      ));

  @override
  Widget build(BuildContext context) {

    final game = MarimoWorldGame(
      environmentHumidityBloc: context.read<EnvironmentHumidityBloc>(),
      environmentTemperatureBloc: context.read<EnvironmentTemperatureBloc>(),
      environmentTrashBloc: context.read<EnvironmentTrashBloc>(),
      environmentWaterBloc: context.read<EnvironmentWaterBloc>(),
      context: context,
      soundBloc: context.read<SoundBloc>(),
      coinBloc: context.read<CoinBloc>(),
      marimoScoreBloc: context.read<MarimoScoreBloc>(),
      marimoLevelBloc: context.read<MarimoLevelBloc>(),
      marimoLifeCycleBloc: context.read<MarimoLifeCycleBloc>(),
    );

    return initWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'RayWorld',
        theme: ThemeData(
          fontFamily: 'NeoDunggeunmoPro',
        ),
        initialRoute: initRoute,
        routes: {
          '/main_scene': (context) => MainGamePage(game: game,),
          '/init_setting': (context) => InitSettingPage(),
          '/game_setting': (context) => GameSettingPage(game: game,),
          '/shop_page': (context) => ShopPage(game: game,),
        },
        home: initWidget(MainGamePage(game: game,)),
        navigatorKey: navigatorKey,
      ),
    );
  }
}

// final binding = WidgetsFlutterBinding.ensureInitialized();
// FlutterNativeSplash.preserve(widgetsBinding: binding);
// main 진입하기전에 작업 할 항목들 !!
//스플래시
//언어 환경 세팅
//앱 start api -> 버전 체크 , 앱 타입 체크
// 로컬 저장소 세팅
// 체크 스토어
// WidgetsFlutterBinding.ensureInitialized();
//앱 시작 타입      : 강제 업데이트 , 운영 , 정기점검

enum AppStartType { forceUpdate, myapp, shutdown }

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void checkAppVersion() {} // 앱 버전 체크 => 앱 스토어로 이동

void checkSystemMaintenance() {} // 앱 정기점검

// 앱 접근 권한 추가
// 네트워크 체크
// 백그라운드 포그라운드 상태에서 처리