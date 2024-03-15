import 'package:flutter/material.dart';
import 'package:srt_ljh/common/colors.dart';
import 'package:srt_ljh/ui/widget/notosans_text.dart';

/// 공통 버튼
class CommonButton extends StatelessWidget {
  const CommonButton(
      {super.key,
      required this.width,
      required this.text,
      this.isEnabled = false,
      this.callback});
  final String text;
  final bool isEnabled;
  final double width;
  final Function()? callback;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: 48.0,
      child: ElevatedButton(
          onPressed: isEnabled ? callback : null,
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all(isEnabled ? clr_476eff : clr_d0dae6),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          child: NotoSansText(
            text: text,
            textColor: isEnabled ? Colors.white : clr_91a1b2,
          )),
    );
  }
}
