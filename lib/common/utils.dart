import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 패스워드 텍스트필드 포맷터
class PasswordInputFormatter extends TextInputFormatter {
  String _realText = '';

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      _realText = "";
    } else {
      String lastStr = newValue.text.characters
          .characterAt(newValue.text.length - 1)
          .toString();
      if (lastStr != "●") {
        _realText += lastStr;
      } else {
        _realText.substring(0, _realText.length - 1);
      }
    }
    return TextEditingValue(
      text: String.fromCharCodes(
          List.filled(newValue.text.length, 0x25CF)), // '●' 문자로 대체
      selection: newValue.selection,
    );
  }

  /// 실제 텍스트 값을 반환하는 메서드
  String getRealText() {
    return _realText;
  }

  void clearRealText() {
    _realText = "";
  }
}

/// 루트 경로 반환
String getRoutePath(List<String> paths) {
  String result = "";
  for (String path in paths) {
    result += ("/$path");
  }
  return result;
}

/// 기차 조건 선택 날짜 반환
String getDataForTrain(DateTime dateTime) {
  List<String> weekdays = ['월', '화', '수', '목', '금', '토', '일'];
  return '${dateTime.year}.${dateTime.month.toString().padLeft(2, '0')}.${dateTime.day.toString().padLeft(2, '0')}(${weekdays[dateTime.weekday - 1]}) ${dateTime.hour.toString().padLeft(2, '0')}시 이후';
}
