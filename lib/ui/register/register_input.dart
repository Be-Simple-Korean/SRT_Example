import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/web.dart';
import 'package:provider/provider.dart';
import 'package:srt_ljh/common/images.dart';
import 'package:srt_ljh/common/my_logger.dart';
import 'package:srt_ljh/common/strings.dart';
import 'package:srt_ljh/common/Constants.dart';
import 'package:srt_ljh/common/colors.dart';
import 'package:srt_ljh/common/utils.dart';
import 'package:srt_ljh/model/base_response.dart';
import 'package:srt_ljh/ui/register/reigster_input_viewmodel.dart';
import 'package:srt_ljh/ui/widget/custom_button.dart';
import 'package:srt_ljh/ui/widget/custom_dialog.dart';
import 'package:srt_ljh/ui/widget/notosans_text.dart';
import 'package:srt_ljh/ui/register/register_widget.dart';

enum InputAuthType {
  NORMAL, // 일반
  NUMBER, // 생년월일, 인증 코드
  EMAIL, // 이메일
  READONLY // 읽기전용
}

/// 회원가입 두번째 화면
class RegisterInput extends StatefulWidget {
  const RegisterInput({super.key, required this.email});

  final String email;
  @override
  State<RegisterInput> createState() => _RegisterInputState();
}

class _RegisterInputState extends State<RegisterInput> {
  final TextEditingController pwd1Controller = TextEditingController();
  final TextEditingController pwd2Controller = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController birthController = TextEditingController();
  final FocusNode pwd1FocusNode = FocusNode();
  final FocusNode pwd2FocusNode = FocusNode();
  final FocusNode nameFocusNode = FocusNode();
  final FocusNode birthFocusNode = FocusNode();
  late KeyboardVisibilityController keyboardController;
  late RegisterInputViewModel _registerInputViewModel;
  @override
  void initState() {
    super.initState();
    keyboardController = KeyboardVisibilityController();
    keyboardController.onChange.listen((isVisible) {
      if (!isVisible) {
        if (pwd1FocusNode.hasFocus) {
          pwd1FocusNode.unfocus();
        } else if (pwd2FocusNode.hasFocus) {
          pwd2FocusNode.unfocus();
        } else if (nameFocusNode.hasFocus) {
          nameFocusNode.unfocus();
        } else if (birthFocusNode.hasFocus) {
          birthFocusNode.unfocus();
        }
      }
    });
  }

