import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:srt_ljh/model/base_response.dart';
import 'package:srt_ljh/network/api_result.dart';
import 'package:srt_ljh/network/srt_repository.dart';

class ReserveTrainInfoViewModel extends ChangeNotifier {
  ReserveTrainInfoViewModel(this.repository, this.result) {
    startTime = getFormatTime(result["depplandtime"].toString());
    finishTime = getFormatTime(result["arrplandtime"].toString());
    people = int.parse(result["selectedPeople"]
        .toString()
        .substring(0, result["selectedPeople"].toString().length - 1));
    setParams();
  }
  final SrtRepository repository;
  final Map<String, dynamic> result;
  Map<String, dynamic> params = {};
  late String startTime;
  late String finishTime;
  late int people;

  ApiResult<BaseResponse>? apiResult;

  ApiResult<BaseResponse>? get getLoginResult => apiResult;

  void setParams() {
    params["boardingDate"] = result["selectedDay"].toString().substring(0, 4) +
        result["selectedDay"].toString().substring(5, 7) +
        result["selectedDay"].toString().substring(8, 10);
    params["ticketCnt"] = people;
    params["trainNo"] = result["trainno"];
    params["depPlaceId"] = result["startId"];
    params["depPlaceName"] = result["startStation"];
    params["depPlandTime"] = startTime.split(":")[0] + startTime.split(":")[1];
    params["arrPlaceId"] = result["finishId"];
    params["arrPlaceName"] = result["finishStation"];
    params["arrPlandTime"] =
        finishTime.split(":")[0] + finishTime.split(":")[1];
    params["price"] = (69000 * people);
  }

  Future<BaseResponse?> requestSrtReserve() async {
    apiResult = await repository.requestSrtReserve(params);
    return apiResult?.data;
  }

  String getFormatTime(String time) {
    return "${time.substring(8, 10)}:${time.substring(10, 12)}";
  }

  String getCompareTime() {
    DateFormat format = DateFormat("HH:mm");

    DateTime start = format.parse(startTime);
    DateTime end = format.parse(finishTime);

    Duration duration = end.difference(start);

    String result =
        "${duration.inHours}시간 ${duration.inMinutes.remainder(60)}분 소요";

    return result;
  }

  String getStationInfo() {
    return "${result["startStation"]} → ${result["finishStation"]}";
  }
}
