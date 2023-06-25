import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marimo_game/app_manage/local_data_manager.dart';
import 'package:marimo_game/bloc/shop_bloc.dart';
import 'package:marimo_game/page/init_setting_page.dart';
import 'package:marimo_game/page/intro_page.dart';
import 'package:video_player/video_player.dart';
import 'app_manage/app_status_observer.dart';
import 'app_manage/environment/environment.dart';
import 'app_manage/language.dart';
import 'app_manage/network_check_widget.dart';
import 'app_manage/restart_widget.dart';
import 'bloc/buy_bloc.dart';
import 'bloc/component_bloc/background_bloc.dart';
import 'bloc/component_bloc/coin_bloc.dart';
import 'bloc/component_bloc/language_manage_bloc.dart';
import 'bloc/marimo_bloc/marimo_exp_bloc.dart';
import 'bloc/marimo_bloc/marimo_bloc.dart';
import 'bloc/component_bloc/sound_bloc.dart';
import 'bloc/component_bloc/time_check_bloc.dart';
import 'bloc/marimo_bloc/marimo_level_bloc.dart';
import 'marimo_game_world.dart';
import 'page/main_game_page.dart';
import 'main_view.dart';

final navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  late dynamic gameDataInfoMap;
  late dynamic shopDataMap;
  late String initRoute;
  final localDataManager = LocalDataManager();
  final isFirstInstall =
      await localDataManager.getIsFirstInstall(); // 첫 설치 유무 체크

  gameDataInfoMap = await localDataManager.getLocalGameData(
      key: 'gameDataInfo', isFirstInstall: isFirstInstall);
  shopDataMap = await localDataManager.getShopData(isFirstInstall);

  initRoute = isFirstInstall ? '/intro' : '/main_scene';

  String marimoName =
      await localDataManager.getValue<String>(key: 'marimoName') ?? "";

  final backgroundValue = BackgroundState.values.firstWhere(
      (element) => element.name == gameDataInfoMap["background"],
      orElse: () => BackgroundState.normal);
  final languageManageValue = Language.values.firstWhere(
      (element) => element.name == gameDataInfoMap["language"],
      orElse: () => Language.ko);
  final marimoAppearanceState = MarimoAppearanceState.values.firstWhere(
      (element) => element.name == gameDataInfoMap["marimoAppearanceState"],
      orElse: () => MarimoAppearanceState.baby);
  final marimoEmotionValue = MarimoEmotion.values.firstWhere(
      (element) => element.name == gameDataInfoMap["marimoEmotion"],
      orElse: () => MarimoEmotion.normal);

  Environment().initConfig(languageManageValue); // 언어 환경 세팅
  runApp(MultiBlocProvider(
      providers: [
        BlocProvider<BuyBloc>(create: (_) => BuyBloc(false)),
        BlocProvider<ShopBloc>(create: (_) => ShopBloc(const ItemState())),
        // BlocProvider<EnemyBloc>(
        //     create: (_) => EnemyBloc(gameDataInfoMap["isCheckedEnemy"]??false)),
        BlocProvider<LanguageManageBloc>(
            create: (_) => LanguageManageBloc(languageManageValue)),
        BlocProvider<TimeCheckBloc>(
            create: (_) => TimeCheckBloc(gameDataInfoMap["isToday"]??true)),
        BlocProvider<BackgroundBloc>(
            create: (_) => BackgroundBloc(backgroundValue)),
        BlocProvider<MarimoBloc>(
            create: (_) => MarimoBloc(MarimoState(
                marimoAppearanceState: marimoAppearanceState,
                marimoEmotion: marimoEmotionValue))),
        // BlocProvider<MarimoHpBloc>(
        //     create: (_) => MarimoHpBloc(gameDataInfoMap["marimoHp"])),
        BlocProvider<MarimoExpBloc>(
            create: (_) => MarimoExpBloc(gameDataInfoMap["marimoExp"]??0)),
        BlocProvider<MarimoLevelBloc>(
            create: (_) => MarimoLevelBloc(gameDataInfoMap["marimoLevel"]??1)),
        //ok
        BlocProvider<CoinBloc>(
            create: (_) => CoinBloc(gameDataInfoMap["coin"]??0)),
        //ok
        BlocProvider<SoundBloc>(create: (_) => SoundBloc(gameDataInfoMap["isCheckedOnOffSound"]??false)), //에러
        // ok null 또는 0이면 true , 1이면 false
        // BlocProvider<EnvironmentTrashBloc>(
        //     create: (_) =>
        //         EnvironmentTrashBloc(gameDataInfoMap["isCleanTrash"])),
        // ok  null 또는 0이면 true , 1이면 false
        // BlocProvider<EnvironmentHumidityBloc>(
        //     create: (_) => EnvironmentHumidityBloc(gameDataInfoMap["humidity"])),
        // BlocProvider<EnvironmentTemperatureBloc>(
        //     create: (_) => EnvironmentTemperatureBloc(gameDataInfoMap["temperature"])),
        //ok
      ],
      child: RestartWidget(
        child: App(
          shopData: shopDataMap,
          initRoute: initRoute,
          marimoName: marimoName,
        ),
      )));

  // FlutterNativeSplash.remove();
}

