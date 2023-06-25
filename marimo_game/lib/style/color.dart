import 'dart:ui';

import 'package:flutter/material.dart';

class CommonColor {
  static const green = Color.fromRGBO(0, 200, 0, 1);
  static const sky = Color.fromRGBO(17, 220, 252, 1);
  static const red = Color.fromRGBO(253, 104, 90, 1);
  static const violet = Color.fromRGBO(200, 139, 251, 1);
  static const orange = Color.fromRGBO(242, 157, 85, 1);
  static const yellow = Color.fromRGBO(236, 205, 11, 1);
  static const brightGreen = Color.fromRGBO(21, 253, 15, 1);

  static materialStatePropertyColor(
          {required Color pressedColor}) =>
      MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.pressed)) {
          return pressedColor;
        }
        return pressedColor;
      });
}
