import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:srt_ljh/common/colors.dart';
import 'package:srt_ljh/common/constants.dart';
import 'package:srt_ljh/common/my_logger.dart';
import 'package:srt_ljh/common/strings.dart';
import 'package:srt_ljh/ui/dialog/select_time_provider.dart';
import 'package:srt_ljh/ui/widget/custom_button.dart';
import 'package:srt_ljh/ui/widget/notosans_text.dart';
import 'package:table_calendar/table_calendar.dart';

/// 팝업 노출
Future<DateTime?> showSelectDateDialog(BuildContext context, DateTime selectedDay) async {
  await initializeDateFormatting();
  if (context.mounted) {
    return showDialog<DateTime?>(
      barrierColor: Colors.black.withOpacity(0.7),
      context: context,
      builder: (BuildContext context) {
        return Align(
            alignment: Alignment.bottomCenter,
            child: ChangeNotifierProvider(
              create: (context) => SelectTimeNotifier(selectedDay.hour),
              child: SizedBox(
                height: 600,
                child: Dialog(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12.0),
                        topRight: Radius.circular(12.0)),
                  ),
                  insetPadding: const EdgeInsets.all(0),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12.0),
                          topRight: Radius.circular(12.0)),
                    ),
                    child: Column(children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 24, right: 19, top: 23),
                        child: Row(
                          children: [
                            const NotoSansText(
                              text: SELECT_DATE_TITLE,
                              textSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                            Spacer(),
                            InkWell(
                              onTap: () {
                                context.pop();
                              },
                              child: const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child:
                                      Icon(Icons.close, color: Colors.black)),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      SelectDate(
                          selectedDay: selectedDay,
                          callback: (_selectedDay) =>
                              selectedDay = _selectedDay),
                      const SizedBox(
                        height: 15,
                      ),
                      Container(
                        width: double.infinity,
                        height: 1,
                        color: clr_eeeeee,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Consumer<SelectTimeNotifier>(
                        builder: (context, value, child) {
                          return Container(
                            padding: const EdgeInsets.only(left: 24),
                            alignment: Alignment.topLeft,
                            child: NotoSansText(
                              text:
                                  "${value.selectedIndex.toString().padLeft(2, '0')}시 이후 출발",
                              textSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          );
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 24),
                        height: 39,
                        child: ListView.builder(
                          itemCount: 24,
                          clipBehavior: Clip.none,
                          itemBuilder: (context, index) {
                            return SelectTimeItem(
                              index: index,
                              callback: (hour) {
                                selectedDay = DateTime(selectedDay.year,
                                    selectedDay.month, selectedDay.day, hour);
                              },
                            );
                          },
                          scrollDirection: Axis.horizontal,
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Container(
                          margin: const EdgeInsets.symmetric(horizontal: 24),
                          child: CommonButton(
                            isEnabled: true,
                            width: double.infinity,
                            text: ALL_SELECT_ALL,
                            callback: () {
                              context.pop(selectedDay);
                            },
                          ))
                    ]),
                  ),
                ),
              ),
            ));
      },
    );
  }
  return null;
}

class SelectDate extends StatefulWidget {
  const SelectDate(
      {super.key, required this.selectedDay, required this.callback});

  final Function(DateTime) callback;
  final DateTime selectedDay;
  @override
  State<SelectDate> createState() => SelectDateState();
}

/// 달력
class SelectDateState extends State<SelectDate> {
  late DateTime _selectedDay;
  @override
  void initState() {
    super.initState();
    _selectedDay = widget.selectedDay;
  }

  @override
  Widget build(BuildContext context) {
    
    return Container(
      height: 313,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: TableCalendar(
        shouldFillViewport: true,
        locale: 'ko_KR',
        firstDay: DateTime.utc(DateTime.now().year, DateTime.now().month, 1),
        lastDay: DateTime.utc(
            DateTime.now().year, DateTime.now().month, DateTime.now().day + 30),
        focusedDay: _selectedDay,
        headerStyle: const HeaderStyle(
          titleCentered: true,
          formatButtonVisible: false,
          rightChevronPadding: EdgeInsets.all(0),
          rightChevronMargin: EdgeInsets.all(0),
          leftChevronMargin: EdgeInsets.all(0),
          leftChevronPadding: EdgeInsets.all(0),
          titleTextStyle: TextStyle(
              fontSize: 16.0,
              color: Colors.black,
              fontFamily: FONT_NOTOSANS,
              fontWeight: FontWeight.w500),
        ),
        daysOfWeekStyle: const DaysOfWeekStyle(
          // 요일 텍스트의 스타일을 조절
          weekdayStyle: TextStyle(
              fontSize: 13.0, // 글꼴 크기를 조절
              fontWeight: FontWeight.w500,
              color: Colors.black),
          weekendStyle: TextStyle(
              fontSize: 13.0, // 글꼴 크기를 조절
              fontWeight: FontWeight.w500,
              color: Colors.black),
        ),
        selectedDayPredicate: (day) {
          return isSameDay(day, _selectedDay);
        },
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
          });
          widget.callback(_selectedDay);
          MyLogger().d(
              "select - ${_selectedDay.year}.${_selectedDay.month}.$_selectedDay.day");
        },
        enabledDayPredicate: (day) {
          return !isBeforeToday(day);
        },
      ),
    );
  }

  // 이전 날짜 선택 불가
  bool isBeforeToday(DateTime day) {
    final now = DateTime.now();
    return day.isBefore(DateTime(now.year, now.month, now.day));
  }
}

/// 시간 선택 아이템
class SelectTimeItem extends StatelessWidget {
  const SelectTimeItem(
      {super.key, required this.index, required this.callback});

  final int index;
  final Function(int) callback;
  @override
  Widget build(BuildContext context) {
    return Consumer<SelectTimeNotifier>(builder: (context, notifier, child) {
      bool isSelected = notifier.selectedIndex == index;
      bool isLated = false;
      Color textColor;
      if (index < DateTime.now().hour) {
        textColor = clr_cccccc;
        isLated = true;
      } else {
        textColor = isSelected ? Colors.white : clr_050f26;
      }
      return InkWell(
        onTap: () {
          if (!isLated) {
            notifier.selectedIndex = index;
            callback(index);
          }
        },
        child: Container(
          height: 38,
          width: 58,
          decoration: BoxDecoration(
              color: isSelected ? clr_476eff : Colors.white,
              border: Border.all(color: clr_cccccc, width: 1.0),
              borderRadius: BorderRadius.circular(0)),
          margin: const EdgeInsets.only(right: 8),
          child: Center(
              child: NotoSansText(
            text: "${index.toString().padLeft(2, '0')}시",
            textSize: 14,
            textColor: textColor,
            fontWeight: FontWeight.w500,
          )),
        ),
      );
    });
  }
}
