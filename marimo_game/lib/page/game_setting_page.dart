import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:marimo_game/style/color.dart';

import '../marimo_game_world.dart';


class GameSettingPage extends StatefulWidget {
  const GameSettingPage({Key? key, required this.game}) : super(key: key);
  final MarimoWorldGame game;

  @override
  State<GameSettingPage> createState() => _GameSettingPageState();
}

class _GameSettingPageState extends State<GameSettingPage> {

 // late bool isSwitched = true;

Future<ValueChanged<bool>?> onOffSound(value) async {
  setState(() {
    bool isSwitched = widget.game.soundBloc.state;
    if(isSwitched){
      widget.game.soundBloc.onBgmSound();
    }else{
      widget.game.soundBloc.offBgmSound();
    }
    print(isSwitched);
  });
}

  Widget toggleWidget({required String txt,required ValueChanged<bool>? onChanged}) => Padding(
    padding: const EdgeInsets.all(10.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(txt),
        Switch(
          value: !widget.game.soundBloc.state,
          onChanged:onChanged,
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
              toggleWidget(txt: "음악 on/off",onChanged: onOffSound),
              //toggleWidget(txt: "푸시설정 on/off",onChanged: onOffSound),
             // Text("언어설정"),
            ],
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
