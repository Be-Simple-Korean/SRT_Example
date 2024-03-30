import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:srt_ljh/common/Constants.dart';
import 'package:srt_ljh/common/colors.dart';
import 'package:srt_ljh/common/images.dart';
import 'package:srt_ljh/common/strings.dart';
import 'package:srt_ljh/common/Utils.dart';
import 'package:provider/provider.dart';
import 'package:srt_ljh/model/base_response.dart';
import 'package:srt_ljh/ui/login/login_viewmodel.dart';
import 'package:srt_ljh/ui/widget/custom_button.dart';
import 'package:srt_ljh/ui/widget/custom_dialog.dart';
import 'package:srt_ljh/ui/widget/notosans_text.dart';

/// 로그인 화면
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginAppState();
}

class _LoginAppState extends State<LoginScreen> {
  String id = "";
  String pwd = "";
  bool isSaved = false;
  bool isButtonEnabled = false;
  final FocusNode idFocusNode = FocusNode();
  final FocusNode pwdFocusNode = FocusNode();
  late KeyboardVisibilityController keyboardController;
  late LoginViewModel loginViewModel;

  /// 로그인 결과 처리
  Future<void> handleLoginResult(
      BuildContext context, BaseResponse result) async {
    switch (result.code) {
      case 0:
        if (result.message == SUCCESS_MESSAGE) {
          GoRouter.of(context).push(getRoutePath([ROUTER_MAIN_PATH]));
        } else {}
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
      case 50:
        CommonDialog.showErrDialog(
            context, "50 이메일 또는 비밀번호를 잘못 입력했습니다.", "", "확인");
        break;
    }
  }

