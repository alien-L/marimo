import 'package:flutter/material.dart';
///
/// Created by ahhyun [ah2yun@gmail.com] on 2023. 03. 30
///

// 앱 상태 체크 옵저버 클래스
class AppStatusObserver extends StatefulWidget {
  final Widget child;
  const AppStatusObserver({required this.child, Key? key,}) : super(key: key);

  @override
  State<AppStatusObserver> createState() => _AppStatusObserverState();
}

class _AppStatusObserverState extends State<AppStatusObserver> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {

    switch (state) {
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.resumed:
        break;
      case AppLifecycleState.detached:
        // 앱 종료 상태
        break;
      case AppLifecycleState.inactive:
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
