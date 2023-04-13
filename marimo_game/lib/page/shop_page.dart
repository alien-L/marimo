import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../style/color.dart';

class ShopPage extends StatelessWidget {
  const ShopPage({Key? key}) : super(key: key);


  Future<List<dynamic>> getData() async {
    List<dynamic> list = [];
    try {
      final dynamicButtonList = await rootBundle.loadString('assets/marimo_shop.json').then((jsonStr) => jsonStr);
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
        title: Text("shop"),
      ),
      body: SafeArea(
        child: Center(
          child:FutureBuilder<List<dynamic>>(
            future: getData(),
            builder: (context, snapshot) {
              Widget child;

              if (!snapshot.hasData || snapshot.hasError) {
                child =  Container();
              } else {
                List<dynamic> list = snapshot.requireData;
              List<Widget> listView = List.generate(list.length, (index){
                  var name = list[index]["name"];
                  var price =  list[index]["price"];
                  var stateScore =  list[index]["state_score"];
                  var enabled =  list[index]["enabled"];
                  var bought =  list[index]["bought"];
                  var category =  list[index]["category"];
                  var image_name =  list[index]["image_name"];

                  return Container(
                    padding: const EdgeInsets.all(3),
                    color: Colors.teal[100],
                    child: Column(
                      children: [
                        image_name==""?Container():Container(
                            width: 70,
                            height: 70,
                            child: Image.asset("assets/images/$image_name")),
                        Text("$name"),
                        Text("$price 원"),
                        TextButton(onPressed: (){}, child: Text("buy"),)
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
                  children: listView
                );
              }

              return child;
            }
          )
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
