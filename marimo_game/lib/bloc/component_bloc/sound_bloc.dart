import 'package:flame_audio/flame_audio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app_manage/local_data_manager.dart';

class SoundBloc extends Cubit<bool> {
  SoundBloc(super.initialState){
    FlameAudio.bgm.initialize();
  }

  void isAllStopSound(bool value) => emit(value);

  void onOffSound(bool value) => emit(value);

  void bgmPlay(){
    if(state){
      FlameAudio.bgm.play('/music/bg_3.mp3');
    }
  }

  void effectSoundPlay(String mp3Name){
    if(state){
      FlameAudio.play(mp3Name);
    }
  }

  void offBgmSound(){
    FlameAudio.bgm.pause();
    FlameAudio.audioCache.clearAll();
    emit(false);
    _updateLocalsoundState();
  }

  void onBgmSound(){
    FlameAudio.bgm.resume();
    emit(true);
    _updateLocalsoundState();
  }

  Future<void> _updateLocalsoundState() async {
    await LocalDataManager().setValue<bool>(
        key: "isCheckedOnOffSound",  value: state);  // null 또는 0이면 true , 1이면 false

  }

}