  @override
  void dispose() {
    pwd1FocusNode.dispose();
    pwd2Controller.dispose();
    pwd1Controller.dispose();
    pwd2Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MyLogger().d(widget.email);
    return SafeArea(
      child: Consumer<RegisterInputViewModel>(
        builder: (BuildContext context,
            RegisterInputViewModel registerInputViewModel, Widget? child) {
          _registerInputViewModel = registerInputViewModel;
          if (_registerInputViewModel.getSingUpResult != null) {
            handleSignUpResult(
                context, _registerInputViewModel.getSingUpResult!.data!);
          }
          _registerInputViewModel.pwd1UnderColor =
              Theme.of(context).dividerColor;
          _registerInputViewModel.email = widget.email;
          return Scaffold(
            body: Column(
              children: <Widget>[
                // 헤더
                const AuthTitleBar(),
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      margin:
                          const EdgeInsets.only(top: 24, right: 24, left: 24),
                      child: Column(
                        children: [
                          // 아이디 텍스트필드
                          AuthTextField(
                            title: REGISTER_TEXT_FIELD_TITLE_ID,
                            hint: "",
                            text: widget.email,
                            authType: InputAuthType.READONLY,
                          ),
                          const SizedBox(height: 24),
                          // 이름 텍스트 필드
                          AuthTextField(
                            focusNode: nameFocusNode,
                            title: REGISTER_TEXT_FIELD_TITLE_NAME,
                            hint: REGISTER_TEXT_FIELD_TITLE_NAME_HINT,
                            controller: nameController,
                            getValue: (name) {
                              _registerInputViewModel.name = name;
                            },
                          ),
                          const SizedBox(height: 24),
                          // 생년월일
                          AuthTextField(
                            focusNode: birthFocusNode,
                            title: REGISTER_TEXT_FIELD_TITLE_BIRTH,
                            hint: REGISTER_TEXT_FIELD_TITLE_BIRTH_HINT,
                            controller: birthController,
                            authType: InputAuthType.NUMBER,
                            getValue: (birth) {
                              _registerInputViewModel.birth = birth;
                            },
                          ),
                          const SizedBox(height: 24),
                          // 비밀번호
                          AuthPasswordCheckTextField(
                              focusNode: pwd1FocusNode,
                              controller: pwd1Controller,
                              title: REGISTER_TEXT_FIELD_TITLE_PASSWORD,
                              hint: REGISTER_TEXT_FIELD_TITLE_PASSWORD_HINT,
                              getValue: (text) {
                                _registerInputViewModel.checkPwd1(
                                    pwd1Controller.text,
                                    Theme.of(context).dividerColor,
                                    clr_da1d1d);
                              },
                              borderColor:
                                  _registerInputViewModel.pwd1UnderColor),
                          if (_registerInputViewModel.isShowPwd1Fail) ...[
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
                          // 비밀번호 체크
                          AuthPasswordCheckTextField(
                            focusNode: pwd2FocusNode,
                            controller: pwd2Controller,
                            title: REGISTER_TEXT_FIELD_TITLE_PASSWORD_CHECK,
                            getValue: (text) {
                              _registerInputViewModel.pwd2 = text;
                              if (pwd2Controller.text.length >= 8) {
                                _registerInputViewModel.checkPassWord();
                              }
                            },
                            borderColor: _registerInputViewModel.isSamePassword
                                ? Theme.of(context).dividerColor
                                : clr_da1d1d,
                          ),
                          if (!_registerInputViewModel.isSamePassword) ...[
                            const SizedBox(height: 8),
                            // 에러 텍스트
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
                  padding:
                      const EdgeInsets.only(bottom: 16, left: 24, right: 24),
                  // 버튼
                  child: CommonButton(
                      isEnabled: _registerInputViewModel.isButtonEnabled,
                      text: REGISTER_BUTTON_TITLE,
                      width: double.infinity,
                      callback: () {
                        if (!_registerInputViewModel.isCheckedPassword) {
                          pwd2FocusNode.unfocus();
                        }
                        if (_registerInputViewModel.pwd2.length < 8 ||
                            _registerInputViewModel.pwd1.length < 8 ||
                            !_registerInputViewModel.isSamePassword ||
                            _registerInputViewModel.birth.isEmpty ||
                            _registerInputViewModel.name.isEmpty) {
                          return;
                        }
                        var result = _registerInputViewModel.requestSignUp();
                        if (result is BaseResponse && mounted) {
                          handleSignUpResult(context, result as BaseResponse);
                        }
                      }),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// 회원가입 결과 처리
  Future<void> handleSignUpResult(
      BuildContext context, BaseResponse result) async {
    switch (result.code) {
      case 0:
        if (result.message == SUCCESS_MESSAGE) {
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
}

class AuthPasswordCheckTextField extends StatefulWidget {
  const AuthPasswordCheckTextField(
      {super.key,
      required this.title,
      this.hint = "",
      this.getValue,
      required this.controller,
      required this.focusNode,
      this.borderColor = clr_eeeeee});
  final String title;
  final String hint;
  final Function(String)? getValue;
  final Color borderColor;
  final TextEditingController controller;
  final FocusNode focusNode;
  @override
  State<AuthPasswordCheckTextField> createState() =>
      _AuthPasswordCheckTextFieldState();
}

class _AuthPasswordCheckTextFieldState
    extends State<AuthPasswordCheckTextField> {
  bool showImage = false;

  void handleTextFieldChanged(String text) {
    widget.getValue?.call(text);
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      NotoSansText(
          text: widget.title,
          textSize: 14,
          textColor: Theme.of(context).colorScheme.onSecondary),
      const SizedBox(height: 6),
      Row(
        children: <Widget>[
          Expanded(
            child: Focus(
              onFocusChange: (value) {
                if (!value) {
                  setState(() {
                    showImage = false;
                  });
                  widget.getValue?.call(widget.controller.text);
                }
              },
              child: TextField(
                obscureText: true,
                focusNode: widget.focusNode,
                onChanged: (value) {
                  if (value.isEmpty) {
                    setState(() {
                      showImage = false;
                    });
                  } else {
                    if (!showImage) {
                      setState(() {
                        showImage = true;
                      });
                    }
                  }
                },
                controller: widget.controller,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontFamily: FONT_NOTOSANS,
                    fontSize: 22),
                decoration: InputDecoration(
                  hintText: widget.hint,
                  hintStyle: TextStyle(
                      fontFamily: FONT_NOTOSANS,
                      color: Theme.of(context).hintColor,
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
                MyLogger().d("pwdClick"),
                widget.controller.text = "",
                setState(() {
                  showImage = false;
                }),
                handleTextFieldChanged("")
              },
              child: SizedBox(
                width: 20,
                height: 20,
                child: Theme.of(context).brightness == Brightness.light
                    ? Image.asset(AppImages.IMAGE_ICO_DELETE)
                    : Image.asset(AppImages.IMAGE_ICO_DELETE_DARK),
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
