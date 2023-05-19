import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as fss;
///
/// Created by ahhyun [ah2yun@gmail.com] on 2023. 03. 30
///
//로컬 저장소
// os별 저장소 optiona 설정
// key:"firstInstall", value: "0"
// "marimoName"
// "marimoState"
// temperature
// humidity
// isCleanWater = value "0" :true , "1":false
// isCleanTrash = value "0" :true , "1":false
//coin
class LocalRepository {

  fss.FlutterSecureStorage getSecureStorage() {
    fss.AndroidOptions getAndroidOptions() =>
        const fss.AndroidOptions(
          encryptedSharedPreferences: true,
        );
    fss.IOSOptions getIosOptions() => const fss.IOSOptions();

    final aosStorage = fss.FlutterSecureStorage(aOptions: getAndroidOptions());
    final iosStorage = fss.FlutterSecureStorage(iOptions: getIosOptions());
    return Platform.isAndroid ? aosStorage : iosStorage;
  }
  Future<String?> getValue({required String key}) async {
    final secureStorage = getSecureStorage();
    return   await secureStorage.read(key:key);
  }

  Future<void> setKeyValue({required String key,required String value}) async {
    final secureStorage = getSecureStorage();
    await secureStorage.write(key: key, value: value);
  }

}