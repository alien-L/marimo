import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:marimo_game/app_manage/environment/environment.dart';
import 'package:marimo_game/bloc/component_bloc/villian_bloc.dart';
import 'package:marimo_game/bloc/marimo_bloc/marimo_bloc.dart';
import 'package:marimo_game/bloc/shop_bloc.dart';
import 'package:marimo_game/components/game_alert.dart';

import '../app_manage/local_repository.dart';
import '../bloc/marimo_bloc/marimo_exp_bloc.dart';
import '../components/marimo_component.dart';
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
        backgroundColor: CommonColor.green,
        title: const Text(
          "SHOP",
          style: TextStyle(
            fontFamily: 'NeoDunggeunmoPro',
            fontSize: 30,
          ),
        ),
      ),
      body: Center(
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
                    var isCheckedMoving = list[index]["isCheckedMoving"]== "true";
                 //   var position_x = list[index]["position_x"];
                  //  var position_y = list[index]["position_y"];
                    var price = list[index]["price"];
                    var stateScore = list[index]["state_score"];
                    var expScore = list[index]["exp_score"];
                    bool isEnabled = list[index]["enabled"] == "true";
                    var bought = list[index]["bought"];
                    var category = list[index]["category"];
                    var villain_name = list[index]["villain_name"];
                    var image_name = list[index]["image_name"];
                    var environment_category =
                        list[index]["environment_category"];

                    ////"environment_category" exp_score

                    return Container(
                      decoration: BoxDecoration(
                        color: isEnabled ? Colors.white : Colors.black26,
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
                                        Text(
                                          "  +$expScore",
                                          style: TextStyle(
                                              fontFamily: 'NeoDunggeunmoPro',
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13,
                                              color: Colors.blueAccent),
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
                                        isEnabled
                                            ? "$price ${Environment().config.constant.coinUnit}"
                                            : "",
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
                                            if (!game.coinBloc.canBuyCoinState(int.parse(price))) {
                                              GameAlert().showMyDialog(text: "돈이 없어요...~~ㅠ_ㅠ", assetsName: 'assets/images/cry_marimo.png', dialogNumber: '02');
                                            } else {
                                              game.soundBloc.effectSoundPlay('/music/click.mp3');
                                              game.coinBloc.subtractCoin(int.parse(price));
                                              game.marimoHpBloc.addScore(int.parse(stateScore));
                                              game.marimoExpBloc.addScore(game.marimoBloc.state.marimoLevel, int.parse(expScore));
                                              game.soundBloc.effectSoundPlay('/music/popup.mp3');
                                              bool isPulledExp = game.marimoExpBloc.changeLifeCycleToExp(game.marimoBloc.state.marimoLevel) == MarimoExpState.level5;
                                              final isCheckedVillain = await LocalRepository().getValue(key: "isCheckedVillain") == "1";
                                              if (isPulledExp && isCheckedVillain) {
                                                await levelUpMarimo(game, game.marimoBloc.state.marimoLevel);
                                              }

                                              if (environment_category == "humidity") {
                                                game.environmentHumidityBloc.updateState(40);
                                                //곰팡이 유무 체크
                                              } else if (environment_category == "temperature") {
                                                game.environmentTemperatureBloc.updateState(15);
                                              } else if (environment_category == "food") {
                                                game.environmentTrashBloc.updateState(true);
                                              }else {}

                                              if(category == "villain"){
                                                final name =  game.villainComponent.getVillainInfoMap()["name"];

                                                if(name == villain_name){
                                                    game.villainComponent.removeFromParent();
                                                    game.villainBloc.hideVillain();
                                                    game.marimoBloc.add(MarimoEmotionChanged(MarimoEmotion.normal));
                                                }

                                              }else if(category == "deco"){
                                                print("여기 !!!");
                                                game.shopBloc.add(BuyEvent(name: name,isCheckedMoving: isCheckedMoving));

                                              }

                                              GameAlert().showMyDialog(
                                                  text: name +
                                                      Environment()
                                                          .config
                                                          .constant
                                                          .getItemMsg,
                                                  assetsName:
                                                      "assets/images/shop/$image_name",
                                              dialogNumber: "01"
                                              );
                                            }
                                          },
                                          child: Text(
                                            isEnabled
                                                ? Environment()
                                                    .config
                                                    .constant
                                                    .buyItem
                                                : Environment()
                                                    .config
                                                    .constant
                                                    .comingSoon,
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
              })), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
