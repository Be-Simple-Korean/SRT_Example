import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:srt_ljh/common/colors.dart';
import 'package:srt_ljh/common/images.dart';
import 'package:srt_ljh/common/theme_provider.dart';
import 'package:srt_ljh/ui/widget/custom_button.dart';
import 'package:srt_ljh/ui/widget/notosans_text.dart';
import 'package:url_launcher/url_launcher.dart';

Future<bool?> showTermsDialog(
    BuildContext context, List<String> terms, List<String> linkUrls) async {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: false,
    isDismissible: false,
    builder: (context) => Container(
        width: double.infinity,
        height: terms.length == 2 ? 347 : 391,
        decoration: BoxDecoration(
            color: Theme.of(context).dialogTheme.backgroundColor,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10))),
        child: Padding(
            padding: const EdgeInsets.only(top: 23),
            child: TermsWidgets(
              terms: terms,
              linkUrls: linkUrls,
            ))),
  );
}

class ImgToggleWithText extends StatefulWidget {
  const ImgToggleWithText({super.key, required this.callback});

  final Function(bool) callback;
  @override
  State<ImgToggleWithText> createState() => _ImgToggleWithTextState();
}

class _ImgToggleWithTextState extends State<ImgToggleWithText> {
  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return InkWell(
          onTap: () {
            setState(() {
              isChecked = !isChecked;
              widget.callback(isChecked);
            });
          },
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          child: Row(
            children: [
              Image.asset(
                isChecked
                    ? AppImages.IMAGE_ICO_LOGIN_CHECKED_Y
                    : AppImages.IMAGE_ICO_LOGIN_CHECKED,
                width: 27,
                height: 27,
              ),
              const SizedBox(width: 4),
              NotoSansText(
                  text: "약관 동의",
                  textColor: Provider.of<ThemeProvider>(context).isDarkMode()
                      ? clr_dedede
                      : clr_666666,
                  textSize: 16)
            ],
          ));
    });
  }
}

class TermsWidgets extends StatefulWidget {
  const TermsWidgets({super.key, required this.terms, required this.linkUrls});

  final List<String> terms;
  final List<String> linkUrls;

  @override
  State<TermsWidgets> createState() => _TermsWidgetsState();
}

class _TermsWidgetsState extends State<TermsWidgets> {
  bool isChecked = false;
  bool isButtonEnabled = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 24, right: 19),
          child: Row(
            children: [
              NotoSansText(
                text: "약관에 동의해주세요.",
                textColor: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
              Spacer(),
              InkWell(
                onTap: () {
                  context.pop(false);
                },
                child: SizedBox(
                    width: 24,
                    height: 24,
                    child: Icon(
                      Icons.close,
                      color: Theme.of(context).colorScheme.onPrimary,
                    )),
              )
            ],
          ),
        ),
        SizedBox(
          height: 30,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: ImgToggleWithText(
            callback: (isChecked) {
              if (isChecked) {
                setState(() {
                  this.isChecked = true;
                  isButtonEnabled = true;
                });
              } else {
                setState(() {
                  this.isChecked = false;
                });
              }
            },
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 16, left: 16, right: 16),
          width: double.infinity,
          height: 1,
          color: Theme.of(context).colorScheme.outline,
        ),
        Container(
          margin:
              const EdgeInsets.only(top: 20, left: 20, right: 24, bottom: 40),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: widget.terms.length,
            itemBuilder: (context, index) {
              return Container(
                  margin: const EdgeInsets.only(top: 12),
                  child: TermsItem(
                    isChecked: isChecked,
                    text: widget.terms[index],
                    linkUrl: widget.linkUrls[index],
                  ));
            },
          ),
        ),
        Container(
            margin: EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: CommonButton(
              width: double.infinity,
              text: "확인",
              isEnabled: isButtonEnabled,
              callback: () {
                context.pop(true);
              },
            ))
      ],
    );
  }
}

class TermsItem extends StatefulWidget {
  const TermsItem(
      {super.key,
      required this.isChecked,
      required this.text,
      required this.linkUrl});

  final bool isChecked;
  final String text;
  final String linkUrl;
  @override
  State<TermsItem> createState() => _TermsItemState();
}

class _TermsItemState extends State<TermsItem> {
  bool _isChecked = false;
  @override
  void initState() {
    super.initState();
  }

  void launchURL(String url) async {
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $uri';
    }
  }

  @override
  Widget build(BuildContext context) {
    _isChecked = widget.isChecked;
    return InkWell(
      onTap: () {
        setState(() {
          _isChecked = true;
        });
      },
      child: Row(
        children: [
          SizedBox(
            width: 32,
            height: 32,
            child: Image.asset(_isChecked
                ? AppImages.IMAGE_ICO_TERMS_CHECKED
                : AppImages.IMAGE_ICO_TERMS_CHECK),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: NotoSansText(
              text: widget.text,
              textSize: 14,
              textColor: Provider.of<ThemeProvider>(context).isDarkMode()
                  ? clr_dedede
                  : clr_666666,
            ),
          ),
          InkWell(
            onTap: () {
              launchURL(widget.linkUrl);
            },
            child: SizedBox(
              width: 16,
              height: 16,
              child: Image.asset(AppImages.IMAGE_ICO_ARROW_RIGHT),
            ),
          ),
        ],
      ),
    );
  }
}
