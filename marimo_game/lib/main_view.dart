import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

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

  void _permissionStorage(Permission permission) async {
    var requestStatus = await permission.request();

    var status = await permission.status;

    if (requestStatus.isGranted && status.isLimited) {
      // isLimited - 제한적 동의 (ios 14 < )
      // 요청 동의됨
    } else if (requestStatus.isPermanentlyDenied ||
        status.isPermanentlyDenied) {
      openAppSettings();
    } else if (status.isRestricted) {
      openAppSettings();
    } else if (status.isDenied) {
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (Platform.isIOS) {
        _permissionStorage(Permission.appTrackingTransparency);
      } else {
        _permissionStorage(Permission.storage);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
   return widget.child;
  }
}