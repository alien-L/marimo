/** Copyright (c) 2021 Razeware LLC

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
distribute, sublicense, create a derivative work, and/or sell copies of the
Software in any work that is designed, intended, or marketed for pedagogical or
instructional purposes related to programming, coding, application development,
or information technology.  Permission for such use, copying, modification,
merger, publication, distribution, sublicensing, creation of derivative works,
or sale is expressly withheld.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE. **/
import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marimo_game/style/color.dart';
import '../app_manage/local_repository.dart';
import '../bloc/game_stats/bloc/game_stats_bloc.dart';
import '../helpers/direction.dart';
import '../helpers/joypad.dart';
import '../helpers/tap_event_controller.dart';
import '../marimo_game_world.dart';

class MainGamePage extends StatelessWidget {
  MainGamePage({Key? key,}) : super(key: key);



  Future<String?> getMarimoName() async {
    LocalRepository localRepository = LocalRepository();
    final String? name= await localRepository.getValue(key: "marimoName");

    return name;
  }

  @override
  Widget build(BuildContext context) {
   // final bloc = context.read<GameStatsBloc>();
   // MarimoWorldGame game = MarimoWorldGame(context,bloc);
    //TapEventsGame game = TapEventsGame();

    void onJoypadDirectionChanged(Direction direction) {
      //game.onJoypadDirectionChanged(direction);
    }

    return Scaffold(
        backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Stack(
              children: [
                // TODO 1
              GameWidget(game:MarimoWorldGame(context,context.read<GameStatsBloc>()) ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Joypad(onDirectionChanged: onJoypadDirectionChanged),
              ),)
                ,
              Positioned(
                  top: 0,
                  child: Container(
                    width: MediaQuery.of(context).size.width, height: 50,
                    //  color: Colors.amber,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 5.0),
                                  child: SizedBox(
                                    width: 45,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.pushNamed(
                                            context, "/shop_page"
                                        );
                                      },
                                      child: Icon(
                                        Icons.shopping_cart_sharp,
                                        size: 15,
                                      ),
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: CommonColor.green),
                                    ),
                                  ),
                                ),
                                FutureBuilder<String?>(
                                  future: getMarimoName(),
                                  builder: (context, snapshot) {
                                    if(snapshot.hasError  || !snapshot.hasData  ){
                                      return Container();
                                    }else{
                                      return Padding(
                                        padding: const EdgeInsets.only(left: 5.0),
                                        child: Row(
                                          children: [
                                            SizedBox(
                                                width: 50,
                                                height: 50,
                                                child: Image.asset('assets/images/mymarimo_btn.png',)),
                                            Text("${snapshot.requireData}"),
                                          ],
                                        ),
                                      );
                                    }
                                  }
                                ),

                              ],
                            ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 5.0),
                                  child: SizedBox(
                                    width: 45,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.pushNamed(
                                            context, "/game_setting"
                                        );
                                      },
                                      child: Icon(
                                        Icons.settings,
                                        size: 15,
                                      ),
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: CommonColor.green),
                                    ),
                                  ),
                                ),
                            //   ],
                            // ),
                          ],
                        ),
                      ],
                    ),
                  )),
              Positioned(
                  top: 50,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 30,
                    color: Colors.amber,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 30,
                          child: Text("마리모 상태바 "),
                        ),
                        Container(
                          height: 30,
                          child: Text("물 : good , 온도 : good , 습도 : good , 먹이 : good"),
                        ),
                      ],
                    ),
                  ))
              ],
            ),
          ),
      );
  }
}
