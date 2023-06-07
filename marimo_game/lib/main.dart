import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marimo_game/page/game_setting_page.dart';
import 'package:marimo_game/page/init_setting_page.dart';
import 'package:marimo_game/page/shop_page.dart';
import 'app_manage/app_status_observer.dart';
import 'app_manage/environment/environment.dart';
import 'app_manage/language.dart';
import 'app_manage/local_repository.dart';
import 'app_manage/network_check_widget.dart';
import 'app_manage/restart_widget.dart';
import 'bloc/component_bloc/background_bloc.dart';
import 'bloc/component_bloc/coin_bloc.dart';
import 'bloc/component_bloc/villian_bloc.dart';
import 'bloc/environment_bloc/environment_humity_bloc.dart';
import 'bloc/environment_bloc/environment_temperature_bloc.dart';
import 'bloc/environment_bloc/environment_trash_bloc.dart';
import 'bloc/component_bloc/language_manage_bloc.dart';
import 'bloc/marimo_bloc/marimo_exp_bloc.dart';
import 'bloc/marimo_bloc/marimo_level_bloc.dart';
import 'bloc/marimo_bloc/marimo_hp_bloc.dart';
import 'bloc/component_bloc/sound_bloc.dart';
import 'bloc/component_bloc/time_check_bloc.dart';
import 'marimo_game_world.dart';
import 'model/marimo_items.dart';
import 'page/main_game_page.dart';
import 'main_view.dart';

final navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
 // await Flame.device.fullScreen();
  final marimoItems = await getInitLocalMarimoItems();
  final marimoItemsMap = marimoItems.toJson();
  String? firstInstall = await LocalRepository().getValue(key: "firstInstall");
  String? marimoName = await LocalRepository().getValue(key: "marimoName");
  String initRoute = firstInstall != null ? '/main_scene' : '/init_setting';

 // print("marimoItems ===> ${marimoItems.toJson()}");
  final backgroundValue = BackgroundState.values.firstWhere(
      (element) => element.name == marimoItemsMap["background"],
      orElse: () => BackgroundState.normal);
  final languageManageValue = Language.values.firstWhere(
      (element) => element.name == marimoItemsMap["language"],
      orElse: () => Language.ko);
  final marimoLevelValue = MarimoLevel.values.firstWhere(
      (element) => element.name == marimoItemsMap["marimoLevel"],
      orElse: () => MarimoLevel.baby);
  final isCheckedOnOffSound = marimoItemsMap["isCheckedOnOffSound"] == null?false:marimoItemsMap["isCheckedOnOffSound"] != 1;
  final isCheckedVillain = marimoItemsMap["isCheckedVillain"] == null?false:marimoItemsMap["isCheckedVillain"] != 1;

  Environment().initConfig(languageManageValue); // 언어 환경 세팅
  runApp(MultiBlocProvider(
      providers: [
    BlocProvider<VillainBloc>(create: (_) => VillainBloc(isCheckedVillain)),
    BlocProvider<LanguageManageBloc>(create: (_) => LanguageManageBloc(languageManageValue)),
    BlocProvider<TimeCheckBloc>(create: (_) => TimeCheckBloc(marimoItemsMap["lastDay"] != "1")), /// 체크 초기값 설정 고민 해보자 marimoItemsMap["lastDay"]??
    BlocProvider<BackgroundBloc>(create: (_) => BackgroundBloc(backgroundValue)), //marimoItemsMap["background"]??"
    BlocProvider<MarimoLevelBloc>(create: (_) => MarimoLevelBloc(marimoLevelValue)),
    BlocProvider<MarimoHpBloc>(create: (_) => MarimoHpBloc(int.parse(marimoItemsMap["marimoHp"] ?? "40"))),
    BlocProvider<MarimoExpBloc>(create: (_) => MarimoExpBloc(int.parse(marimoItemsMap["marimoExp"] ?? "0"))), //ok
    BlocProvider<CoinBloc>(create: (_) => CoinBloc(int.parse(marimoItemsMap["coin"] ?? "0"))), //ok
    BlocProvider<SoundBloc>(create: (_) => SoundBloc(isCheckedOnOffSound)),     // ok null 또는 0이면 true , 1이면 false
    BlocProvider<EnvironmentTrashBloc>(create: (_) => EnvironmentTrashBloc(isCheckedOnOffSound)), // ok  null 또는 0이면 true , 1이면 false
    BlocProvider<EnvironmentHumidityBloc>(create: (_) => EnvironmentHumidityBloc(int.parse(marimoItemsMap["humidity"] ?? "50"))),
    BlocProvider<EnvironmentTemperatureBloc>(create: (_) => EnvironmentTemperatureBloc(double.parse(marimoItemsMap["temperature"] ?? "16"))), //ok
  ],
      child: App(
        initRoute: initRoute,
        marimoName: marimoName,
      )));

  // FlutterNativeSplash.remove();
}

class App extends StatelessWidget {
  App({Key? key, required this.initRoute, required this.marimoName}) : super(key: key);
  final String initRoute;
  final String? marimoName;

  @override
  Widget build(BuildContext context) {
    Widget initWidget(Widget child) => AppStatusObserver(
        timeCheckBloc: context.read<TimeCheckBloc>(),
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
      soundBloc: context.read<SoundBloc>(),
      coinBloc: context.read<CoinBloc>(),
      marimoHpBloc: context.read<MarimoHpBloc>(),
      marimoLevelBloc: context.read<MarimoLevelBloc>(),
      timeCheckBloc: context.read<TimeCheckBloc>(),
      marimoExpBloc: context.read<MarimoExpBloc>(),
      villainBloc: context.read<VillainBloc>(),
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
          '/main_scene': (context) => MainGamePage(
             marimoName: marimoName??"",
                game: game,
              ),
          '/init_setting': (context) => InitSettingPage(),
          '/game_setting': (context) => GameSettingPage(
                game: game,
              ),
          '/shop_page': (context) => ShopPage(
                game: game,
              ),
        },
        home: MainGamePage(
          marimoName: marimoName??"",
          game: game,
        ),
        navigatorKey: navigatorKey,
      ),
    );
  }
}

enum AppStartType { forceUpdate, myapp, shutdown }

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

//언어 환경 세팅
//앱 start api -> 버전 체크 , 앱 타입 체크
// 로컬 저장소 세팅
// 체크 스토어
// WidgetsFlutterBinding.ensureInitialized();
//앱 시작 타입      : 강제 업데이트 , 운영 , 정기점검

// 서버 개발
void checkAppVersion() {} // 앱 버전 체크 => 앱 스토어로 이동

void checkSystemMaintenance() {} // 앱 정기점검

// 앱 접근 권한 추가
// 네트워크 체크
// 백그라운드 포그라운드 상태에서 처리
