import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:srt_ljh/common/colors.dart';
import 'package:srt_ljh/common/images.dart';
import 'package:srt_ljh/common/my_logger.dart';
import 'package:srt_ljh/common/strings.dart';
import 'package:srt_ljh/common/theme_provider.dart';
import 'package:srt_ljh/common/utils.dart';
import 'package:srt_ljh/ui/widget/notosans_text.dart';

class SearchTrain extends StatelessWidget {
  const SearchTrain({super.key, required this.result});

  final Map<String, dynamic> result;
  @override
  Widget build(BuildContext context) {
    MyLogger().d(result.toString());
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            const SearchTrainHeader(),
            SearchInfoWidget(result: result),
            if (result["totalCount"] == 0) ...[
              const NoSearchTrainList()
            ] else ...[
              Expanded(
                child: ListView.builder(
                  itemCount: result["totalCount"],
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.only(
                                top: 12, bottom: 11, left: 26, right: 26),
                            color: Provider.of<ThemeProvider>(context,
                                        listen: false)
                                    .isDarkMode()
                                ? clr_292f3a
                                : Colors.white,
                            width: double.infinity,
                            child: Row(children: [
                              NotoSansText(
                                text: "기차",
                                textSize: 14,
                                textColor:
                                    Theme.of(context).colorScheme.onSurface,
                                fontWeight: FontWeight.w500,
                              ),
                              SizedBox(
                                width: 58,
                              ),
                              NotoSansText(
                                text: "출발",
                                textSize: 14,
                                textColor:
                                    Theme.of(context).colorScheme.onSurface,
                                fontWeight: FontWeight.w500,
                              ),
                              SizedBox(
                                width: 58,
                              ),
                              NotoSansText(
                                text: "도착",
                                textSize: 14,
                                textColor:
                                    Theme.of(context).colorScheme.onSurface,
                                fontWeight: FontWeight.w500,
                              ),
                              Spacer(),
                              NotoSansText(
                                text: "일반실",
                                textSize: 14,
                                textColor:
                                    Theme.of(context).colorScheme.onSurface,
                                fontWeight: FontWeight.w500,
                              )
                            ]),
                          ),
                          Container(
                            width: double.infinity,
                            height: 1,
                            color: Theme.of(context).colorScheme.secondary,
                          )
                        ],
                      );
                    } else {
                      return Container(
                        alignment: Alignment.center,
                        width: double.infinity,
                        child: Column(children: [
                          Container(
                            height: 64,
                            color:
                                Provider.of<ThemeProvider>(context).isDarkMode()
                                    ? clr_1b1d23
                                    : Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                NotoSansText(
                                  text:
                                      "SRT ${result["trainInfoList"][index]["trainno"]}",
                                  fontWeight: FontWeight.w700,
                                  textColor:
                                      Theme.of(context).colorScheme.onSurface,
                                  textSize: 13,
                                ),
                                SizedBox(
                                  width: 42.5,
                                ),
                                NotoSansText(
                                  text: getFormatTime(result["trainInfoList"]
                                          [index]["depplandtime"]
                                      .toString()),
                                  textColor:
                                      Theme.of(context).colorScheme.onSurface,
                                  textSize: 13,
                                ),
                                Container(
                                  margin: const EdgeInsets.only(
                                      left: 17.5, right: 16.5),
                                  width: 16,
                                  height: 16,
                                  child: Image.asset(
                                      AppImages.IMAGE_ICO_ARROW_BLUE),
                                ),
                                NotoSansText(
                                  text: getFormatTime(result["trainInfoList"]
                                          [index]["arrplandtime"]
                                      .toString()),
                                  textColor:
                                      Theme.of(context).colorScheme.onSurface,
                                  textSize: 13,
                                ),
                                Spacer(),
                                InkWell(
                                  onTap: () {
                                    Map<String, dynamic> resultData = {};
                                    resultData["startId"]=result["startId"];
                                    resultData["finishId"]=result["finishId"];
                                    resultData["startStation"] =
                                        result["startStation"];
                                    resultData["finishStation"] =
                                        result["finishStation"];
                                    resultData["selectedDay"] =
                                        result["selectedDay"];
                                    resultData["selectedPeople"] =
                                        result["selectPeople"];
                                    resultData["trainno"] =
                                        result["trainInfoList"][index]
                                            ["trainno"];
                                    resultData["depplandtime"] =
                                        result["trainInfoList"][index]
                                            ["depplandtime"];
                                    resultData["arrplandtime"] =
                                        result["trainInfoList"][index]
                                            ["arrplandtime"];
                                    context.push(
                                        getRoutePath([
                                          ROUTER_MAIN_PATH,
                                          ROUTER_SEARCH_TRAIN,
                                          ROUTER_RESERVE_TRAIN_INPUT
                                        ]),
                                        extra: resultData);
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .surface,
                                        border: Border.all(
                                            width: 1.0,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .outline),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    height: 40,
                                    width: 60,
                                    child: NotoSansText(
                                      text: (result["trainInfoList"][index]
                                                  ["reserveYN"] ==
                                              "N")
                                          ? "예매가능"
                                          : "매진",
                                      textColor: (result["trainInfoList"][index]
                                                  ["reserveYN"] ==
                                              "N")
                                          ? (Provider.of<ThemeProvider>(context)
                                                  .isDarkMode()
                                              ? clr_dedede
                                              : Colors.black)
                                          : (Provider.of<ThemeProvider>(context)
                                                  .isDarkMode()
                                              ? clr_6A6F7D
                                              : clr_cccccc),
                                      fontWeight: FontWeight.w500,
                                      textSize: 12,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            height: 8,
                            decoration: BoxDecoration(
                              color: Provider.of<ThemeProvider>(context)
                                      .isDarkMode()
                                  ? clr_313740
                                  : clr_f6f6f6,
                              border: Border.all(
                                width: 1.0,
                                color: Theme.of(context).colorScheme.outline,
                              ),
                            ),
                          )
                        ]),
                      );
                    }
                  },
                ),
              )
            ]
          ],
        ),
      ),
    );
  }

  String getFormatTime(String time) {
    return "${time.substring(8, 10)}:${time.substring(10, 12)}";
  }
}

