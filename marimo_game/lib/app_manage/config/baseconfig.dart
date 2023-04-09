
import '../../const/constant.dart';

///
/// Created by ahhyun [ah2yun@gmail.com] on 2023. 03. 30
///
abstract class BaseConfig {
  String get apiHost; // 기본 세팅
  bool get useHttps; // 기본 세팅
  bool get trackEvents; // 기본 세팅
  bool get reportErrors; // 기본 세팅

  String get iosAppStoreURL; // 앱스토어 url
  String get aosAppStoreURL; // 플레이 스토어 url
  late Constant constant; // 공통 문자,문자열
}

class KoreanConfig extends BaseConfig{

  @override
  String get aosAppStoreURL => throw UnimplementedError();

  @override
  String get apiHost => throw UnimplementedError();

  @override
  String get iosAppStoreURL => throw UnimplementedError();

  @override
  bool get reportErrors => throw UnimplementedError();

  @override
  bool get trackEvents => throw UnimplementedError();

  @override
  bool get useHttps => throw UnimplementedError();

  @override
  Constant constant = KoreanConstant();
}

class EnglishConfig extends BaseConfig{

  @override
  String get aosAppStoreURL => throw UnimplementedError();

  @override
  String get apiHost => throw UnimplementedError();

  @override
  String get iosAppStoreURL => throw UnimplementedError();

  @override
  bool get reportErrors => throw UnimplementedError();

  @override
  bool get trackEvents => throw UnimplementedError();

  @override
  bool get useHttps => throw UnimplementedError();

  @override
  Constant constant = EnglishConstant();
}

class JapanConfig extends BaseConfig{

  @override
  String get aosAppStoreURL => throw UnimplementedError();

  @override
  String get apiHost => throw UnimplementedError();

  @override
  String get iosAppStoreURL => throw UnimplementedError();

  @override
  bool get reportErrors => throw UnimplementedError();

  @override
  bool get trackEvents => throw UnimplementedError();

  @override
  bool get useHttps => throw UnimplementedError();

  @override
  Constant constant = JapanConstant();
}