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
import 'package:marimo_game/bloc/environment_bloc/environment_bloc.dart';
import 'package:marimo_game/page/game_setting_page.dart';
import 'package:marimo_game/page/init_setting_page.dart';
import 'package:marimo_game/page/shop_page.dart';
import 'app_manage/app_status_observer.dart';
import 'app_manage/environment/environment.dart';
import 'app_manage/language.dart';
import 'app_manage/local_repository.dart';
import 'app_manage/network_check_widget.dart';
import 'app_manage/restart_widget.dart';
import 'bloc/marimo_bloc/marimo_bloc.dart';
import 'bloc/sound_bloc.dart';
import 'marimo_game_world.dart';
import 'page/main_game_page.dart';
import 'main_view.dart';
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
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
 // final binding = WidgetsFlutterBinding.ensureInitialized();
 // FlutterNativeSplash.preserve(widgetsBinding: binding);
  // main 진입하기전에 작업 할 항목들 !!
  //스플래시
  //언어 환경 세팅
  //앱 start api -> 버전 체크 , 앱 타입 체크
  // 로컬 저장소 세팅
  // 체크 스토어
 // WidgetsFlutterBinding.ensureInitialized();
  Environment().initConfig(Language.ko); // 언어 환경 세팅
  final bool isMainPage =  await getInitRoute();
  String initRoute = isMainPage?'/main_scene':'/init_setting';
  runApp(RestartWidget(child:
  MultiBlocProvider(
    providers: [
      BlocProvider<SoundBloc>(create: (_) => SoundBloc()),
      BlocProvider<MarimoBloc>(create: (_) => MarimoBloc()),
      BlocProvider<EnvironmentBloc>(create: (_) => EnvironmentBloc()),
    ],
      child:
      App(initRoute: initRoute,)
  )

  ));
 // FlutterNativeSplash.remove();
}

Future<bool> getInitRoute() async {
  LocalRepository localRepository = LocalRepository(); // 로컬 저장소
  final marimoName = await localRepository.getValue(key: "marimoName");
  final isMainPage = marimoName != null?true:false;
  return isMainPage;
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
        marimoBloc: context.read<MarimoBloc>(),
        environmentBloc: context.read<EnvironmentBloc>(),
        context: context, soundBloc: context.read<SoundBloc>(),
    );
    
    return initWidget( MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'RayWorld',
        theme: ThemeData(
          fontFamily: 'NeoDunggeunmoPro',//'NeoDunggeunmoPro',
        ),
        initialRoute: initRoute,
        routes:{
          '/main_scene' : (context) => MainGamePage(game: game,),
        //  '/main_scene' : (context) => MainGamePage(game: game,),
          '/init_setting' : (context) => InitSettingPage(),
          '/game_setting' : (context) => GameSettingPage(game: game,),
          '/shop_page' : (context) => ShopPage(game: game,),
        },
        home: initWidget(MainGamePage(game: game,)),
      ),
    );
  }
}
