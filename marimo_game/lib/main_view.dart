import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'app_manage/local_repository.dart';
import 'package:http/http.dart' as http;

import 'bloc/environment_bloc/environment_humity_bloc.dart';
import 'bloc/environment_bloc/environment_temperature_bloc.dart';
import 'model/weather_info.dart';

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
    final environmentTemperatureBloc = BlocProvider.of<EnvironmentTemperatureBloc>(context);
    final environmentHumidityBloc = BlocProvider.of<EnvironmentHumidityBloc>(context);

    environmentTemperatureBloc.updateState(temperature);
    environmentHumidityBloc.updateState(humidity);
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
