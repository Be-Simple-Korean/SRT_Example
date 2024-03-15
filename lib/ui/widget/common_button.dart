import 'package:flutter/material.dart';
import 'package:srt_ljh/common/colors.dart';
import 'package:srt_ljh/ui/widget/notosans_text.dart';

/// 공통 버튼
class CommonButton extends StatelessWidget {
  const CommonButton(
      {super.key,
      required this.width,
      required this.text,
      this.callback});
  final String text;
  final double width;
  final Function()? callback;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: 48.0,
      child: ElevatedButton(
        onPressed: callback,
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all(Colors.white),
          backgroundColor: MaterialStateProperty.all(clr_476eff),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        child: NotoSansText(text: text, textColor: Colors.white,)
      ),
    );
  }
}
