import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:marimo_game/bloc/marimo_bloc/marimo_exp_bloc.dart';
import '../bloc/marimo_bloc/marimo_level_bloc.dart';
import '../marimo_game_world.dart';
import 'game_alert.dart';
import 'marimo_component.dart';

class VillainController extends Component
    with
        HasGameRef<MarimoWorldGame>,
        FlameBlocListenable<MarimoExpBloc, int> {
  bool isFirst = true;
  VillainController();

  @override
  bool listenWhen(int previousState, int newState) {
    bool isLevel3 = game.marimoExpBloc.changeLifeCycleToExp(game.marimoLevelBloc.state) ==  MarimoExpState.level3;
    // exp 는 -- 관리 없는걸로 , 무찌르면 4로 업 , 못 치우면 계속 hp --
    // 빌런을 없앴는지 체크하는 로직 추가 , 빌런 없애기전까지는 레벨업 못하게 막아야됨
    // 빌런 움직임 추가 , 빌런 팝업창 ui, 마리모 스트레스 받는거 추가
    // 상태가 계속 변하니 ...
    // 돌아다니는 애니메이션 추가
    return isLevel3 && isFirst;
  }

  @override
  Future<void> onNewState(int state) async {
    isFirst = false; // 로컬에 저장하기 ,빌런 블럭에 추가

    print("2))) isFirst $isFirst");
    game.villainComponent.removeFromParent();
    parent?.add(gameRef.villainComponent =VillainComponent(game.marimoLevelBloc.state));
    game.marimoComponent.removeFromParent();
    parent?.add(gameRef.marimoComponent =
        MarimoComponent(name: game.marimoLevelBloc.state.name,));
     await GameAlert().showMyDialog(
      text: "꺅!!!빌런이 나타났어요!!!!!",
      assetsName: "assets/images/one_marimo.png",
    );
  }
}



class VillainComponent extends SpriteAnimationComponent
    with
        HasGameRef<MarimoWorldGame>,
        CollisionCallbacks,
        KeyboardHandler,
        FlameBlocListenable<MarimoLevelBloc, MarimoLevel> {

   final MarimoLevel level;

  VillainComponent(this.level){
    positionType = PositionType.viewport;
  }

  @override
  Future<void> onLoad() async {
    final name = _getVillanName();
    final coinSprite = await game.loadSprite('$name.png');

    add(
      SpriteComponent(
        sprite: coinSprite,
        position: Vector2(250,300),
        size: Vector2.all(200),
        anchor: Anchor.center,
      ),
    );
    await super.onLoad();
  }


  String _getVillanName(){
    String result = '';
    switch (level) {
      case MarimoLevel.zero:
        result =  "zero";
        break;
      case MarimoLevel.baby:
        result =  "cat";
        break;
      case MarimoLevel.child:
        result =  "rabbit";
        break;
      case MarimoLevel.child2:
        result =  "shark";
        break;
      case MarimoLevel.teenager:
        result =  "shrimp";
        break;
      case MarimoLevel.adult:
        result =  "snail";
        break;
      case MarimoLevel.oldMan:
        result =  "mouse";
        break;
    }
    return result;
  }

}