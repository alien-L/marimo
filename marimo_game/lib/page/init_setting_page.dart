import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:marimo_game/app_manage/environment/environment.dart';
import 'package:marimo_game/style/color.dart';
import '../app_manage/local_repository.dart';
import '../components/game_alert.dart';

class InitSettingPage extends StatelessWidget {
  InitSettingPage({Key? key}) : super(key: key);
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {

    Widget textFormField(){

      return Column(
        children: [
          TextField(
            controller: controller,
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
            onChanged: (value){
          //    print(value);
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(
                CommonColor.green,
              ),),
              onPressed: () async {
                final name = controller.value.text;
                  bool specialChar = name.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
                  bool gap = name.contains(RegExp('\\s'));
                  if(specialChar || name.length>11 || name.isEmpty|| name == "" || gap){
                    GameAlert().showErrorDialog(text:Environment().config.constant.nameValidationCheckMsg);
                  }else{
                    LocalRepository localRepository = LocalRepository();
                    await localRepository.setKeyValue(key: 'marimoName', value: name);
                    await localRepository.setKeyValue(key: 'firstInstall', value: "1");
                    Navigator.pushNamed(context, "/main_scene");
                  }
              },
              child: const Text('OK'),
            ),
          )
        ],
      );
    }

    Widget initSettingWidget() => Padding(
      padding: const EdgeInsets.all(10.0),
      child: SizedBox(width: 300, height: 250, child: textFormField()),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                          Center(
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


