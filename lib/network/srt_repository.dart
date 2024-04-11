import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:srt_ljh/common/constants.dart';
import 'package:srt_ljh/common/my_logger.dart';
import 'package:srt_ljh/model/base_response.dart';
import 'package:srt_ljh/network/api_result.dart';

class SrtRepository {
  final dio = Dio();
  static final SrtRepository _instance = SrtRepository._internal();

  factory SrtRepository() {
    return _instance;
  }

  SrtRepository._internal() {
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
        MyLogger().d(log.toString()); // 로그를 출력하는 함수 정의
      },
    ));
  }

  /// 로그인 api 통신
  Future<ApiResult<BaseResponse>> requestLogin(
      Map<String, dynamic> params) async {
    String jsonData = jsonEncode(params);
    try {
      final response = await dio.post(API_LOGIN, data: jsonData);
      if (response.statusCode == 200) {
        return ApiResult.success(BaseResponse(
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

  /// 인증 코드 보내기 api 통신
  Future<ApiResult<BaseResponse>> requestSendAuthCode(
      Map<String, dynamic> params) async {
    try {
      final response =
          await dio.get(API_SEND_AUTH_CODE, queryParameters: params);
      if (response.statusCode == 200) {
        return ApiResult.success(BaseResponse(
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

  /// 인증 코드 보내기 api 통신
  Future<ApiResult<BaseResponse>> requestVerifyAuthCode(
      Map<String, dynamic> params) async {
    String jsonData = jsonEncode(params);
    try {
      final response = await dio.post(API_VERIFY_AUTH_CODE, data: jsonData);
      if (response.statusCode == 200) {
        return ApiResult.success(BaseResponse(
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

  /// 회원가입 api 통신
  Future<ApiResult<BaseResponse>> requestSignUp( Map<String, dynamic> params) async {
  String jsonData = jsonEncode(params);
    try {
      final response = await dio.post(API_SIGN_UP, data: jsonData);
      if (response.statusCode == 200) {
        return ApiResult.success(BaseResponse(
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

    /// srt info api 통신
  Future<ApiResult<BaseResponse>> requestSrtInfo() async {
    try {
      final response = await dio.post(API_SRT_INFO);
      if (response.statusCode == 200) {
        return ApiResult.success(BaseResponse(
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

  /// srt list api 통신
  Future<ApiResult<BaseResponse>> requestSrtList(Map<String, dynamic> params) async {
      String jsonData = jsonEncode(params);
    try {
      final response = await dio.post(API_SRT_LIST,data: jsonData);
      if (response.statusCode == 200) {
        return ApiResult.success(BaseResponse(
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

  /// srt 예매하기 
  Future<ApiResult<BaseResponse>> requestSrtReserve(Map<String, dynamic> params) async {
      String jsonData = jsonEncode(params);
    try {
      final response = await dio.post(API_SRT_RESERVE,data: jsonData);
      if (response.statusCode == 200) {
        return ApiResult.success(BaseResponse(
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
