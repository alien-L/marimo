import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:marimo_game/style/color.dart';


class GameSettingPage extends StatefulWidget {
  const GameSettingPage({Key? key}) : super(key: key);

  @override
  State<GameSettingPage> createState() => _GameSettingPageState();
}

class _GameSettingPageState extends State<GameSettingPage> {
bool isSwitched = false;

  Widget toggleWidget({required String txt}) => Padding(
    padding: const EdgeInsets.all(10.0),
    child: Row(
      children: [
        Text(txt),
        Switch(
          value: isSwitched,
          onChanged: (value) {
            setState(() {
              isSwitched = value;
              print(isSwitched);
            });
          },
          activeTrackColor: CommonColor.green,
          activeColor: CommonColor.green,
        ),
      ],
    ),
  );

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
              toggleWidget(txt: "음악 on/off"),
              toggleWidget(txt: "푸시설정 on/off"),
             // Text("언어설정"),
            ],
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
