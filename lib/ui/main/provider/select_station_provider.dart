import 'package:flutter/material.dart';
import 'package:srt_ljh/common/strings.dart';

class SelectPlaceNotifier extends ChangeNotifier {
  Map<String, dynamic> startInfoMap = {};
  Map<String, dynamic> finishInfoMap = {};
  List<dynamic> stationList = [];

  int _selectedIndex = -1;

  int get selectedIndex => _selectedIndex;

  SelectPlaceNotifier(
      Map<String, dynamic> startInfoMap,
      Map<String, dynamic> finishInfoMap,
      this.stationList) {
    this.startInfoMap = initStation(startInfoMap);
    this.finishInfoMap = initStation(finishInfoMap);
  }

  Map<String, dynamic> initStation(Map<String, dynamic>? stationInfo) {
    if (stationInfo != null) {
      return stationInfo;
    } else {
      return {"stationNm": SELECT_STATION_DEFAULT, "stationId": ""};
    }
  }

  void setStartStation(Map<String, dynamic> stationInfo) {
    startInfoMap = stationInfo;
  }

  void setFinishStation(Map<String, dynamic> stationInfo) {
    finishInfoMap = stationInfo;
  }

  Map<String, dynamic> get getStartStationInfo => startInfoMap;
  Map<String, dynamic> get getFinishStationInfo => finishInfoMap;
  String get getStartStationName => startInfoMap["stationNm"];
  String get getFinishStationName => finishInfoMap["stationNm"];

  void resetIndex() {
    _selectedIndex = -1;
    notifyListeners();
  }

  void selectIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  void swapStation() {
    Map<String, dynamic> temp = startInfoMap;
    startInfoMap = finishInfoMap;
    finishInfoMap = temp;
    notifyListeners();
  }

  bool getCheckCompleteStation() {
    if ((startInfoMap["stationId"] as String).isNotEmpty &&
        (finishInfoMap["stationId"] as String).isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }
}
