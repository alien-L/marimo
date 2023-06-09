import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/experimental.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/animation.dart';
import 'package:marimo_game/bloc/marimo_bloc/marimo_exp_bloc.dart';
import '../bloc/marimo_bloc/marimo_bloc.dart';
import '../marimo_game_world.dart';
import 'game_alert.dart';
import 'marimo_component.dart';

class VillainController extends Component
    with
        HasGameRef<MarimoWorldGame>,
        FlameBlocListenable<MarimoExpBloc, int> , TapCallbacks{
  bool isFirst = true;
  VillainController();

  @override
  bool listenWhen(int previousState, int newState) {
    bool isLevel3 = game.marimoExpBloc.changeLifeCycleToExp(game.marimoBloc.state.marimoLevel) ==  MarimoExpState.level3;
  //  final isCheckedVillain = LocalRepository().getValue(key: "isCheckedVillain");
    return isLevel3 &&isFirst;
  }

  @override
  Future<void> onNewState(int state) async {
    isFirst = false; // 로컬에 저장하기 ,빌런 블럭에 추가
    game.villainBloc.showVillain();
    final villainComponent = VillainComponent(game.size,game.marimoBloc.state.marimoLevel);
    //if(game.villainBloc.state){ // 빌런 나타남
      game.villainComponent.removeFromParent();
      parent?.add(gameRef.villainComponent = villainComponent);
      game.marimoComponent.removeFromParent();
      game.marimoBloc.add(MarimoEmotionChanged(MarimoEmotion.cry));
      parent?.add(gameRef.marimoComponent = MarimoComponent(levelName: game.marimoBloc.state.marimoLevel.name, emotionName:  game.marimoBloc.state.marimoEmotion.name,));
      game.soundBloc.effectSoundPlay('music/villain.mp3');
      await GameAlert().showMyDialog(
          text: "꺅!!!빌런이 나타났어요!!!!!",
          assetsName: "assets/images/${villainComponent.getVillianInfoList().first}.png",
          dialogNumber: "02"
      );

  }
}



class VillainComponent extends SpriteComponent
    with HasGameRef<MarimoWorldGame>,
        CollisionCallbacks,
        FlameBlocListenable<MarimoBloc, MarimoState>,
        TapCallbacks{
  late Vector2 _worldSize;
  late Vector2 _pos;
  final Vector2 velocity = Vector2.zero();
  final MarimoLevel level;

  VillainComponent(Vector2 worldSize,this.level):super(size: Vector2.all(100), anchor: Anchor.center){
    _worldSize = worldSize;
    positionType = PositionType.viewport;
  }

   @override
   void onTapUp(TapUpEvent event) {
     GameAlert().showMyDialog(text: getVillianInfoList().last,
         assetsName: "assets/images/${getVillianInfoList().first}.png",
         dialogNumber: "02");
   }

  @override
  Future<void> onLoad() async {
    final name = getVillianInfoList().first;
    final coinSprite = await game.images.load('$name.png');
    sprite = Sprite( coinSprite);
    add(RectangleHitbox()..collisionType = CollisionType.passive);
    add(
         SequenceEffect([
           MoveEffect.by(
             Vector2(30, 100),
             EffectController(
               duration: 5,
               infinite: true,
               curve: Curves.easeOutQuad,
             ),
           ),
           MoveToEffect(
           Vector2(100, 100),
             EffectController(
               duration: 5,
               infinite: true,
               curve: Curves.easeOutQuad,
             ),
           ),
           MoveEffect.by(
             Vector2(30, 100),
             EffectController(
               duration: 5,
               infinite: true,
               curve: Curves.easeOutQuad,
             ),
           ),
          // RemoveEffect(),
         ])
     );
    final random = Random();
    final posX = random.nextDouble() * _worldSize.x;
    final posY = random.nextDouble() * _worldSize.y;
    _pos = Vector2(posX , posY);
    position = _pos;
    await super.onLoad();
  }


  List<String> getVillianInfoList(){
    List<String> result = [];
    switch (level) {
      case MarimoLevel.zero:
        result =  ["zero"];
        break;
      case MarimoLevel.baby:
        result =  ["cat","이 냐옹이는 생선이 먹고싶다옹!!\n생선을 달라옹!!! =ㅅ=!!!"]; //fish
        break;
      case MarimoLevel.child:
        result =  ["rabbit","울 엄마가 계란후라이 먹고싶대 0ㅅ0"]; //계란후라이
        break;
      case MarimoLevel.child2:
        result =  ["shark","난 감성적인 F 상어 .\n 육지에 있는 체리를 구해줘 >_<"]; // 체리
        break;
      case MarimoLevel.teenager:
        result =  ["shrimp","나 곧 피자 재료로 쓰일거 같아....\n 고기와 함께 구워지겠지..."]; //고기
        break;
      case MarimoLevel.adult:
        result =  ["snail","밤하늘의 펄얼~~~~~~\n나랑 별보러 가지않을래~~~~^0^"]; //별
        break;
      case MarimoLevel.oldMan:
        result =  ["mouse","아이엠 마우스 유노????\n 아이워너치즈 -3-"]; //cheese
        break;
    }
    return result;
  }

}