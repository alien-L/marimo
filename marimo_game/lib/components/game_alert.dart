import 'package:flutter/material.dart';

import '../main.dart';

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
          onTap: (){
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
                      child: Image.asset("assets/images/dialog_$dialogNumber.png"),
                    )),
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                      width: 80,
                      height: 80,
                      child: assetsName != "" ?Image.asset(assetsName):null),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.only(top: MediaQuery.of(context).size.height/2 -300,),
                    child: Text(text
                        ,style: const TextStyle(
                      color: Colors.black
                    ),
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

}
