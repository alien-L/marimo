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
import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
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
import 'bloc/coin_bloc.dart';
import 'bloc/marimo_bloc/marimo_level_bloc.dart';
import 'bloc/marimo_bloc/marimo_lifecycle_bloc.dart';
import 'bloc/marimo_bloc/marimo_score_bloc.dart';
import 'bloc/sound_bloc.dart';
import 'marimo_game_world.dart';
import 'page/main_game_page.dart';
import 'main_view.dart';

final navigatorKey = GlobalKey<NavigatorState>();

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
  final bool isMainPage = await getInitRoute();
  String initRoute = isMainPage ? '/main_scene' : '/init_setting';
  String? coinLocalRepositoryValue = await LocalRepository().getValue(key: "coin");
 // MarimoLevel marimoLocalRepositoryValue = await LocalRepository().getValue(key: "MarimoLevel")??MarimoLevel ;

 // WidgetsBinding.instance.addPostFrameCallback((_) async {
//    if (Platform.isIOS) {
  await getMyEnvironment();
 //   } else {
      //  checkPermissionForAos();
  //  }
    // final isFirstInstallApp = await _getFirstInstallStatus();
    // if (!mounted) return;
    //  if (isFirstInstallApp) {
    //    getMyEnvironment();
    //    await localRepository.setKeyValue(key: "marimoStateScore", value: "50");
    //    // 첫 앱 설치
    //  }
//  });
  var isWaterChanged = await LocalRepository()
      .getValue(key: "isWaterChanged"); // set , get 설정 해 주기
  var isFoodTrashChanged =
      await LocalRepository().getValue(key: "isFoodTrashChanged");
  var humidityLocalValue = await LocalRepository().getValue(key: "humidity");
  var temperatureLocalValue =
      await LocalRepository().getValue(key: "temperature");

  EnvironmentState environmentState = Loaded(
      isWaterChanged: isWaterChanged == "0"?true:false,
      temperature: double.parse(temperatureLocalValue??"0"),
      humidity: int.parse(humidityLocalValue??"0"),
      isFoodTrashChanged: isFoodTrashChanged == "0"?true:false, );

  runApp(RestartWidget(
      child: MultiBlocProvider(
          providers: [
        BlocProvider<MarimoLevelBloc>(create: (_) => MarimoLevelBloc(MarimoLevel.baby)),
        BlocProvider<MarimoScoreBloc>(create: (_) => MarimoScoreBloc(50)),
        BlocProvider<MarimoLifeCycleBloc>(create: (_) => MarimoLifeCycleBloc(MarimoLifeCycle.normal)),
        BlocProvider<CoinBloc>(create: (_) => CoinBloc(int.parse(coinLocalRepositoryValue ?? "0"))),
        BlocProvider<SoundBloc>(create: (_) => SoundBloc()),
        BlocProvider<EnvironmentBloc>(create: (_) => EnvironmentBloc(environmentState)),
      ],
          child: App(
            initRoute: initRoute,
          ))));
  // FlutterNativeSplash.remove();
}

Future<bool> getInitRoute() async {
  LocalRepository localRepository = LocalRepository(); // 로컬 저장소
  final marimoName = await localRepository.getValue(key: "marimoName");
  final isMainPage = marimoName != null ? true : false;
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
      environmentBloc: context.read<EnvironmentBloc>(),
      context: context,
      soundBloc: context.read<SoundBloc>(),
      coinBloc: context.read<CoinBloc>(),
      marimoScoreBloc: context.read<MarimoScoreBloc>(),
      marimoLevelBloc:context.read<MarimoLevelBloc>(),
      marimoLifeCycleBloc: context.read<MarimoLifeCycleBloc>(),
    );

    return initWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'RayWorld',
        theme: ThemeData(
          fontFamily: 'NeoDunggeunmoPro', //'NeoDunggeunmoPro',
        ),
        initialRoute: initRoute,
        routes: {
          '/main_scene': (context) => MainGamePage(
                game: game,
              ),
          //  '/main_scene' : (context) => MainGamePage(game: game,),
          '/init_setting': (context) => InitSettingPage(),
          '/game_setting': (context) => GameSettingPage(
                game: game,
              ),
          '/shop_page': (context) => ShopPage(
                game: game,
              ),
        },
        home: initWidget(MainGamePage(
          game: game,
        )),
        navigatorKey: navigatorKey,
      ),
    );
  }
}

