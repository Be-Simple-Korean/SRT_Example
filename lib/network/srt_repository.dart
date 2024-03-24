import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:logger/web.dart';
import 'package:srt_ljh/common/constants.dart';
import 'package:srt_ljh/model/login_response.dart';
import 'package:srt_ljh/network/api_result.dart';

class SrtRepositroy {
  final dio = Dio();
  final logger = Logger();
  SrtRepositroy() {
    dio.options.baseUrl = BASE_URL;
    dio.options.headers = {
      'Content-Type': 'application/json',
    };
    dio.interceptors.add(LogInterceptor(
      request: true, // 요청 정보 로깅 여부
      requestHeader: true, // 요청 헤더 로깅 여부
      requestBody: true, // 요청 바디 로깅 여부
      responseHeader: true, // 응답 헤더 로깅 여부
      responseBody: true, // 응답 바디 로깅 여부
      error: true, // 에러 로깅 여부
      logPrint: (log) {
        logger.d(log); // 로그를 출력하는 함수 정의
      },
    ));
  }

  /// 로그인 api 통신
  Future<ApiResult<LoginResponse>> requestLogin(
      Map<String, dynamic> params) async {
    String jsonData = jsonEncode(params);
    try {
      final response = await dio.post(API_LOGIN, data: jsonData);
      if (response.statusCode == 200) {
        return ApiResult.success(LoginResponse(
            code: response.data['code'],
            message: response.data['message'],
            data: response.data['data']));
      } else {
        return ApiResult.error('Error: ${response.statusCode}');
      }
    } catch (e) {
      return ApiResult.error(e.toString());
    }
  }
}
