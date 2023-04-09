import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:marimo_game/style/color.dart';

class GameSettingPage extends StatelessWidget {
  const GameSettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CommonColor.green,
        title: Text("설정"),
      ),
      body: SafeArea(
        child: Center(
          child:Column(
            children: [
              Container(
                width: 200,
                height: 200,
                color: Colors.amber,
                child: Text("설정 페이지"),
              ),
            ],
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
