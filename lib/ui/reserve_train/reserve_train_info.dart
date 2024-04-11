import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:srt_ljh/common/colors.dart';
import 'package:srt_ljh/common/constants.dart';
import 'package:srt_ljh/common/strings.dart';
import 'package:srt_ljh/common/utils.dart';
import 'package:srt_ljh/model/base_response.dart';
import 'package:srt_ljh/ui/reserve_train/dialog/terms_dialog.dart';
import 'package:srt_ljh/ui/reserve_train/reserve_train_info_viewmodel.dart';
import 'package:srt_ljh/ui/widget/custom_button.dart';
import 'package:srt_ljh/ui/widget/custom_dialog.dart';
import 'package:srt_ljh/ui/widget/notosans_text.dart';

class ReserveTrainInfo extends StatefulWidget {
  const ReserveTrainInfo({super.key});

  @override
  State<ReserveTrainInfo> createState() => _ReserveTrainInfoState();
}

class _ReserveTrainInfoState extends State<ReserveTrainInfo> {
  Future<void> showTermsBottomSheet(BuildContext context) async {
    bool? isAgree = await showTermsDialog(
        context, ["[필수] 여객운송 약관 및 부속 약관 동의", "[필수] 예매 서비스 이용 동의"], ["", ""]);
    if (isAgree != null) {
      if (isAgree && mounted) {
        var result =
            await Provider.of<ReserveTrainInfoViewModel>(context, listen: false)
                .requestSrtReserve();
        if (result != null && mounted) {
          handleResult(context, result);
        }
      }
    }
  }

  // 예매 정보 pref에 저장
  Future<void> saveStationInfo(BuildContext context) async {
    var prefs = await SharedPreferences.getInstance();
    if (mounted) {
      List<String> dataList =
          prefs.getStringList(PREF_KEY_STATION_INFO) ?? List.empty(growable: true);
      dataList.add(
          Provider.of<ReserveTrainInfoViewModel>(context,listen: false).getStationInfo());
      prefs.setStringList(PREF_KEY_STATION_INFO, dataList);
    }
  }

  /// main 결과 처리
  Future<void> handleResult(BuildContext context, BaseResponse result) async {
    switch (result.code) {
      case 0:
        if (result.message == SUCCESS_MESSAGE) {
          await saveStationInfo(context);
          if (mounted) {
            CommonDialog.showSimpleDialog(context, "승차권 예매가 완료되었습니다.", "", "확인",
                () {
              context.push(getRoutePath([ROUTER_MAIN_PATH]));
            });
          }
        } else {
          CommonDialog.showErrDialog(context, "실패", "", "확인");
        }
        break;
      case 10:
        CommonDialog.showErrDialog(context, "필수 Parameter가 없습니다", "", "확인");
        break;
      default:
        CommonDialog.showErrDialog(context, "실패", "", "확인");
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(body: Consumer<ReserveTrainInfoViewModel>(
      builder: (context, viewModel, child) {
        return Column(children: [
          const ReserveTrainInfoHeader(),
          Container(
            color: clr_f8f8f8,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NotoSansText(text: viewModel.result["selectedDay"]),
                const SizedBox(
                  height: 20,
                ),
                NotoSansText(
                  text: "SRT ${viewModel.result["trainno"]}",
                  textColor: clr_888888,
                  textSize: 14,
                ),
                SizedBox(
                  height: 8,
                ),
                NotoSansText(
                    text: viewModel.result["startStation"] +
                        "(" +
                        viewModel.startTime +
                        ") -> " +
                        viewModel.result["finishStation"] +
                        "(" +
                        viewModel.finishTime +
                        ")",
                    textSize: 18),
                SizedBox(
                  height: 4,
                ),
                NotoSansText(
                  text: viewModel.getCompareTime(),
                  textColor: clr_888888,
                  textSize: 14,
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const NotoSansText(
                    text: "결제 금액",
                    fontWeight: FontWeight.w500,
                    textSize: 18,
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      NotoSansText(
                        text: "운임요금",
                      ),
                      NotoSansText(text: getAmount(69000)),
                    ],
                  ),
                  const SizedBox(
                    height: 7,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: NotoSansText(
                      text: viewModel.people.toString() + " 매",
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Container(
                    width: double.infinity,
                    height: 1,
                    color: clr_eeeeee,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      NotoSansText(
                        text: "총 결제금액",
                        fontWeight: FontWeight.w700,
                        textSize: 16,
                      ),
                      NotoSansText(
                        text: getAmount(69000 * viewModel.people),
                        fontWeight: FontWeight.w700,
                        textSize: 16,
                        textColor: clr_476eff,
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 48,
            margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            child: CommonButton(
              width: double.infinity,
              isEnabled: true,
              text: "확인",
              callback: () {
                showTermsBottomSheet(context);
              },
            ),
          )
        ]);
      },
    )));
  }
}

/// 헤더
class ReserveTrainInfoHeader extends StatelessWidget {
  const ReserveTrainInfoHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: Stack(
        children: <Widget>[
          Align(
              alignment: Alignment.center,
              child: NotoSansText(
                text: "예매 정보 확인",
                textColor: Theme.of(context).colorScheme.onPrimary,
                textSize: 18,
                fontWeight: FontWeight.w600,
              )),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: InkWell(
                  onTap: () {
                    context.pop();
                  },
                  child: SizedBox(
                      width: 24,
                      height: 24,
                      child: Icon(
                        Icons.close,
                        color: Theme.of(context).colorScheme.onSurface,
                      )),
                )),
          ),
        ],
      ),
    );
  }
}
