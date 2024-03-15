import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:srt_ljh/common/images.dart';
import 'package:srt_ljh/common/strings.dart';
import 'package:srt_ljh/network/network_manager.dart';
import 'package:srt_ljh/common/Constants.dart';
import 'package:srt_ljh/common/colors.dart';
import 'package:srt_ljh/common/utils.dart';
import 'package:srt_ljh/ui/widget/common_button.dart';
import 'package:srt_ljh/ui/widget/common_dialog.dart';
import 'package:srt_ljh/ui/widget/notosans_text.dart';
import 'package:srt_ljh/ui/register/register_widget.dart';

// enum InputAuthType {
//   Normal, // 일반
//   NUMBER, // 생년월일, 인증 코드
//   EMAIL, // 이메일
//   READONLY // 읽기전용
// }
enum InputAuthType {
  NORMAL, // 일반
  NUMBER, // 생년월일, 인증 코드
  EMAIL, // 이메일
  READONLY // 읽기전용
}

/// 회원가입 두번째 화면
class Register extends StatefulWidget {
  const Register({super.key, required this.email});

  final String email;
  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String pwd1 = "";
  String pwd2 = "";
  String name = "";
  String birth = "";
  bool isNotSameShow = false;
  bool isNotCompleteInput = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.email);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          body: Column(
            children: <Widget>[
              const AuthTitleBar(),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    margin: const EdgeInsets.only(top: 24, right: 24, left: 24),
                    child: Column(
                      children: [
                        AuthTextField(
                          title: REGISTER_TEXT_FIELD_TITLE_ID,
                          hint: "",
                          text: widget.email,
                          authType: InputAuthType.NORMAL,
                        ),
                        const SizedBox(height: 24),
                        AuthTextField(
                          title: REGISTER_TEXT_FIELD_TITLE_NAME,
                          hint: REGISTER_TEXT_FIELD_TITLE_NAME_HINT,
                          getValue: (name) {
                            this.name = name;
                          },
                        ),
                        const SizedBox(height: 24),
                        AuthTextField(
                          title: REGISTER_TEXT_FIELD_TITLE_BIRTH,
                          hint: REGISTER_TEXT_FIELD_TITLE_BIRTH_HINT,
                          authType: InputAuthType.NUMBER,
                          getValue: (birth) {
                            this.birth = birth;
                          },
                        ),
                        const SizedBox(height: 24),
                        AuthPasswordCheckTextField(
                          title: REGISTER_TEXT_FIELD_TITLE_PASSWORD,
                          hint: REGISTER_TEXT_FIELD_TITLE_PASSWORD_HINT,
                          getValue: (text) {
                            pwd1 = text;
                            checkPassword();
                          },
                          borderColor:
                              isNotCompleteInput ? clr_da1d1d : clr_eeeeee,
                        ),
                        if (isNotCompleteInput) ...[
                          const SizedBox(height: 8),
                          const Align(
                              alignment: Alignment.centerLeft,
                              child: NotoSansText(
                                text: REGISTER_PASSWORD_ERROR_TEXT,
                                textSize: 12,
                                textColor: clr_da1d1d,
                              ))
                        ],
                        const SizedBox(height: 24),
                        AuthPasswordCheckTextField(
                          title: REGISTER_TEXT_FIELD_TITLE_PASSWORD_CHECK,
                          getValue: (text) {
                            pwd2 = text;
                            checkPassword();
                          },
                          borderColor: isNotSameShow ? clr_da1d1d : clr_eeeeee,
                        ),
                        if (isNotSameShow) ...[
                          const SizedBox(height: 8),
                          const Align(
                              alignment: Alignment.centerLeft,
                              child: NotoSansText(
                                text: REGISTER_PASSWORD_CHECK_ERROR_TEXT,
                                textSize: 12,
                                textColor: clr_da1d1d,
                              ))
                        ],
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16, left: 24, right: 24),
                child: CommonButton(
                    text: REGISTER_BUTTON_TITLE,
                    width: double.infinity,
                    callback: () async {
                      if (pwd2.isEmpty ||
                          isNotSameShow ||
                          isNotCompleteInput ||
                          birth.isEmpty ||
                          name.isEmpty) {
                        return;
                      }
                      Map<String, dynamic> params = {};
                      params["email"] = widget.email;
                      params["pw"] = pwd2;
                      params["birth"] = birth;
                      params["name"] = name;
                      await signUpProcess(context, params);
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 비밀번호 체크
  void checkPassword() {
    if (pwd2.length >= pwd1.length && pwd1.length >= 8 && pwd2.length >= 8) {
      setState(() {
        isNotSameShow = pwd1 != pwd2;
      });
    } else if (pwd1.length < 8) {
      setState(() {
        isNotCompleteInput = true;
      });
    } else if (pwd1.length >= 8) {
      setState(() {
        isNotCompleteInput = false;
      });
    }
  }

  /// 회원가입 요청
  Future<Map<String, dynamic>> requstSignUp(Map<String, dynamic> params) async {
    try {
      return await NetworkManager().signUp(params);
    } catch (e) {
      print('Network request error: $e');
      rethrow;
    }
  }

  /// 회원가입 결과 처리
  Future<void> handleSignUpResult(
      BuildContext context, Map<String, dynamic> result) async {
    switch (result["code"]) {
      case 0:
        if (result["message"] == SUCCESS_MESSAGE) {
          context.go(ROUTER_ROOT_PATH);
        } else {
          CommonDialog.showErrDialog(context, "인증 실패", "", "확인");
        }
        break;
      case 10:
        CommonDialog.showErrDialog(context, "10 필수 Parameter가 없습니다", "", "확인");
        break;
      case 20:
        CommonDialog.showErrDialog(context, "20 이메일 형식으로 입력해주세요", "", "확인");
        break;
      case 30:
        CommonDialog.showErrDialog(
            context, "30 비밀번호 최소 6자리 이상 입력해주세요", "", "확인");
        break;
      case 40:
        CommonDialog.showErrDialog(context, "40 중복된 이메일 입니다.", "", "확인");
        break;
    }
  }

  /// 회원가입 프로세스
  Future<bool> signUpProcess(
      BuildContext context, Map<String, dynamic> params) async {
    try {
      Map<String, dynamic> result = await requstSignUp(params);
      if (mounted) {
        await handleSignUpResult(context, result);
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
}

class AuthPasswordCheckTextField extends StatefulWidget {
  const AuthPasswordCheckTextField(
      {super.key,
      required this.title,
      this.hint = "",
      this.getValue,
      this.borderColor = clr_eeeeee});
  final String title;
  final String hint;
  final Function(String)? getValue;
  final Color borderColor;

  @override
  State<AuthPasswordCheckTextField> createState() =>
      _AuthPasswordCheckTextFieldState();
}

class _AuthPasswordCheckTextFieldState
    extends State<AuthPasswordCheckTextField> {
  bool showImage = false;
  PasswordInputFormatter format = PasswordInputFormatter();
  TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _handleTextFieldChanged(String text) {
    widget.getValue?.call(format.getRealText());
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      NotoSansText(text: widget.title, textSize: 14, textColor: clr_888888),
      const SizedBox(height: 6),
      Row(
        children: <Widget>[
          Expanded(
            child: Focus(
              onFocusChange: (hasFocus) {
                if (!hasFocus) {
                  widget.getValue?.call(format.getRealText());
                }
              },
              child: TextField(
                onChanged: (text) {
                  setState(() {
                    showImage = text.isNotEmpty;
                  });
                },
                controller: controller,
                inputFormatters: [format],
                style: const TextStyle(
                    color: Colors.black,
                    fontFamily: FONT_NOTOSANS,
                    fontSize: 22),
                decoration: InputDecoration(
                  hintText: widget.hint,
                  hintStyle: const TextStyle(
                      fontFamily: FONT_NOTOSANS,
                      color: clr_cccccc,
                      fontSize: 22,
                      fontWeight: FontWeight.normal),
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          if (showImage)
            GestureDetector(
              onTap: () => {
                print("pwdClick"),
                controller.text = "",
                format.clearRealText(),
                _handleTextFieldChanged("")
              },
              child: SizedBox(
                width: 20,
                height: 20,
                child: Image.asset(AppImages.IMAGE_ICO_DELETE),
              ),
            ),
        ],
      ),
      const SizedBox(height: 12),
      Container(
        width: double.infinity,
        height: 1.0,
        color: widget.borderColor,
      )
    ]);
  }
}