  /// id 가져오기
  Future<void> getId() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    id = pref.getString(PREFS_KEY_ID) ?? "";
    if (id.isNotEmpty) {
      setState(() {
        isSaved = true;
      });
    }
  }

  /// 버튼 enabled 변경
  void setButtonEnabled() {
    setState(() {
      if (id.isNotEmpty && pwd.isNotEmpty) {
        isButtonEnabled = true;
      } else {
        isButtonEnabled = false;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    keyboardController = KeyboardVisibilityController();
    keyboardController.onChange.listen((isVisible) {
      if (!isVisible) {
        if (idFocusNode.hasFocus) {
          idFocusNode.unfocus();
        } else if (pwdFocusNode.hasFocus) {
          pwdFocusNode.unfocus();
        }
      }
    });
    getId();
  }

  @override
  Widget build(BuildContext context) {
    var loginViewModel = Provider.of<LoginViewModel>(context);
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          children: <Widget>[
            // 최상단 로고
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(top: 40.0, left: 28.00),
              child: isDark
                  ? ColorFiltered(
                      colorFilter:
                          const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                      child: Image.asset(AppImages.IMAGE_IMG_MAIN_LOGO))
                  : Image.asset(AppImages.IMAGE_IMG_MAIN_LOGO),
            ),
            const SizedBox(height: 97.0),
            // 앱 로고
            Center(
              child: isDark
                  ? ColorFiltered(
                      colorFilter:
                          const ColorFilter.mode(clr_dedede, BlendMode.srcIn),
                      child: Image.asset(AppImages.IMAGE_LOGO))
                  : Image.asset(AppImages.IMAGE_LOGO),
            ),
            const SizedBox(height: 97.0),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  // id TextField
                  LoginTextField(
                    title: LOGIN_TEXT_FIELD_TITLE_ID,
                    text: id,
                    focusNode: idFocusNode,
                    getText: (text) {
                      id = text.trim();
                      setButtonEnabled();
                    },
                  ),
                  const SizedBox(height: 12.0),
                  // pwd TextField
                  LoginTextField(
                    focusNode: pwdFocusNode,
                    title: LOGIN_TEXT_FIELD_TITLE_PW,
                    getText: (text) {
                      pwd = text.trim();
                      setButtonEnabled();
                    },
                  ),
                  const SizedBox(height: 25.0),
                  // 로그인 버튼
                  CommonButton(
                    isEnabled: isButtonEnabled,
                    text: LOGIN_BUTTON_TITLE,
                    width: double.infinity,
                    callback: () async {
                      if (id.isEmpty || pwd.isEmpty) {
                        return;
                      }
                      var result = await loginViewModel.requestLogin(id, pwd);
                      if (result != null && mounted) {
                        handleLoginResult(context, result);
                      }
                    },
                  ),
                  const SizedBox(height: 14.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // 아이디 저장
                      ImgToggleWithText(
                        callback: (isToggle) async {
                          SharedPreferences pref =
                              await SharedPreferences.getInstance();
                          if (isToggle) {
                            pref.setString(PREFS_KEY_ID, id);
                            setState(() {
                              isSaved = true;
                            });
                          } else {
                            pref.setString(PREFS_KEY_ID, "");
                            setState(() {
                              isSaved = false;
                            });
                          }
                        },
                        isSaved: isSaved,
                      ),
                      const Spacer(),
                      // 회원가입 이동
                      InkWell(
                          onTap: () {
                            context.push(
                                getRoutePath([ROUTER_REGISTER_AUTH_PATH]));
                          },
                          child: NotoSansText(
                            text: LOGIN_GO_REGISTER,
                            textColor: isDark ? clr_666666 : clr_727b90,
                            textSize: 17,
                            isHaveUnderline: true,
                          ))
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

/// 로그인 공통 텍스트필드
class LoginTextField extends StatefulWidget {
  const LoginTextField(
      {super.key,
      this.focusNode,
      required this.title,
      this.getText,
      this.text = ""});
  final String title;
  final String text;
  final Function(String)? getText;
  final FocusNode? focusNode;

  @override
  State<LoginTextField> createState() => _LoginTextFieldState();
}

class _LoginTextFieldState extends State<LoginTextField> {
  late TextEditingController controller;
  late PasswordInputFormatter? formatter;
  @override
  void initState() {
    controller = TextEditingController();
    formatter = widget.title == LOGIN_TEXT_FIELD_TITLE_ID
        ? null
        : PasswordInputFormatter();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.title == LOGIN_TEXT_FIELD_TITLE_ID && widget.text.isNotEmpty) {
      controller.text = widget.text;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      height: 62,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border.all(
            color: Theme.of(context).colorScheme.secondary, width: 1.0),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 22,
            width: 28,
            margin: const EdgeInsets.only(top: 20),
            child: NotoSansText(
                text: widget.title,
                fontWeight: FontWeight.w400,
                lineHeight: 22,
                textColor: Theme.of(context).colorScheme.onSecondary),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Focus(
              onFocusChange: (hasFocus) {
                // 포커스가 해제됐을때 값을 반환
                if (!hasFocus) {
                  var text = "";
                  if (formatter == null) {
                    text = controller.text;
                  } else {
                    text = formatter?.getRealText() ?? "";
                  }
                  widget.getText?.call(text);
                }
              },
              child: SizedBox(
                height: 22,
                child: TextField(
                  focusNode: widget.focusNode,
                  controller: controller,
                  inputFormatters: widget.title == LOGIN_TEXT_FIELD_TITLE_PW
                      ? [formatter!]
                      : null,
                  cursorColor: Theme.of(context).colorScheme.onPrimary,
                  textAlignVertical: TextAlignVertical.center,
                  cursorHeight: 22,
                  decoration: InputDecoration(
                      isDense: true,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                      hintText: widget.title == LOGIN_TEXT_FIELD_TITLE_ID
                          ? LOGIN_ID_HINT
                          : ""),
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 16,
                      decorationThickness: 0,
                      fontFamily: FONT_NOTOSANS),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 아이디 저장
class ImgToggleWithText extends StatefulWidget {
  const ImgToggleWithText(
      {super.key, required this.callback, required this.isSaved});

  final Function(bool) callback;
  final bool isSaved;
  @override
  State<ImgToggleWithText> createState() => _ImgToggleWithTextState();
}

class _ImgToggleWithTextState extends State<ImgToggleWithText> {
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return InkWell(
          onTap: () {
            setState(() {
              widget.callback(!widget.isSaved);
            });
          },
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          child: Row(
            children: [
              Image.asset(
                widget.isSaved
                    ? AppImages.IMAGE_ICO_LOGIN_CHECKED_Y
                    : AppImages.IMAGE_ICO_LOGIN_CHECKED,
                width: 27,
                height: 27,
              ),
              const SizedBox(width: 4),
              const NotoSansText(
                  text: LOGIN_SAVE_ID, textColor: clr_888888, textSize: 12)
            ],
          ));
    });
  }
}
