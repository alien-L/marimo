class GameDataInfo {
  // 로컬 저장소 체크 , 백그라운드 , 포그라운드 , 업데이트시
  // 앱을 처음 구동할때 불러와서 로컬에 있나 없나 체크 하기
  GameDataInfo(
      {this.language,
      this.background,
      this.marimoAppearanceState,
      this.marimoExp,
      this.coin,
      this.humidity,
      this.temperature,
      this.marimoLevel});

      bool? isToday;
      String? language;
      String? background;
      String? marimoAppearanceState;


      int? marimoExp;
      int? coin;
      int? marimoLevel;

      int? humidity;
      double? temperature;


  factory GameDataInfo.fromJson(Map<String, dynamic> json) => GameDataInfo(
        language: json['language'] as String?,
        background: json['background'] as String?,
        marimoAppearanceState: json['marimoAppearanceState'] as String?,
        marimoExp: json['marimoExp'] as int?,
        coin: json['coin'] as int?,
        humidity: json['humidity'] as int?,
        temperature: json['temperature'] as double?,
        marimoLevel: json['marimoLevel'] as int?,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'language': language,
        'background': background,
        'marimoAppearanceState': marimoAppearanceState,
        'marimoExp': marimoExp,
        'coin': coin,
        'humidity': humidity,
        'temperature': temperature,
        'marimoLevel': marimoLevel,
      };
}
