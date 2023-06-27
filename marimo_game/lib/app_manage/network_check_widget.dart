import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:marimo_game/components/alert/game_alert.dart';
///
/// Created by ahhyun [ah2yun@gmail.com] on 2023. 03. 30
///

// 네트워크 체크 위젯
// class NetWorkCheckWidget extends StatelessWidget {
//    NetWorkCheckWidget(this.child, {super.key});
//
//   final Widget child;
//
//    final Connectivity _connectivity = Connectivity();
//
//    void initState() {
//      getConnectivityResult();
//    }
//
//    Future<ConnectivityResult> getConnectivityResult() async {
//      ConnectivityResult result = ConnectivityResult.none;
//      try {
//        result = await _connectivity.checkConnectivity();
//      } on PlatformException catch (e) {}
//
//      return result;
//    }
//
//
//    Widget resultWidget(Widget child) {
//      return FutureBuilder<ConnectivityResult>(
//          future: getConnectivityResult(),
//          initialData: ConnectivityResult.none,
//          builder: (context, snapshot) {
//            if (!snapshot.hasData || snapshot.hasError) {
//
//            } else {
//
//            }
//            switch (snapshot.requireData) {
//              case ConnectivityResult.none:
//               break;
//              case ConnectivityResult.mobile:
//              // 와이파이 환경 설정
//                break;
//              case ConnectivityResult.wifi:
//              // 모바일 환경
//                break;
//              default:
//            }
//
//            return child;
//          });
//    }
//
//
//    @override
//   Widget build(BuildContext context) {
//
//     return Material(
//       child: resultWidget(child)
//     );
//   }
// }
