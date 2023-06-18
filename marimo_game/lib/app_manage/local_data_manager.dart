import 'dart:convert';
import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/game_data_info.dart';
import '../model/marimo_shop.dart';

class LocalDataManager {

  // 초기 데이터 가져오기
  Future<dynamic> getInitLocalData({required String path, required String key}) async {
    final dynamicButtonList = await rootBundle
        .loadString(path) //'assets/local_game_info.json'
        .then((jsonStr) => jsonStr);
    final data = await json.decode(dynamicButtonList);
    saveLocalData(data: data,key: key);
    return data;
  }

  // 로컬에 데이터 저장하기
  Future<void> saveLocalData({dynamic data, required String key}) async {
    final gameDataInfo = GameDataInfo.fromJson(data);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, jsonEncode(gameDataInfo));
    //'gameDataInfo' , shopdata
  }

  //로컬에 저장된 데이터 가져오기
  Future<dynamic> getLocalData({required String key}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    Map<String, dynamic> gameDataInfoMap = {};
    final String? gameDataInfoStr = prefs.getString(key);
    if (gameDataInfoStr != null) {
      gameDataInfoMap = jsonDecode(gameDataInfoStr) as Map<String, dynamic>;
    }

    final gameDataInfo = GameDataInfo.fromJson(gameDataInfoMap);
  //  print(gameDataInfo);
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

  // Future<dynamic> getShopData() async {
  //   final data = await getInitLocalData('assets/shop.json',"shopData");
  //   return data["shopData"];
  // }


  dynamic getJsonData({required String key}) async {
    final data = await getLocalData(key: key);
   return data[key];
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
  }

}
