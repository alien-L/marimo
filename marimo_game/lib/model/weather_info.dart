

class WeatherInfo {
  dynamic coord;
  dynamic weather;
  dynamic base;
  dynamic main;
  dynamic visibility;
  dynamic wind;
  dynamic clouds;
  dynamic dt;
  dynamic sys;
  dynamic timezone;
  dynamic id;
  dynamic name;
  dynamic cod;

  WeatherInfo(
      {this.coord,
        this.weather,
        this.base,
        this.main,
        this.visibility,
        this.wind,
        this.clouds,
        this.dt,
        this.sys,
        this.timezone,
        this.id,
        this.name,
        this.cod});

  factory WeatherInfo.fromJson(Map<String, dynamic> json) => WeatherInfo(
    coord: json['coord'] as dynamic,
    weather: json['weather'] as dynamic,
    base: json['base'] as dynamic,
    main: json['main'] as dynamic,
    visibility: json['visibility'] as dynamic,
    wind: json['wind'] as dynamic,
    clouds: json['clouds'] as dynamic,
    dt: json['dt'] as dynamic,
    sys: json['sys'] as dynamic,
    timezone: json['timezone'] as dynamic,
    id: json['id'] as dynamic,
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'coord': coord,
    'weather': weather,
    'base': base,
    'main': main,
    'visibility': visibility,
    'wind': wind,
    'clouds': clouds,
    'dt': dt,
    'sys ': sys,
    'timezone': timezone,
    'id': id,
  };
}
