class GameDataInfo {
  // 로컬 저장소 체크 , 백그라운드 , 포그라운드 , 업데이트시
  // 앱을 처음 구동할때 불러와서 로컬에 있나 없나 체크 하기
  GameDataInfo(
      {required this.language,
      required this.lastDay,
      required this.background,
      required this.marimoLevel,
      required this.marimoEmotion,
      required this.marimoHp,
      required this.marimoExp,
      required this.coin,
      required this.isCheckedOnOffSound,
      required this.isCleanTrash,
      required this.humidity,
      required this.temperature,
      required this.isCheckedEnemy,
      required this.shopData});

  bool? isCheckedEnemy;
  String? language;
  bool? lastDay;
  String? background;
  String? marimoLevel;
  int? marimoHp;
  int? marimoExp;
  int? coin;
  bool? isCheckedOnOffSound;
  bool? isCleanTrash;
  int? humidity;
  double? temperature;
  String? marimoEmotion;
  List<Map<String,dynamic>> shopData;

  factory GameDataInfo.fromJson(Map<String, dynamic> json) => GameDataInfo(
        language: json['language'] as String?,
        lastDay: json['lastDay'] as bool?,
        background: json['background'] as String?,
        marimoLevel: json['marimoLevel'] as String?,
        marimoHp: json['marimoHp'] as int?,
        marimoExp: json['marimoExp'] as int?,
        coin: json['coin'] as int?,
        isCheckedOnOffSound: json['isCheckedOnOffSound'] as bool?,
        isCleanTrash: json['isCleanTrash'] as bool?,
        humidity: json['humidity'] as int?,
        temperature: json['temperature'] as double?,
        isCheckedEnemy: json['isCheckedEnemy'] as bool?,
        shopData: json['isCheckedEnemy'] as   List<Map<String,dynamic>>,
        marimoEmotion: json['marimoEmotion'] as String?,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'language': language,
        'lastDay': lastDay,
        'background': background,
        'marimoLevel': marimoLevel,
        'marimoHp': marimoHp,
        'marimoExp': marimoExp,
        'coin': coin,
        'isCheckedOnOffSound': isCheckedOnOffSound,
        'isCleanTrash': isCleanTrash,
        'humidity': humidity,
        'temperature': temperature,
        'isCheckedEnemy': isCheckedEnemy,
        'shopData': shopData,
        'marimoEmotion': marimoEmotion,
      };
}
