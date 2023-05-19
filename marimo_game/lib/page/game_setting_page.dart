import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:marimo_game/app_manage/environment/environment.dart';
import 'package:marimo_game/style/color.dart';

import '../app_manage/language.dart';
import '../app_manage/restart_widget.dart';
import '../main.dart';
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

Widget dropDownButton() => DropdownButtonFormField<Language>(
      decoration: const InputDecoration(
labelText: 'Language',
floatingLabelBehavior: FloatingLabelBehavior.always,
labelStyle: TextStyle(fontSize: 15, color: Color(0xffcfcfcf)),
      ),
      // underline: Container(height: 1.4, color: Color(0xffc0c0c0)),
      onChanged: (Language? newValue) {
// value 값 보내주기
       // Environment().initConfig(newValue!); -- > cubit으로 처리 ?
       // widget.game.backgroundBloc.close();
//RestartWidget.restartApp(navigatorKey.currentContext!, newValue!);
print(newValue);
   // widget.game.languageManageBloc.changeLanguage(newValue);
      },
      items: [Language.en, Language.jp, Language.ko]
  .map<DropdownMenuItem<Language>>((Language i) {
return DropdownMenuItem<Language>(
  value: i,
  child: Text(
      '${{'en': 'english', 'jp': 'japan', 'ko': "korea"}[i.name]}'),
  //  {'en': 'english', 'jp': 'japan','ko':"korea"}[i.name]
  // Text({'M': '남성', 'F': '여성'}[i] ?? '비공개'),
);
      }).toList(),
    );


@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CommonColor.green,
        title: Text(Environment().config.constant.setting),
      ),
      body: SafeArea(
        child: Center(
          child:Column(
            children: [
           //   dropDownButton(),
              toggleWidget(txt:Environment().config.constant.soundOnOff,onChanged: onOffSound),
              //toggleWidget(txt: "푸시설정 on/off",onChanged: onOffSound),
             // Text("언어설정"),
            ],
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
