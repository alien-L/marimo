import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:marimo_game/app_manage/local_data_manager.dart';
import 'package:marimo_game/marimo_game_world.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../app_manage/language.dart';
import '../../const/constant.dart';
import '../../main.dart';
import '../../page/shop_page.dart';
import '../button/common_button.dart';

class GameAlert {
  GameAlert();

  // Future<void> showMyDialog({
  //   required String text,
  //   required String assetsName,
  //   required String dialogNumber,
  // }) async {
  //   return showDialog<void>(
  //     context: navigatorKey.currentContext!,
  //     barrierDismissible: false, // user must tap button!
  //     builder: (BuildContext context) {
  //       return GestureDetector(
  //         onTap: () {
  //           Navigator.of(context).pop();
  //         },
  //         child: AlertDialog(
  //           backgroundColor: Colors.transparent,
  //           titlePadding: EdgeInsets.zero,
  //           contentPadding: EdgeInsets.zero,
  //           iconPadding: EdgeInsets.zero,
  //           insetPadding: EdgeInsets.zero,
  //           actionsPadding: EdgeInsets.zero,
  //           buttonPadding: EdgeInsets.zero,
  //           content: Stack(
  //             children: [
  //               Align(
  //                   alignment: Alignment.center,
  //                   child: Padding(
  //                     padding: const EdgeInsets.all(8.0),
  //                     child: Image.asset(
  //                         "${CommonConstant.assetsImageDialog}dialog_$dialogNumber.png"),
  //                   )),
  //               Align(
  //                 alignment: Alignment.center,
  //                 child: SizedBox(
  //                     width: 80,
  //                     height: 80,
  //                     child: assetsName != "" ? Image.asset(assetsName) : null),
  //               ),
  //               Align(
  //                 alignment: Alignment.center,
  //                 child: Padding(
  //                   padding: EdgeInsets.only(
  //                     top: MediaQuery.of(context).size.height / 2 - 300,
  //                   ),
  //                   child: Text(
  //                     text,
  //                     style: const TextStyle(color: Colors.black),
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  Widget dropDownButton() => DropdownButtonFormField<Language>(
        decoration: const InputDecoration(
          labelText: 'Language',
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelStyle: TextStyle(fontSize: 15, color: Color(0xffcfcfcf)),
        ),
        onChanged: (Language? newValue) {
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
              :
          Container(
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
            shadowColor: Colors.transparent,
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
                       //     game.paused = false;
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
                    "${CommonConstant.assetsImageMain}setting.png",
                    height: 60,
                  ),
                ),
                buttonWidget(
                  title: '사운드 재생',
                  imageName: "music",
                  onTap: () {
                    print("${game.soundBloc.state}");
                    bool isSwitched = !game.soundBloc.state;
                    String soundImageName = game.soundBloc.state?"music":"stop";

                    if (isSwitched) {
                      game.soundBloc.offBgmSound();
                    } else {
                      game.soundBloc.onBgmSound();
                    }
                    //
                     //game.soundBloc.onOffSound(!game.soundBloc.state);
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
                      }
                    }),
                buttonWidget(
                    title: '앱 정보',
                    imageName: 'info',
                    onTap: () {
                      showInfoDialog(
                        title: '게임 정보',
                        contents: '게임 정보입니당',
                        color: Color.fromRGBO(200, 139, 251, 1),
                      );
                    }),
                buttonWidget(
                    title: '초기화',
                    imageName: 'yes',
                    onTap: () {
                      showMiniDialog('초기화', '게임을 초기화 하겠습니까??\n앱이 자동으로 꺼집니다.',
                          () {
                        LocalDataManager().resetMyGameData();
                        Navigator.pop(context);
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

  Future<void> showInfoDialog(
      {String title = '',
      String contents = '',
      String? assetsName = "",
      required Color color}) {
    return showDialog<void>(
        context: navigatorKey.currentContext!,
        barrierDismissible: true, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            // Color.fromRGBO(200, 139, 251, 1),
            backgroundColor: color,
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
                assetsName == ""
                    ? const SizedBox()
                    : Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                            width: 80,
                            height: 80,
                            child: Image.asset(assetsName ?? "")),
                      ),
                SizedBox(
                  height: 5,
                ),
                Align(alignment: Alignment.center, child: Text(contents)),
                SizedBox(
                  height: 5,
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
      barrierColor: Colors.transparent,
      context: navigatorKey.currentContext!,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        final sc = StreamController<String>.broadcast();

        getShopCategory(String categoryName) {
          sc.add(categoryName);
        }

    Widget  btn ()=>  ElevatedButton(
          style:  ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith(
                    (states) {
                  // If the button is pressed, return green, otherwise blue
                  if (states.contains(
                      MaterialState.pressed)) {
                    return  const Color.fromRGBO(
                        17, 220, 252, 1);
                  }
                  return const Color.fromRGBO(
                      17, 220, 252, 1);
                }),
          ),
          onPressed:  () => getShopCategory("marimo"), child: Text("마리모 용품"),);

        return AlertDialog(
          shadowColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          titlePadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          iconPadding: EdgeInsets.zero,
          insetPadding: EdgeInsets.zero,
          actionsPadding: EdgeInsets.zero,
          buttonPadding: EdgeInsets.zero,
          content: StreamBuilder<String>(
              stream: sc.stream,
              initialData: "marimo",
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.hasError) {
                  return Container();
                } else {
                  return Container(
                      width: 350,
                      height: 500,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
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
                          //   top: 80,
                          //   child: Image.asset(
                          //     "${CommonConstant.assetsImageShop}shop_bg.png",
                          //     width: 350,
                          //   ),
                          // ),
                          Positioned(
                            top: 30,
                            child: Row(
                              children: [
                               SizedBox(
                                   width: 110,
                                   height: 50,
                                    child:
                                    CommonButton(
                                      imageName: 'pupple',
                                      haveMessage: true,
                                      buttonName: "마리모 용품",
                                      onTap: () => getShopCategory("marimo"),
                                      textStyle: TextStyle(fontSize: 14),
                                    )),
                                SizedBox(
                                    width: 110,
                                    height: 50,
                                    child: CommonButton(
                                      imageName: 'pupple',
                                      haveMessage: true,
                                      buttonName: "수질 관리",
                                      onTap: () =>
                                          getShopCategory("environment"),
                                      textStyle: TextStyle(fontSize: 14),
                                    )),
                                SizedBox(
                                    width: 110,
                                    height: 50,
                                    child: CommonButton(
                                      imageName: 'pupple',
                                      haveMessage: true,
                                      buttonName: "어항 꾸미기",
                                      onTap: () => getShopCategory("deco"),
                                      textStyle: TextStyle(fontSize: 14),
                                    )),
                              ],
                            ),
                          ),
                          Positioned(
                            top: 80,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                               //   color: Colors.black,
                                   width: 110,
                                    height: 50,
                                    child: CommonButton(
                                      imageName: 'pupple',
                                      haveMessage: true,
                                      buttonName: "코인 구매",
                                      onTap: () => getShopCategory("coin"),
                                      textStyle: TextStyle(fontSize: 14),
                                    )),
                                Container(
                                 //   color: Colors.red,
                                    width: 110,
                                    height: 50,
                                    child: CommonButton(
                                      imageName: 'pupple',
                                      haveMessage: true,
                                      buttonName: "잡화점",
                                      onTap: () => getShopCategory("grocery"),
                                      textStyle: TextStyle(fontSize: 14),
                                    )),
                                Container(
                               //     color: Colors.blue,
                                    width: 110,
                                    height: 50,
                                    // child: CommonButton(
                                    //   imageName: 'pupple',
                                    //   haveMessage: true,
                                    //   buttonName: "광고",
                                    //   onTap: () => getShopCategory("grocery"),
                                    //   textStyle: TextStyle(fontSize: 14),
                                    // )
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            top: 130,
                            child: SizedBox(
                              width: 345,
                              height: 280,
                              child: ShopPage(
                                game: game,
                                categoryName: snapshot.requireData,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 410,
                            child: SizedBox(
                              width: 350,
                              height: 80,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Positioned(
                                      top: 0,
                                      child: Image.asset(
                                        "${CommonConstant.assetsImageShop}add_coin.png",
                                        height: 90,
                                      )),
                                  Positioned(
                                    top: 30,
                                    right: 52,
                                    child: CommonButton(
                                      imageName: 'go',
                                      height: 30,
                                      onTap: () {
                                        //  Navigator.of(context).pop();
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ));
                }
              }),
        );
      },
    );
  }
}
