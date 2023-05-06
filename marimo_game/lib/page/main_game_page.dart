/** Copyright (c) 2021 Razeware LLC

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in
    all copies or substantial portions of the Software.

    Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
    distribute, sublicense, create a derivative work, and/or sell copies of the
    Software in any work that is designed, intended, or marketed for pedagogical or
    instructional purposes related to programming, coding, application development,
    or information technology.  Permission for such use, copying, modification,
    merger, publication, distribution, sublicensing, creation of derivative works,
    or sale is expressly withheld.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
    THE SOFTWARE. **/
import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marimo_game/bloc/environment_bloc/environment_bloc.dart';
import 'package:marimo_game/bloc/marimo_bloc/marimo_bloc.dart';
import 'package:marimo_game/components/game_alert.dart';
import 'package:marimo_game/style/color.dart';
import '../app_manage/local_repository.dart';
import '../helpers/direction.dart';
import '../helpers/joypad.dart';
import '../marimo_game_world.dart';

class MainGamePage extends StatelessWidget {
  MainGamePage({
    Key? key, required this.game,
  }) : super(key: key);
  LocalRepository localRepository = LocalRepository();
  final MarimoWorldGame game;

  Future<String?> getMarimoName() async {
    final String? name = await localRepository.getValue(key: "marimoName");

    return name;
  }

  @override
  Widget build(BuildContext context) {

    void onJoypadDirectionChanged(Direction direction) {
      game.onJoypadDirectionChanged(direction);
    }

    Widget developerManagerWidget()=> Row(
      children: [
        TextButton(
            onPressed: () async {
              await  LocalRepository().setKeyValue(
                  key: "coin", value: "1000000");
              game.coinBloc.emit(1000000);
            },
            child: Container(
                height: 20,
                color: Colors.green,
                child: Text('코인 ++ '))),
        TextButton(
            onPressed: () {
              localRepository.getSecureStorage().deleteAll();
            },
            child: Container(
                height: 20,
                color: Colors.green,
                child: Text('reset')))
      ],
    );


    Widget topButtonWidget(String route,String imagePath,double height)=>
    InkWell(
      onTap: (){
        Navigator.pushNamed(
            context, route);
      },
      child: SizedBox(
        //width: 40,
        height: height,
        child: Image.asset(imagePath),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Stack(
          children: [
            GameWidget(game: game),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Joypad(onDirectionChanged: onJoypadDirectionChanged),
              ),
            ),
            Positioned(
                top: 0,
                left: 120,
                child: developerManagerWidget()),
            Positioned(
              top: 0,
              child: Padding(
                padding: const EdgeInsets.only(left: 5.0,),
                child: topButtonWidget("/shop_page","assets/images/shop.png",50),
              ),
            ),
            Positioned(
              top: 10,
              right: 5,
              child: Padding(
                padding: const EdgeInsets.only(right: 3.0),
                child: topButtonWidget("/game_setting","assets/images/setting.png",20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
