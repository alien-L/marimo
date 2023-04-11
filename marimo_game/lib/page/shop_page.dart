import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../style/color.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({Key? key}) : super(key: key);

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> with TickerProviderStateMixin  {
  late TabController ctr;

  @override
  void initState() {
    super.initState();
    ctr = new TabController(vsync: this, length: 5);
  }

  @override
  void dispose() {
    ctr.dispose();
    super.dispose();
  }

  Future<List<dynamic>> getData() async {
    List<dynamic> list = [];
    try {
      final dynamicButtonList = await rootBundle
          .loadString('assets/marimo_shop.json')
          .then((jsonStr) => jsonStr);
      final data = await json.decode(dynamicButtonList);
      list = data["data"];
    //  print("list ==> $list");
    } catch (e) {
      log(e.toString());
    }
    return list;
  }
  List<List<dynamic>> tempList = [];
  List decoList = [];
  List villainList = [];
  List environmentList = [];
  List etcList = [];
  List marimodecoList = [];
  List<dynamic> resultView = [];

  @override
  Widget build(BuildContext context) {
    Widget result;

    return FutureBuilder<List<dynamic>>(
        future: getData(),
      builder: (context, snapshot) {

        if (!snapshot.hasData || snapshot.hasError) {
          result = Container();
        } else {

          List<dynamic> snapshotData = snapshot.requireData;

          for(var i=0; i<snapshotData.length; i++){
            final category = snapshotData[i]["category"];
            if(category == "deco"){
              print("category ==> $category, $snapshotData");
              decoList.add(snapshotData);
            }else if(category == "villain"){
              villainList.add(snapshotData);
              //print("villainList ==> $villainList");
            }else if(category == "environment"){
              environmentList.add(snapshotData);
            }else if(category == "etc"){
              etcList.add(snapshotData);
            }else if(category == "marimo_deco"){
              marimodecoList.add(snapshotData);
            }
          }
      //    print("decoList ==> $decoList");
        //  print("villainList ==> $villainList");

          tempList.addAll([decoList,villainList,environmentList,etcList,marimodecoList]);


          for(var i=0; i<tempList.length; i++){

            var temp = List.generate(tempList[i].length, (index) {
              var name = snapshotData[index]["name"];
              var price = snapshotData[index]["price"];
              var stateScore = snapshotData[index]["state_score"];
              var enabled = snapshotData[index]["enabled"];
              var bought = snapshotData[index]["bought"];
              var category = snapshotData[index]["category"];
              var image_name = snapshotData[index]["image_name"];

              return Container(
                padding: const EdgeInsets.all(3),
                color: Colors.teal[100],
                child: Column(
                  children: [
                    image_name == ""
                        ? Container()
                        : Container(
                        width: 70,
                        height: 70,
                        child: Image.asset(
                            "assets/images/$image_name")),
                    Text("$name"),
                    Text("$price 원"),
                    TextButton(
                      onPressed: () {},
                      child: Text("buy"),
                    )
                  ],
                ),
              );
            });

            resultView.add(temp);
          }

            List<Widget> tabBarView = List.generate(
                tempList.length,
                (index) => Center(
                    child: GridView.count(
                        primary: false,
                        padding: const EdgeInsets.all(20),
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        crossAxisCount: 2,
                        children: resultView[index])));

            result = TabBarView(
              controller: ctr,
              children: tabBarView);
        }

        return Scaffold(
          appBar: AppBar(
            backgroundColor: CommonColor.green,
            title: Text("shop"),
            bottom: TabBar(
              controller: ctr,
              tabs: [
                Tab(child: Text("어항 꾸미기템"),),
                Tab(child: Text("퇴치템"),),
                Tab(child: Text("환경변화템"),),
                Tab(child: Text("그외"),),
                Tab(child: Text("마리모 꾸미기템"),),
                //more tabs here
              ],
            ),
          ),
          body: SafeArea(
            child: Center(child:result),
          ), // This trailing comma makes auto-formatting nicer for build methods.
        );
      }
    );
  }
}