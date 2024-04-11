import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:srt_ljh/common/colors.dart';
import 'package:srt_ljh/ui/widget/notosans_text.dart';

/// 공통 팝업
class CommonDialog {
  /// 에러 팝업 노출
  static void showErrDialog(
      BuildContext context, String content, String leftText, String rightText) {
    showSimpleDialog(context, content, leftText, rightText, null);
  }

  /// 팝업 노출
  static void showSimpleDialog(BuildContext context, String content,
      String leftText, String rightText, Function? rightTextClicked) {
    showDialog(
        barrierColor: clr_B2000000,
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          Color rightTextColor = leftText.isNotEmpty
              ? clr_476eff
              : Theme.of(context).colorScheme.onSurface;
          return Dialog(
            backgroundColor: Theme.of(context).dialogTheme.backgroundColor,
            insetPadding: const EdgeInsets.symmetric(horizontal: 42),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: const EdgeInsets.only(
                      top: 34, left: 32, right: 32, bottom: 28),
                  child: NotoSansText(
                      text: content,
                      textColor: Theme.of(context).colorScheme.onSurface),
                ),
                Container(
                  width: double.infinity,
                  height: 1.0,
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
                SizedBox(
                  height: 53,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (leftText.isNotEmpty) ...[
                        Expanded(
                            flex: 1,
                            child: SizedBox(
                              height: 53,
                              child: Center(
                                  child: NotoSansText(
                                      text: leftText,
                                      textColor: Theme.of(context)
                                          .colorScheme
                                          .onSurface)),
                            )),
                        Container(
                          width: 1.0,
                          height: 53,
                          color: clr_eeeeee,
                        ),
                      ],
                      Expanded(
                          flex: 1,
                          child: InkWell(
                            onTap: () {
                              rightTextClicked?.call();
                              context.pop();
                            },
                            child: SizedBox(
                              height: 53,
                              child: Center(
                                  child: NotoSansText(
                                text: rightText,
                                textColor: rightTextColor,
                              )),
                            ),
                          )),
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }
}
