import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:marimo_game/app_manage/local_data_manager.dart';
import 'package:marimo_game/bloc/shop_bloc.dart';
import 'package:marimo_game/page/init_setting_page.dart';
import 'package:marimo_game/page/intro_page.dart';
import 'package:video_player/video_player.dart';
import 'app_manage/app_status_observer.dart';
import 'app_manage/environment/environment.dart';
import 'app_manage/language.dart';
import 'app_manage/restart_widget.dart';
import 'bloc/component_bloc/background_bloc.dart';
import 'bloc/component_bloc/coin_bloc.dart';
import 'bloc/component_bloc/language_manage_bloc.dart';
import 'bloc/marimo_bloc/marimo_exp_bloc.dart';
import 'bloc/marimo_bloc/marimo_bloc.dart';
import 'bloc/component_bloc/sound_bloc.dart';
import 'bloc/marimo_bloc/marimo_level_bloc.dart';
import 'marimo_game_world.dart';
import 'page/main_game_page.dart';
import 'main_view.dart';

final navigatorKey = GlobalKey<NavigatorState>();

// Future<InitializationStatus> _initGoogleMobileAds() {
//   // TODO: Initialize Google Mobile Ads SDK
//   return MobileAds.instance.initialize();
// }

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //_initGoogleMobileAds();
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
        BlocProvider<ShopBloc>(create: (_) => ShopBloc(const ItemState())),
        BlocProvider<LanguageManageBloc>(
            create: (_) => LanguageManageBloc(languageManageValue)),
        BlocProvider<BackgroundBloc>(
            create: (_) => BackgroundBloc(backgroundValue)),
        BlocProvider<MarimoBloc>(
            create: (_) => MarimoBloc(MarimoState(
                marimoAppearanceState: marimoAppearanceState,
                marimoEmotion: marimoEmotionValue))),
        BlocProvider<MarimoExpBloc>(
            create: (_) => MarimoExpBloc(gameDataInfoMap["marimoExp"]??0)),
        BlocProvider<MarimoLevelBloc>(
            create: (_) => MarimoLevelBloc(gameDataInfoMap["marimoLevel"]??1)),
        //ok
        BlocProvider<CoinBloc>(
            create: (_) => CoinBloc(gameDataInfoMap["coin"]??0)),
        //ok
        BlocProvider<SoundBloc>(create: (_) => SoundBloc(false)), //에러
      ],
      child: backButtonWidget(
        child: App(
          shopData: shopDataMap,
          initRoute: initRoute,
          marimoName: marimoName,
        ),
      )));
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

    Widget initWidget(Widget child) => AppStatusObserver(
        marimoLevelBloc: context.read<MarimoLevelBloc>(),
        languageManageBloc: context.read<LanguageManageBloc>(),
        backgroundBloc: context.read<BackgroundBloc>(),
        soundBloc: context.read<SoundBloc>(),
        coinBloc: context.read<CoinBloc>(),
        marimoBloc: context.read<MarimoBloc>(),
        marimoExpBloc: context.read<MarimoExpBloc>(),
        shopBloc: context.read<ShopBloc>(),
        child:
          MainView(
            child: child,
          ),
        );

    final game = MarimoWorldGame(
      marimoLevelBloc: context.read<MarimoLevelBloc>(),
      languageManageBloc: context.read<LanguageManageBloc>(),
      backgroundBloc: context.read<BackgroundBloc>(),
      soundBloc: context.read<SoundBloc>(),
      coinBloc: context.read<CoinBloc>(),
      marimoBloc: context.read<MarimoBloc>(),
      marimoExpBloc: context.read<MarimoExpBloc>(),
      shopBloc: context.read<ShopBloc>(),
    );
    final VideoPlayerController controller =
        VideoPlayerController.asset('assets/videos/intro.mp4');

    return backButtonWidget(child:initWidget(
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
    ));
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

Widget backButtonWidget({required Widget child}) {

  return WillPopScope(
    onWillPop: () {
      print("백버튼 막음 ");
      return Future(() => false);
    },
    child: child,
  );
}