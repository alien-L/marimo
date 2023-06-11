import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:marimo_game/components/alert/game_alert.dart';
import 'package:marimo_game/style/color.dart';
import '../app_manage/local_repository.dart';
import '../helpers/direction.dart';
import '../helpers/joypad.dart';
import '../marimo_game_world.dart';

class MainGamePage extends StatelessWidget {
  MainGamePage({
    Key? key, required this.game, required this.marimoName,
  }) : super(key: key);
  LocalRepository localRepository = LocalRepository();
  final MarimoWorldGame game;
  final String marimoName;


  Future<String?>  getMarimoName() async {
 return  await localRepository.getValue(key: "marimoName");
  }


  @override
  Widget build(BuildContext context) {

    void onJoypadDirectionChanged(Direction direction) {
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
          //  CoinEffect(game: game,),
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


    Widget topButtonWidget(String route,String imagePath,double height,GestureTapCallback onTap)=>
    InkWell(
      onTap: onTap,
    //(){
        // Navigator.pushNamed(
        //     context, route);
    //    GameAlert().showSettingsDialog(game);
     // },
      child: SizedBox(
        //width: 40,
        height: height,
        child: Image.asset(imagePath),
      ),
    );

    return
      Material(
        child: SafeArea(
          top: true,
          bottom: false,
        //  minimum: EdgeInsets.all(16.0),
         // maintainBottomViewPadding: true,
          child: AnnotatedRegion(
            value: SystemUiOverlayStyle.light,
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
                // Positioned(
                //     bottom: 30,
                //     left: 0,
                //     child: developerManagerWidget()),
                Positioned(
                  top: 0,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5.0,),
                    child: topButtonWidget("/shop_page","assets/images/shop.png",50,(){
                      Navigator.pushNamed(context,"/shop_page");
                    }),
                  ),
                ),
                Positioned(
                  top: 50,
                  left: 10,
                  child: FutureBuilder(
                      future: getMarimoName(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        //해당 부분은 data를 아직 받아 오지 못했을때 실행되는 부분을 의미한다.
                        // if (snapshot.hasData == false) {
                        //   return CircularProgressIndicator();
                        // }
                        if (!snapshot.hasData || snapshot.hasError) {
                          return Container();
                        }
                        //error가 발생하게 될 경우 반환하게 되는 부분
                        else if (snapshot.hasError) {
                          return Container();
                        }
                        // 데이터를 정상적으로 받아오게 되면 다음 부분을 실행하게 되는 것이다.
                        else {
                        final name_space = Container(
                         // height: 19,
                       //   color: Colors.yellowAccent,
                          child: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Row(
                              children: [
                                SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: Image.asset("assets/images/mymarimo_btn.png")),
                                // Text(
                                //   "MY MARIMO:" ,
                                //   style: const TextStyle(
                                //     fontFamily: 'NeoDunggeunmoPro',
                                //     fontSize: 15,
                                //     color: Colors.black,
                                //   ),
                                // ),
                                SizedBox(width: 10,),
                                Container(
                                  height: 19,
                                  color:CommonColor.green,
                                  child: Center(
                                    child: Text(
                                     "${snapshot.data.toString()}" ,
                                      style: const TextStyle(
                                        fontFamily: 'NeoDunggeunmoPro',
                                        fontSize: 15,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );


                          return name_space;
                        }
                      }),
                ),
                Positioned(
                  top: 10,
                  right: 5,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 3.0),
                    child: topButtonWidget("/game_setting","assets/images/setting.png",20,(){
                      GameAlert().showSettingsDialog(game);
                    }),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  }
}
