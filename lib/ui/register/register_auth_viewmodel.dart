import 'package:flutter/material.dart';
import 'package:srt_ljh/model/base_response.dart';
import 'package:srt_ljh/network/api_result.dart';
import 'package:srt_ljh/network/srt_repository.dart';

class RegisterAuthViewModel with ChangeNotifier {
  final SrtRepository repository;

  ApiResult<BaseResponse>? sendAuthCodeResult;

  ApiResult<BaseResponse>? get getSendAuthCodeResult => sendAuthCodeResult;

  RegisterAuthViewModel(this.repository);

  Future<BaseResponse?> requestSentAuthCode(String email) async {
    Map<String, dynamic> params = {};
    params["email"] = email;
    sendAuthCodeResult = await repository.requestSendAuthCode(params);
    return sendAuthCodeResult?.data;
  }

  Future<BaseResponse?> requestVerifyAuthCode(String code) async {
    Map<String, dynamic> params = {};
    params["code"] = code;
    sendAuthCodeResult = await repository.requestVerifyAuthCode(params);
    return sendAuthCodeResult?.data;
  }
}
