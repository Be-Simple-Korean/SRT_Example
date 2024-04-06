import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:srt_ljh/common/colors.dart';
import 'package:srt_ljh/common/images.dart';
import 'package:srt_ljh/common/strings.dart';
import 'package:srt_ljh/common/theme_provider.dart';
import 'package:srt_ljh/ui/widget/notosans_text.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({
    super.key,
  });
  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late List<String> dataList;
  @override
  void initState() {
    super.initState();
    dataList = [];
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            NotificationHeader(
              callback: () {
                setState(() {
                  dataList.add("");
                });
              },
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: dataList.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin:
                          const EdgeInsets.only(top: 15, left: 16, right: 16),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 1.0,
                              color: Theme.of(context).colorScheme.secondary),
                          color:
                              Provider.of<ThemeProvider>(context).isDarkMode()
                                  ? clr_323741
                                  : Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(
                          vertical: 19, horizontal: 20),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                NotoSansText(
                                  text: "푸시 타이틀",
                                  textSize: 14,
                                  textColor:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                                const Spacer(),
                                NotoSansText(
                                    text: "9999.99.99(일)",
                                    textSize: 14,
                                    textColor:
                                        Provider.of<ThemeProvider>(context)
                                                .isDarkMode()
                                            ? clr_737b93
                                            : clr_888888)
                              ],
                            ),
                            NotoSansText(
                                text: "푸시 내용입니다.",
                                textSize: 14,
                                textColor: Provider.of<ThemeProvider>(context)
                                        .isDarkMode()
                                    ? clr_99A0B1
                                    : clr_666666)
                          ]),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}

/// 헤더
class NotificationHeader extends StatelessWidget {
  const NotificationHeader({super.key, required this.callback});

  final Function() callback;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 22),
      height: 56,
      child: Stack(
        children: <Widget>[
          Align(
              alignment: Alignment.center,
              child: NotoSansText(
                text: SELECT_STATION_TITLE,
                textColor: Theme.of(context).colorScheme.onPrimary,
                textSize: 18,
                fontWeight: FontWeight.w600,
              )),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
                padding: const EdgeInsets.only(right: 23.4),
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
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: InkWell(
                onTap: () {
                  callback.call();
                },
                child: SizedBox(
                    width: 24,
                    height: 24,
                    child: Icon(
                      Icons.add,
                      color: Theme.of(context).colorScheme.onPrimary,
                    )),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
