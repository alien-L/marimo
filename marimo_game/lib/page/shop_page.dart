import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:marimo_game/app_manage/environment/environment.dart';
import 'package:marimo_game/bloc/component_bloc/enemy_bloc.dart';
import 'package:marimo_game/bloc/marimo_bloc/marimo_bloc.dart';
import 'package:marimo_game/bloc/shop_bloc.dart';
import 'package:marimo_game/components/alert/game_alert.dart';
import 'package:marimo_game/const/constant.dart';

import '../app_manage/local_repository.dart';
import '../bloc/marimo_bloc/marimo_exp_bloc.dart';
import '../components/marimo.dart';
import '../marimo_game_world.dart';
import '../style/color.dart';

//enum shopCategory

class ShopPage extends StatelessWidget {
  const ShopPage({Key? key, required this.game, required this.categoryName})
      : super(key: key);
  final MarimoWorldGame game;
  final String categoryName;

  Future<List<dynamic>> getData() async {
    List<dynamic> list = [];
    Iterable<dynamic> result = [];
    try {
      final dynamicButtonList = await rootBundle
          .loadString('assets/marimo_shop.json')
          .then((jsonStr) => jsonStr);
      final data = await json.decode(dynamicButtonList);
      list = data["data"];
      result = list.where((element) => element["category"] == categoryName);
    } catch (e) {
      log(e.toString());
    }
    return result.toList();
  }

  Future<void> setLocalItem(String key) async => await LocalRepository()
      .setKeyValue(key: key, value: "true");

  Future<bool> checkHaveMyItem(String key) async {
  String? _name = await LocalRepository().getValue(key: key);

   bool result = await LocalRepository().getValue(key: key) == "1";
  print("$_name----$result");
    return result;
  }

