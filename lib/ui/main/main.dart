import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:srt_ljh/common/colors.dart';
import 'package:srt_ljh/common/images.dart';
import 'package:srt_ljh/common/strings.dart';
import 'package:srt_ljh/common/utils.dart';
import 'package:srt_ljh/ui/widget/common_button.dart';
import 'package:srt_ljh/ui/widget/notosans_text.dart';

/// 메인 화면
class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(children: [
            const MainHeader(),
            const SizedBox(
              height: 16,
            ),
            const StationBar(),
            const SizedBox(
              height: 20,
            ),
            const RecentReservation(),
            const SizedBox(
              height: 20,
            ),
            SelectTrainCondition(
                title: MAIN_SELECT_DATE_TITLE,
                defaultData: getDataForTrain("2023", "10", "16", "월", "06")),
            const SizedBox(
              height: 12,
            ),
            const SelectTrainCondition(
                title: MAIN_SELECT_PEOPLE_TITLE, defaultData: "1명"),
            const SizedBox(
              height: 24,
            ),
            const CommonButton(width: double.infinity, text: MAIN_SEARCH_TRAIN),
            const SizedBox(
              height: 48,
            ),
            Row(
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: Image.asset(AppImages.IMAGE_ICO_BELL),
                ),
                SizedBox(
                  width: 8,
                ),
                const NotoSansText(
                  text: "철도노조 태업 관련 이용 안내 (22.11.24)",
                  fontWeight: FontWeight.w500,
                  textSize: 14,
                ),
                const Spacer(),
                SizedBox(
                  width: 20,
                  height: 20,
                  child: Image.asset(AppImages.IMAGE_ICO_ARROW_RIGHT),
                ),
              ],
            )
          ]),
        ),
      ),
    );
  }
}

/// 메인화면 헤더
class MainHeader extends StatelessWidget {
  const MainHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 0),
      child: Row(
        children: [
          Container(
            height: 60,
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.only(top: 21.0, left: 4.00),
            child: Image.asset(AppImages.IMAGE_IMG_MAIN_LOGO),
          ),
          const Spacer(),
          const HeaderIconWithText(
            isNew: false,
            imgPath: AppImages.IMAGE_ICO_ALARM,
            title: MAIN_ARLAM,
            marginRight: 8.0,
          ),
          const HeaderIconWithText(
              isNew: false,
              imgPath: AppImages.IMAGE_ICO_TICKET,
              title: MAIN_MY_TICKET,
              marginRight: 0.0)
        ],
      ),
    );
  }
}

/// 메인화면 헤더 우측 ui
class HeaderIconWithText extends StatelessWidget {
  const HeaderIconWithText(
      {super.key,
      required this.isNew,
      required this.imgPath,
      required this.title,
      required this.marginRight});

  final bool isNew;
  final String imgPath;
  final String title;
  final double marginRight;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 21.0, right: marginRight),
      width: 60,
      height: 60,
      padding: const EdgeInsets.only(bottom: 4),
      child: Column(children: [
        Container(
          height: 34,
          padding: const EdgeInsets.only(right: 10, left: 16),
          child: Stack(
            children: [
              Positioned(
                left: 0,
                bottom: 0,
                child: SizedBox(
                  width: 28,
                  height: 28,
                  child: Image.asset(imgPath),
                ),
              ),
              if (isNew)
                Positioned(
                  right: 0,
                  top: 0,
                  child: SizedBox(
                    width: 18,
                    height: 18,
                    child: Image.asset(AppImages.IMAGE_ICO_NEW),
                  ),
                ),
            ],
          ),
        ),
        const Spacer(),
        NotoSansText(
          text: title,
          textSize: 12,
          fontWeight: FontWeight.bold,
        )
      ]),
    );
  }
}

/// 역 선택 위젯
class StationBar extends StatefulWidget {
  const StationBar({super.key});

  @override
  State<StationBar> createState() => _StationBarState();
}

class _StationBarState extends State<StationBar> {
  String startStation = "";
  String finishStation = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0),
      width: double.infinity,
      height: 102,
      decoration: BoxDecoration(
        color: clr_3d4964,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
              flex: 1,
              child: InkWell(
                onTap: () {
                  moveToSelectStation(context, true);
                },
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    NotoSansText(
                      text: MAIN_START_STATION,
                      textColor: clr_bbbbbb,
                      textSize: 13,
                    ),
                    NotoSansText(
                      text: MAIN_STATION_CHOICE_TITLE,
                      textColor: Colors.white,
                      textSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ),
              )),
          SizedBox(
              width: 48,
              height: 48,
              child: Image.asset(AppImages.IMAGE_ICO_CHANGE)),
          Expanded(
            flex: 1,
            child: InkWell(
              onTap: () {
                moveToSelectStation(context, false);
              },
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  NotoSansText(
                    text: MAIN_FINISH_STATION,
                    textColor: clr_bbbbbb,
                    textSize: 13,
                  ),
                  NotoSansText(
                    text: MAIN_STATION_CHOICE_TITLE,
                    textColor: Colors.white,
                    textSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void moveToSelectStation(BuildContext context, bool isStart) async {
    var result = await context.push(getRoutePath([ROUTER_SELECT_STATION_PATH]),
        extra: isStart) as Map<String, dynamic>?;
    if (result == null) {
      return;
    }
    startStation = result[SELECT_STATION_START];
    finishStation = result[SELECT_STATION_FINISH];
  }
}

/// 최근 예매 구간 위젯
class RecentReservation extends StatelessWidget {
  const RecentReservation({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const Align(
          alignment: Alignment.centerLeft,
          child: NotoSansText(
              text: MAIN_RECENT_RESERVATION_TITLE,
              textColor: clr_888888,
              textSize: 14)),
      const SizedBox(height: 8),
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
    ]);
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
      margin: const EdgeInsets.only(right: 6),
      color: clr_eff0f5,
      child: const Center(
          child: NotoSansText(
        text: "수서 -> 동탄",
        textSize: 14,
        fontWeight: FontWeight.w500,
        textColor: clr_494f60,
      )),
    );
  }
}

/// 날짜, 인원수 선택 위젯
class SelectTrainCondition extends StatelessWidget {
  const SelectTrainCondition(
      {super.key, this.title = "", this.defaultData = ""});

  final String title;
  final String defaultData;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 62,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: clr_eeeeee, width: 1.0),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.only(left: 20, right: 22),
      width: double.infinity,
      child: Row(children: [
        NotoSansText(
          text: title,
          textColor: clr_888888,
        ),
        const Spacer(),
        NotoSansText(
          text: defaultData,
        )
      ]),
    );
  }
}
