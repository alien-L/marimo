import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:marimo_game/components/game_alert.dart';
import 'package:marimo_game/style/color.dart';
import '../app_manage/local_repository.dart';
import '../helpers/direction.dart';
import '../helpers/joypad.dart';
import '../marimo_game_world.dart';
import 'drag_event.dart';

class MainGamePage extends StatelessWidget {
  MainGamePage({
    Key? key, required this.game,
  }) : super(key: key);
  LocalRepository localRepository = LocalRepository();
  final MarimoWorldGame game;

  @override
  Widget build(BuildContext context) {

    void onJoypadDirectionChanged(Direction direction) {
    //   final deviceSize = MediaQuery.of(context).size;
     // print("디바이스 사이즈 ==> width : ${deviceSize.width}, height : ${deviceSize.height}");
     // print("x =>${game.marimoComponent.position.x}, y => ${game.marimoComponent.position.y}");
       game.onJoypadDirectionChanged(direction);
       game.soundBloc.effectSoundPlay('/music/bubble.mp3');
    }

    Widget developerManagerWidget()=> Column(
      children: [
        Row(
          children: [
            TextButton(
                onPressed: () async {
                  await  LocalRepository().setKeyValue(
                      key: "coin", value: "1000000");
                  game.coinBloc.emit(1000000);
                },
                child: Container(
                    height: 20,
                    color: Colors.green,
                    child: Text('코인 ++ '))),
            TextButton(
                onPressed: () {
                  localRepository.getSecureStorage().deleteAll();
                },
                child: Container(
                    height: 20,
                    color: Colors.green,
                    child: Text('reset'))),
          ],
        ),
        Row(
          children: [
            TextButton(
                onPressed: () async {
                  game.marimoHpBloc.subtractScore(10);
                },
                child: Container(
                    height: 20,
                    color: Colors.green,
                    child: Text('hp --'))),
            TextButton(
                onPressed: () async {
                  game.marimoHpBloc.addScore(10);
                },
                child: Container(
                    height: 20,
                    color: Colors.green,
                    child: Text('hp ++'))),
            TextButton(
                onPressed: () async {
                  game.environmentTemperatureBloc.updateState(25);
                  },
                child: Container(
                    height: 20,
                    color: Colors.green,
                    child: Text('온도 올라감'))),
            TextButton(
                onPressed: () async {
                GameAlert().showErrorDialog(text: "test");
                },
                child: Container(
                    height: 20,
                    color: Colors.green,
                    child: Text('에러'))),
            TextButton(
                onPressed: () async {
                  game.environmentTrashBloc.updateState(false);
                },
                child: Container(
                    height: 20,
                    color: Colors.green,
                    child: Text('쓰레기 투척'))),
          ],
        ),
      ],
    );


    Widget topButtonWidget(String route,String imagePath,double height)=>
    InkWell(
      onTap: (){
        Navigator.pushNamed(
            context, route);
      },
      child: SizedBox(
        //width: 40,
        height: height,
        child: Image.asset(imagePath),
      ),
    );

    return Scaffold(
      backgroundColor: CommonColor.green,
      body: AnnotatedRegion(
        value: SystemUiOverlayStyle.light,
        child: SafeArea(
          top: true,
          bottom: false,
          child: Stack(
            children: [
             // GameWidget(game: DragEventsGame()),
              GameWidget(game: game),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Joypad(onDirectionChanged: onJoypadDirectionChanged),
                ),
              ),
              Positioned(
                  bottom: 30,
                  left: 0,
                  child: developerManagerWidget()),
              Positioned(
                top: 0,
                child: Padding(
                  padding: const EdgeInsets.only(left: 5.0,),
                  child: topButtonWidget("/shop_page","assets/images/shop.png",50),
                ),
              ),
              Positioned(
                top: 10,
                right: 5,
                child: Padding(
                  padding: const EdgeInsets.only(right: 3.0),
                  child: topButtonWidget("/game_setting","assets/images/setting.png",20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
