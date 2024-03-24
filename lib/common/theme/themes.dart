import 'package:flutter/material.dart';
import 'package:srt_ljh/common/colors.dart';

ThemeData lightThemeData() {
  return ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white
  );
}


ThemeData darkThemeData() {
  return ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: clr_22242a
  );
}