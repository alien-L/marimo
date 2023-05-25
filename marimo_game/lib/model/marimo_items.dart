import 'package:marimo_game/app_manage/local_repository.dart';

class MarimoItems {
  // 로컬 저장소 체크 , 백그라운드 , 포그라운드 , 업데이트시
  // 앱을 처음 구동할때 불러와서 로컬에 있나 없나 체크 하기
  MarimoItems({
    required this.language,
    required this.lastDay,
    required this.background,
    required this.marimoName,
    required this.marimoLevel,
    required this.marimoHp,
    required this.marimoExp,
    required this.coin,
    required this.totalCoinCount,
    required this.isCheckedOnOffSound,
    required this.isCleanTrash,
    required this.humidity,
    required this.temperature,
    required this.firstInstall,
  });

  dynamic language; // 보류
  dynamic lastDay; //ok ??? 체크
  dynamic background; //ok

  dynamic marimoName;

  /// ok init_setting.dart 에서 관리
  dynamic marimoLevel; //ok
  dynamic marimoHp; //ok
  dynamic marimoExp;

  dynamic coin; //ok
  dynamic totalCoinCount;

  /// ok

  dynamic isCheckedOnOffSound; //ok

  dynamic isCleanTrash; //ok
  dynamic humidity; //ok
  dynamic temperature; //ok

  dynamic firstInstall;

  /// ok  main_view.dart 에서 관리

  factory MarimoItems.fromJson(Map<String, dynamic> json) => MarimoItems(
        language: json['language'] as dynamic,
        lastDay: json['lastDay'] as dynamic,
        background: json['background'] as dynamic,
        marimoName: json['marimoName'] as dynamic,
        marimoLevel: json['marimoLevel'] as dynamic,
        marimoHp: json['marimoHp'] as dynamic,
        marimoExp: json['marimoExp'] as dynamic,
        coin: json['coin'] as dynamic,
        totalCoinCount: json['totalCoinCount'] as dynamic,
        isCheckedOnOffSound: json['isCheckedOnOffSound'] as dynamic,
        isCleanTrash: json['isCleanTrash'] as dynamic,
        humidity: json['humidity'] as dynamic,
        temperature: json['temperature'] as dynamic,
        firstInstall: json['firstInstall'] as dynamic,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'language': language,
        'lastDay': lastDay,
        'background': background,
        'marimoName': marimoName,
        'marimoLevel': marimoLevel,
        'marimoHp': marimoHp,
        'marimoExp': marimoExp,
        'coin': coin,
        'totalCoinCount': totalCoinCount,
        'isCheckedOnOffSound': isCheckedOnOffSound,
        'isCleanTrash': isCleanTrash,
        'humidity': humidity,
        'temperature': temperature,
        'firstInstall': firstInstall,
      };
}

Future<MarimoItems> getInitLocalMarimoItems() async {

  final items = MarimoItems(
      language: await LocalRepository().getValue(key: "language"),
      lastDay: await LocalRepository().getValue(key: "lastDay"),
      background: await  LocalRepository().getValue(key: "background"),
      marimoName: await  LocalRepository().getValue(key: "marimoName"),
      marimoLevel: await LocalRepository().getValue(key: "marimoLevel"),
      marimoHp: await LocalRepository().getValue(key: "marimoHp"),
      marimoExp: await LocalRepository().getValue(key: "marimoExp"),
      coin: await LocalRepository().getValue(key: "coin"),
      totalCoinCount:  await LocalRepository().getValue(key: "totalCoinCount"),
      isCheckedOnOffSound: await LocalRepository().getValue(key: "isCheckedOnOffSound"),
      isCleanTrash: await LocalRepository().getValue(key: "isCleanTrash"),
      humidity: await LocalRepository().getValue(key: "humidity"),
      temperature: await LocalRepository().getValue(key: "temperature"),
      firstInstall: await LocalRepository().getValue(key: "firstInstall"),);

  print("json ==> $items");

  return items;
}
