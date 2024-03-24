import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:srt_ljh/common/constants.dart';

class NetworkManager {
  // 싱글톤 인스턴스 생성
  static final NetworkManager _instance = NetworkManager._internal();

  // 팩토리 생성자
  factory NetworkManager() {
    return _instance;
  }

  // 내부 생성자
  NetworkManager._internal();

  // GET 요청을 보내는 메소드
  Future<dynamic> get(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> sendAuthCode(String email) async {
    try {
      final response = await get(BASE_URL + API_SEND_AUTH_CODE + email);
      print("code = ${response["code"]}");
      if (response["code"] == 0) {
        print("msg = ${response["message"]}");
        return response["message"].toString();
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> verifyCode(Map<String, dynamic> code) async {
    String jsonData = jsonEncode(code);
    try {
      final response =
          await http.post(Uri.parse(BASE_URL + API_VERIFY_AUTH_CODE),
              headers: <String, String>{
                'Content-Type': 'application/json',
              },
              body: jsonData);
      if (response.statusCode == 200) {
        // 요청 성공 시 처리
        print('Post created: SUCCESS');
        return jsonDecode(response.body);
      } else {
        // 요청 실패 시 처리
        print('Request failed with status: ${response.statusCode}.');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> signUp(Map<String, dynamic> params) async {
    String jsonData = jsonEncode(params);
    try {
      final response = await http.post(Uri.parse(BASE_URL + API_SIGN_UP),
          headers: <String, String>{
            'Content-Type': 'application/json',
          },
          body: jsonData);
      if (response.statusCode == 200) {
        // 요청 성공 시 처리
        print('Post created: SUCCESS');
        return jsonDecode(response.body);
      } else {
        // 요청 실패 시 처리
        print('Request failed with status: ${response.statusCode}.');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> login(Map<String, dynamic> params) async {
    String jsonData = jsonEncode(params);
    try {
      final response = await http.post(Uri.parse(BASE_URL + API_LOGIN),
          headers: <String, String>{
            'Content-Type': 'application/json',
          },
          body: jsonData);
      if (response.statusCode == 200) {
        // 요청 성공 시 처리
        print('Post created: SUCCESS');
        return jsonDecode(response.body);
      } else {
        // 요청 실패 시 처리
        print('Request failed with status: ${response.statusCode}.');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> requestMain() async {
    try {
      final response = await http.post(
        Uri.parse(BASE_URL + API_SRT_INFO),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode == 200) {
        // 요청 성공 시 처리
        print('Post created: SUCCESS');
        return jsonDecode(utf8.decode(response.bodyBytes));
      } else {
        // 요청 실패 시 처리
        print('Request failed with status: ${response.statusCode}.');
      }
    } catch (e) {
      rethrow;
    }
  }
}
