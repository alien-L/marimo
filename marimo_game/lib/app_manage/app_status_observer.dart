import 'package:flutter/material.dart';
import 'package:marimo_game/bloc/component_bloc/time_check_bloc.dart';
///
/// Created by ahhyun [ah2yun@gmail.com] on 2023. 03. 30
///

// 앱 상태 체크 옵저버 클래스
class AppStatusObserver extends StatefulWidget {
  final Widget child;
  final TimeCheckBloc timeCheckBloc;
  const AppStatusObserver({required this.child, Key? key, required this.timeCheckBloc,}) : super(key: key);

  @override
  State<AppStatusObserver> createState() => _AppStatusObserverState();
}

class _AppStatusObserverState extends State<AppStatusObserver> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    widget.timeCheckBloc.checkForTomorrow();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {

    switch (state) {
      case AppLifecycleState.paused:
        print("paused 상태 앱 종료 ");
        widget.timeCheckBloc.updateLocalLastTime(DateTime.now());
        // 종료했을때 시간체크 close time
        break;
      case AppLifecycleState.resumed:
       print("resumed 포그라운드  상태 ");
       widget.timeCheckBloc.checkForTomorrow();
        // 시작 했을때 시간체크 start time current time
        break;
      case AppLifecycleState.detached:
      // 종료했을때 시간체크 close time
        widget.timeCheckBloc.updateLocalLastTime(DateTime.now());
      print("detached 상태 앱 종료 ");
        // 앱 종료 상태
        break;
      case AppLifecycleState.inactive:
      // 종료했을때 시간체크 close time
        widget.timeCheckBloc.updateLocalLastTime(DateTime.now());
        print("inactive 백그라운드 상태 ");
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
