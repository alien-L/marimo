import 'package:flutter/material.dart';

import '../main.dart';

class GameAlert {
  GameAlert();

  Future<void> showMyDialog({
    required String text,
    required String assetsName,
  }) async {
    return showDialog<void>(
      context: navigatorKey.currentContext!,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          titlePadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          iconPadding: EdgeInsets.zero,
          insetPadding: EdgeInsets.zero,
          actionsPadding: EdgeInsets.zero,
          buttonPadding: EdgeInsets.zero,
       //   title: Text(title),
          //"assets/images/dialog.png"
          content: Stack(
            children: [
              Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset("assets/images/dialog.png"),
                  )),
              Align(
                alignment: Alignment.center,
                child: InkWell(
                  onTap: (){
                    Navigator.of(context).pop();
                  },
                  child: Container(
                      width: 80,
                      height: 80,
                      child: Image.asset(assetsName)),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.only(top: MediaQuery.of(context).size.height/2 -300,),
                  child: Text(text
                      ,style: TextStyle(
                    color: Color.fromRGBO(238, 130, 148,1),
                  ),
                  ),
                ),
              ),
              Positioned(
                bottom: MediaQuery.of(context).size.height/2 -160,
                left: MediaQuery.of(context).size.width/2-35,
                child: Align(
                  alignment: Alignment.center,
                  child: InkWell(
                      onTap: (){
                        Navigator.of(context).pop();
                      },
                      child: Container(
                          width: 70,
                          height: 30,
                          child: Image.asset("assets/images/ok_btn.png",width: 151,height: 57,)),
                ),
                ),
              )
            ],
          ),
          actions: <Widget>[
          ],
        );
      },
    );
  }


  Future<void> showErrorDialog({
    required String text,
   // required String assetsName,
  }) async {
    return showDialog<void>(
      context: navigatorKey.currentContext!,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          titlePadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          iconPadding: EdgeInsets.zero,
          insetPadding: EdgeInsets.zero,
          actionsPadding: EdgeInsets.zero,
          buttonPadding: EdgeInsets.zero,
          //   title: Text(title),
          //"assets/images/dialog.png"
          content: GestureDetector(
            onTap: (){
              Navigator.of(context).pop();
            },
            child: Stack(
              children: [
                Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.asset("assets/images/error_popup.png")),
                    )),
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.only(top: MediaQuery.of(context).size.height/2 -350,),
                    child: Text(text
                      ,style: TextStyle(
                        fontSize: 13,
                      color: Colors.black
                      //  color: Color.fromRGBO(255, 0, 120, 1)
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
          ],
        );
      },
    );
  }
}
