import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:srt_ljh/common/colors.dart';
import 'package:srt_ljh/common/strings.dart';
import 'package:srt_ljh/ui/dialog/select_people_provider.dart';
import 'package:srt_ljh/ui/widget/common_button.dart';
import 'package:srt_ljh/ui/widget/notosans_text.dart';

/// 팝업 노출
Future<String?> showSelectPeopleDialog(BuildContext context,int index) {
  String selectedPeople = MAIN_DEFAULT_PEOPLE;
  return showDialog<String>(
    barrierColor: Colors.black.withOpacity(0.7),
    context: context,
    builder: (BuildContext context) {
      return Align(
        alignment: Alignment.bottomCenter,
        child: ChangeNotifierProvider(
          create: (_) => SelectPeopleNotifier(index),
          child: SizedBox(
            height: 223, // 다이얼로그 높이
            child: Dialog(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.0),
                    topRight: Radius.circular(12.0)),
              ),
              insetPadding: const EdgeInsets.all(0),
              child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 23),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12.0),
                        topRight: Radius.circular(12.0)),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 36,
                        child: Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 24.0),
                              child: NotoSansText(
                                text: SELECT_PEOPLE_TITLE,
                                textSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Spacer(),
                            Container(
                                margin: const EdgeInsets.only(right: 19),
                                width: 24,
                                height: 24,
                                child: const Icon(Icons.close,
                                    color: Colors.black)),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 24),
                        height: 39,
                        child: ListView.builder(
                          itemCount: 9,
                          clipBehavior: Clip.none,
                          itemBuilder: (context, index) {
                            return SelectPeopleItem(
                              index: index,
                              callback: (people) {
                                selectedPeople = people;
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
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        child: CommonButton(
                          width: double.infinity,
                          text: ALL_SELECT_ALL,
                          isEnabled: true,
                          callback: () {
                            context.pop(selectedPeople);
                          },
                        ),
                      )
                    ],
                  )),
            ),
          ),
        ),
      );
    },
  );
}

class SelectPeopleItem extends StatelessWidget {
  const SelectPeopleItem(
      {super.key, required this.index, required this.callback});

  final int index;
  final Function(String) callback;

  @override
  Widget build(BuildContext context) {
    return Consumer<SelectPeopleNotifier>(builder: (context, notifier, child) {
      bool isSelected = notifier.selectedIndex == index;
      return InkWell(
        onTap: () {
          notifier.selectedIndex = index;
          callback("${index + 1}명");
        },
        child: Container(
          height: 38,
          width: 58,
          decoration: BoxDecoration(
              color: isSelected ? clr_476eff : Colors.white,
              border: Border.all(color: clr_dddddd, width: 1.0),
              borderRadius: BorderRadius.circular(0)),
          margin: const EdgeInsets.only(right: 8),
          child: Center(
              child: NotoSansText(
            text: "${index + 1}명",
            textSize: 14,
            textColor: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.w500,
          )),
        ),
      );
    });
  }
}
