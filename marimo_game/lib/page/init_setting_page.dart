import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:marimo_game/style/color.dart';

import '../app_manage/language.dart';
import '../app_manage/local_repository.dart';

class InitSettingPage extends StatelessWidget {
  InitSettingPage({Key? key}) : super(key: key);
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {

    Widget dropDownButton() => DropdownButtonFormField<Language>(
          decoration: const InputDecoration(
            labelText: 'Language',
            floatingLabelBehavior: FloatingLabelBehavior.always,
            labelStyle: TextStyle(fontSize: 15, color: Color(0xffcfcfcf)),
          ),
          // underline: Container(height: 1.4, color: Color(0xffc0c0c0)),
          onChanged: (Language? newValue) {
            // value 값 보내주기
            print(newValue);
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
                if(name !=""){
                  // 로컬저장소에 첫설치 아니라고 알려주기
                  // 로컬저장소에 이름 저장
                  // 이름 전송
                  LocalRepository localRepository = LocalRepository();
                  await localRepository.setKeyValue(key: 'marimoName', value: name);
                  Navigator.pushNamed(context, "/main_scene");

                }else{
                  //null 체크 및 validation 체크 들어가야됨
                  print("null ====> $name");
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
