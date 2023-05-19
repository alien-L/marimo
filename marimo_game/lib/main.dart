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
import 'package:marimo_game/app_manage/local_repository.dart';
import 'package:marimo_game/page/game_setting_page.dart';
import 'package:marimo_game/page/init_setting_page.dart';
import 'package:marimo_game/page/shop_page.dart';
import 'app_manage/app_status_observer.dart';
import 'app_manage/environment/environment.dart';
import 'app_manage/language.dart';
import 'app_manage/network_check_widget.dart';
import 'app_manage/restart_widget.dart';
import 'bloc/component_bloc/background_bloc.dart';
import 'bloc/component_bloc/coin_bloc.dart';
import 'bloc/environment_bloc/environment_humity_bloc.dart';
import 'bloc/environment_bloc/environment_temperature_bloc.dart';
import 'bloc/environment_bloc/environment_trash_bloc.dart';
import 'bloc/component_bloc/language_manage_bloc.dart';
import 'bloc/marimo_bloc/marimo_exp_bloc.dart';
import 'bloc/marimo_bloc/marimo_level_bloc.dart';
import 'bloc/marimo_bloc/marimo_hp_bloc.dart';
import 'bloc/component_bloc/sound_bloc.dart';
import 'bloc/component_bloc/time_check_bloc.dart';
import 'const/constant.dart';
import 'marimo_game_world.dart';
import 'model/marimo_items.dart';
import 'page/main_game_page.dart';
import 'main_view.dart';

final navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  final marimoItems =  await getInitLocalMarimoItems();
  final marimoItemsMap =  marimoItems.toJson();
  String? isFirstInstall = await LocalRepository().getValue(key: "firstInstall");
  String initRoute = isFirstInstall != null ?'/main_scene' : '/init_setting';
  print("marimoItems ===> ${marimoItems.toJson()}");

  Environment().initConfig(Language.ko); // 언어 환경 세팅
  runApp(RestartWidget(
      child: MultiBlocProvider(
          providers: [
         BlocProvider<LanguageManageBloc>(create: (_) => LanguageManageBloc(Language.ko)),
            // 배경 초기값 설정 해주기
        BlocProvider<TimeCheckBloc>(create: (_) => TimeCheckBloc(true)), // 초기값 설정 고민 해보자
        BlocProvider<BackgroundBloc>(create: (_) => BackgroundBloc(BackgroundState.normal)),
        BlocProvider<MarimoLevelBloc>(create: (_) => MarimoLevelBloc(marimoItemsMap["marimoLevel"]??MarimoLevel.baby)),
        BlocProvider<MarimoHpBloc>(create: (_) => MarimoHpBloc(marimoItemsMap["marimoHp"]??50)),
        BlocProvider<MarimoExpBloc>(create: (_) => MarimoExpBloc(marimoItemsMap["marimoExp"]??100)),
      //  BlocProvider<MarimoHpLifeCycleBloc>(create: (_) => MarimoHpLifeCycleBloc(marimoItemsMap["marimoLifeCycle"]??MarimoHpLifeCycle.normal)),

        BlocProvider<CoinBloc>(create: (_) => CoinBloc(int.parse(marimoItemsMap["coin"]?? "0"))),
        BlocProvider<SoundBloc>(create: (_) => SoundBloc(false)), // booleen 형 바꿔주기 //marimoItemsMap["isCheckedOnOffSound"]??false

        BlocProvider<EnvironmentTrashBloc>(create: (_) => EnvironmentTrashBloc(marimoItemsMap["isCleanTrash"] == null ||marimoItemsMap["isCleanTrash"] == "0")), // null 또는 0이면 true , 1이면 false
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


  @override
  Widget build(BuildContext context) {

    Widget initWidget(Widget child) => AppStatusObserver(
        timeCheckBloc: context.read<TimeCheckBloc>() ,
        // 앱 백그라운드 , 포그라운드 상태 체크
        child: NetWorkCheckWidget(
          //네트워크 상태 체크
          MainView(
            child: child,
          ),
        ));

    final game = MarimoWorldGame(
      languageManageBloc: context.read<LanguageManageBloc>(),
      backgroundBloc: context.read<BackgroundBloc>(),
      environmentHumidityBloc: context.read<EnvironmentHumidityBloc>(),
      environmentTemperatureBloc: context.read<EnvironmentTemperatureBloc>(),
      environmentTrashBloc: context.read<EnvironmentTrashBloc>(),
      context: context,
      soundBloc: context.read<SoundBloc>(),
      coinBloc: context.read<CoinBloc>(),
      marimoHpBloc: context.read<MarimoHpBloc>(),
      marimoLevelBloc: context.read<MarimoLevelBloc>(),
      //marimoLifeCycleBloc: context.read<MarimoHpLifeCycleBloc>(),
      timeCheckBloc: context.read<TimeCheckBloc>(),
      marimoExpBloc:  context.read<MarimoExpBloc>(),
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
        home: initWidget(MainGamePage(game: game,),),
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