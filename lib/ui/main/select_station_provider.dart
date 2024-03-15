import 'package:flutter/material.dart';

class SelectStationNotifier extends ChangeNotifier {
  String? _selectedStation;

  String? get selectedStation => _selectedStation;

  void selectStation(String station) {
    _selectedStation = station;
    notifyListeners();
  }
}

/// 현재의 선택역 위치 상태 - 출발 or 도착
class SelectPlaceNotifier extends ChangeNotifier {
  PLACE? _place;
  String? _startPlace;
  String? _finishPlace;

  PLACE? get place => _place;
  String? get startPlace => _startPlace;
  String? get finishPlace => _finishPlace;

  void setPlace(PLACE place) {
    _place = place;
  }

  void setStart(String start) {
    _startPlace = start;
  }

  void setFinish(String finish) {
    _finishPlace = finish;
  }
}

enum PLACE { START, FINISH }
