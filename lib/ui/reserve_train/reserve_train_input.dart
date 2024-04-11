import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:srt_ljh/common/colors.dart';
import 'package:srt_ljh/common/constants.dart';
import 'package:srt_ljh/common/images.dart';
import 'package:srt_ljh/common/strings.dart';
import 'package:srt_ljh/common/theme_provider.dart';
import 'package:srt_ljh/common/utils.dart';
import 'package:srt_ljh/ui/reserve_train/dialog/terms_dialog.dart';
import 'package:srt_ljh/ui/reserve_train/reserve_train_input_viewmodel.dart';
import 'package:srt_ljh/ui/widget/custom_button.dart';
import 'package:srt_ljh/ui/widget/notosans_text.dart';

class ReserveTrainInput extends StatefulWidget {
  const ReserveTrainInput({super.key, required this.result});

  final Map<String, dynamic> result;
  @override
  State<ReserveTrainInput> createState() => _ReserveTrainInputState();
}

class _ReserveTrainInputState extends State<ReserveTrainInput> {
  final TextEditingController pwd1Controller = TextEditingController();
  final TextEditingController pwd2Controller = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final FocusNode pwd1FocusNode = FocusNode();
  final FocusNode pwd2FocusNode = FocusNode();
  final FocusNode nameFocusNode = FocusNode();
  final FocusNode phoneFocusNode = FocusNode();
  late KeyboardVisibilityController keyboardController;
  bool isErrorName = false;
  bool isErrorPhone = false;
  bool isErrorPwd1 = false;
  bool isErrorPwd2 = false;

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
        } else if (phoneFocusNode.hasFocus) {
          phoneFocusNode.unfocus();
        }
      }
    });
  }

  @override
  void dispose() {
    pwd2FocusNode.dispose();
    nameFocusNode.dispose();
    phoneFocusNode.dispose();
    pwd1FocusNode.dispose();
    pwd2Controller.dispose();
    pwd1Controller.dispose();
    nameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  Future<void> showTermsBottomSheet(BuildContext context) async {
    bool? isAgree = await showTermsDialog(context, [
      "[필수] 개인정보 수집 및 이용 동의",
      "[필수] 개인정보 제공 동의",
      "[선택] 마케팅 정보 수신 동의"
    ], [
      "http://dpms.openobject.net:4132/terms/terms_collection.html",
      "http://dpms.openobject.net:4132/terms/terms_marketing.html",
      "http://dpms.openobject.net:4132/terms/terms_provide.html"
    ]);
    if (isAgree != null) {
      if (isAgree && mounted) {
        context.replace(
            getRoutePath([
              ROUTER_MAIN_PATH,
              ROUTER_SEARCH_TRAIN,
              ROUTER_RESERVE_TRAIN_INFO
            ]),
            extra: widget.result);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          const ReserveTrainInputHeader(),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.only(left: 24, right: 24),
            child: Column(
              children: [
                const SizedBox(
                  height: 24,
                ),
                ReserveTextField(
                  title: "이름",
                  hint: "김*픈",
                  reserveInputType: ReserveInputType.NAME,
                  borderColor:
                      isErrorName ? clr_da1d1d : Theme.of(context).hintColor,
                  focusNode: nameFocusNode,
                  controller: nameController,
                  getValue: (text) {
                    Provider.of<ReserveTrainInputProvider>(context,
                            listen: false)
                        .setName(text);
                    if (text.isEmpty) {
                      setState(() {
                        isErrorName = true;
                      });
                    } else {
                      if (isErrorName) {
                        setState(() {
                          isErrorName = false;
                        });
                      }
                    }
                  },
                ),
                const SizedBox(
                  height: 5,
                ),
                Visibility(
                    visible: isErrorName,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: const NotoSansText(
                        text: "이름은 필수 입력입니다.",
                        textSize: 12,
                        textColor: clr_da1d1d,
                      ),
                    )),
                SizedBox(
                  height: isErrorName ? 6 : 30,
                ),
                ReserveTextField(
                  title: "휴대폰번호",
                  hint: "01012**56**",
                  isInputNumber: true,
                  reserveInputType: ReserveInputType.PHONE,
                  borderColor:
                      isErrorPhone ? clr_da1d1d : Theme.of(context).hintColor,
                  focusNode: phoneFocusNode,
                  controller: phoneController,
                  getValue: (text) {
                    Provider.of<ReserveTrainInputProvider>(context,
                            listen: false)
                        .setPhone(text);
                    if (text.isEmpty) {
                      setState(() {
                        isErrorPhone = true;
                      });
                    } else {
                      if (isErrorPhone) {
                        setState(() {
                          isErrorPhone = false;
                        });
                      }
                    }
                  },
                ),
                const SizedBox(
                  height: 5,
                ),
                Visibility(
                    visible: isErrorPhone,
                    child: const Align(
                      alignment: Alignment.centerLeft,
                      child: NotoSansText(
                        text: "휴대폰번호는 필수 입력입니다.",
                        textSize: 12,
                        textColor: clr_da1d1d,
                      ),
                    )),
                SizedBox(
                  height: isErrorName ? 6 : 30,
                ),
                ReserveTextField(
                  title: "비밀번호",
                  hint: "숫자 5자리",
                  borderColor:
                      isErrorPwd1 ? clr_da1d1d : Theme.of(context).hintColor,
                  isInputNumber: true,
                  reserveInputType: ReserveInputType.PASSWORD,
                  isSecure: true,
                  focusNode: pwd1FocusNode,
                  controller: pwd1Controller,
                  getValue: (text) {
                    Provider.of<ReserveTrainInputProvider>(context,
                            listen: false)
                        .setPwd1(text);
                    if (text.isEmpty) {
                      setState(() {
                        isErrorPwd1 = true;
                      });
                    } else {
                      if (isErrorPwd1) {
                        setState(() {
                          isErrorPwd1 = false;
                        });
                      }
                      if (text.length >= 5) {
                        FocusScope.of(context).requestFocus(pwd2FocusNode);
                      }
                    }
                  },
                ),
                const SizedBox(
                  height: 5,
                ),
                Visibility(
                    visible: isErrorPwd1,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: const NotoSansText(
                        text: "비밀번호는 필수 입력입니다.",
                        textSize: 12,
                        textColor: clr_da1d1d,
                      ),
                    )),
                SizedBox(
                  height: isErrorName ? 6 : 30,
                ),
                ReserveTextField(
                  title: "비밀번호 확인",
                  hint: "",
                  reserveInputType: ReserveInputType.PASSWORD,
                  borderColor:
                      isErrorPwd2 ? clr_da1d1d : Theme.of(context).hintColor,
                  isInputNumber: true,
                  isSecure: true,
                  focusNode: pwd2FocusNode,
                  controller: pwd2Controller,
                  getValue: (text) {
                    Provider.of<ReserveTrainInputProvider>(context,
                            listen: false)
                        .setPwd2(text);
                    if (text.isEmpty ||
                        !Provider.of<ReserveTrainInputProvider>(context,
                                listen: false)
                            .isSamePwd()) {
                      setState(() {
                        isErrorPwd2 = true;
                      });
                    } else {
                      if (isErrorPwd2) {
                        setState(() {
                          isErrorPwd2 = false;
                        });
                      }
                    }
                  },
                ),
                const SizedBox(
                  height: 5,
                ),
                Visibility(
                    visible: isErrorPwd2,
                    child: const Align(
                      alignment: Alignment.centerLeft,
                      child: NotoSansText(
                        text: "비밀번호가 일치하지 않습니다.",
                        textSize: 12,
                        textColor: clr_da1d1d,
                      ),
                    )),
              ],
            ),
          )),
          Consumer<ReserveTrainInputProvider>(
            builder: (context, viewModel, child) {
              return Container(
                  margin:
                      const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                  child: CommonButton(
                    width: double.infinity,
                    text: "확인",
                    isEnabled: viewModel.isButtonEnabled,
                    callback: () {
                      showTermsBottomSheet(context);
                    },
                  ));
            },
          )
        ],
      ),
    ));
  }
}