class App extends StatelessWidget {
  App(
      {Key? key,
      required this.initRoute,
      required this.marimoName,
      required this.shopData})
      : super(key: key);
  final String initRoute;
  final String marimoName;
  final dynamic shopData;

  @override
  Widget build(BuildContext context) {
    //soundBloc.bgmPlay();

    // Widget soundCheckWidget(){
    //
    //   return BlocListener(listener: listener)
    // }
    //
    Widget initWidget(Widget child) => AppStatusObserver(
        marimoLevelBloc: context.read<MarimoLevelBloc>(),
        languageManageBloc: context.read<LanguageManageBloc>(),
        backgroundBloc: context.read<BackgroundBloc>(),
        // environmentHumidityBloc: context.read<EnvironmentHumidityBloc>(),
        // environmentTemperatureBloc: context.read<EnvironmentTemperatureBloc>(),
        //  environmentTrashBloc: context.read<EnvironmentTrashBloc>(),
        soundBloc: context.read<SoundBloc>(),
        coinBloc: context.read<CoinBloc>(),
        //  marimoHpBloc: context.read<MarimoHpBloc>(),
        marimoBloc: context.read<MarimoBloc>(),
        timeCheckBloc: context.read<TimeCheckBloc>(),
        marimoExpBloc: context.read<MarimoExpBloc>(),
        //  enemyBloc: context.read<EnemyBloc>(),
        shopBloc: context.read<ShopBloc>(),
        child: NetWorkCheckWidget(
          //네트워크 상태 체크
          MainView(
            child: child,
          ),
        ));

    final game = MarimoWorldGame(
      marimoLevelBloc: context.read<MarimoLevelBloc>(),
      languageManageBloc: context.read<LanguageManageBloc>(),
      backgroundBloc: context.read<BackgroundBloc>(),
    //  environmentHumidityBloc: context.read<EnvironmentHumidityBloc>(),
     // environmentTemperatureBloc: context.read<EnvironmentTemperatureBloc>(),
      //  environmentTrashBloc: context.read<EnvironmentTrashBloc>(),
      soundBloc: context.read<SoundBloc>(),
      coinBloc: context.read<CoinBloc>(),
      //  marimoHpBloc: context.read<MarimoHpBloc>(),
      marimoBloc: context.read<MarimoBloc>(),
      timeCheckBloc: context.read<TimeCheckBloc>(),
      marimoExpBloc: context.read<MarimoExpBloc>(),
      //  enemyBloc: context.read<EnemyBloc>(),
      shopBloc: context.read<ShopBloc>(),
      buyBloc: context.read<BuyBloc>()
    );
    final VideoPlayerController controller =
        VideoPlayerController.asset('assets/videos/intro.mp4');

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
                marimoName: marimoName,
                game: game,
              ),
          '/intro': (context) => IntroPage(
                videoController: controller,
              ),
          '/init_setting': (context) => InitSettingPage(
                videoPlayerController: controller,
              ),
        },
        home: MainGamePage(
          marimoName: marimoName,
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
