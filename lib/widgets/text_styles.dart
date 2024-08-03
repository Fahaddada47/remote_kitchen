
import 'package:flutter/material.dart';

const String defaultFontFamily = 'Roboto';

TextStyle getTextStyle({
  Color? color,
  double? fontSize,
  FontWeight? fontWeight,
  String? fontFamily,
}) {
  return TextStyle(
    color: color ?? const Color(0xFF1B1B1B),
    fontSize: fontSize ?? 14,
    fontFamily: fontFamily ?? defaultFontFamily,
    fontWeight: fontWeight ?? FontWeight.w300,
  );
}