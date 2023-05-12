
import 'package:marimo_game/app_manage/local_repository.dart';

class MarimoItems{
  // 로컬 저장소 체크 , 백그라운드 , 포그라운드 , 업데이트시
  // 앱을 처음 구동할때 불러와서 로컬에 있나 없나 체크 하기
  MarimoItems({
    this.coin,
    this.isCheckedOnOffSound,
    this.isCleanTrash,
    this.isCleanWater,
    this.humidity,
    this.temperature,
    this.marimoName,
    this.marimoLevel,
    this.marimoLifeCycle,
    this.marimoScore
  });

  dynamic coin;
  dynamic isCheckedOnOffSound;

  dynamic isCleanWater;
  dynamic isCleanTrash;
  dynamic humidity;
  dynamic temperature;

  dynamic marimoName;
  dynamic marimoLevel;
  dynamic marimoLifeCycle;
  dynamic marimoScore;

  factory MarimoItems.fromJson(Map<String, dynamic> json) => MarimoItems(
    isCheckedOnOffSound: json['isCheckedOnOffSound'] as dynamic,
    coin: json['coin'] as dynamic,

    isCleanTrash: json['isCleanTrash'] as dynamic,
    isCleanWater: json['isCleanWater'] as dynamic,
    humidity: json['humidity'] as dynamic,
    temperature: json['temperature'] as dynamic,

    marimoName: json['marimoName'] as dynamic,
    marimoLevel: json['marimoLevel'] as dynamic,
    marimoScore: json['marimoScore'] as dynamic,
    marimoLifeCycle: json['marimoLifeCycle'] as dynamic,
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'coin': coin,
    'isCheckedOnOffSound':isCheckedOnOffSound,

    'isCleanTrash': isCleanTrash,
    'isCleanWater': isCleanWater,
    'humidity': humidity,
    'temperature': temperature,

    'marimoName': marimoName,
    'marimoLevel': marimoLevel,
    'marimoScore': marimoScore,
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