import 'package:flutter/material.dart';
import 'package:srt_ljh/common/colors.dart';

class ThemeProvider with ChangeNotifier, WidgetsBindingObserver {
  ThemeData lightThemeData = ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: Colors.white,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: Colors.white,
        onPrimary: Colors.black,
        error: Colors.white,
        onError: Colors.black,
        background: Colors.white,
        onBackground: Colors.black,
        surface: Colors.white,
        onSurface: Colors.black,
        secondary: clr_eeeeee,
        onSecondary: clr_888888,
      ));

  ThemeData darkThemeData = ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: clr_22242a,
      colorScheme: const ColorScheme(
        brightness: Brightness.dark,
        primary: Colors.black,
        onPrimary: Colors.white,
        error: Colors.black,
        onError: Colors.white,
        background: Colors.black,
        onBackground: Colors.white,
        surface: clr_313740,
        onSurface: clr_dedede,
        secondary: clr_434654,
        onSecondary: clr_727b90,
      ));

  late ThemeMode currentTheme;
  ThemeMode get currentThemeMode => currentTheme;
  ThemeProvider() {
    WidgetsBinding.instance.addObserver(this);
    var brightness =
        WidgetsBinding.instance.platformDispatcher.platformBrightness;
    if (brightness == Brightness.light) {
      currentTheme = ThemeMode.light;
    } else {
      currentTheme = ThemeMode.dark;
    }
  }

  void changeTheme(bool isLight) {
    if (isLight) {
      currentTheme = ThemeMode.light;
    } else {
      currentTheme = ThemeMode.dark;
    }
    notifyListeners();
  }

  @override
  void didChangePlatformBrightness() {
    var brightness =
        WidgetsBinding.instance.platformDispatcher.platformBrightness;
    if (brightness == Brightness.light) {
      currentTheme = ThemeMode.light;
    } else {
      currentTheme = ThemeMode.dark;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
