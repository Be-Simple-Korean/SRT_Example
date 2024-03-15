import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:srt_ljh/common/colors.dart';
import 'package:srt_ljh/common/Constants.dart';
import 'package:srt_ljh/common/strings.dart';
import 'package:srt_ljh/ui/widget/notosans_text.dart';
import 'package:srt_ljh/ui/register/register_input.dart';

/// 회원가입 공통 타이틀
class AuthTitleBar extends StatelessWidget {
  const AuthTitleBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: Stack(
        children: <Widget>[
          const Align(
              alignment: Alignment.center,
              child: NotoSansText(
                text: REGISTER_TITLE,
                textColor: Colors.black,
                textSize: 20,
              )),
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () {
                context.pop();
              },
              child: const Padding(
                padding: EdgeInsets.only(right: 23.4),
                child: Icon(Icons.close, color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 회원가입 공통 텍스트 필드
class AuthTextField extends StatefulWidget {
  AuthTextField(
      {super.key,
      required this.title,
      required this.hint,
      this.text = "",
      this.authType = InputAuthType.NORMAL,
      this.controller,
      this.getValue});

  final String text;
  final String title;
  final String hint;
  final InputAuthType authType;
  final TextEditingController? controller;
  final Function(String)? getValue;
  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  late TextEditingController _controller;
  bool get _isControllerProvided => widget.controller != null;

  @override
  void initState() {
    _controller = _isControllerProvided
        ? widget.controller!
        : TextEditingController(text: widget.text);
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
    bool isEnabled = true;
    bool isReadOnly = false;
    TextInputType keyboardType = TextInputType.text;
    switch (widget.authType) {
      case InputAuthType.READONLY:
        isReadOnly = true;
        isEnabled = false;
        break;
      case InputAuthType.NUMBER:
        keyboardType = TextInputType.number;
        break;
      case InputAuthType.EMAIL:
        keyboardType = TextInputType.emailAddress;
        break;
      default:
        break;
    }

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        widget.title,
        style: const TextStyle(
            fontFamily: FONT_NOTOSANS, fontSize: 14, color: clr_888888),
      ),
      const SizedBox(height: 6),
      Focus(
        onFocusChange: (hasFocuse) => {
          if (!hasFocuse) {widget.getValue?.call(widget.controller?.text ?? "")}
        },
        child: TextField(
          keyboardType: keyboardType,
          readOnly: isReadOnly,
          enabled: isEnabled,
          controller: _controller,
          style: const TextStyle(
              color: clr_888888, fontFamily: FONT_NOTOSANS, fontSize: 22),
          decoration: InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.zero,
            hintText: widget.hint,
            hintStyle: const TextStyle(
                fontFamily: FONT_NOTOSANS,
                color: clr_cccccc,
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
        color: clr_eeeeee,
      )
    ]);
  }
}
