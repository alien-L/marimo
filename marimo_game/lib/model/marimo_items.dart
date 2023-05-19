
import 'package:marimo_game/app_manage/local_repository.dart';

class MarimoItems{
  // 로컬 저장소 체크 , 백그라운드 , 포그라운드 , 업데이트시
  // 앱을 처음 구동할때 불러와서 로컬에 있나 없나 체크 하기
  MarimoItems({
    this.coin,
    this.totalCoinCount,
    this.isCheckedOnOffSound,
    this.isCleanTrash,
    this.humidity,
    this.temperature,
    this.marimoName,
    this.marimoLevel,
    this.marimoLifeCycle,
    this.marimoHp
  });

  dynamic coin;
  dynamic totalCoinCount;

  dynamic isCheckedOnOffSound;

  dynamic isCleanTrash;
  dynamic humidity;
  dynamic temperature;

  dynamic marimoName;
  dynamic marimoLevel;
  dynamic marimoLifeCycle;
  dynamic marimoHp;

  factory MarimoItems.fromJson(Map<String, dynamic> json) => MarimoItems(
    isCheckedOnOffSound: json['isCheckedOnOffSound'] as dynamic,
    coin: json['coin'] as dynamic,
    totalCoinCount: json['totalCoinCount'] as dynamic,
    isCleanTrash: json['isCleanTrash'] as dynamic,
    humidity: json['humidity'] as dynamic,
    temperature: json['temperature'] as dynamic,

    marimoName: json['marimoName'] as dynamic,
    marimoLevel: json['marimoLevel'] as dynamic,
    marimoHp: json['marimoHp'] as dynamic,
    marimoLifeCycle: json['marimoLifeCycle'] as dynamic,
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'coin': coin,
    'isCheckedOnOffSound':isCheckedOnOffSound,
    'totalCoinCount':totalCoinCount,
    'isCleanTrash': isCleanTrash,
    'humidity': humidity,
    'temperature': temperature,

    'marimoName': marimoName,
    'marimoLevel': marimoLevel,
    'marimoHp': marimoHp,
    'marimoLifeCycle': marimoLifeCycle,
  };
}

Future<MarimoItems> getInitLocalMarimoItems() async {
  Map<String, dynamic> _json = {};

  LocalRepository localRepository = LocalRepository(); // 로컬 저장소

  MarimoItems().toJson().keys.forEach((element) async {
    final value = await localRepository.getValue(key: element);
    _json.addAll({element:value});
  });

  return MarimoItems.fromJson(_json);
}