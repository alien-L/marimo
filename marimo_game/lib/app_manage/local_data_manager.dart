import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/game_data_info.dart';
import '../model/marimo_shop.dart';

class LocalDataManager {

  //get)  초기 데이터 가져오기
  Future<dynamic> getLocalGameData({required String key,required bool isFirstInstall}) async {

    if(isFirstInstall){
      final dynamicButtonList = await rootBundle
          .loadString('assets/local_game_info.json')
          .then((jsonStr) => jsonStr);
      final data = await json.decode(dynamicButtonList);
     // saveLocalData(data: data, key: key);
      final modelData = GameDataInfo.fromJson(data);
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(key, jsonEncode(modelData));
      return data;
    }else{
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      Map<String, dynamic> gameDataInfoMap = {};
      final String? gameDataInfoStr = prefs.getString(key);
      if (gameDataInfoStr != null) {
        gameDataInfoMap = jsonDecode(gameDataInfoStr) as Map<String, dynamic>;
      }

      return gameDataInfoMap;
    }
  }


  getValue<T>({required String key}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    switch (T) {
      case bool:
        return prefs.getBool(key);
      case double:
        return prefs.getDouble(key);
      case int:
        return prefs.getInt(key);
      case String:
        return prefs.getString(key);
      case Object:
        return prefs.get(key);
      case List<String>:
        return prefs.getStringList(key);
    }
  }

  setValue<T>({required String key, required dynamic value}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    switch (T) {
      case bool:
        return prefs.setBool(key, value);
      case double:
        return prefs.setDouble(key, value);
      case int:
        return prefs.setInt(key, value);
      case String:
        return prefs.setString(key, value);
      case List<String>:
        return prefs.setStringList(key, value);
    }
  }

  Future<dynamic> getShopData(bool isFirstInstall) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if(isFirstInstall){
      final initJSonData = await rootBundle
          .loadString('assets/shop.json')
          .then((jsonStr) => jsonStr);
      final data = await json.decode(initJSonData);
      List<Shop> shopData = <Shop>[];

      data["shopData"].forEach((json) {
        shopData.add(Shop.fromJson(json));
      });

      await prefs.setString("shopData", jsonEncode(shopData));
    return data;
    }else{
      return   prefs.getString("shopData");
    }
  }

  // 첫실행 세팅
  Future<bool> getIsFirstInstall() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final result = prefs.getBool("isFirstInstall");
    return result ?? true;
  }

  // 첫실행 세팅
  Future<bool> setIsFirstInstall() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final result = prefs.setBool("isFirstInstall", false);

    return result;
  }

  // 게임 데이터 삭제 및 리셋
  Future<void> resetMyGameData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    SharedPreferences.setMockInitialValues({});
  }
}
