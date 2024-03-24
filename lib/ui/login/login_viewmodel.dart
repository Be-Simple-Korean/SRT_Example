import 'package:flutter/foundation.dart';
import 'package:srt_ljh/model/login_response.dart';
import 'package:srt_ljh/network/api_result.dart';
import 'package:srt_ljh/network/srt_repository.dart';

class LoginViewModel with ChangeNotifier {
  
   final SrtRepositroy repository;

  ApiResult<LoginResponse>? loginResult;

  ApiResult<LoginResponse>? get getLoginResult => loginResult;

  LoginViewModel(this.repository);

  Future<LoginResponse?> requestLogin(String id, String pw) async {
    Map<String,dynamic> params = {};
    params["email"] = id;
    params["pw"] = pw;
    loginResult = await repository.requestLogin(params);
    return loginResult?.data;
  }
}