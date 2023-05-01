import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'app_manage/local_repository.dart';
import 'package:http/http.dart' as http;

import 'bloc/environment_bloc/environment_bloc.dart';

///
/// Created by ahhyun [ah2yun@gmail.com] on 2023. 03. 30
///

// 권한 획득 체크 => 카메라, 저장소, 위치 , 푸시
class MainView extends StatefulWidget {
  const MainView({super.key, required this.child});

  final Widget child;

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  late PermissionStatus statusTest;
  LocalRepository localRepository = LocalRepository();

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<Position?> _getCurrentPosition() async {
    // Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    late Position? _currentPosition;

    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return null;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position? position) {
      setState(() => _currentPosition = position);
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

  checkEnvironment(Map<String, dynamic> data) async {
    print("여기 날씨 ");
    final temperature = data["temp"];
    final humidity = data["humidity"];
    final envriomentBloc = context.read<EnvironmentBloc>();

    // late var isWaterChanged;// set , get 설정 해 주기
    // late var isFoodTrashChanged;
    // late var humidityLocalValue;
    // late var temperatureLocalValue;
    var isWaterChanged = await localRepository.getValue(
        key: "isWaterChanged"); // set , get 설정 해 주기
    var isFoodTrashChanged =
        await localRepository.getValue(key: "isFoodTrashChanged");
    var humidityLocalValue =
        await localRepository.getValue(key: "humidity");
    var temperatureLocalValue =
        await localRepository.getValue(key: "temperature");

    if (isWaterChanged == null ||
        isFoodTrashChanged == null ||
        humidityLocalValue == null ||
        temperatureLocalValue == null) {

       await localRepository.setKeyValue(key: "isWaterChanged", value: "0");
       await localRepository.setKeyValue(key: "isFoodTrashChanged", value: "0");
       await localRepository.setKeyValue(key: "humidity", value: humidity.toString());
       await localRepository.setKeyValue(key: "temperature", value: temperature.toString());

    }

    print("event 발생!!!!");
    envriomentBloc.add(EnvironmentChangeEvent(
        isWaterChanged: isWaterChanged == "0",
        humidity: humidity,
        temperature: temperature,
        isFoodTrashChanged: isFoodTrashChanged == "0")); // bad 인경우 temp값 가져와서  35 이면 죽이게 만들기
  }

  getMyEnvironment() async {
    final position = await _getCurrentPosition();
    var lat = position?.latitude;
    var lon = position?.longitude;
    final _weatherInfo = await getWeatherByCurrentLocation(lat, lon);
    final detailedWeatherInfo = _weatherInfo.main;
    checkEnvironment(detailedWeatherInfo);
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (Platform.isIOS) {
        getMyEnvironment();
      } else {
        checkPermissionForAos();
      }
      final isFirstInstallApp = await _getFirstInstallStatus();
      if (!mounted) return;
      if (isFirstInstallApp) {
        getMyEnvironment();
        await localRepository.setKeyValue(key: "marimoStateScore", value: "50");
        // 첫 앱 설치
      }
    });
  }

  @override
  bool get mounted => super.mounted;

  @override
  void dispose() {
    super.dispose();
  }

  Future<bool> _getFirstInstallStatus() async {
    LocalRepository localRepository = LocalRepository(); // 로컬 저장소
    final isFirst = await localRepository.getValue(key: "firstInstall");
    if (isFirst == null) {
      await localRepository.setKeyValue(key: 'firstInstall', value: '1');
      print("첫 앱 설치 ");
      return true;
    } else {
      print("아니다 ");
      return false;
    }
  }

  /// iOS 권한 체크 메소드
  /// notification 권한 획득시
  Future<void> checkPermissionForiOS() async {
    // 광고수집 > 푸시 알림 > 위치
    // IDFA > NOTIFICATION > LOCATION
    bool idfa = await runPermission(Permission.appTrackingTransparency);

    if (idfa) {
      await runPermission(Permission.notification);

      // try {
      //   final bool result =
      //       await Channel.methodChannel.invokeMethod("notification");
      //
      //   if(result) {
      //
      //     if(Environment().config.brandCode == 'KD') {
      //       await runPermission(Permission.locationWhenInUse);
      //     }
      //
      //   }
      // } on PlatformException catch (e) {
      //
      // }
    }
  }

  // 안드로이드 권한 획득 메소드
  Future<void> checkPermissionForAos() async {
    List<Permission> permissionList = [
      Permission.phone,
      Permission.camera,
      Permission.storage,
      Permission.location,
      Permission.notification,
    ];

    for (Permission item in permissionList) {
      await item.request();
    }
  }

  // 권한 팝업 실행 여부 체크
  Future<bool> runPermission(Permission permission) async {
    PermissionStatus status = await permission.request();
    if (status == PermissionStatus.granted ||
        status == PermissionStatus.denied ||
        status == PermissionStatus.permanentlyDenied) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

class WeatherInfo {
  dynamic coord;
  dynamic weather;
  dynamic base;
  dynamic main;
  dynamic visibility;
  dynamic wind;
  dynamic clouds;
  dynamic dt;
  dynamic sys;
  dynamic timezone;
  dynamic id;
  dynamic name;
  dynamic cod;

  WeatherInfo(
      {this.coord,
      this.weather,
      this.base,
      this.main,
      this.visibility,
      this.wind,
      this.clouds,
      this.dt,
      this.sys,
      this.timezone,
      this.id,
      this.name,
      this.cod});

  factory WeatherInfo.fromJson(Map<String, dynamic> json) => WeatherInfo(
        coord: json['coord'] as dynamic,
        weather: json['weather'] as dynamic,
        base: json['base'] as dynamic,
        main: json['main'] as dynamic,
        visibility: json['visibility'] as dynamic,
        wind: json['wind'] as dynamic,
        clouds: json['clouds'] as dynamic,
        dt: json['dt'] as dynamic,
        sys: json['sys'] as dynamic,
        timezone: json['timezone'] as dynamic,
        id: json['id'] as dynamic,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'coord': coord,
        'weather': weather,
        'base': base,
        'main': main,
        'visibility': visibility,
        'wind': wind,
        'clouds': clouds,
        'dt': dt,
        'sys ': sys,
        'timezone': timezone,
        'id': id,
      };
}
