import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

import '../../api/api_base_helper.dart';

class CommonHttpClient {
  final ApiBaseHelper _helper = ApiBaseHelper();


  //
  // Future<AppStartInfo?> getAppMaintenance() async {
  //   var checkUri = Uri.https('www.elandmall.co.kr', '/app/start.json', {});
  //   try {
  //     final response = await http.get(checkUri);
  //     final responseJson = json.decode(utf8.decode(response.bodyBytes));
  //     return AppStartInfo.fromJson(responseJson);
  //   } catch (e) {
  //     return null;
  //   }
  // }
  //
  // Future<AppTask?> postAppTask(AppSendTask appSendTask) async {
  //   try {
  //     final responseJson = await _helper.post(authority: "tuho.elandmall.co.kr", unEncodedPath: "/log-management/app", params: [appSendTask]);
  //
  //     return AppTask.fromJson(responseJson);
  //   } catch (e) {
  //     return null;
  //   }
  // }

}
