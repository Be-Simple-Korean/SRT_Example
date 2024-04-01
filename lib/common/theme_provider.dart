import 'package:flutter/material.dart';
import 'package:srt_ljh/common/colors.dart';

class ThemeProvider with ChangeNotifier, WidgetsBindingObserver {
  ThemeData lightThemeData = ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: Colors.white,
      dividerColor: clr_eeeeee,
      drawerTheme: const DrawerThemeData(backgroundColor: clr_eff0f5),
      colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: Colors.white,
          onPrimary: Colors.black,
          error: Colors.white,
          onPrimaryContainer: clr_bbbbbb,
          onError: Colors.black,
          primaryContainer: clr_3d4964,
          background: Colors.white,
          onBackground: Colors.black,
          surface: Colors.white,
          onSurface: Colors.black,
          surfaceTint: Colors.white,
          secondary: clr_eeeeee,
          onSecondary: clr_888888,
          secondaryContainer: clr_eff0f5,
          onSecondaryContainer: clr_494f60),
      hintColor: clr_cccccc,
      dialogTheme: const DialogTheme(backgroundColor: Colors.white),
      focusColor: clr_888888);

  ThemeData darkThemeData = ThemeData(
      drawerTheme: const DrawerThemeData(backgroundColor: clr_323741),
      dialogTheme: const DialogTheme(backgroundColor: clr_292f3a),
      dividerColor: clr_494c5a,
      brightness: Brightness.dark,
      hintColor: clr_494c5a,
      focusColor: clr_dedede,
      scaffoldBackgroundColor: clr_22242a,
      colorScheme: const ColorScheme(
          brightness: Brightness.dark,
          primaryContainer: clr_313740,
          onPrimaryContainer: clr_727b90,
          primary: Colors.black,
          onPrimary: Colors.white,
          error: Colors.black,
          onError: Colors.white,
          background: Colors.black,
          onBackground: Colors.white,
          surface: clr_313740,
          onSurface: clr_dedede,
          surfaceTint: clr_1b1d23,
          secondary: clr_434654,
          onSecondary: clr_727b90,
          onSecondaryContainer: clr_dedede,
          secondaryContainer: clr_313740));

  late ThemeMode currentThemeMode;
  ThemeMode get getCurrentThemeMode => currentThemeMode;

  /// 생성자 - 시스템 모드를 가져와 설정
  ThemeProvider() {
    WidgetsBinding.instance.addObserver(this);
    var brightness =
        WidgetsBinding.instance.platformDispatcher.platformBrightness;
    if (brightness == Brightness.light) {
      currentThemeMode = ThemeMode.light;
    } else {
      currentThemeMode = ThemeMode.dark;
    }
  }

  void changeTheme(bool isLight) {
    if (isLight) {
      currentThemeMode = ThemeMode.light;
    } else {
      currentThemeMode = ThemeMode.dark;
    }
    notifyListeners();
  }

  /// 모드 변경 감지
  @override
  void didChangePlatformBrightness() {
    var brightness =
        WidgetsBinding.instance.platformDispatcher.platformBrightness;
    if (brightness == Brightness.light) {
      currentThemeMode = ThemeMode.light;
    } else {
      currentThemeMode = ThemeMode.dark;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
