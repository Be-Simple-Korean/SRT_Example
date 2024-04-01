import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:srt_ljh/common/colors.dart';
import 'package:srt_ljh/common/constants.dart';
import 'package:srt_ljh/common/images.dart';
import 'package:srt_ljh/common/my_logger.dart';
import 'package:srt_ljh/common/strings.dart';
import 'package:srt_ljh/common/utils.dart';
import 'package:srt_ljh/model/base_response.dart';
import 'package:srt_ljh/ui/dialog/select_date_dialog.dart';
import 'package:srt_ljh/ui/dialog/select_people_dialog.dart';
import 'package:srt_ljh/ui/main/main_viewmodel.dart';
import 'package:srt_ljh/ui/widget/custom_button.dart';
import 'package:srt_ljh/ui/widget/custom_dialog.dart';
import 'package:srt_ljh/ui/widget/notosans_text.dart';
import 'package:url_launcher/url_launcher.dart';

enum ThemeMode { SYSTEM, LIGHT, DARK }

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mainViewmodel = Provider.of<MainViewModel>(context, listen: false);

    return SafeArea(
      child: Main(mainViewmodel: mainViewmodel),
    );
  }
}

/// 메인 화면
class Main extends StatefulWidget {
  const Main({
    super.key,
    required this.mainViewmodel,
  });
  final MainViewModel mainViewmodel;
  @override
  State<Main> createState() => _MainScreenState();
}

class _MainScreenState extends State<Main> {
  late Future<void> myFuture;
  Map<String, dynamic> noticeMap = {};
  List<dynamic> bannerList = [];
  late GlobalKey<ScaffoldState> scaffoldKey;
  ThemeMode currentMode = ThemeMode.DARK;

  @override
  void initState() {
    myFuture = widget.mainViewmodel.requestSrtInfo();
    scaffoldKey = GlobalKey<ScaffoldState>();
    super.initState();
  }

  /// main 결과 처리
  Future<void> handleMainResult(
      BuildContext context, BaseResponse result) async {
    switch (result.code) {
      case 0:
        if (result.message == SUCCESS_MESSAGE) {
          List<dynamic> notices = result.data?["noticeList"];
          if (notices.isNotEmpty) {
            noticeMap = notices[0];
          }
          bannerList = result.data?["bannerList"];
        } else {
          CommonDialog.showErrDialog(context, "실패", "", "확인");
        }
        break;
      case 10:
        CommonDialog.showErrDialog(
            context, "필수 Parameter(deviceId)가 없습니다", "", "확인");
        break;
      default:
        CommonDialog.showErrDialog(context, "실패", "", "확인");
        break;
    }
  }

