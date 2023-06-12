import 'dart:io';

import 'package:flutter/material.dart';
import 'package:marimo_game/app_manage/restart_widget.dart';
import 'package:marimo_game/marimo_game_world.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app_manage/environment/environment.dart';
import '../../app_manage/language.dart';
import '../../app_manage/local_repository.dart';
import '../../main.dart';
import '../../page/shop_page.dart';
import '../../style/color.dart';
import '../button/common_button.dart';

class GameAlert {
  GameAlert();

  Future<void> showMyDialog({
    required String text,
    required String assetsName,
    required String dialogNumber,
  }) async {
    return showDialog<void>(
      context: navigatorKey.currentContext!,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: AlertDialog(
            backgroundColor: Colors.transparent,
            titlePadding: EdgeInsets.zero,
            contentPadding: EdgeInsets.zero,
            iconPadding: EdgeInsets.zero,
            insetPadding: EdgeInsets.zero,
            actionsPadding: EdgeInsets.zero,
            buttonPadding: EdgeInsets.zero,
            content: Stack(
              children: [
                Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child:
                          Image.asset("assets/images/dialog_$dialogNumber.png"),
                    )),
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                      width: 80,
                      height: 80,
                      child: assetsName != "" ? Image.asset(assetsName) : null),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 2 - 300,
                    ),
                    child: Text(
                      text,
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget dropDownButton() => DropdownButtonFormField<Language>(
        decoration: const InputDecoration(
          labelText: 'Language',
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelStyle: TextStyle(fontSize: 15, color: Color(0xffcfcfcf)),
        ),
        onChanged: (Language? newValue) {
          //RestartWidget.restartApp(navigatorKey.currentContext!, newValue!);
          print(newValue);
        },
        items: [Language.en, Language.jp, Language.ko]
            .map<DropdownMenuItem<Language>>((Language i) {
          return DropdownMenuItem<Language>(
            value: i,
            child: Text(
                '${{'en': 'english', 'jp': 'japan', 'ko': "korea"}[i.name]}'),
          );
        }).toList(),
      );

  Widget buttonWidget({
    required String title,
    required String imageName,
    required GestureTapCallback onTap,
    bool isSoundButton = false,
  }) =>
      Row(
        // mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 150,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    "assets/images/buttons/$imageName.png",
                    height: 40,
                  ),
                  Text(
                    title,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          isSoundButton
              ? Container(
                  width: 100,
                  child: CommonButton(
                    imageName: imageName,
                    height: 40,
                    onTap: onTap,
                  ).buttonWidget1(),
                )
              : Container(
                  width: 100,
                  child: CommonButton(
                    imageName: imageName,
                    height: 40,
                    onTap: onTap,
                  ),
                ),
        ],
      );

  Future<void> showSettingsDialog(MarimoWorldGame game) async {
    return showDialog<void>(
      context: navigatorKey.currentContext!,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: () {
            //  Navigator.of(context).pop();
          },
          child: AlertDialog(
            backgroundColor: Colors.transparent,
            titlePadding: EdgeInsets.zero,
            contentPadding: EdgeInsets.zero,
            iconPadding: EdgeInsets.zero,
            insetPadding: EdgeInsets.zero,
            actionsPadding: EdgeInsets.zero,
            buttonPadding: EdgeInsets.zero,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(child: Container(width: 100, height: 20)),
                    //   Container(width: 100,height: 30, color: Colors.amber),
                    Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: Container(
                        alignment: Alignment.topLeft,
                        child: CommonButton(
                          imageName: 'x',
                          height: 20,
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Image.asset(
                    "assets/images/marimo_joypad.png",
                    height: 60,
                  ),
                ),
                buttonWidget(
                  title: '사운드 재생',
                  imageName: "music",
                  onTap: () {
                    bool isSwitched = game.soundBloc.state;
                    //  String soundImageName = game.soundBloc.state?"music":"stop";

                    if (isSwitched) {
                      game.soundBloc.onBgmSound();
                      print("여기");
                    } else {
                      print("여기 1");
                      game.soundBloc.offBgmSound();
                    }

                    ///    game.soundBloc.onOffSound(!game.soundBloc.state);
                    // showInfoDialog('사운드 재생', '게임 정보입니당');
                  },
                  isSoundButton: true,
                ), // 소리 체크해서 위젯 편집 하기
                buttonWidget(
                    title: '인스타그램',
                    imageName: 'go',
                    onTap: () async {
                      // 인스타그램이 설치되어 있지 않을 때 웹 링크
                      const INSTAGRAM_WEB_LINK =
                          'https://www.instagram.com/my_marimo_world/';
                      const INSTAGRAM_LINK =
                          'instagram://user?username=my_marimo_world';
                      if (await canLaunchUrl(Uri.parse(INSTAGRAM_LINK))) {
                        await launchUrl(Uri.parse(INSTAGRAM_LINK));
                      } else {
                        await launchUrl(Uri.parse(INSTAGRAM_WEB_LINK));
                        print("여기");
                      }
                    }),
                buttonWidget(
                    title: '앱 정보',
                    imageName: 'info',
                    onTap: () {
                      showInfoDialog('게임 정보', '게임 정보입니당');
                    }),
                buttonWidget(
                    title: '초기화',
                    imageName: 'yes',
                    onTap: () {
                      showMiniDialog('초기화', '게임을 초기화 하겠습니까??\n앱이 자동으로 꺼집니다.',
                          () {
                        LocalRepository().getSecureStorage().deleteAll();
                        Navigator.pop(context);
                        //RestartWidget.restartApp(navigatorKey.currentContext!, Language.ko);
                        exit(0);
                      });
                    }),
                buttonWidget(
                    title: '앱 리뷰쓰기',
                    imageName: 'ok',
                    onTap: () async {
                      // 구글 플레이 스토어 링크
                      const GOOGLE_PLAY_STORE_LINK =
                          'market://details?id=io.github.Antodo';
                      // 구글 플레이 스토어가 설치되어 있지 않을 때 웹 링크
                      const GOOGLE_PLAY_STORE_WEB_LINK =
                          'https://play.google.com/store/apps/details?id=io.github.Antodo';
                      // 애플 앱 스토어 링크
                      const APPLE_APP_STORE_LINK =
                          'itms-apps://itunes.apple.com/us/app/id1553604322?mt=8';
                      // 애플 앱 스토어가 설치되어 있지 않을 때 웹 링크
                      const APPLE_APP_STORE_WEB_LINK =
                          'https://apps.apple.com/us/app/antodo-%EC%8B%AC%ED%94%8C%ED%95%9C-%EC%86%90%EA%B8%80%EC%94%A8-%ED%95%A0%EC%9D%BC-%EA%B3%84%ED%9A%8D-%EB%A9%94%EB%AA%A8/id1553604322';
                      if (Platform.isIOS) {
                        if (await canLaunchUrl(
                            Uri.parse(APPLE_APP_STORE_LINK))) {
                          await launchUrl(Uri.parse(APPLE_APP_STORE_LINK));
                        } else {
                          await launchUrl(Uri.parse(APPLE_APP_STORE_WEB_LINK));
                        }
                      } else {
                        if (await canLaunchUrl(
                            Uri.parse(GOOGLE_PLAY_STORE_LINK))) {
                          await launchUrl(Uri.parse(GOOGLE_PLAY_STORE_LINK));
                        } else {
                          await launchUrl(
                              Uri.parse(GOOGLE_PLAY_STORE_WEB_LINK));
                        }
                      }
                    }),
                buttonWidget(
                    title: '게임종료',
                    imageName: 'exit',
                    onTap: () {
                      showMiniDialog('게임종료', '게임을 종료하겠습니까?', () {
                        exit(0);
                      });
                      //   exit(0);
                    }),
              ],
            ), // T
          ),
        );
      },
    );
  }

  Future<void> showMiniDialog(
      String title, String contents, GestureTapCallback onTap) {
    return showDialog<void>(
        context: navigatorKey.currentContext!,
        barrierDismissible: true, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Color.fromRGBO(21, 253, 15, 1),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            //Dialog Main Title
            title: Column(
              children: <Widget>[
                Text(title),
              ],
            ),
            //
            content: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Align(alignment: Alignment.center, child: Text(contents)),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: CommonButton(
                        imageName: 'yes',
                        height: 30,
                        onTap: onTap,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: CommonButton(
                        imageName: 'no',
                        height: 30,
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }

  Future<void> showInfoDialog(String title, String contents) {
    return showDialog<void>(
        context: navigatorKey.currentContext!,
        barrierDismissible: true, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Color.fromRGBO(200, 139, 251, 1),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            //Dialog Main Title
            title: Column(
              children: <Widget>[
                Text(title),
              ],
            ),
            //
            content: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Align(alignment: Alignment.center, child: Text(contents)),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: CommonButton(
                    imageName: 'ok',
                    height: 30,
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
          );
        });
  }

  Future<void> showShopDialog(MarimoWorldGame game) async {
    return showDialog<void>(
      context: navigatorKey.currentContext!,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: () {
            // Navigator.of(context).pop();
          },
          child: AlertDialog(
            backgroundColor: CommonColor.green,
            //Color.fromRGBO(200, 139, 251, 1),
            //Colors.transparent,
            titlePadding: EdgeInsets.zero,
            contentPadding: EdgeInsets.zero,
            iconPadding: EdgeInsets.zero,
            insetPadding: EdgeInsets.zero,
            actionsPadding: EdgeInsets.zero,
            buttonPadding: EdgeInsets.zero,
            content: Container(
                //   color: Colors.white,
                //Color.fromRGBO(21, 253, 15, 1),
                width: 350,
                height: 500,
                child: Stack(
                  children: [
                    Positioned(
                      top: 5,
                      right: 0,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 5.0),
                        child: Container(
                          alignment: Alignment.topLeft,
                          child: CommonButton(
                            imageName: 'x',
                            height: 20,
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                      ),
                    ),
                    // Positioned(
                    //   top: 0,
                    //   child: Container(
                    //     //   width: 600,
                    //       child: Image.asset(
                    //         "assets/images/deco/shop_popup.png",
                    //         //    width: 500,
                    //         height: 500,
                    //       )),
                    // ),
                    //  Positioned(
                    //    top: 10,
                    // //   right: 0,
                    //    child:
                    //    Container(
                    //      alignment: Alignment.topCenter,
                    //      //   width: 600,
                    //        child: Text("SHOP",style: TextStyle(fontSize: 20),))
                    //        // Image.asset(
                    //        //   "assets/images/buttons/yes.png",
                    //        //   width: 60,
                    //        // )),
                    //  ),
                    Positioned(
                      top: 80,
                      //  left: 36,
                      child: Container(
                          //   width: 600,
                          child: Image.asset(
                        "assets/images/deco/shop_bg.png",
                        width: 350,
                      )),
                    ),
                    Positioned(
                      top: 130,
                      left: 80,
                      child: SizedBox(
                          width: 80,
                          child: CommonButton(
                            imageName: 'shop_red',
                            haveMessage: true,
                          )),
                    ),
                    Positioned(
                      top: 130,
                      right: 70,
                      child: SizedBox(
                          width: 70,
                          child: CommonButton(
                            imageName: 'shop_green',
                            haveMessage: true,
                          )),
                    ),
                    Positioned(
                      top: 50,
                      left: 100,
                      child: SizedBox(
                          width: 55,
                          child: CommonButton(
                            imageName: 'shop_sky_s',
                            haveMessage: true,
                          )),
                    ),
                    Positioned(
                      top: 45,
                      right: 45,
                      child: SizedBox(
                          width: 70,
                          child: CommonButton(
                            imageName: 'shop_sky',
                            haveMessage: true,
                          )),
                    ),
                    Positioned(
                      top: 55,
                      left: 55,
                      child: SizedBox(
                          width: 40,
                          child: CommonButton(
                            imageName: 'shop_orange',
                            haveMessage: true,
                          )),
                    ),
                    Positioned(
                      top: 250,
                      child: SizedBox(
                        width: 350,
                        height: 200,
                        child: ShopPage(
                          game: game,
                        ),
                      ),
                    ),
                    // Positioned(
                    //   bottom: 15,
                    //   left: 120,
                    //   child: Stack(
                    //       alignment: Alignment.center,
                    //       children: [
                    //         Align(
                    //           alignment: Alignment.center,
                    //           child: SizedBox(
                    //               width: 100,
                    //               child: CommonButton(
                    //                 imageName: 'assets/images/buttons/sky',
                    //                 onTap: (){
                    //                   Navigator.of(context).pop();
                    //                 },
                    //               )),
                    //         ),
                    //         Align(
                    //             alignment: Alignment.center,
                    //             child: Text("닫기",style: TextStyle(fontSize: 25),)),
                    //       ]
                    //   ),
                    // ),
                    //  child,
                  ],
                )),
          ),
        );
      },
    );
  }
}
