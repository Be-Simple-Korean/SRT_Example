import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:srt_ljh/common/Constants.dart';
import 'package:srt_ljh/common/Utils.dart';
import 'package:srt_ljh/common/strings.dart';
import 'package:srt_ljh/network/network_manager.dart';
import 'package:srt_ljh/ui/widget/common_button.dart';
import 'package:srt_ljh/ui/widget/common_dialog.dart';
import 'package:srt_ljh/ui/register/register_providers.dart';
import 'package:srt_ljh/ui/register/register_widget.dart';
import 'package:srt_ljh/ui/register/register_input.dart';

/// 회원가입 첫 단계
class RegisterAuth extends StatefulWidget {
  const RegisterAuth({super.key});

  @override
  State<RegisterAuth> createState() => _RegisterAuthState();
}

class _RegisterAuthState extends State<RegisterAuth> {
  bool isShow = false;

  /// 인증 코드 보내기
  Future<void> sendAuthCode(String email) async {
    try {
      String message = await NetworkManager().sendAuthCode(email);
      print(message);
      setState(() {
        if (message == SUCCESS_MESSAGE) {
          isShow = true;
        } else {
          CommonDialog.showSimpleDialog(context, "인증 코드 보내기 실패", "", "확인");
        }
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  /// 검증 요청
  Future<Map<String, dynamic>> requstVerify(Map<String, dynamic> params) async {
    try {
      return await NetworkManager().verifyCode(params);
    } catch (e) {
      print('Network request error: $e');
      rethrow;
    }
  }

  /// 검증 결과 처리
  Future<void> handleVerifyResult(
      BuildContext context, Map<String, dynamic> result, String email) async {
    switch (result["code"]) {
      case 0:
        if (result["message"] == SUCCESS_MESSAGE) {
          context.go(
              getRoutePath([ROUTER_REGISTER_AUTH_PATH, ROUTER_REGISTER_PATH]),
              extra: email);
        } else {
          CommonDialog.showErrDialog(context, "인증 실패", "", "확인");
        }
        break;
      case 10:
        CommonDialog.showErrDialog(context, "10 필수 Parameter가 없습니다", "", "확인");
        break;
      case 60:
        CommonDialog.showErrDialog(context, "60 코드가 일치하지 않습니다", "", "확인");
        break;
    }
  }

  /// 검증 수행 절차
  Future<bool> veriftProcess(String code, String email) async {
    Map<String, dynamic> params = {};
    params["code"] = code;
    try {
      Map<String, dynamic> result = await requstVerify(params);
      if (mounted) {
        await handleVerifyResult(context, result, email);
      }
      return true;
    } catch (e) {
      // 네트워크 요청 실패 처리
      if (mounted) {
        CommonDialog.showErrDialog(context, "네트워크 오류가 발생했습니다.", "", "확인");
      }
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          body: Column(
            children: <Widget>[
              const AuthTitleBar(),
              Container(
                margin: const EdgeInsets.only(top: 24, right: 24, left: 24),
                child: Consumer<AuthController>(
                  builder: (BuildContext context, AuthController authController,
                      Widget? child) {
                    return Column(
                      children: [
                        AuthTextField(
                          title: REGISTER_AUTH_TEXT_FIELD_TITLE_ID,
                          hint: REGISTER_AUTH_TEXT_FIELD_TITLE_ID_HINT,
                          authType: InputAuthType.EMAIL,
                          controller: authController.emailController,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: CommonButton(
                            text: REGISTER_AUTH_BUTTON_TITLE_AUTH,
                            width: 150.0,
                            callback: () async {
                              var email = authController.emailController.text;
                              print("email = $email");
                              await sendAuthCode(email);
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        if (isShow) ...[
                          AuthTextField(
                            title: REGISTER_AUTH_TEXT_FIELD_TITLE_AUTH_CODE,
                            hint: REGISTER_AUTH_TEXT_FIELD_TITLE_AUTH_CODE_HINT,
                            controller: authController.codeCotroller,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: CommonButton(
                              text: "확인",
                              width: 150.0,
                              callback: () async {
                                await veriftProcess(
                                    authController.codeCotroller.text,
                                    authController.emailController.text);
                              },
                            ),
                          )
                        ]
                      ],
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
