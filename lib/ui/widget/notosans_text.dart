import 'package:flutter/material.dart';
import 'package:srt_ljh/common/Constants.dart';

/// NotoSans폰트를 사용하는 Text 위젯
class NotoSansText extends StatelessWidget {
  const NotoSansText(
      {super.key,
      this.text,
      this.textColor,
      this.textSize = 16,
      this.isHaveUnderline = false,
      this.fontWeight});

  final String? text;
  final Color? textColor;
  final FontWeight? fontWeight;
  final double textSize;
  final bool isHaveUnderline;

  @override
  Widget build(BuildContext context) {
    return Text(
      text ?? "",
      style: TextStyle(
          decoration:
              isHaveUnderline ? TextDecoration.underline : TextDecoration.none,
          color: textColor ?? Colors.black,
          fontFamily: FONT_NOTOSANS,
          fontSize: textSize,
          fontWeight: fontWeight),
    );
  }
}