/// 헤더
class SearchTrainHeader extends StatelessWidget {
  const SearchTrainHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      child: Stack(
        children: <Widget>[
          Align(
              alignment: Alignment.center,
              child: NotoSansText(
                text: "기차 조회",
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

/// 조회 정보 위젯
class SearchInfoWidget extends StatelessWidget {
  const SearchInfoWidget({super.key, required this.result});
  final Map<String, dynamic> result;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding:
              const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 12),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Provider.of<ThemeProvider>(context).isDarkMode()
                  ? clr_313740
                  : clr_f8f8f8,
              border: Border.all(
                  width: 1.0, color: Theme.of(context).colorScheme.secondary)),
          child: Column(children: [
            NotoSansText(
              text: "${result["startStation"]} → ${result["finishStation"]} ",
              textSize: 22,
              textColor: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.w700,
            ),
            const SizedBox(
              height: 16,
            ),
            Container(
              width: double.infinity,
              height: 1,
              color: Theme.of(context).colorScheme.secondary,
            ),
            const SizedBox(height: 12),
            NotoSansText(
              text: "총 인원수 ${result["selectPeople"]}",
              textColor: Provider.of<ThemeProvider>(context).isDarkMode()
                  ? clr_AEB4C8
                  : clr_888888,
            )
          ]),
        ),
        const SizedBox(
          height: 40,
        ),
        NotoSansText(
          text: result["selectedDay"],
          fontWeight: FontWeight.w500,
          textColor: Theme.of(context).colorScheme.onTertiaryContainer,
        ),
        const SizedBox(
          height: 20,
        ),
        Container(
          width: double.infinity,
          height: 1,
          color: Provider.of<ThemeProvider>(context).isDarkMode()
              ? clr_434654
              : clr_2C3548,
        ),
      ],
    );
  }
}

/// 기차 없을때 표시 위젯
class NoSearchTrainList extends StatelessWidget {
  const NoSearchTrainList({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      SizedBox(
        width: 80,
        height: 80,
        child: Image.asset(Provider.of<ThemeProvider>(context).isDarkMode()
            ? AppImages.IMAGE_ERROR_DARK
            : AppImages.IMAGE_ERROR),
      ),
      const SizedBox(
        height: 16,
      ),
      const NotoSansText(
        text: "조회 가능한 기차가 없습니다.",
        textColor: clr_666666,
      )
    ]));
  }
}