  @override
  Widget build(BuildContext context) {
    var controller = PrimaryScrollController.of(context);
    // controller?.jumpTo(0);
    return Center(
        child: FutureBuilder<List<dynamic>>(
            future: getData(),
            builder: (context, snapshot) {
              Widget child;

              if (!snapshot.hasData || snapshot.hasError) {
                child = Container();
              } else {
                controller.jumpTo(0);
                List<dynamic> list = snapshot.requireData;
                List<Widget> listView = List.generate(list.length, (index) {
                  var name = list[index]["name"];
                  var isCheckedMoving =
                      list[index]["isCheckedMoving"] == "true";
                  //   var position_x = list[index]["position_x"];
                  //  var position_y = list[index]["position_y"];
                  var price = list[index]["price"];
                  var stateScore = list[index]["state_score"];
                  var expScore = list[index]["exp_score"];
                  bool isEnabled = list[index]["enabled"] == "true";
                //  var bought = checkHaveMyItem(name); // 로컬에서 체크
                  var category = list[index]["category"];
                  var enemy_name = list[index]["enemy_name"];
                  var image_name = list[index]["image_name"];
                  var environment_category =
                      list[index]["environment_category"];



                  onClickEvent() async {
                  //  final checkHaveMyItem = await LocalRepository().getValue(key: name) ;
                    if(!isEnabled){
                      GameAlert().showInfoDialog(
                        title: "ㅠㅠ...",
                        contents: "곧 만나요.....~~ㅠ_ㅠ",
                        assetsName: 'assets/images/cry_marimo.png',
                        color: Colors.indigo,
                      );
                    }
                    else if (!game.coinBloc.canBuyCoinState(int.parse(price))) {
                      GameAlert().showInfoDialog(
                        title: "ㅠㅠ...",
                        contents: "돈이 없어요...~~ㅠ_ㅠ",
                        assetsName: 'assets/images/cry_marimo.png',
                        color: Color.fromRGBO(200, 139, 251, 1),
                      );
                    } else {
                      game.soundBloc.effectSoundPlay('/music/click.mp3');
                      game.coinBloc.subtractCoin(int.parse(price));
                      game.marimoHpBloc.addScore(int.parse(stateScore));
                      game.marimoExpBloc.addScore(
                          game.marimoBloc.state.marimoLevel,
                          int.parse(expScore));
                      game.soundBloc.effectSoundPlay('/music/popup.mp3');
                      bool isPulledExp = game.marimoExpBloc
                              .changeLifeCycleToExp(
                                  game.marimoBloc.state.marimoLevel) ==
                          MarimoExpState.level5;
                      final isCheckedEnemy = await LocalRepository()
                              .getValue(key: "isCheckedEnemy") ==
                          "1";

                      if (isPulledExp && isCheckedEnemy) {
                        await levelUpMarimo(
                            game, game.marimoBloc.state.marimoLevel);
                      }

                      if (environment_category == "humidity") {
                        game.environmentHumidityBloc
                            .updateState(40); //곰팡이 유무 체크
                      } else if (environment_category == "temperature") {
                        game.environmentTemperatureBloc.updateState(15);
                      } else if (environment_category == "food") {
                        game.environmentTrashBloc.updateState(true);
                      } else {}

                      if (category == "enemy") {
                        final name =
                            game.enemyComponent.getEnemyInfoMap()["name"];
                        print("$name 여기 !!!$enemy_name");
                        if (name == enemy_name) {
                          game.enemyComponent.removeFromParent();
                          game.enemyBloc.hideEnemy();
                          game.marimoBloc
                              .add(MarimoEmotionChanged(MarimoEmotion.normal));
                        }
                      } else if (category == "deco") {
                       final checkHaveMyItem = await LocalRepository().getValue(key: name) ;
                            //== "true";
                       print("test $checkHaveMyItem , $name ");
                        if(checkHaveMyItem =="1"){
                          GameAlert().showInfoDialog(
                            title: "ㅠㅠ...",
                            contents: "이미 구매 했어유 .....~~ㅠ_ㅠ",
                            assetsName: 'assets/images/cry_marimo.png',
                            color: Colors.indigo,
                          );
                        }else{
                          game.shopBloc.add(BuyEvent(
                              name: name, isCheckedMoving: isCheckedMoving));
                          setLocalItem(name);
                          GameAlert().showInfoDialog(
                            title: "아이템 구매",
                            contents: name + Environment().config.constant.getItemMsg,
                            assetsName: "${CommonConstant.assetsImageShop}/$image_name",
                            color: Color.fromRGBO(200, 139, 251, 1),
                          );
                        }
                      }
                      // setLocalItem(name);
                      // GameAlert().showInfoDialog(
                      //   title: "아이템 구매",
                      //   contents: name + Environment().config.constant.getItemMsg,
                      //   assetsName: "${CommonConstant.assetsImageShop}/$image_name",
                      //   color: Color.fromRGBO(200, 139, 251, 1),
                      // );
                    }
                  }

                  return
                    FutureBuilder<bool>(
                      future: checkHaveMyItem(name),
                      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                        if (!snapshot.hasData || snapshot.hasError) {
                          return   Container();
                        } else {
                              final isLocalEnabled = !snapshot.requireData;
                              print("퓨쳐빌더 $isLocalEnabled");
                          return Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: Colors.black,
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                              // shape: BoxShape.,
                              color: isEnabled && isLocalEnabled
                                  ? Colors.white.withOpacity(0.8)
                              //Color.fromRGBO(1, 113,163, 1)
                              //Colors.white.withOpacity(0.5)
                                  : Colors.black26,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 5,
                                ),
                                image_name == ""
                                    ? Container()
                                    : Container(
                                    width: 45,
                                    height: 70,
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
                                            padding: const EdgeInsets.only(left: 10),
                                            child: Text(
                                              isEnabled&&isLocalEnabled
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
                                                  MaterialStateProperty.resolveWith(
                                                          (states) {
                                                        // If the button is pressed, return green, otherwise blue
                                                        if (states.contains(
                                                            MaterialState.pressed)) {
                                                          return isEnabled&&isLocalEnabled
                                                              ? Color.fromRGBO(
                                                              17, 220, 252, 1)
                                                          //   Color.fromRGBO(21, 253, 15, 1)
                                                              : Colors.black26;
                                                        }
                                                        return isEnabled&&isLocalEnabled
                                                            ? Color.fromRGBO(
                                                            17, 220, 252, 1)
                                                        //Color.fromRGBO(21, 253, 15, 1)
                                                            : Colors.black26;
                                                      }),
                                                ),
                                                onPressed: () => onClickEvent(),
                                                child: Text(
                                                  isEnabled&&isLocalEnabled
                                                      ? Environment()
                                                      .config
                                                      .constant
                                                      .buyItem
                                                      : Environment()
                                                      .config
                                                      .constant
                                                      .comingSoon,
                                                  style: TextStyle(
                                                      color: Colors.black87,
                                                      fontFamily: 'NeoDunggeunmoPro',
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 12),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                      },
                    );
                });

                child = GridView.count(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    primary: false,
                    padding: const EdgeInsets.all(10),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    crossAxisCount: 2,
                    children: listView);
              }

              return SingleChildScrollView(
                  controller: controller, child: child);
            }));
  }
}
