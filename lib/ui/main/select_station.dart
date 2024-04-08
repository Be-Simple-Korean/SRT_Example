import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:srt_ljh/common/colors.dart';
import 'package:srt_ljh/common/images.dart';
import 'package:srt_ljh/common/strings.dart';
import 'package:srt_ljh/common/theme_provider.dart';
import 'package:srt_ljh/ui/main/provider/select_station_provider.dart';
import 'package:srt_ljh/ui/widget/custom_button.dart';
import 'package:srt_ljh/ui/widget/custom_dialog.dart';
import 'package:srt_ljh/ui/widget/notosans_text.dart';

/**
 * TODO 최근 검색 구간
 * 
 *  */
/// 역 선택 화면
class SelectStation extends StatefulWidget {
  const SelectStation({super.key, required this.extras});

  final Map<String, dynamic> extras;

  @override
  State<SelectStation> createState() => _SelectStationState();
}

class _SelectStationState extends State<SelectStation> {
  bool _isStart = false;
  bool isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _isStart = widget.extras["isStart"];
    if (widget.extras["startStation"] != SELECT_STATION_DEFAULT &&
        widget.extras["finishStation"] != SELECT_STATION_DEFAULT) {
      isButtonEnabled = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: ChangeNotifierProvider(
          create: (context) => SelectPlaceNotifier(
              widget.extras["startStation"], widget.extras["finishStation"]),
          builder: (context, child) {
            return Column(
              children: [
                const Header(),
                Expanded(
                  child: Stack(children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 64),
                      child: SingleChildScrollView(
                        child: Column(children: [
                          const SizedBox(
                            height: 16,
                          ),
                          StationBar(
                            selected: _isStart
                                ? SELECT_STATION_START
                                : SELECT_STATION_FINISH,
                            changeState: (isStart) {
                              _isStart = isStart;
                              Provider.of<SelectPlaceNotifier>(context,
                                      listen: false)
                                  .resetIndex();
                            },
                          ),
                          const SizedBox(
                            height: 32,
                          ),
                          const RecentReservation(),
                          const SizedBox(
                            height: 32,
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.only(left: 24),
                            child: NotoSansText(
                              text: SELECT_STATION_LIST_TITLE,
                              textSize: 22,
                              fontWeight: FontWeight.w500,
                              textColor:
                                  Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(
                            height: 14,
                          ),
                          SelectStationGridView(
                            stationCallback: (station) {
                              if (_isStart) {
                                Provider.of<SelectPlaceNotifier>(context,
                                        listen: false)
                                    .setStartStation(station);
                              } else {
                                Provider.of<SelectPlaceNotifier>(context,
                                        listen: false)
                                    .setFinishStation(station);
                              }
                              bool isComplete =
                                  Provider.of<SelectPlaceNotifier>(context,
                                          listen: false)
                                      .getCheckCompleteStation();
                              if (isComplete) {
                                setState(() {
                                  isButtonEnabled = true;
                                });
                              }
                            },
                          ),
                        ]),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 80,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Provider.of<ThemeProvider>(context, listen: false)
                                      .isDarkMode()
                                  ? clr_22242a
                                  : Colors.white,
                              Provider.of<ThemeProvider>(context, listen: false)
                                      .isDarkMode()
                                  ? clr_22242a.withOpacity(0.01)
                                  : Colors.white.withOpacity(0.01),
                            ],
                            stops: const [0.7, 1.0],
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: CommonButton(
                            width: double.infinity,
                            text: SELECT_STATION_COMPLETE,
                            isEnabled: isButtonEnabled,
                            callback: () {
                              context.pop({
                                SELECT_STATION_START: Provider.of<SelectPlaceNotifier>(context,listen: false).getStartStationInfo,
                                SELECT_STATION_FINISH: Provider.of<SelectPlaceNotifier>(context,listen: false).getFinishStationInfo
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ]),
                ),
              ],
            );
          }),
    ));
  }
}

/// 헤더
class Header extends StatelessWidget {
  const Header({super.key});

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
            child: GestureDetector(
              onTap: () {
                context.pop();
              },
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
                                child:
                                    Image.asset(AppImages.IMAGE_ICO_LINE_LEFT))
                            : Image.asset(AppImages.IMAGE_ICO_LINE_LEFT)),
                  )),
            ),
          ),
        ],
      ),
    );
  }
}

/// 역 선택 위젯
class StationBar extends StatefulWidget {
  const StationBar(
      {super.key, required this.selected, required this.changeState});

  final String selected;
  final Function(bool) changeState;
  @override
  State<StationBar> createState() => _StationBarState();
}

class _StationBarState extends State<StationBar> {
  String _selected = "";
  @override
  void initState() {
    super.initState();
    _selected = widget.selected;
  }