/// 헤더
class ReserveTrainInputHeader extends StatelessWidget {
  const ReserveTrainInputHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: Stack(
        children: <Widget>[
          Align(
              alignment: Alignment.center,
              child: NotoSansText(
                text: "예매 고객정보 입력",
                textColor: Theme.of(context).colorScheme.onPrimary,
                textSize: 18,
                fontWeight: FontWeight.w600,
              )),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
                padding: const EdgeInsets.only(left: 22, right: 23.4),
                child: InkWell(
                  onTap: () {
                    context.pop();
                  },
                  child: SizedBox(
                      width: 24,
                      height: 24,
                      child: Provider.of<ThemeProvider>(context).isDarkMode()
                          ? ColorFiltered(
                              colorFilter: const ColorFilter.mode(
                                  Colors.white, BlendMode.srcIn),
                              child: Image.asset(AppImages.IMAGE_ICO_LINE_LEFT))
                          : Image.asset(AppImages.IMAGE_ICO_LINE_LEFT)),
                )),
          ),
        ],
      ),
    );
  }
}

/// 예매정보 텍스트 필드
class ReserveTextField extends StatefulWidget {
  ReserveTextField(
      {super.key,
      required this.title,
      required this.hint,
      this.controller,
      this.getValue,
      this.focusNode,
      this.isInputNumber = false,
      this.isSecure = false,
      required this.borderColor,
      required this.reserveInputType});

