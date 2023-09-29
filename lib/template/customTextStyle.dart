import 'package:flutter/material.dart';

const double fontSize = 60;
const double subFontSize = 50;

class CustomTextStyle {
  static TextStyle mainStyle = TextStyle(
      fontFamily: 'YeongdeokSea',
      fontSize: fontSize,
      color: Colors.black,
  );

  static TextStyle buttonStyle = TextStyle(
      fontFamily: 'YeongdeokSea',
      fontSize: subFontSize,
      color: Colors.purple
  );
}