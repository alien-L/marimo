
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SoundBloc extends Cubit<bool> {
  SoundBloc() : super(false){
    FlameAudio.bgm.initialize();
  }

  void isAllStopSound(bool value) => emit(value);

  void bgmPlay(){
      FlameAudio.bgm.play('/music/bg_3.mp3');
  }

  void coinEffectSoundPlay(){
    FlameAudio.play('/music/coin_1.mp3');
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
