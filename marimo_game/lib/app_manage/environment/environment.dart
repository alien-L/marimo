
import '../config/baseconfig.dart';
import '../language.dart';

///
/// Created by ahhyun [ah2yun@gmail.com] on 2023. 03. 30
///

//환경세팅 클래스
//싱글톤 패턴 사용
class Environment {
  factory Environment() {
    return _instance;
  }

  Environment._privateConstructor();

  static final Environment _instance = Environment._privateConstructor();

 late BaseConfig config;

  initConfig(Language language){
    config = _getConfig(language);
  }

  BaseConfig _getConfig(Language language) {
    switch (language) {
      case Language.ko:
        return KoreanConfig();
      case Language.en:
        return EnglishConfig();
      case Language.jp:
        return JapanConfig();
      default:
        return KoreanConfig();
    }
  }
}