  @override
  Widget build(BuildContext context) {
    String selectedStartStation =
        Provider.of<SelectPlaceNotifier>(context).getStartStationName;
    String selectedFinishStation =
        Provider.of<SelectPlaceNotifier>(context).getFinishStationName;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      width: double.infinity,
      height: 102,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
            width: Provider.of<ThemeProvider>(context).isDarkMode() ? 1.0 : 0.0,
            color: Provider.of<ThemeProvider>(context).isDarkMode()
                ? clr_434654
                : Colors.transparent),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            offset: const Offset(0, 4),
            blurRadius: 24,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const NotoSansText(
                    text: MAIN_START_STATION,
                    textColor: clr_bbbbbb,
                    textSize: 13,
                  ),
                  InkWell(
                    onTap: () {
                      if (_selected != SELECT_STATION_START) {
                        setState(() {
                          _selected = SELECT_STATION_START;
                        });
                        widget.changeState(true);
                      }
                    },
                    child: NotoSansText(
                      text: selectedStartStation,
                      textColor: _selected == SELECT_STATION_START
                          ? clr_476eff
                          : Theme.of(context).colorScheme.onTertiary,
                      textSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              )),
          InkWell(
            onTap: () {
              if (selectedStartStation != SELECT_STATION_DEFAULT &&
                  selectedFinishStation != SELECT_STATION_DEFAULT) {
                Provider.of<SelectPlaceNotifier>(context, listen: false)
                    .swapStation();
              }
            },
            child: SizedBox(
                width: 48,
                height: 48,
                child: Image.asset(AppImages.IMAGE_ICO_CHANGE_DARK)),
          ),
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const NotoSansText(
                  text: MAIN_FINISH_STATION,
                  textColor: clr_bbbbbb,
                  textSize: 13,
                ),
                InkWell(
                  onTap: () {
                    if (_selected != SELECT_STATION_FINISH) {
                      setState(() {
                        _selected = SELECT_STATION_FINISH;
                      });
                      widget.changeState(false);
                    }
                  },
                  child: NotoSansText(
                    text: selectedFinishStation,
                    textColor: _selected == SELECT_STATION_FINISH
                        ? clr_476eff
                        : Theme.of(context).colorScheme.onTertiary,
                    textSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 최근 예매 구간 위젯
class RecentReservation extends StatelessWidget {
  const RecentReservation({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 102,
      color: Theme.of(context).colorScheme.tertiaryContainer,
      padding: const EdgeInsets.only(left: 24, top: 20),
      child: Column(children: [
        Align(
            alignment: Alignment.centerLeft,
            child: NotoSansText(
                text: MAIN_RECENT_RESERVATION_TITLE,
                textColor: Theme.of(context).colorScheme.onTertiaryContainer,
                fontWeight: FontWeight.w500,
                textSize: 14)),
        const SizedBox(height: 4),
        SizedBox(
          height: 38, // 원하는 높이로 설정
          child: ListView.builder(
            clipBehavior: Clip.none,
            scrollDirection: Axis.horizontal,
            itemCount: 4,
            itemBuilder: (context, index) {
              return const RecentReservationItem();
            },
          ),
        )
      ]),
    );
  }
}

/// 최근 예매 아이템
class RecentReservationItem extends StatelessWidget {
  const RecentReservationItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 38,
      padding: const EdgeInsets.only(left: 14, right: 13),
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.outlineVariant,
          border: Border.all(
              color: Theme.of(context).colorScheme.outline, width: 1.0),
          borderRadius: BorderRadius.circular(3)),
      child: Center(
          child: NotoSansText(
        text: "수서 -> 동탄",
        textSize: 14,
        fontWeight: FontWeight.w500,
        textColor: Provider.of<ThemeProvider>(context).isDarkMode()
            ? clr_dedede
            : clr_383b5a,
      )),
    );
  }
}

/// 역 선택 그리드 뷰
class SelectStationGridView extends StatefulWidget {
  const SelectStationGridView({super.key, required this.stationCallback});

  final Function(Map<String, dynamic>) stationCallback;
  @override
  State<SelectStationGridView> createState() => _SelectStationGridViewState();
}

class _SelectStationGridViewState extends State<SelectStationGridView> {
  int selectedIndex = -1;
  Future<List<dynamic>>? myFuture;
  @override
  void initState() {
    super.initState();
    myFuture = readJsonFile();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
        future: myFuture,
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            var data = snapshot.data;
            selectedIndex =
                Provider.of<SelectPlaceNotifier>(context).selectedIndex;
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data?.length ?? 0,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () async {
                        String station = data?[index]["stationNm"];
                        bool isSame = await getCompareStation(context, station);
                        if (isSame) {
                          if (mounted) {
                            CommonDialog.showErrDialog(
                                context,
                                SELECT_STATION_SELECT_ERROR_MESSAGE,
                                "",
                                ALL_CONFIRM);
                          }
                          return;
                        }
                        if (mounted) {
                          Provider.of<SelectPlaceNotifier>(context,
                                  listen: false)
                              .selectIndex(index);
                          widget.stationCallback(data?[index]);
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: index == selectedIndex
                                ? clr_476eff
                                : Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: Theme.of(context).colorScheme.outline,
                                width: 1.0)),
                        child: NotoSansText(
                          text: data?[index]["stationNm"] ?? "",
                          textSize: 13,
                          fontWeight: FontWeight.w500,
                          textColor: index == selectedIndex
                              ? Colors.white
                              : Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    );
                  },
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 151 / 52,
                    crossAxisSpacing: 10.0, // 아이템 간 가로 간격
                    mainAxisSpacing: 10.0, // 아이템 간 세로 간격),
                  )),
            );
          } else {
            return CircularProgressIndicator();
          }
        }));
  }

  Future<List<dynamic>> readJsonFile() async {
    // 파일 읽기
    final String response = await rootBundle.loadString('assets/stations.json');
    // JSON 변환
    final data = await json.decode(response);
    return data;
  }

  Future<bool> getCompareStation(BuildContext context, String station) async {
    String selectedStartStation =
        Provider.of<SelectPlaceNotifier>(context, listen: false).getStartStationName;
    if (selectedStartStation == station) {
      return true;
    } else {
      return false;
    }
  }
}
