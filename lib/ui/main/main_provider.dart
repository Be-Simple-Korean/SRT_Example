import 'package:flutter/material.dart';
import 'package:srt_ljh/common/strings.dart';

/// 예매에 필요한 정보 저장
class MainNotifier extends ChangeNotifier {
  String _startPlace = SELECT_STATION_DEFAULT;
  String _finishPlace = SELECT_STATION_DEFAULT;
  DateTime _selecteDay = DateTime.now();
  String _selectedPeople = MAIN_DEFAULT_PEOPLE;
  bool _isButtonEnabled = false;

  String get getStartPlace => _startPlace;
  String get getFinishPlace => _finishPlace;
  DateTime get getSelectedDay => _selecteDay;
  String get getSelectedPeople => _selectedPeople;
  bool get isButtonEnabled => _isButtonEnabled;
  void setStartPlace(String start) {
    _startPlace = start;
  }

  void setFinishPlace(String finish) {
    _finishPlace = finish;
    notifyButton();
  }

  void setSelectedDay(DateTime selectedDay) {
    _selecteDay = selectedDay;
    notifyButton();
  }

  void setSelectedPeople(String selectedPeople) {
    _selectedPeople = selectedPeople;
    notifyButton();
  }

  void notifyButton() {
    if (_startPlace != SELECT_STATION_DEFAULT &&
        _finishPlace != SELECT_STATION_DEFAULT) {
      _isButtonEnabled = true;
      notifyListeners();
    }
  }
}
