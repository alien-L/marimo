import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class CommonFont {
  static neoDunggeunmoPro({
    required FontWeight fontWeight,
    required double fontSize,
    required Color color,
  }) =>
      TextStyle(
          fontFamily: 'NeoDunggeunmoPro',
          fontWeight: fontWeight,
          fontSize: fontSize,
          color: color
      );
}
