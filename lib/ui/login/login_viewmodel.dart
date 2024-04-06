import 'package:flutter/foundation.dart';
import 'package:srt_ljh/model/base_response.dart';
import 'package:srt_ljh/network/api_result.dart';
import 'package:srt_ljh/network/srt_repository.dart';

class LoginViewModel with ChangeNotifier {
  
   final SrtRepository repository;

  ApiResult<BaseResponse>? loginResult;

  ApiResult<BaseResponse>? get getLoginResult => loginResult;

  LoginViewModel(this.repository);

  Future<BaseResponse?> requestLogin(String id, String pw) async {
    Map<String,dynamic> params = {};
    params["email"] = id;
    params["pw"] = pw;
    loginResult = await repository.requestLogin(params);
    return loginResult?.data;
  }
}