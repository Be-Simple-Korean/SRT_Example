import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:srt_ljh/common/Constants.dart';
import 'package:srt_ljh/common/Utils.dart';
import 'package:srt_ljh/common/strings.dart';
import 'package:srt_ljh/model/base_response.dart';
import 'package:srt_ljh/ui/register/register_auth_viewmodel.dart';
import 'package:srt_ljh/ui/widget/custom_button.dart';
import 'package:srt_ljh/ui/widget/custom_dialog.dart';
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
  bool isButtonEnabled = false;
  late TextEditingController emailController;
  late TextEditingController authCodeController;

  @override
  void initState() {
    super.initState();

    emailController = TextEditingController();
    authCodeController = TextEditingController();
  }

  /// 인증 코드 전송 결과 처리
  Future<void> handleSendAuthCodeResult(
      BuildContext context, BaseResponse result) async {
    switch (result.code) {
      case 0:
        if (result.message == SUCCESS_MESSAGE) {
          setState(() {
            isShow = true;
          });
        } else {
          CommonDialog.showErrDialog(context, "인증 코드 전송 실패", "", "확인");
        }
        break;
    }
  }

  /// 검증 결과 처리
  Future<void> handleVerifyResult(
      BuildContext context, BaseResponse result) async {
    switch (result.code) {
      case 0:
        if (result.message == SUCCESS_MESSAGE) {
          context.push(
              getRoutePath([ROUTER_REGISTER_AUTH_PATH, ROUTER_REGISTER_PATH]),
              extra: emailController.text);
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: <Widget>[
            // 헤더
            const AuthTitleBar(),
            Container(
              margin: const EdgeInsets.only(top: 24, right: 24, left: 24),
              child: Column(
                children: [
                  // 이메일 텍스트필드
                  AuthTextField(
                    title: REGISTER_AUTH_TEXT_FIELD_TITLE_ID,
                    hint: REGISTER_AUTH_TEXT_FIELD_TITLE_ID_HINT,
                    authType: InputAuthType.EMAIL,
                    controller: emailController,
                    getOnChanged: (text) {
                      if (text.isEmpty) {
                        if (isButtonEnabled) {
                          setState(() {
                            isButtonEnabled = false;
                          });
                        }
                      } else {
                        if (!isButtonEnabled) {
                          setState(() {
                            isButtonEnabled = true;
                          });
                        }
                      }
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  // 인증 보내기 버튼
                  Consumer<RegisterAuthViewModel>(
                    builder: (context, viewmodel, child) {
                      return Align(
                        alignment: Alignment.centerRight,
                        child: CommonButton(
                          isEnabled: isButtonEnabled,
                          text: REGISTER_AUTH_BUTTON_TITLE_AUTH,
                          width: 150.0,
                          callback: () async {
                            var result = await viewmodel
                                .requestSentAuthCode(emailController.text);
                            if (result != null && mounted) {
                              handleSendAuthCodeResult(context, result);
                            }
                          },
                        ),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  if (isShow) ...[
                    //인증 코드 텍스트 필드
                    AuthTextField(
                      title: REGISTER_AUTH_TEXT_FIELD_TITLE_AUTH_CODE,
                      hint: REGISTER_AUTH_TEXT_FIELD_TITLE_AUTH_CODE_HINT,
                      controller: authCodeController,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    // 인증 코드 확인 버튼
                    Consumer<RegisterAuthViewModel>(
                        builder: (context, viewmodel, child) {
                      return Align(
                        alignment: Alignment.centerRight,
                        child: CommonButton(
                          text: ALL_CONFIRM,
                          width: 150.0,
                          isEnabled: true,
                          callback: () async {
                            var result = await viewmodel
                                .requestVerifyAuthCode(authCodeController.text);
                            if (result != null && mounted) {
                              handleVerifyResult(context, result);
                            }
                          },
                        ),
                      );
                    })
                  ]
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
