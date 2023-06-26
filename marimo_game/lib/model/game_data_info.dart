class GameDataInfo {
  // 로컬 저장소 체크 , 백그라운드 , 포그라운드 , 업데이트시
  // 앱을 처음 구동할때 불러와서 로컬에 있나 없나 체크 하기
  GameDataInfo(
      {this.language,
      this.endDay,
      this.background,
      this.marimoAppearanceState,
      //  required this.marimoEmotion,
      //   required this.marimoHp,
      this.marimoExp,
      this.coin,
     // this.isCheckedOnOffSound,
      //   required this.isCleanTrash,
      this.humidity,
      this.temperature,
      // required this.isCheckedEnemy,
      this.isToday,
      this.marimoLevel});

      // bool? isCheckedEnemy;
      bool? isToday;
      String? language;
      int? endDay;
      String? background;
      String? marimoAppearanceState;

    //  int? marimoHp;
      int? marimoExp;
      int? coin;
      int? marimoLevel;
     // bool? isCheckedOnOffSound;

    //  bool? isCleanTrash;
      int? humidity;
      double? temperature;

      // String? marimoEmotion;

  factory GameDataInfo.fromJson(Map<String, dynamic> json) => GameDataInfo(
        language: json['language'] as String?,
        isToday: json['isToday'] as bool?,
        endDay: json['endDay'] as int?,
        background: json['background'] as String?,
        marimoAppearanceState: json['marimoAppearanceState'] as String?,
        //marimoHp: json['marimoHp'] as int?,
        marimoExp: json['marimoExp'] as int?,
        coin: json['coin'] as int?,
      //  isCheckedOnOffSound: json['isCheckedOnOffSound'] as bool?,
        // isCleanTrash: json['isCleanTrash'] as bool?,
        humidity: json['humidity'] as int?,
        temperature: json['temperature'] as double?,
        marimoLevel: json['marimoLevel'] as int?,
        // isCheckedEnemy: json['isCheckedEnemy'] as bool?,
        //  marimoEmotion: json['marimoEmotion'] as String?,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'language': language,
        'endDay': endDay,
        'isToday': isToday,
        'background': background,
        'marimoAppearanceState': marimoAppearanceState,
        // 'marimoHp': marimoHp,
        'marimoExp': marimoExp,
        'coin': coin,
       // 'isCheckedOnOffSound': isCheckedOnOffSound,
        //  'isCleanTrash': isCleanTrash,
        'humidity': humidity,
        'temperature': temperature,
        'marimoLevel': marimoLevel,
        //  'isCheckedEnemy': isCheckedEnemy,
        //   'marimoEmotion': marimoEmotion,
      };
}