getMyEnvironment() async {
  final position = await _getCurrentPosition();
  var lat = position?.latitude;
  var lon = position?.longitude;
  final _weatherInfo = await getWeatherByCurrentLocation(lat, lon);
  final detailedWeatherInfo = _weatherInfo.main;
  checkEnvironment(detailedWeatherInfo);
}

Future<Position?> _getCurrentPosition() async {
  // Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  late Position? _currentPosition;

  final hasPermission = await _handleLocationPermission();
  if (!hasPermission) return null;
  await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
      .then((Position? position) {
    _currentPosition = position;
  }).catchError((e) {
    debugPrint(e);
  });

  return _currentPosition;
}

Future<WeatherInfo> getWeatherByCurrentLocation(lat, lon) async {
  var url =
      'https://api.openweathermap.org/data/2.5/weather?lat=${lat}&lon=${lon}&appid=658d847ef1d28e72e047ab0c5a476d54&units=metric';
  Uri myUri = Uri.parse(url);
  final response = await http.get(myUri);
  final responseJson = json.decode(utf8.decode(response.bodyBytes));
  print("url ===> 🦄 $responseJson");
  // local에 저장
  return WeatherInfo.fromJson(responseJson);
}

Future<bool> _handleLocationPermission() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
    //     content: Text(
    //         'Location services are disabled. Please enable the services')));
    return false;
  }
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //     const SnackBar(content: Text('Location permissions are denied')));
      return false;
    }
  }
  if (permission == LocationPermission.deniedForever) {
    // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
    //     content: Text(
    //         'Location permissions are permanently denied, we cannot request permissions.'))
    // );
    return false;
  }
  return true;
}

checkEnvironment(Map<String, dynamic> data) async {
  print("여기 날씨 ");
  final temperature = data["temp"];
  final humidity = data["humidity"];
  //final envriomentBloc = navigatorKey.currentContext.read<EnvironmentBloc>();

  // late var isWaterChanged;// set , get 설정 해 주기
  // late var isFoodTrashChanged;
  // late var humidityLocalValue;
  // late var temperatureLocalValue;
  var isWaterChanged = await LocalRepository()
      .getValue(key: "isWaterChanged"); // set , get 설정 해 주기
  var isFoodTrashChanged =
      await LocalRepository().getValue(key: "isFoodTrashChanged");
  var humidityLocalValue = await LocalRepository().getValue(key: "humidity");
  var temperatureLocalValue =
      await LocalRepository().getValue(key: "temperature");

  if (isWaterChanged == null ||
      isFoodTrashChanged == null ||
      humidityLocalValue == null ||
      temperatureLocalValue == null) {
    await LocalRepository().setKeyValue(key: "isWaterChanged", value: "0");
    await LocalRepository().setKeyValue(key: "isFoodTrashChanged", value: "0");
    await LocalRepository()
        .setKeyValue(key: "humidity", value: humidity.toString());
    await LocalRepository()
        .setKeyValue(key: "temperature", value: temperature.toString());
  }

  print("event 발생!!!!");
  // envriomentBloc.add(EnvironmentChangeEvent(
  //     isWaterChanged: isWaterChanged == "0",
  //     humidity: humidity,
  //     temperature: temperature,
  //     isFoodTrashChanged: isFoodTrashChanged == "0")); // bad 인경우 temp값 가져와서  35 이면 죽이게 만들기
}
