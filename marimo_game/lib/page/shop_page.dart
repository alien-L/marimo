import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:marimo_game/app_manage/local_repository.dart';
import 'package:marimo_game/components/bar/coin_collector_bar.dart';
import 'package:marimo_game/components/game_alert.dart';

import '../bloc/marimo_bloc/marimo_bloc.dart';
import '../marimo_game_world.dart';
import '../style/color.dart';

class ShopPage extends StatelessWidget {
  const ShopPage({Key? key, required this.game}) : super(key: key);
  final MarimoWorldGame game;

  Future<List<dynamic>> getData() async {
    List<dynamic> list = [];
    try {
      final dynamicButtonList = await rootBundle
          .loadString('assets/marimo_shop.json')
          .then((jsonStr) => jsonStr);
      final data = await json.decode(dynamicButtonList);
      list = data["data"];
      print("list ==> $list");
    } catch (e) {
      log(e.toString());
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: IconButton(onPressed: () {
        //   Navigator.pop(context);
        //   //라우트 이동 시 argument 전달 해 주기
        //  // Navigator.pushNamed(context, "/main_scene");
        // }, icon: Icon(Icons.navigate_before),),
        backgroundColor: CommonColor.green,
        title: Text(
          "SHOP",
          style: TextStyle(
            fontFamily: 'NeoDunggeunmoPro',
            fontSize: 30,
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
            child: FutureBuilder<List<dynamic>>(
                future: getData(),
                builder: (context, snapshot) {
                  Widget child;

                  if (!snapshot.hasData || snapshot.hasError) {
                    child = Container();
                  } else {
                    List<dynamic> list = snapshot.requireData;
                    List<Widget> listView = List.generate(list.length, (index) {
                      var name = list[index]["name"];
                      var price = list[index]["price"];
                      var stateScore = list[index]["state_score"];
                      bool isEnabled = list[index]["enabled"] == "true";
                      var bought = list[index]["bought"];
                      var category = list[index]["category"];
                      var image_name = list[index]["image_name"];

                      return Container(
                        // padding: const EdgeInsets.all(3),
                        //color: Colors.white,
                        decoration: BoxDecoration(
                          color: isEnabled ? Colors.white : Colors.black26,
                          // border: Border.all(
                          //       width: 1,
                          //     color: CommonColor.green,
                          //     ),
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 5,
                            ),
                            image_name == ""
                                ? Container()
                                : Container(
                                    width: 150,
                                    height: 100,
                                    child: Image.asset(
                                        "assets/images/shop/$image_name")),
                            //  Align(
                            //      alignment: Alignment.topLeft,
                            //        child:
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10,
                                          right: 3.0,
                                          top: 3.0,
                                          bottom: 3.0),
                                      child: Row(
                                        children: [
                                          Text(
                                            "$name",
                                            style: TextStyle(
                                                fontFamily: 'NeoDunggeunmoPro',
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15),
                                            //  textAlign: TextAlign.left,
                                          ),
                                          Text(
                                            "  +$stateScore",
                                            style: TextStyle(
                                                fontFamily: 'NeoDunggeunmoPro',
                                                fontWeight: FontWeight.bold,
                                                fontSize: 13,
                                                color: Colors.red),
                                            //  textAlign: TextAlign.left,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: Text(
                                          "$price 원",
                                          style: TextStyle(
                                            color: Colors.black87,
                                            fontSize: 14,
                                            fontFamily: 'NeoDunggeunmoPro',
                                          ),
                                          //  textAlign: TextAlign.left,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 30,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              right: 10, bottom: 5),
                                          child: ElevatedButton(
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty
                                                      .resolveWith((states) {
                                                // If the button is pressed, return green, otherwise blue
                                                if (states.contains(
                                                    MaterialState.pressed)) {
                                                  return isEnabled
                                                      ? Colors.green
                                                      : Colors.black26;
                                                }
                                                return isEnabled
                                                    ? CommonColor.green
                                                    : Colors.black26;
                                              }),
                                            ),
                                            onPressed: () async {
                                              game.soundBloc.effectSoundPlay('/music/click.mp3');
                                              game.coinBloc.subtractCoin(int.parse(price));
                                              game.marimoBloc.add(MarimoStateScoreCalculatedEvent(isPlus: true, score: int.parse(stateScore)));
                                              game.soundBloc.effectSoundPlay('/music/popup.mp3');
                                              GameAlert().showMyDialog(text: "$name을 구매했어요 !! ",assetsName: "assets/images/shop/$image_name");
                                              },
                                            child: Text(
                                              isEnabled ? '구매하기' : '곧 만나요',
                                              style: TextStyle(
                                                  fontFamily:
                                                      'NeoDunggeunmoPro',
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12),
                                            ),
                                            //style: TextStyle(fontFamily: 'NeoDunggeunmoPro',fontSize: 30,),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            // )
                            // TextButton(
                            //   onPressed: () {},
                            //   child: Text("buy"),
                            // )
                          ],
                        ),
                      );
                    });

                    child = GridView.count(
                        primary: false,
                        padding: const EdgeInsets.all(20),
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        crossAxisCount: 2,
                        children: listView);
                  }

                  return Container(
                      //  color: CommonColor.green,
                      child: child);
                })),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
