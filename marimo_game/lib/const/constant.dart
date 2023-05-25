
///
/// Created by ahhyun [ah2yun@gmail.com] on 2023. 03. 30
///

abstract class Constant {
  String get temperature;
  String get humidity;
  String get celsius;
  String get percent;
  String get environment;
  String get levelUpMsg;
  String get setting;
  String get bgmOnOff;
  String get nameValidationCheckMsg;
  String get coinUnit;
  String get getItemMsg;
  String get buyItem;
  String get comingSoon;
  String get effectSoundOnOff;
}

class KoreanConstant extends Constant{

  @override
  String get celsius => "°C";

  @override
  String get environment => "어항 환경:";

  @override
  String get humidity => "습도:";

  @override
  String get percent => "%";

  @override
  String get temperature => "온도:";

  @override
  String get levelUpMsg => "MARIMO LEVEL UP !!!! \n마리모가 성장했어요 ^0^v";

  @override
  String get setting => "설정";

  @override
  String get bgmOnOff => "배경음";

  @override
  String get nameValidationCheckMsg => """닉네임은 1~10 글자 까지 가능합니다.\n공백 및 특수기호는 사용할 수 없습니다.""";

  @override
  String get coinUnit => "원";

  @override
  String get buyItem => "구매하기";

  @override
  String get comingSoon => "곧 만나요";

  @override
  String get getItemMsg => "을 구매했어요 !!";

  @override
  String get effectSoundOnOff => "효과음";

}

class EnglishConstant extends Constant{
  
  @override
  String get celsius => "°C";

  @override
  String get environment => "environment:";

  @override
  String get humidity => "humidity:";

  @override
  String get percent => "%";

  @override
  String get temperature => "temperature:";

  @override
  String get levelUpMsg => "MARIMO LEVEL UP !!!! \nMarimo has grown ^0^v";

  @override
  String get buyItem => "buy";

  @override
  String get coinUnit => "dollars";

  @override
  String get comingSoon => "coming soon";

  @override
  String get getItemMsg => "  <== I got it!! ";

  @override
  String get nameValidationCheckMsg => """Nickname can be from 1 to 10 characters.\nSpace and special symbols are not allowed.""";

  @override
  String get setting => "setting";

  @override
  String get bgmOnOff => "sound on/off";

  @override
  String get effectSoundOnOff => "효과음";

}

class JapanConstant extends Constant{
  @override

  String get celsius => "°C";

  @override
  String get environment => "環境:";

  @override
  String get humidity => "湿度:";

  @override
  String get percent => "%";

  @override
  String get temperature => "温度:";

  @override
  String get levelUpMsg => "MARIMO LEVEL UP ！！！！\nまりもが成長しました。";

  @override
  String get buyItem => "購買すること";

  @override
  String get coinUnit => "円";

  @override
  String get comingSoon => "coming soon";

  @override
  String get getItemMsg => "を購入しました。";

  @override
  String get nameValidationCheckMsg => """ニックネームは1~10文字まで可能です。\n空白または特殊記号は使用できません。""";

  @override
  String get setting => "設定";

  @override
  String get bgmOnOff => "音楽 on/off";

  @override
  String get effectSoundOnOff => "효과음";

}