  void _launchURL(String url) async {
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $uri';
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return FutureBuilder(
      future: myFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            var result = snapshot.data as BaseResponse;
            handleMainResult(context, result);
          }
          var selectDecoration = BoxDecoration(
              color: clr_313740,
              borderRadius: BorderRadius.circular(11),
              border: Border.all(width: 1.0, color: clr_434654));
          return Scaffold(
            key: scaffoldKey,
            drawer: Drawer(
              width: 250,
              child: Padding(
                padding: const EdgeInsets.only(top: 73, left: 28,bottom: 40,right: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 135,
                      height: 22,
                      child: Theme.of(context).brightness == Brightness.dark
                          ? ColorFiltered(
                              colorFilter: const ColorFilter.mode(
                                  Colors.white, BlendMode.srcIn),
                              child: Image.asset(AppImages.IMAGE_IMG_MAIN_LOGO))
                          : Image.asset(AppImages.IMAGE_IMG_MAIN_LOGO),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    NotoSansText(
                      text: "다크모드",
                      fontWeight: FontWeight.w500,
                      textColor: Theme.of(context).colorScheme.onSurface,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                        width: 194,
                        height: 41,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Theme.of(context).colorScheme.surfaceTint,
                            border: Border.all(
                                width: isDark ? 1.0 : 0.0, color: clr_434654)),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: InkWell(
                                  onTap: () {
                                    if (currentMode != ThemeMode.SYSTEM) {
                                      setState(() {
                                        currentMode = ThemeMode.SYSTEM;
                                      });
                                    }
                                  },
                                  child: Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 4, vertical: 3),
                                    decoration: currentMode == ThemeMode.SYSTEM
                                        ? selectDecoration
                                        : null,
                                    alignment: Alignment.center,
                                    child: NotoSansText(
                                      text: "시스템",
                                      textColor: Colors.white,
                                    ),
                                  )),
                            ),
                            Expanded(
                              flex: 1,
                              child: InkWell(
                                  onTap: () {
                                    if (currentMode != ThemeMode.LIGHT) {
                                      setState(() {
                                        currentMode = ThemeMode.LIGHT;
                                      });
                                    }
                                  },
                                  child: Container(
                                    decoration: currentMode == ThemeMode.LIGHT
                                        ? selectDecoration
                                        : null,
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 4, vertical: 3),
                                    alignment: Alignment.center,
                                    child: NotoSansText(
                                      text: "라이트",
                                      textColor: Colors.white,
                                    ),
                                  )),
                            ),
                            Expanded(
                              flex: 1,
                              child: InkWell(
                                onTap: () {
                                  if (currentMode != ThemeMode.DARK) {
                                    setState(() {
                                      currentMode = ThemeMode.DARK;
                                    });
                                  }
                                },
                                child: Container(
                                  decoration: currentMode == ThemeMode.DARK
                                      ? selectDecoration
                                      : null,
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 4, vertical: 3),
                                  alignment: Alignment.center,
                                  child: NotoSansText(
                                    text: "다크",
                                    textColor: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )),
                    const Expanded(
                        child: Align(
                            alignment: Alignment.bottomRight,
                            child: NotoSansText(
                              text: "로그아웃",
                              textColor: clr_727b90,
                              fontWeight: FontWeight.w500,
                              textSize: 20,
                            )))
                  ],
                ),
              ),
            ),
            body: SingleChildScrollView(
              child: Column(children: [
                MainHeader(
                  callback: () {
                    scaffoldKey.currentState?.openDrawer();
                  },
                ),
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
                    defaultData: getDataForTrain(DateTime.now())),
                const SizedBox(
                  height: 12,
                ),
                const SelectTrainCondition(
                    title: MAIN_SELECT_PEOPLE_TITLE,
                    defaultData: MAIN_DEFAULT_PEOPLE),
                const SizedBox(
                  height: 24,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: CommonButton(
                      isEnabled: widget.mainViewmodel.isButtonEnabled,
                      width: double.infinity,
                      text: MAIN_SEARCH_TRAIN),
                ),
                const SizedBox(
                  height: 48,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: InkWell(
                    onTap: () => _launchURL(noticeMap["linkUrl"]),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: isDark
                              ? ColorFiltered(
                                  colorFilter: const ColorFilter.mode(
                                      Colors.white, BlendMode.srcIn),
                                  child: Image.asset(AppImages.IMAGE_ICO_BELL))
                              : Image.asset(AppImages.IMAGE_ICO_BELL),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        NotoSansText(
                          text: noticeMap["title"],
                          fontWeight: FontWeight.w500,
                          textColor: Theme.of(context).colorScheme.onSurface,
                          textSize: 14,
                        ),
                        const Spacer(),
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: isDark
                              ? ColorFiltered(
                                  colorFilter: const ColorFilter.mode(
                                      Colors.white, BlendMode.srcIn),
                                  child: Image.asset(
                                      AppImages.IMAGE_ICO_ARROW_RIGHT))
                              : Image.asset(AppImages.IMAGE_ICO_ARROW_RIGHT),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                AutoScrollBanner(bannerList: bannerList),
                const SizedBox(
                  height: 46,
                ),
                InkWell(
                  onTap: () {
                    _launchURL(MAIN_RESERVATION_SERVICE_TERMS_URL);
                  },
                  child: const NotoSansText(
                    text: MAIN_RESERVATION_SERVICE_TERMS_TITLE,
                    isHaveUnderline: true,
                    textSize: 12,
                    textColor: clr_666666,
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Container(
                  color: clr_f8f8f8,
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  child: const NotoSansText(
                    text: MAIN_SELLER_GUIDE,
                    textSize: 11,
                    textColor: clr_888888,
                    lineHeight: 14,
                    textAlign: TextAlign.center,
                  ),
                )
              ]),
            ),
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}

/// 메인화면 헤더
class MainHeader extends StatelessWidget {
  const MainHeader({super.key, required this.callback});

  final Function() callback;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              callback.call();
            },
            child: Container(
              height: 60,
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(top: 21.0, left: 4.00),
              child: Theme.of(context).brightness == Brightness.dark
                  ? ColorFiltered(
                      colorFilter:
                          const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                      child: Image.asset(AppImages.IMAGE_IMG_MAIN_LOGO))
                  : Image.asset(AppImages.IMAGE_IMG_MAIN_LOGO),
            ),
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
    bool isDark = Theme.of(context).brightness == Brightness.dark;
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
                  child: isDark
                      ? ColorFiltered(
                          colorFilter: const ColorFilter.mode(
                              Colors.white, BlendMode.srcIn),
                          child: Image.asset(imgPath))
                      : Image.asset(imgPath),
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
          textColor: Theme.of(context).colorScheme.onPrimary,
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
  String startStation = SELECT_STATION_DEFAULT;
  String finishStation = SELECT_STATION_DEFAULT;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      width: double.infinity,
      height: 102,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
            color: clr_434654,
            width: Theme.of(context).brightness == Brightness.dark ? 1.0 : 0.0),
      ),
      child: Row(
        children: [
          Expanded(
              flex: 1,
              child: InkWell(
                onTap: () {
                  moveToSelectStation(context, true);
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    NotoSansText(
                      text: MAIN_START_STATION,
                      textColor:
                          Theme.of(context).colorScheme.onPrimaryContainer,
                      textSize: 13,
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    NotoSansText(
                      text: startStation,
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
              child: InkWell(
                  onTap: () {
                    if (startStation != SELECT_STATION_DEFAULT &&
                        finishStation != SELECT_STATION_DEFAULT) {
                      setState(() {
                        var temp = startStation;
                        startStation = finishStation;
                        finishStation = temp;
                      });
                    }
                  },
                  child: Image.asset(AppImages.IMAGE_ICO_CHANGE))),
          Expanded(
            flex: 1,
            child: InkWell(
              onTap: () {
                moveToSelectStation(context, false);
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  NotoSansText(
                    text: MAIN_FINISH_STATION,
                    textColor: Theme.of(context).colorScheme.onPrimaryContainer,
                    textSize: 13,
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  NotoSansText(
                    text: finishStation,
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
    Map<String, dynamic> extras = {
      "isStart": isStart,
      "startStation": startStation,
      "finishStation": finishStation
    };
    var result = await context.push(
        getRoutePath([ROUTER_MAIN_PATH, ROUTER_SELECT_STATION_PATH]),
        extra: extras) as Map<String, dynamic>?;
    if (result == null) {
      return;
    }
    setState(() {
      startStation = result[SELECT_STATION_START];
      finishStation = result[SELECT_STATION_FINISH];
    });
    if (mounted) {
      Provider.of<MainViewModel>(context, listen: false)
          .setStartPlace(startStation);
      Provider.of<MainViewModel>(context, listen: false)
          .setFinishPlace(finishStation);
    }
  }
}

/// 최근 예매 구간 위젯
class RecentReservation extends StatelessWidget {
  const RecentReservation({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24),
      child: Column(children: [
        Align(
            alignment: Alignment.centerLeft,
            child: NotoSansText(
                text: MAIN_RECENT_RESERVATION_TITLE,
                textColor: Theme.of(context).colorScheme.onSecondary,
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
      margin: const EdgeInsets.only(right: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
        border: Border.all(
            color: clr_434654,
            width: Theme.of(context).brightness == Brightness.dark ? 1.0 : 0.0),
      ),
      child: Center(
          child: NotoSansText(
        text: "수서 -> 동탄",
        textSize: 14,
        fontWeight: FontWeight.w500,
        textColor: Theme.of(context).colorScheme.onSecondaryContainer,
      )),
    );
  }
}

/// 날짜, 인원수 선택 위젯
class SelectTrainCondition extends StatefulWidget {
  const SelectTrainCondition(
      {super.key, this.title = "", this.defaultData = ""});

  final String title;
  final String defaultData;

  @override
  State<SelectTrainCondition> createState() => _SelectTrainConditionState();
}

class _SelectTrainConditionState extends State<SelectTrainCondition> {
  late String text;
  late bool isSelectDate;
  late DateTime? selectedDay;
  @override
  void initState() {
    text = widget.defaultData;
    isSelectDate = widget.title == MAIN_SELECT_DATE_TITLE;
    selectedDay = DateTime.now();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: InkWell(
        onTap: () async {
          if (isSelectDate) {
            selectedDay = await showSelectDateDialog(context, selectedDay!);
            if (selectedDay != null) {
              setState(() {
                text = getDataForTrain(selectedDay!);
              });
              if (mounted) {
                Provider.of<MainViewModel>(context, listen: false)
                    .setSelectedDay(selectedDay!);
              }
            }
          } else {
            var people = await showSelectPeopleDialog(
                context, int.parse(text.substring(0, 1)) - 1);
            if (people != null) {
              setState(() {
                text = people;
              });
              if (mounted) {
                Provider.of<MainViewModel>(context, listen: false)
                    .setSelectedPeople(people);
              }
            }
          }
        },
        child: Container(
          height: 62,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            border: Border.all(
                color: Theme.of(context).colorScheme.secondary, width: 1.0),
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.only(left: 20, right: 22),
          width: double.infinity,
          child: Row(children: [
            NotoSansText(
              text: widget.title,
              textColor: clr_888888,
            ),
            const Spacer(),
            NotoSansText(
              text: isSelectDate ? text : "총 $text",
              textColor: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            )
          ]),
        ),
      ),
    );
  }
}

/// 배너
class AutoScrollBanner extends StatefulWidget {
  const AutoScrollBanner({super.key, required this.bannerList});

  final List<dynamic> bannerList;
  @override
  State<AutoScrollBanner> createState() => _AutoScrollBannerState();
}

class _AutoScrollBannerState extends State<AutoScrollBanner> {
  final PageController _pageController = PageController();
  Timer? _timer;
  int _currentPage = 0;

  void _resetTimer() {
    if (widget.bannerList.length > 1) {
      _timer?.cancel();
      _timer = Timer.periodic(Duration(seconds: 10), (Timer timer) {
        _currentPage++;
        _pageController.animateToPage(
          _currentPage,
          duration: Duration(milliseconds: 350),
          curve: Curves.easeIn,
        );
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _resetTimer();
    _pageController.addListener(() {
      int nextPage = _pageController.page!.round();
      if (_currentPage != nextPage && widget.bannerList.length > 1) {
        _resetTimer();
        setState(() {
          _currentPage = nextPage;
        });
        MyLogger().d("현재 페이지: $_currentPage");
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 24, right: 21),
            child: SizedBox(
              width: double.infinity,
              height: 140,
              child: PageView.builder(
                controller: _pageController,
                itemBuilder: (context, index) {
                  var url = (widget.bannerList[index % widget.bannerList.length]
                      as Map<String, dynamic>)["imgUrl"];
                  return CachedNetworkImage(
                    imageUrl: BASE_URL + url,
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
          ),
          const SizedBox(
            height: 14,
          ),
          CustomIndicator(
              currentIndex: _currentPage % widget.bannerList.length,
              count: widget.bannerList.length)
        ],
      ),
      if (widget.bannerList.length > 1) ...[
        Positioned(
          top: 58,
          left: 16,
          child: InkWell(
              onTap: () {
                _pageController.animateToPage(
                  _currentPage - 1,
                  duration: const Duration(milliseconds: 350),
                  curve: Curves.easeIn,
                );
              },
              child: const BannerImageButton(
                isLeft: true,
              )),
        ),
        Positioned(
          top: 58,
          right: 16,
          child: InkWell(
              onTap: () {
                _pageController.animateToPage(
                  _currentPage + 1,
                  duration: const Duration(milliseconds: 350),
                  curve: Curves.easeIn,
                );
              },
              child: const BannerImageButton(
                isLeft: false,
              )),
        ),
      ]
    ]);
  }
}

/// 배너 옆 사이드 버튼
class BannerImageButton extends StatelessWidget {
  const BannerImageButton({super.key, required this.isLeft});

  final bool isLeft;
  @override
  Widget build(BuildContext context) {
    var image = Theme.of(context).brightness == Brightness.dark
        ? ColorFiltered(
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            child: Image.asset(isLeft
                ? AppImages.IMAGE_ARROW_LEFT
                : AppImages.IMAGE_ARROW_RIGHT))
        : isLeft
            ? Image.asset(AppImages.IMAGE_ARROW_LEFT)
            : Image.asset(AppImages.IMAGE_ARROW_LEFT);
    return Container(
        width: 24,
        height: 24,
        padding: EdgeInsets.only(left: isLeft ? 0 : 10, right: isLeft ? 10 : 0),
        alignment: isLeft ? Alignment.centerRight : Alignment.centerLeft,
        decoration: BoxDecoration(
            color: clr_797979.withOpacity(0.12),
            borderRadius: BorderRadius.circular(12.0)),
        child: SizedBox(width: 6, height: 10, child: image));
  }
}

/// 배너 인디케이터
class CustomIndicator extends StatelessWidget {
  const CustomIndicator(
      {super.key, required this.currentIndex, required this.count});

  final int currentIndex;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(count, (idx) {
        return Container(
          width: idx == currentIndex ? 16.0 : 6.0,
          height: 6.0,
          margin: const EdgeInsets.symmetric(horizontal: 3.0),
          decoration: BoxDecoration(
            color: idx == currentIndex ? clr_383b5a : clr_dddddd,
            borderRadius: BorderRadius.circular(6.0),
          ),
        );
      }),
    );
  }
}
