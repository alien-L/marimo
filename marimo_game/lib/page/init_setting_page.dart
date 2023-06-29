import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:marimo_game/app_manage/environment/environment.dart';
import 'package:marimo_game/style/color.dart';
import 'package:video_player/video_player.dart';
import '../app_manage/local_data_manager.dart';
import '../components/button/common_button.dart';
import '../components/alert/game_alert.dart';
import '../main.dart';

class InitSettingPage extends StatelessWidget {
  InitSettingPage({Key? key, required this.videoPlayerController}){
   videoPlayerController.dispose();
  }
  final TextEditingController txtController = TextEditingController();
  LocalDataManager localDataManager = LocalDataManager();
  final VideoPlayerController videoPlayerController;

  @override
  Widget build(BuildContext context) {
    
    Widget textFormField() {
      return Column(
        children: [
          TextField(
            controller: txtController,
            decoration: const InputDecoration(
              labelStyle: TextStyle(color: CommonColor.green),
              hintText: 'please input your marimo name.',
              labelText: 'NAME',
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: CommonColor.green, width: 2.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: CommonColor.green, width: 2.0),
              ),
            ),
            onChanged: (value) {
            },
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: CommonButton(
              imageName: 'play',
              height: 50,
              onTap: () async {
                final name = txtController.value.text;
                bool specialChar = name.contains(RegExp(r'''
  ^!#%&@`:;-.<>,~\\(\\)\\{\\}\\^\\[\\][*][+][$][|][']["]
  '''));
                //  ^[ㄱ-ㅎ가-힣0-9a-zA-Z]*$
                RegExp basicReg = RegExp(r"^[ㄱ-ㅎ가-힣0-9a-zA-Z\s+]*$");
                bool gap = name.contains(RegExp('\\s'));
                if (specialChar ||
                    name.length > 11 ||
                    name.isEmpty ||
                    name == "" ||
                    gap) {
                  GameAlert().showInfoDialog(
                    title: "",
                    contents: Environment().config.constant.nameValidationCheckMsg,
                    assetsName: 'assets/images/one_marimo.png',
                    color: Color.fromRGBO(200, 139, 251, 1),
                  );
                } else {
                  localDataManager.setIsFirstInstall();
                  localDataManager.setValue<String>(key: "marimoName", value: name);
                  Navigator.pushNamed(context, "/main_scene");
                }
              },
            ),
          ),
        ],
      );
    }

    Widget initSettingWidget() => Padding(
          padding: const EdgeInsets.all(10.0),
          child: SizedBox(width: 300, height: 250, child: textFormField()),
        );

    return backButtonWidget(child:Scaffold(
        backgroundColor: Colors.white,
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Center(
              child: Image(
                  width: 100,
                  height: 100,
                  image: AssetImage("assets/images/one_marimo.png")),
            ),
            initSettingWidget(),
          ],
        ))));
  }
}
