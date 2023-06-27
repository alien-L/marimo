import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:marimo_game/app_manage/local_data_manager.dart';
import 'package:marimo_game/components/alert/game_alert.dart';
import 'package:marimo_game/style/color.dart';
import '../const/constant.dart';
import '../helpers/direction.dart';
import '../helpers/joypad.dart';
import '../marimo_game_world.dart';

class MainGamePage extends StatelessWidget {
  MainGamePage({
    Key? key,
    required this.game,
    required this.marimoName,
  }) : super(key: key);
  LocalDataManager localDataManager = LocalDataManager();
  final MarimoWorldGame game;
  final String marimoName;

  Future<String?> getMarimoName() async {
    final result = await localDataManager.getValue<String>(key: "marimoName");
    return result;
  }

  @override
  Widget build(BuildContext context) {

    void onJoypadDirectionChanged(Direction direction) {
      game.onJoypadDirectionChanged(direction);
      game.soundBloc.effectSoundPlay('/music/bubble.mp3');
    }
    //
    // Widget developerManagerWidget() => Column(
    //       children: [
    //         Row(
    //           children: [
    //             TextButton(
    //                 onPressed: () async {
    //                   await  LocalDataManager().setValue<int>(
    //                       key: "coin", value: 200000);
    //                   game.coinBloc.emit(2000000);
    //                 },
    //                 child: Container(
    //                     height: 20,
    //                     color: Colors.green,
    //                     child: Text('코인 ++ '))),
    //             TextButton(
    //                 onPressed: () {
    //                   LocalDataManager().resetMyGameData();
    //                 },
    //                 child: Container(
    //                     height: 20, color: Colors.green, child: Text('reset'))),
    //           ],
    //         ),
    //         Row(
    //           children: [
    //             TextButton(
    //                 onPressed: () async {
    //                 //  game.environmentTemperatureBloc.updateState(25);
    //                 },
    //                 child: Container(
    //                     height: 20,
    //                     color: Colors.green,
    //                     child: Text('온도 올라감'))),
    //             TextButton(
    //                 onPressed: () async {
    //                   // String userJson =
    //                   //     json.encode("assets/local_game_info.json");
    //                   game.marimoExpBloc.addScore(game.marimoLevelBloc.state, 100);
    //                   //  game.environmentTrashBloc.updateState(false);
    //                 },
    //                 child: Container(
    //                     height: 20,
    //                     color: Colors.green,
    //                     child: Text('경험치 테스 '))),
    //           ],
    //         ),
    //       ],
    //     );

    Widget topButtonWidget(String route, String imagePath, double height,
            GestureTapCallback onTap) =>
        InkWell(
          onTap: onTap,
          child: SizedBox(
            //width: 40,
            height: height,
            child: Image.asset(imagePath),
          ),
        );

    return Material(
      child: SafeArea(
        top: true,
        bottom: false,
        child: AnnotatedRegion(
          value: SystemUiOverlayStyle.light,
          child: Stack(
            children: [

              GameWidget(game: game),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 50,right: 40),
                  child: Joypad(onDirectionChanged: onJoypadDirectionChanged),
                ),
              ),
              Positioned(
                top: 0,
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 5.0,
                  ),
                  child: topButtonWidget("/shop_page",
                      "${CommonConstant.assetsImageMain}shop.png", 50, () {
                    GameAlert().showShopDialog(game);
                  }),
                ),
              ),
            //  Positioned(bottom:50,child: developerManagerWidget()),
              Positioned(
                top: 50,
                left: 10,
                child: FutureBuilder(
                    future: getMarimoName(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (!snapshot.hasData || snapshot.hasError) {
                        return Container();
                      }
                      else if (snapshot.hasError) {
                        return Container();
                      }
                      else {
                        final name_space = Container(
                          child: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Row(
                              children: [
                                SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: Image.asset(
                                        "assets/images/mymarimo_btn.png")),
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  height: 19,
                                  color: CommonColor.green,
                                  child: Center(
                                    child: Text(
                                      "${snapshot.data.toString()}",
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
                  child: topButtonWidget("/game_setting",
                      "${CommonConstant.assetsImageMain}setting.png", 20, () {
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

