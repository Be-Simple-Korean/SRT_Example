import 'package:flutter/material.dart';
import 'package:srt_ljh/common/strings.dart';

class SelectStationNotifier extends ChangeNotifier {
  String? _selectedStation;

  String? get selectedStation => _selectedStation;

  void selectStation(String station) {
    _selectedStation = station;
    notifyListeners();
  }
}

/// 현재의 선택역 위치 상태 - 출발 or 도착, 선택역
class SelectPlaceNotifier extends ChangeNotifier {
  PLACE? _place;
  String _startPlace = SELECT_STATION_DEFAULT;
  String _finishPlace = SELECT_STATION_DEFAULT;
  int _selectedIndex = -1;

  PLACE? get place => _place;
  String get startPlace => _startPlace;
  String get finishPlace => _finishPlace;
  int get selectedIndex => _selectedIndex;

  void setPlace(PLACE place) {
    _place = place;
    resetIndex();
  }

  void setStart(String start) {
    _startPlace = start;
    notifyListeners();
  }

  void setFinish(String finish) {
    _finishPlace = finish;
    notifyListeners();
  }

  void resetIndex() {
    _selectedIndex = -1;
    notifyListeners();
  }

  void selectIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  void swapStation() {
    String temp = _startPlace!;
    _startPlace = _finishPlace!;
    _finishPlace = temp;
    notifyListeners();
  }

  bool getCheckCompleteStation() {
    if (_startPlace != SELECT_STATION_DEFAULT && _finishPlace != SELECT_STATION_DEFAULT) {
      return true;
    } else {
      return false;
    }
  }
}

enum PLACE { START, FINISH }
