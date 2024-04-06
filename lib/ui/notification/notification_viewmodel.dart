import 'package:flutter/material.dart';
import 'package:srt_ljh/model/base_response.dart';
import 'package:srt_ljh/network/api_result.dart';
import 'package:srt_ljh/network/srt_repository.dart';

class SearchTrainViewModel extends ChangeNotifier {
  SearchTrainViewModel(this.repository);

  final SrtRepository repository;
  ApiResult<BaseResponse>? apiResult;
  ApiResult<BaseResponse>? get getApiResult => apiResult;

  Future<BaseResponse?> requestSrtInfo() async {
    Map<String, dynamic> params = {};
    params["depPlaceId"] = "오송";
    params["arrPlaceId"] = "공주";
    params["depPlandDate"] = "20240505";
    params["depPlandTime"] = "2000";

    apiResult = await repository.requestSrtList(params);
    return apiResult?.data;
  }
}
