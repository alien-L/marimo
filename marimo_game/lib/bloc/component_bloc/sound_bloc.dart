
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app_manage/local_repository.dart';

class SoundBloc extends Cubit<bool> {
  SoundBloc(super.initialState){
    FlameAudio.bgm.initialize();
  }

  void isAllStopSound(bool value) => emit(value);

  void bgmPlay(){
    if(!state){
      FlameAudio.bgm.play('/music/bg_3.mp3');
    }
  }

  void effectSoundPlay(String mp3Name){
    if(!state){
      FlameAudio.play(mp3Name);
    }
  }

  void offBgmSound(){
    FlameAudio.bgm.pause();
    FlameAudio.audioCache.clearAll();
    emit(true);
    updateLocalsoundState();
  }

  void onBgmSound(){
    FlameAudio.bgm.resume();
    emit(false);
    updateLocalsoundState();
  }

  Future<void> updateLocalsoundState() async {
    await LocalRepository().setKeyValue(
        key: "isCheckedOnOffSound", value: state.toString());
  }

}