  final String title;
  final String hint;
  final TextEditingController? controller;
  final Function(String)? getValue;
  final FocusNode? focusNode;
  bool isInputNumber;
  bool isSecure;
  final Color borderColor;
  final ReserveInputType reserveInputType;
  @override
  State<ReserveTextField> createState() => _ReserveTextFieldState();
}

class _ReserveTextFieldState extends State<ReserveTextField> {
  late TextEditingController _controller;
  bool get _isControllerProvided => widget.controller != null;
  TextInputType keyboardType = TextInputType.text;
  PhoneNumberInputFormatter? phoneNumberInputFormatter;
  List<TextInputFormatter> inputFormatters = [];
  bool isReadOnly = false;
  String name = "";
  int length = 0;

  Future<String> getName() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String name = pref.getString(PREF_KEY_NAME) ?? "";
    if (name.isNotEmpty && name.length <= 3) {
      widget.getValue?.call(name);
      name = name.replaceRange(1, 2, "*");
      _controller.text = name;
    }
    return name;
  }

  @override
  void initState() {
    if (widget.isInputNumber) {
      keyboardType = TextInputType.number;
    }
    _controller = _isControllerProvided
        ? widget.controller!
        : TextEditingController(text: name);
    if (widget.reserveInputType == ReserveInputType.PHONE) {
      length = 11;
      phoneNumberInputFormatter = PhoneNumberInputFormatter(isName: false);
      inputFormatters.add(phoneNumberInputFormatter!);
    } else if (widget.reserveInputType == ReserveInputType.NAME) {
      length = 3;
      isReadOnly = true;
      getName().toString();
    } else {
      length = 5;
    }

    super.initState();
  }

  @override
  void dispose() {
    if (!_isControllerProvided) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        widget.title,
        style: TextStyle(
            fontFamily: FONT_NOTOSANS,
            fontSize: 14,
            color: Theme.of(context).colorScheme.onSecondary),
      ),
      const SizedBox(height: 6),
      Focus(
        onFocusChange: (hasFocuse) => {
          if (!hasFocuse)
            {
              if (widget.reserveInputType == ReserveInputType.PHONE)
                {
                  widget.getValue
                      ?.call(phoneNumberInputFormatter!.getRealText())
                }
              else
                {widget.getValue?.call(_controller.text)}
            }
        },
        child: TextField(
        cursorColor: Theme.of(context).colorScheme.onPrimary,
          enabled:
              widget.reserveInputType == ReserveInputType.NAME ? false : true,
          readOnly: isReadOnly,
          inputFormatters: inputFormatters,
          maxLength: length,
          obscureText: widget.isSecure,
          focusNode: widget.focusNode,
          keyboardType: keyboardType,
          controller: _controller,
          style: TextStyle(
              decorationThickness: 0,
              color: Theme.of(context).focusColor,
              fontFamily: FONT_NOTOSANS,
              fontSize: 22),
          decoration: InputDecoration(
            counterText: "",
            isDense: true,
            contentPadding: EdgeInsets.zero,
            hintText: widget.hint,
            hintStyle: TextStyle(
                fontFamily: FONT_NOTOSANS,
                color: Theme.of(context).hintColor,
                fontSize: 22,
                fontWeight: FontWeight.normal),
            border: InputBorder.none,
          ),
        ),
      ),
      const SizedBox(height: 6),
      Container(
        width: double.infinity,
        height: 1.0,
        color: widget.borderColor,
      )
    ]);
  }
}

enum ReserveInputType { NAME, PHONE, PASSWORD }
