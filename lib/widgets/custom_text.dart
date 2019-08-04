import 'package:flutter/material.dart';

/// a custom widget for the text
class CustomText extends Text {

  CustomText(
      String data,
      {color: Colors.white,
      fontSize: 17.0,
      fontStyle: FontStyle.normal,
      textAlign: TextAlign.center})
      : super(
      data,
      textAlign: textAlign,
      style: TextStyle(
        color: color,
        fontStyle: fontStyle,
        fontSize: fontSize
      ));
}