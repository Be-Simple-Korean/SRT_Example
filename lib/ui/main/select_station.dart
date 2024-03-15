import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:srt_ljh/common/colors.dart';
import 'package:srt_ljh/common/images.dart';
import 'package:srt_ljh/common/strings.dart';
import 'package:srt_ljh/ui/main/select_station_provider.dart';
import 'package:srt_ljh/ui/widget/common_button.dart';
import 'package:srt_ljh/ui/widget/notosans_text.dart';

/**
 * TODO
 * 1. 역 선택 전환
 * 2. 동일 역 선택 불가 처리
 * 3. 최근 검색 구간
 * 4. 역 선택한 결과 스왑
 * 
 *  */
/// 역 선택 화면
class SelectStation extends StatelessWidget {
  const SelectStation({super.key, required this.isStart});

  final bool isStart;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: ChangeNotifierProvider(
          create: (context) => SelectPlaceNotifier(),
          builder: (context, child) {
            return Column(
              children: [
                const Header(),
                const SizedBox(
                  height: 16,
                ),
                StationBar(
                  selected: isStart ? "출발" : "도착",
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
                  child: const NotoSansText(
                    text: "정차역",
                    textSize: 22,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  height: 14,
                ),
                Expanded(
                  // 여기에 Expanded 추가
                  child: ChangeNotifierProvider(
                    create: (context) => SelectStationNotifier(),
                    child: Stack(
                      children: [
                        const Positioned.fill(
                          child: SelectStationGridView(),
                        ),
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: Container(
                            height: 80,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  Colors.white,
                                  Colors.white.withOpacity(0.01),
                                ],
                                stops: const [0.9, 1.0],
                              ),
                            ),
                            child: Consumer<SelectStationNotifier>(
                              builder: (context, notifier, child) {
                                return Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: CommonButton(
                                    width: double.infinity,
                                    text: "선택완료",
                                    callback: () {
                                      context.pop(notifier.selectedStation);
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
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
          const Align(
              alignment: Alignment.center,
              child: NotoSansText(
                text: SELECT_STATION_TITLE,
                textColor: Colors.black,
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
                        child: Image.asset(AppImages.IMAGE_ICO_LINE_LEFT)),
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
  const StationBar({super.key, required this.selected});

  final String selected;

  @override
  State<StationBar> createState() => _StationBarState();
}

class _StationBarState extends State<StationBar> {
  String _selected = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selected = widget.selected;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      width: double.infinity,
      height: 102,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
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
                      if (_selected != "출발") {
                        setState(() {
                          _selected = "출발";
                        });
                        Provider.of<SelectPlaceNotifier>(context, listen: false)
                            .setPlace(PLACE.START);
                      }
                    },
                    child: NotoSansText(
                      text: MAIN_STATION_CHOICE_TITLE,
                      textColor: _selected == "출발" ? clr_476eff : clr_bbbbbb,
                      textSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              )),
          SizedBox(
              width: 48,
              height: 48,
              child: Image.asset(AppImages.IMAGE_ICO_CHANGE_DARK)),
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                NotoSansText(
                  text: MAIN_FINISH_STATION,
                  textColor: clr_bbbbbb,
                  textSize: 13,
                ),
                InkWell(
                  onTap: () {
                    if (_selected != "도착") {
                      setState(() {
                        _selected = "도착";
                      });
                      Provider.of<SelectPlaceNotifier>(context, listen: false)
                          .setPlace(PLACE.FINISH);
                    }
                  },
                  child: NotoSansText(
                    text: MAIN_STATION_CHOICE_TITLE,
                    textColor: _selected == "도착" ? clr_476eff : clr_bbbbbb,
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
      color: clr_f8f8f8,
      padding: const EdgeInsets.only(left: 24, top: 20),
      child: Column(children: [
        const Align(
            alignment: Alignment.centerLeft,
            child: NotoSansText(
                text: MAIN_RECENT_RESERVATION_TITLE,
                textColor: Colors.black,
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
          color: clr_f8f8f8,
          border: Border.all(color: clr_bbbbbb, width: 1.0),
          borderRadius: BorderRadius.circular(3)),
      child: const Center(
          child: NotoSansText(
        text: "수서 -> 동탄",
        textSize: 14,
        fontWeight: FontWeight.w500,
        textColor: clr_383b5a,
      )),
    );
  }
}

/// 역 선택 그리드 뷰
class SelectStationGridView extends StatefulWidget {
  const SelectStationGridView({super.key});

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
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            var data = snapshot.data;
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: GridView.builder(
                  itemCount: snapshot.data?.length ?? 0,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          selectedIndex = index;
                        });
                        Provider.of<SelectStationNotifier>(context,
                                listen: false)
                            .selectStation(data?[index]["stationNm"]);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: index == selectedIndex
                                ? Colors.blue
                                : Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: clr_cccccc)),
                        child: NotoSansText(
                          text: data?[index]["stationNm"] ?? "",
                          textSize: 13,
                          fontWeight: FontWeight.w500,
                          textColor: index == selectedIndex
                              ? Colors.white
                              : Colors.black,
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
}
