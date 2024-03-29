import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:srt_ljh/common/Constants.dart';
import 'package:srt_ljh/common/colors.dart';
import 'package:srt_ljh/common/images.dart';
import 'package:srt_ljh/common/strings.dart';
import 'package:srt_ljh/common/theme/theme_provider.dart';
import 'package:srt_ljh/common/Utils.dart';
import 'package:provider/provider.dart';
import 'package:srt_ljh/model/login_response.dart';
import 'package:srt_ljh/ui/login/login_viewmodel.dart';
import 'package:srt_ljh/ui/widget/common_button.dart';
import 'package:srt_ljh/ui/widget/common_dialog.dart';
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

  /// 로그인 결과 처리
  Future<void> handleLoginResult(
      BuildContext context, LoginResponse result) async {
    switch (result.code) {
      case 0:
        if (result.message == SUCCESS_MESSAGE) {
          GoRouter.of(context).go(getRoutePath([ROUTER_MAIN_PATH]));
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
    getId();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
        builder: (context, child) {
          return Consumer<ThemeProvider>(
              builder: (context, themeProvider, child) {
            bool isDark = themeProvider.currentTheme == ThemeMode.dark;
            return MaterialApp(
              theme: themeProvider.lightThemeData,
              darkTheme: themeProvider.darkThemeData,
              themeMode: themeProvider.currentTheme,
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                resizeToAvoidBottomInset: false,
                body: SafeArea(
                  child: Column(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: const EdgeInsets.only(top: 40.0, left: 28.00),
                        child: isDark
                            ? ColorFiltered(
                                colorFilter: const ColorFilter.mode(
                                    Colors.white, BlendMode.srcIn),
                                child:
                                    Image.asset(AppImages.IMAGE_IMG_MAIN_LOGO))
                            : Image.asset(AppImages.IMAGE_IMG_MAIN_LOGO),
                      ),
                      const SizedBox(height: 97.0),
                      Center(
                        child: isDark
                            ? ColorFiltered(
                                colorFilter: const ColorFilter.mode(
                                    clr_dedede, BlendMode.srcIn),
                                child: Image.asset(AppImages.IMAGE_LOGO))
                            : Image.asset(AppImages.IMAGE_LOGO),
                      ),
                      const SizedBox(height: 97.0),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Column(
                          children: [
                            LoginTextField(
                              title: LOGIN_TEXT_FIELD_TITLE_ID,
                              text: id,
                              getText: (text) {
                                id = text;
                                setButtonEnabled();
                              },
                            ),
                            const SizedBox(height: 12.0),
                            LoginTextField(
                              title: LOGIN_TEXT_FIELD_TITLE_PW,
                              getText: (text) {
                                pwd = text;
                                setButtonEnabled();
                              },
                            ),
                            const SizedBox(height: 25.0),
                            Consumer<LoginViewModel>(
                              builder: (context, loginViewModel, child) {
                                return CommonButton(
                                  isEnabled: isButtonEnabled,
                                  text: LOGIN_BUTTON_TITLE,
                                  width: double.infinity,
                                  callback: () async {
                                    if (id.isEmpty || pwd.isEmpty) {
                                      return;
                                    }
                                    var result = await loginViewModel
                                        .requestLogin(id, pwd);
                                    if (result != null && mounted) {
                                      handleLoginResult(context, result);
                                    }
                                  },
                                );
                              },
                            ),
                            const SizedBox(height: 14.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
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
                                InkWell(
                                    onTap: () {
                                      context.go(getRoutePath(
                                          [ROUTER_REGISTER_AUTH_PATH]));
                                    },
                                    child: NotoSansText(
                                      text: LOGIN_GO_REGISTER,
                                      textColor:
                                          isDark ? clr_666666 : clr_727b90,
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
              ),
            );
          });
        });
  }
}

/// 로그인 공통 텍스트필드
class LoginTextField extends StatefulWidget {
  const LoginTextField(
      {super.key, required this.title, this.getText, this.text = ""});
  final String title;
  final String text;
  final Function(String)? getText;

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
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              NotoSansText(
                  text: widget.title,
                  textColor: Theme.of(context).colorScheme.onSecondary),
              const SizedBox(width: 20),
              Expanded(
                child: Focus(
                  onFocusChange: (hasFocus) {
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
                  child: TextField(
                    controller: controller,
                    inputFormatters: widget.title == LOGIN_TEXT_FIELD_TITLE_PW
                        ? [formatter!]
                        : null,
                    cursorHeight: 22.0,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    ),
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 16,
                        fontFamily: FONT_NOTOSANS),
                  ),
                ),
              ),
            ],
          ),
        );
      },
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
