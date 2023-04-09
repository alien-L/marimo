import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../style/color.dart';

class ShopPage extends StatelessWidget {
  const ShopPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CommonColor.green,
        title: Text("shop"),
      ),
      body: SafeArea(
        child: Center(
          child:Column(
            children: [
              Container(
                width: 200,
                height: 200,
                color: Colors.amber,
                child: Text("shop 페이지"),
              ),
            ],
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
