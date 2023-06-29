import 'package:flame_audio/flame_audio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SoundBloc extends Cubit<bool> {
  SoundBloc(super.initialState){
    FlameAudio.bgm.initialize();
  }

  void bgmPlay(){
    if(!state){
      var list = ['1','2','3'];
      var randomItem = (list..shuffle()).first;
      FlameAudio.bgm.play('music/bg_$randomItem.mp3',);
    }
  }

  void effectSoundPlay(String mp3Name){
    if(!state){
      FlameAudio.play(mp3Name,volume: 3);
    }
  }

  void offBgmSound(){
    FlameAudio.bgm.pause();
    FlameAudio.audioCache.clearAll();
    emit(true);
  }

  void onBgmSound(){
    FlameAudio.bgm.resume();
    emit(false);
  }
}
