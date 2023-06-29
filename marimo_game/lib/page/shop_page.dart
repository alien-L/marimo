import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:marimo_game/app_manage/environment/environment.dart';
import 'package:marimo_game/app_manage/local_data_manager.dart';
import 'package:marimo_game/bloc/shop_bloc.dart';
import 'package:marimo_game/components/alert/game_alert.dart';
import 'package:marimo_game/const/constant.dart';
import 'package:marimo_game/style/color.dart';
import 'package:marimo_game/style/font.dart';
import '../marimo_game_world.dart';

class ShopPage extends StatelessWidget {
  ShopPage({Key? key, required this.game, required this.categoryName});

  final MarimoWorldGame game;
  final String categoryName;

  Future<List<dynamic>> getData() async {
    Iterable<dynamic> result = [];
    try {
      final shopData =
          await LocalDataManager().getValue<String>(key: "shopData");
      List list = json.decode(shopData).cast<Map<String, dynamic>>().toList();
      list.sort((a,b)=>a["price"].compareTo(b["price"]));
      result = list.where((element) => element["category"] == categoryName);
    } catch (e) {
    }
    return result.toList();
  }

  @override
  Widget build(BuildContext context) {
    var controller = PrimaryScrollController.of(context);

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
                  var isCheckedMoving = list[index]["isCheckedMoving"];
                  var price = list[index]["price"];
                  var expScore = list[index]["exp_score"];
                  bool isEnabled = list[index]["enabled"];
               //   var category = list[index]["category"];
                  var image_name = list[index]["image_name"];

                 void onClickEvent() async {
                    if (!isEnabled) {
                      GameAlert().showInfoDialog(
                        title: "ㅠㅠ...",
                        contents: "곧 만나요.....~~ㅠ_ㅠ",
                        assetsName: 'assets/images/cry_marimo.png',
                        color: Colors.indigo,
                      );
                    } else if (!game.coinBloc.canBuyCoinState(price)) {
                      GameAlert().showInfoDialog(
                        title: "ㅠㅠ...",
                        contents: "돈이 없어요...~~ㅠ_ㅠ",
                        assetsName: 'assets/images/cry_marimo.png',
                        color: CommonColor.violet,
                      );
                    } else {
                      game.soundBloc.effectSoundPlay('music/click.mp3');
                      game.coinBloc.subtractCoin(price); // 코인 감소
                      game.marimoExpBloc.addScore(game.marimoLevelBloc.state, expScore); // 경험치 증가
                      game.shopBloc.add(BuyEvent(name: name, isCheckedMoving: isCheckedMoving, buyItem:  true, key: UniqueKey() ));  //이벤트 발생
                      game.soundBloc.effectSoundPlay('music/popup.mp3');
                      GameAlert().showInfoDialog(
                        title: "아이템 구매",
                        contents: name + Environment().config.constant.getItemMsg,
                        assetsName: "${CommonConstant.assetsImageShop}$image_name",
                        color: const Color.fromRGBO(200, 139, 251, 1),
                      );
                    }
                  }


                  Widget _nameExpStateSpace()=> Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10, right: 3.0, top: 3.0, bottom: 3.0),
                      child: Row(
                        children: [
                          Text("$name", style: CommonFont.neoDunggeunmoPro(fontWeight: FontWeight.bold, fontSize: 15,color: Colors.black),),
                          Text("  +$expScore", style: CommonFont.neoDunggeunmoPro(fontWeight: FontWeight.bold, fontSize: 13,color:Colors.blueAccent),
                          ),
                        ],
                      ),
                    ),
                  );
                  Widget _priceInfo()=> Padding(
                    padding:
                    const EdgeInsets.only(left: 10),
                    child: Text(
                      isEnabled ? "$price ${Environment().config.constant.coinUnit}" : "",
                      style: CommonFont.neoDunggeunmoPro(fontWeight: FontWeight.bold, fontSize: 14,color: Colors.black87,),
                    ),
                  );
                  Widget _buyButton()=> SizedBox(
                    height: 30,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          right: 10, bottom: 5),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: CommonColor.materialStatePropertyColor(pressedColor: isEnabled ? CommonColor.sky:Colors.black12,),
                        ),
                        onPressed: () => onClickEvent(),
                        child: Text(
                          isEnabled ? Environment().config.constant.buyItem : Environment().config.constant.comingSoon,
                          style:  CommonFont.neoDunggeunmoPro(fontWeight:FontWeight.bold, fontSize: 12,color: Colors.black87),
                        ),
                      ),
                    ),
                  );

                  return Container(
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.black,),
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      color: isEnabled ? Colors.white.withOpacity(0.8) : Colors.black26,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 5,),
                        SizedBox(
                            width: 45,
                            height: 70,
                            child: Image.asset("assets/images/shop/$image_name")),
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              _nameExpStateSpace(),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  _priceInfo(),
                                  _buyButton(),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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
