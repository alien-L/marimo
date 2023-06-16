import 'dart:convert';
import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/game_data_info.dart';
import '../model/marimo_shop.dart';

class LocalDataManager {

  // 초기 데이터 가져오기
  Future<dynamic> getInitGameDataInfo() async {
    final dynamicButtonList = await rootBundle
        .loadString('assets/local_game_info.json')
        .then((jsonStr) => jsonStr);
    final data = await json.decode(dynamicButtonList);
       print("🍎 data==> $data");
    saveGameData<GameDataInfo>(data);
    return data;
  }

  // 로컬에 데이터 저장하기
  Future<void> saveGameData<T>(data) async {
    if(T is GameDataInfo){
      final gameDataInfo = GameDataInfo.fromJson(data);
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('gameDataInfo', jsonEncode(gameDataInfo));
      print("savedata ${jsonEncode(gameDataInfo)},,,${jsonEncode(gameDataInfo).runtimeType}");
    }else if(T is Shop){
      final shopData = Shop.fromJson(data);
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('shop', jsonEncode(shopData));
      print("savedata // shopData ${jsonEncode(shopData)},,,${jsonEncode(shopData).runtimeType}");
    }
  }

  //로컬에 저장된 데이터 가져오기
  Future<dynamic> getGameDataInfo() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    Map<String, dynamic> gameDataInfoMap = {};
    final String? gameDataInfoStr = prefs.getString('gameDataInfo');
    if (gameDataInfoStr != null) {
      gameDataInfoMap = jsonDecode(gameDataInfoStr) as Map<String, dynamic>;
    }

    final gameDataInfo = GameDataInfo.fromJson(gameDataInfoMap);
    print(gameDataInfo);
   // final data = await json.decode(gameDataInfo);
    return gameDataInfoMap;
  }

  getValue<T>({required String key}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    switch (T) {
      case bool:
        return   prefs.getBool(key);
      case double:
        return   prefs.getDouble(key);
      case int:
        return  prefs.getInt(key);
      case String:
        return prefs.getString(key);
      case Object:
        return   prefs.get(key);
      case List<String>:
        return prefs.getStringList(key);
    }
  }

  setValue<T>({required String key,required dynamic value}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    switch (T) {
      case bool:
        return   prefs.setBool(key,value);
      case double:
        return   prefs.setDouble(key,value);
      case int:
        return  prefs.setInt(key,value);
      case String:
        return prefs.setString(key,value);
      case List<String>:
        return   prefs.setStringList(key, value);
    }
  }

  Future<dynamic> getShopData() async {
    final dynamicButtonList = await rootBundle
        .loadString('assets/shop.json')
        .then((jsonStr) => jsonStr);
    final data = await json.decode(dynamicButtonList);
    print("🍎 data==> $data");
    saveGameData<Shop>(data);
    return data;
  }


  Future<bool> getIsFirstInstall() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final result = prefs.getBool("isFirstInstall");
    return result ?? true;
  }

  Future<bool> setIsFirstInstall() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final result = prefs.setBool("isFirstInstall", false);

    return result;
  }

  dynamic getJsonData({required String key}) async {
    final data = await getGameDataInfo();
   return data[key];
  }

//  setJsonData({})

 // readFile() {}
 // writeFile() {}
}
