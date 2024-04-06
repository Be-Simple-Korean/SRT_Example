import 'package:flutter/material.dart';
import 'package:srt_ljh/common/colors.dart';
import 'package:srt_ljh/model/base_response.dart';
import 'package:srt_ljh/network/api_result.dart';
import 'package:srt_ljh/network/srt_repository.dart';

class RegisterInputViewModel with ChangeNotifier {
  final SrtRepository repository;

  ApiResult<BaseResponse>? signUpResult;

  ApiResult<BaseResponse>? get getSingUpResult => signUpResult;

  RegisterInputViewModel(this.repository);

  String pwd1 = "";
  String pwd2 = "";
  String name = "";
  String birth = "";
  String email = "";
  Color pwd1UnderColor = clr_eeeeee;
  bool isShowPwd1Fail = false;
  bool isSamePassword = true; // 비밀번호 체크
  bool isCheckedPassword = false;
  bool isButtonEnabled = false; // 버튼 활성화

  /// 가입 요청
  Future<BaseResponse?> requestSignUp() async {
    Map<String, dynamic> params = {};
    params["email"] = email;
    params["pw"] = pwd2;
    params["birth"] = birth;
    params["name"] = name;
    signUpResult = await repository.requestSignUp(params);
    notifyListeners();
    return signUpResult?.data;
  }

  void checkPwd1(String text, Color trueColor, Color failColor) {
    pwd1 = text;
    isShowPwd1Fail = false;
    if (text.isEmpty) {
      pwd1UnderColor = trueColor;
    } else if (text.length < 8) {
      pwd1UnderColor = failColor;
      isShowPwd1Fail = true;
    } else {
      pwd1UnderColor = trueColor;
    }
    notifyListeners();
  }

  void checkPassWord() {
    isCheckedPassword = true;
    isSamePassword = pwd1 == pwd2;
    if (isSamePassword) {
      isButtonEnabled = true;
    } else {
      isButtonEnabled = false;
    }
    notifyListeners();
  }
}
