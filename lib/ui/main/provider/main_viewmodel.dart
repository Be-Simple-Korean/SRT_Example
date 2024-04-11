import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:srt_ljh/common/constants.dart';
import 'package:srt_ljh/common/strings.dart';
import 'package:srt_ljh/model/base_response.dart';
import 'package:srt_ljh/network/api_result.dart';
import 'package:srt_ljh/network/srt_repository.dart';

class MainViewModel with ChangeNotifier {
  final SrtRepository repository;

  ApiResult<BaseResponse>? apiResult;

  ApiResult<BaseResponse>? get getLoginResult => apiResult;

  MainViewModel(this.repository) {
    readJsonFile();
  }

  void readJsonFile() async {
    // 파일 읽기
    final String response = await rootBundle.loadString('assets/stations.json');
    // JSON 변환
    stationList = await json.decode(response);
  }

  Map<String, dynamic> startInfoMap = {
    "stationNm": SELECT_STATION_DEFAULT,
    "stationId": ""
  };
  Map<String, dynamic> finishInfoMap = {
    "stationNm": SELECT_STATION_DEFAULT,
    "stationId": ""
  };

  DateTime _selectedDay = DateTime.now();
  String _selectedPeople = MAIN_DEFAULT_PEOPLE;
  bool _isButtonEnabled = false;
  List<String> recentStation = [];
  List<dynamic> stationList = [];
  Map<String, dynamic> get getStartStationInfo => startInfoMap;
  Map<String, dynamic> get getFinishStationInfo => finishInfoMap;
  String get getStartStationName => startInfoMap["stationNm"];
  String get getFinishStationName => finishInfoMap["stationNm"];
  DateTime get getSelectedDay => _selectedDay;
  String get getSelectedPeople => _selectedPeople;
  bool get isButtonEnabled => _isButtonEnabled;

  void setStartStation(Map<String, dynamic> stationInfo) {
    startInfoMap = stationInfo;
    notifyListeners();
  }

  void setFinishStation(Map<String, dynamic> stationInfo) {
    finishInfoMap = stationInfo;
    notifyButton();
  }

  void setSelectedDay(DateTime selectedDay) {
    _selectedDay = selectedDay;
    notifyButton();
  }

  void setSelectedPeople(String selectedPeople) {
    _selectedPeople = selectedPeople;
    notifyButton();
  }

  void getRecentStationInfo() async {
    var pref = await SharedPreferences.getInstance();
    recentStation = pref.getStringList(PREF_KEY_STATION_INFO) ?? List.empty();
  }

  void notifyButton() {
    if ((startInfoMap["stationId"] as String).isNotEmpty &&
        (finishInfoMap["stationId"] as String).isNotEmpty) {
      _isButtonEnabled = true;
      notifyListeners();
    }
  }

  Future<BaseResponse?> requestSrtInfo() async {
    getRecentStationInfo();
    apiResult = await repository.requestSrtInfo();
    return apiResult?.data;
  }

  Future<BaseResponse?> requestSrtList() async {
    Map<String, dynamic> params = {};
    params["depPlaceId"] = startInfoMap["stationId"];
    params["arrPlaceId"] = finishInfoMap["stationId"];
    params["depPlandDate"] = _selectedDay.year.toString() +
        _selectedDay.month.toString().padLeft(2, '0') +
        _selectedDay.day.toString().padLeft(2, '0');
    params["depPlandTime"] = _selectedDay.hour.toString().padLeft(2, '0') +
        _selectedDay.minute.toString().padLeft(2, '0');

    apiResult = await repository.requestSrtList(params);
    return apiResult?.data;
  }

  Map<String, dynamic> getStationInfoMap(String stationNm) {
    Map<String, dynamic> result = {
      "stationNm": SELECT_STATION_DEFAULT,
      "stationId": ""
    };
    for (var item in stationList) {
      if (item["stationNm"] == stationNm) {
        result = item;
        break;
      }
    }
    return result;
  }
}
