import 'dart:io';

class AdHelper {

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/6300978111'; // 테스트 용
   //   return 'ca-app-pub-7908404119066522/1996030107'; // 실제 키
    } else if (Platform.isIOS) {
  //    return   'ca-app-pub-7908404119066522/7119761639'; // 실제 키
    return 'ca-app-pub-3940256099942544/2934735716'; // 테스트 용
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/5224354917'; // 테스트 용
    //  return 'ca-app-pub-7908404119066522/5256618262';  // 실제 키
    } else if (Platform.isIOS) {
   //   return 'ca-app-pub-7908404119066522/3020163700';  // 실제 키
      return 'ca-app-pub-3940256099942544/1712485313'; // 테스트 용
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }
}