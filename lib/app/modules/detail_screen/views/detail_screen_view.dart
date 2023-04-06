import 'dart:convert';
import 'package:argon_admin/app/constants/color_constant.dart';
import 'package:argon_admin/app/constants/sizeConstant.dart';
import 'package:argon_admin/utilities/text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../models/attendace_details_model.dart';
import '../../../models/chart_sample_data.dart';
import '../controllers/detail_screen_controller.dart';

class DetailScreenView extends GetWidget<DetailScreenController> {
  @override
  Widget build(BuildContext context) {
    MySize().init(context);
    return GetBuilder<DetailScreenController>(
        init: DetailScreenController(),
        builder: (controller) {
          return Obx(() {
            return SingleChildScrollView(
              child: Container(
                height: MySize.getHeight(900),
                child: Column(
                  children: [
                    Expanded(
                      child: (controller.hasData.isFalse)
                          ? Center(
                              child: CircularProgressIndicator(
                                  color: appTheme.primaryTheme),
                            )
                          : Container(
                              padding: Spacing.only(
                                  left: MySize.getWidth(80),
                                  top: 35,
                                  right: 100),
                              child: Column(
                                children: [
                                  getTopSection(
                                      context: context, controller: controller),
                                  Space.height(20),
                                  selectDateUi(
                                      controller: controller, context: context),
                                  Space.height(100),
                                  Expanded(
                                    child: Row(
                                      children: [
                                        getChartSection(
                                            context: context,
                                            controller: controller),
                                        getClockInOutEntries(
                                            context: context,
                                            controller: controller),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    )
                  ],
                ),
              ),
            );
          });
        });
  }

  getTopSection(
      {required BuildContext context,
      required DetailScreenController controller}) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Row(children: [
        InkWell(
          onTap: () {
            controller.dashboardScreenController!.isDetailsSelected.value =
                false;
            controller.dashboardScreenController!.isDashboardSelected.value =
                true;
          },
          child: Icon(Icons.arrow_back_ios, size: MySize.getWidth(20)),
        ),
        Space.width(10),
        GestureDetector(
          onTap: () {
            controller.totalMonthHourVisibleCounter++;
          },
          child: Text(
            "Detail Screen View",
            style: TextStyle(
                fontWeight: FontWeight.w700, fontSize: MySize.getHeight(22)),
          ),
        ),
        (controller.totalMonthHourVisibleCounter >= 5)
            ? Text(
                "    ${Duration(seconds: controller.monthTotalTime.value).inHours}",
                style: TextStyle(fontSize: MySize.getHeight(20)),
              )
            : Container(),
      ]),
      Container(
        padding: Spacing.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(MySize.getHeight(30))),
        child: Text(
          controller.totalTime.value,
          style: TextStyle(
              color: appTheme.primaryTheme,
              fontWeight: FontWeight.bold,
              fontSize: MySize.getHeight(20)),
        ),
      ),
      InkWell(
        onTap: () async {
          controller.selectedMonth.value = (await showMonthYearPicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2019),
            lastDate: DateTime(
              DateTime.now().year,
              DateTime.now().month,
            ),
          ))!;

          if (!isNullEmptyOrFalse(controller.selectedMonth)) {
            controller.selectedIndexForEntry.value = 0;
            controller.lastDateOfMonth =
                getLastDateOfMonth(date: controller.selectedMonth.value);
            controller.getAttendanceDetails(context: context);
          }
        },
        child: Container(
          height: MySize.getHeight(40),
          width: MySize.getWidth(150),
          margin: Spacing.only(top: MySize.getHeight(10), bottom: 10),
          decoration: BoxDecoration(
            border: Border.all(
              color: appTheme.primaryTheme,
              width: MySize.getHeight(2),
            ),
            borderRadius: BorderRadius.circular(MySize.getHeight(30)),
          ),
          alignment: Alignment.center,
          padding: Spacing.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                  "${DateFormat("MMM").format(controller.selectedMonth.value)} / ${controller.selectedMonth.value.year}",
                  style: TextStyle(
                      color: appTheme.primaryTheme,
                      fontWeight: FontWeight.bold,
                      fontSize: MySize.getWidth(18))),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                color: appTheme.primaryTheme,
                size: MySize.getHeight(30),
              ),
            ],
          ),
        ),
      ),
    ]);
  }

  getChartSection(
      {required BuildContext context,
      required DetailScreenController controller}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Text("Average Hours:-"),
                Text(
                    "${(Duration(seconds: controller.monthTotalTime.value).inHours / controller.dataList.length).toStringAsFixed(2)}")
              ],
            ),
            Container(
              height: MySize.getHeight(400),
              width: MySize.getWidth(500),
              child: SfCartesianChart(
                plotAreaBorderWidth: 0,
                title: ChartTitle(
                    text:
                        "${DateFormat("MMM").format(controller.selectedMonth.value)} / ${controller.selectedMonth.value.year}"),
                primaryXAxis: CategoryAxis(
                  majorGridLines: MajorGridLines(width: 0),
                ),
                primaryYAxis: NumericAxis(
                    axisLine: AxisLine(width: 0),
                    labelFormat: '{value}',
                    title: AxisTitle(text: "Hours"),
                    majorTickLines: MajorTickLines(size: 0)),
                series: _getDefaultColumnSeries(controller: controller),
                tooltipBehavior: TooltipBehavior(
                    enable: true, header: '', canShowMarker: false),
              ),
            ),
          ],
        ),
      ],
    );
  }

  List<ColumnSeries<ChartSampleData, String>> _getDefaultColumnSeries(
      {required DetailScreenController controller}) {
    return <ColumnSeries<ChartSampleData, String>>[
      ColumnSeries<ChartSampleData, String>(
          dataSource: controller.chartData,
          xValueMapper: (ChartSampleData sales, _) =>
              sales.x.toString().split("-")[2].toString().split(" ")[0],
          yValueMapper: (ChartSampleData sales, _) => sales.y,
          color: appTheme.primaryTheme)
    ];
  }

  selectDateUi({
    required BuildContext context,
    required DetailScreenController controller,
  }) {
    return Container(
        child: Wrap(
      runSpacing: MySize.getHeight(8),
      children: List.generate(controller.attendanceDetailsList.length, (index) {
        return InkWell(
          onTap: () {
            controller.selectedIndexForEntry.value = index;
            controller.dataEntryList.clear();
            RxList<Data> data2 = RxList<Data>([]);
            controller.attendanceDetailsList[index].data!.forEach((element) {
              data2.add(element);
              controller.dataEntryList.add(element);
            });

            controller.attendanceDetailsList.forEach((element) {
              element.isSelected.value = false;
            });

            controller.attendanceDetailsList[index].isSelected.value = true;
            controller.totalTime.value = (isNullEmptyOrFalse(
                    controller.attendanceDetailsList[index].data))
                ? getTotalTime(0)
                : getTotalTime(int.parse(controller.dataEntryList.last.total!));
          },
          child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              margin: Spacing.only(right: 10),
              alignment: Alignment.center,
              width: MySize.getWidth(26),
              padding: Spacing.symmetric(horizontal: 0, vertical: 12),
              decoration: BoxDecoration(
                  color: (controller
                          .attendanceDetailsList[index].isSelected.isTrue)
                      ? appTheme.primaryTheme
                      : Colors.white,
                  borderRadius: BorderRadius.circular(10000)),
              child: Text(
                (index + 1).toString(),
                style: TextStyle(
                    color: (controller
                            .attendanceDetailsList[index].isSelected.isTrue)
                        ? Colors.white
                        : Colors.black,
                    fontSize: MySize.getHeight(14),
                    fontWeight: FontWeight.bold),
              )),
        );
      }),
    ));
  }

  getClockInOutEntries(
      {required BuildContext context,
      required DetailScreenController controller}) {
    return Expanded(
      child: Obx(() {
        return Center(
            child: Center(
          child: Container(
            width: MySize.getWidth(500),
            padding: EdgeInsets.only(top: MySize.getHeight(40)),
            child: Column(
              children: [
                Container(
                  width: MySize.getWidth(550),
                  height: MySize.getHeight(40),
                  padding:
                      EdgeInsets.symmetric(horizontal: MySize.getWidth(40)),
                  decoration: BoxDecoration(
                    color: Color(0xffe5e7eb),
                    borderRadius: BorderRadius.circular(MySize.size25!),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "No.",
                        style: TextStyle(
                          fontSize: MySize.size20,
                          color: Color(0xff626262),
                        ),
                      ),
                      Text(
                        "Time",
                        style: TextStyle(
                          fontSize: MySize.size20,
                          color: Color(0xff626262),
                        ),
                      ),
                      Text(
                        "Status",
                        style: TextStyle(
                          fontSize: MySize.size20,
                          color: Color(0xff626262),
                        ),
                      ),
                      Text(
                        "Edit",
                        style: TextStyle(
                          fontSize: MySize.size20,
                          color: Color(0xff626262),
                        ),
                      ),
                    ],
                  ),
                ),
                Space.height(20),
                (controller.hasData.value)
                    ? ((!isNullEmptyOrFalse(controller.dataEntryList))
                        ? Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  for (int i = 0;
                                      i < controller.dataEntryList.length;
                                      i++)
                                    Container(
                                      width: MySize.getWidth(500),
                                      height: MySize.getHeight(40),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: MySize.getWidth(40)),
                                      margin: EdgeInsets.only(
                                          bottom: MySize.getHeight(15)),
                                      decoration: BoxDecoration(
                                        color: (controller.dataEntryList[i].st
                                                    .toString()
                                                    .toUpperCase() ==
                                                "IN")
                                            ? Color(0xffe0fefd)
                                            : Color(0xffffefec),
                                        borderRadius: BorderRadius.circular(
                                            MySize.size25!),
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                strDigits(i + 1),
                                                style: TextStyle(
                                                  fontSize: MySize.size18,
                                                  color: (controller
                                                              .dataEntryList[i]
                                                              .st
                                                              .toString()
                                                              .toUpperCase() ==
                                                          "IN")
                                                      ? Color(0xff28998f)
                                                      : Color(0xfffb8266),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                getStringFromDateTime(
                                                    time: controller
                                                        .dataEntryList[i]
                                                        .time!),
                                                style: TextStyle(
                                                  fontSize: MySize.size18,
                                                  color: (controller
                                                              .dataEntryList[i]
                                                              .st
                                                              .toString()
                                                              .toUpperCase() ==
                                                          "IN")
                                                      ? Color(0xff28998f)
                                                      : Color(0xfffb8266),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Center(
                                              child: Text(
                                                "    ${controller.dataEntryList[i].st.toString().toUpperCase()}",
                                                style: TextStyle(
                                                  fontSize: MySize.size18,
                                                  color: (controller
                                                              .dataEntryList[i]
                                                              .st
                                                              .toString()
                                                              .toUpperCase() ==
                                                          "IN")
                                                      ? Color(0xff28998f)
                                                      : Color(0xfffb8266),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: InkWell(
                                              onTap: () {
                                                controller.editTime = controller
                                                    .dataEntryList[i].time!;
                                                controller.editTimeController
                                                        .text =
                                                    getStringFromDateTime(
                                                        time: controller
                                                            .editTime);
                                                openEditDialog(
                                                    context: context,
                                                    timeEntryList: controller
                                                        .dataEntryList,
                                                    controller: controller,
                                                    selectedIndex: i);
                                              },
                                              child: Container(
                                                height: MySize.getHeight(20),
                                                width: MySize.getWidth(20),
                                                alignment:
                                                    Alignment.centerRight,
                                                child: Image(
                                                  fit: BoxFit.cover,
                                                  image: AssetImage((controller
                                                              .dataEntryList[i]
                                                              .st
                                                              .toString()
                                                              .toUpperCase() ==
                                                          "IN")
                                                      ? "assets/in_edit.png"
                                                      : "assets/out_edit.png"),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          )
                        : const Center(
                            child: Text("No any entry found."),
                          ))
                    : const Center(
                        // child: CircularProgressIndicator(),
                        ),
                Space.height(40),
              ],
            ),
          ),
        ));
      }),
    );
  }

  openEditDialog(
      {required BuildContext context,
      required RxList<Data> timeEntryList,
      required int selectedIndex,
      required DetailScreenController controller}) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Container(
              child: Form(
                key: controller.formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    getTextField(
                        hintText: "Enter Time",
                        readonly: true,
                        onTap: () async {
                          controller.editTime = await openTimePicker(
                              context: context,
                              selectedTime: controller.editTime,
                              controller: controller,
                              selectedIndex: selectedIndex);

                          controller.editTimeController.text =
                              getStringFromDateTime(time: controller.editTime);
                        },
                        textEditingController: controller.editTimeController),
                    Space.height(20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: Container(
                              height: MySize.getHeight(35),
                              width: MySize.getWidth(100),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      MySize.getHeight(10)),
                                  border:
                                      Border.all(color: appTheme.primaryTheme)),
                              alignment: Alignment.center,
                              child: Text("Cancel")),
                        ),
                        Space.width(15),
                        InkWell(
                          onTap: () {
                            print(
                                "Update Index := ${controller.selectedIndexForEntry}");
                            updateTimeEntry(
                                selectedIndex: selectedIndex,
                                context: context,
                                controller: controller);
                          },
                          child: Container(
                              height: MySize.getHeight(35),
                              width: MySize.getWidth(100),
                              decoration: BoxDecoration(
                                  color: appTheme.primaryTheme,
                                  borderRadius: BorderRadius.circular(
                                      MySize.getHeight(10)),
                                  border:
                                      Border.all(color: appTheme.primaryTheme)),
                              alignment: Alignment.center,
                              child: Text(
                                "Update",
                                style: TextStyle(color: Colors.white),
                              )),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Future<DateTime> openTimePicker(
      {required BuildContext context,
      required DateTime selectedTime,
      required int selectedIndex,
      required DetailScreenController controller}) async {
    TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime:
            TimeOfDay(hour: selectedTime.hour, minute: selectedTime.minute),
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
            child: child!,
          );
        });
    if (!isNullEmptyOrFalse(time)) {
      DateTime pickedTime = DateTime(
          controller.dataEntryList[selectedIndex].date!.year,
          controller.dataEntryList[selectedIndex].date!.month,
          controller.dataEntryList[selectedIndex].date!.day,
          time!.hour,
          time.minute);
      if (controller.dataEntryList[selectedIndex].st == "in") {
        if (selectedIndex == 0) {
          if (controller.dataEntryList.length == 1) {
            return pickedTime;
          } else {
            if (pickedTime
                .isAfter(controller.dataEntryList[selectedIndex + 1].time!)) {
              getSnackBar(context: context, text: "Invalid Time");
            } else {
              return pickedTime;
            }
          }
        } else {
          if (selectedIndex + 1 == controller.dataEntryList.length) {
            // In is located at last position....
            if (pickedTime
                .isBefore(controller.dataEntryList[selectedIndex - 1].time!)) {
              getSnackBar(context: context, text: "Invalid Time");
            } else {
              return pickedTime;
            }
          } else {
            if (pickedTime
                .isBefore(controller.dataEntryList[selectedIndex - 1].time!)) {
              getSnackBar(context: context, text: "Invalid Time");
            } else if (pickedTime
                .isAfter(controller.dataEntryList[selectedIndex + 1].time!)) {
              getSnackBar(context: context, text: "Invalid Time");
            } else {
              return pickedTime;
            }
          }
        }
      } else {
        if (selectedIndex + 1 == controller.dataEntryList.length) {
          if (pickedTime
              .isBefore(controller.dataEntryList[selectedIndex - 1].time!)) {
            getSnackBar(context: context, text: "Invalid Time");
          } else {
            return pickedTime;
          }
        } else {
          if (pickedTime
              .isAfter(controller.dataEntryList[selectedIndex + 1].time!)) {
            getSnackBar(context: context, text: "Invalid Time");
          } else if (pickedTime
              .isBefore(controller.dataEntryList[selectedIndex - 1].time!)) {
            getSnackBar(context: context, text: "Invalid Time");
          } else {
            return pickedTime;
          }
        }
      }
    }
    return controller.editTime;
  }

  updateTimeEntry(
      {required int selectedIndex,
      required BuildContext context,
      required DetailScreenController controller}) {
    Map<String, dynamic> dict = {};
    if (controller.editTime == controller.dataEntryList[selectedIndex].time) {
      Get.back();
    } else {
      if (controller.dataEntryList[selectedIndex].st == "in") {
        if (selectedIndex == 0) {
          if (controller.dataEntryList.length == 1) {
            dict["data"] = jsonEncode([
              {
                "email": controller.dataEntryList[selectedIndex].email,
                "st": "in",
                "total": "0",
                "date": getDateInFormat(
                    date: controller.dataEntryList[selectedIndex].date!),
                "time": getStringTimeFromDateTime(date: controller.editTime)
              }
            ]);
          } else {
            Duration diff = controller.dataEntryList[selectedIndex].time!
                .difference(controller.editTime);

            controller.dataEntryList[selectedIndex].time = controller.editTime;

            for (int i = selectedIndex + 1;
                i < controller.dataEntryList.length;
                i++) {
              controller.dataEntryList[i].total =
                  (int.parse(controller.dataEntryList[i].total!) +
                          diff.inSeconds)
                      .toString();
            }
            List<Map<String, dynamic>> test = [];
            controller.dataEntryList.forEach((element) {
              test.add({
                "email": element.email,
                "st": element.st,
                "total": element.total,
                "date": getDateInFormat(date: element.date!),
                "time": getStringTimeFromDateTime(date: element.time!)
              });
            });
            dict["data"] = jsonEncode(test);
          }
        } else {
          if (selectedIndex + 1 == controller.dataEntryList.length) {
            Duration diff = controller.dataEntryList[selectedIndex].time!
                .difference(controller.editTime);

            controller.dataEntryList[selectedIndex].time = controller.editTime;
            List<Map<String, dynamic>> test = [];
            controller.dataEntryList.forEach((element) {
              test.add({
                "email": element.email,
                "st": element.st,
                "total": element.total,
                "date": getDateInFormat(date: element.date!),
                "time": getStringTimeFromDateTime(date: element.time!)
              });
            });
            dict["data"] = jsonEncode(test);
          } else {
            Duration diff = controller.dataEntryList[selectedIndex].time!
                .difference(controller.editTime);

            controller.dataEntryList[selectedIndex].time = controller.editTime;

            for (int i = selectedIndex + 1;
                i < controller.dataEntryList.length;
                i++) {
              controller.dataEntryList[i].total =
                  (int.parse(controller.dataEntryList[i].total!) +
                          diff.inSeconds)
                      .toString();
            }
            List<Map<String, dynamic>> test = [];
            controller.dataEntryList.forEach((element) {
              test.add({
                "email": element.email,
                "st": element.st,
                "total": element.total,
                "date": getDateInFormat(date: element.date!),
                "time": getStringTimeFromDateTime(date: element.time!)
              });
            });
            dict["data"] = jsonEncode(test);
          }
        }
      } else {
        if (selectedIndex + 1 == controller.dataEntryList.length) {
          Duration diff = controller.editTime
              .difference(controller.dataEntryList[selectedIndex].time!);
          controller.dataEntryList[selectedIndex].time = controller.editTime;
          controller.dataEntryList[selectedIndex].total =
              (int.parse(controller.dataEntryList[selectedIndex].total!) +
                      diff.inSeconds)
                  .toString();
          List<Map<String, dynamic>> test = [];
          controller.dataEntryList.forEach((element) {
            test.add({
              "email": element.email,
              "st": element.st,
              "total": element.total,
              "date": getDateInFormat(date: element.date!),
              "time": getStringTimeFromDateTime(date: element.time!)
            });
          });
          dict["data"] = jsonEncode(test);
        } else {
          dict["data"] = getEncodedJson(
              time1: controller.editTime,
              time2: controller.dataEntryList[selectedIndex].time!,
              selectedIndex: selectedIndex,
              controller: controller);
        }
      }
    }
    if (!isNullEmptyOrFalse(dict)) {
      dict["date_st"] =
          getDateInFormat(date: controller.dataEntryList[selectedIndex].date!);
      dict["email_st"] = controller.dataEntryList[selectedIndex].email;
      Get.back();

      controller.callUpdateAttendance(context: context, dict: dict);
    }
  }

  String getEncodedJson(
      {required DateTime time1,
      required DateTime time2,
      required int selectedIndex,
      required DetailScreenController controller,
      bool isForLast = false}) {
    List<Map<String, dynamic>> test = [];
    Duration diff = time1.difference(time2);

    if (isForLast) {
      controller.dataEntryList[selectedIndex].time = controller.editTime;
      controller.dataEntryList[selectedIndex].total =
          (int.parse(controller.dataEntryList[selectedIndex].total!) +
                  diff.inSeconds)
              .toString();
      List<Map<String, dynamic>> test = [];
      controller.dataEntryList.forEach((element) {
        test.add({
          "email": element.email,
          "st": element.st,
          "total": element.total,
          "date": getDateInFormat(date: element.date!),
          "time": getStringTimeFromDateTime(date: element.time!)
        });
      });
    } else {
      controller.dataEntryList[selectedIndex].time = controller.editTime;
      for (int i = selectedIndex + 1;
          i < controller.dataEntryList.length;
          i++) {
        controller.dataEntryList[i].total =
            (int.parse(controller.dataEntryList[i].total!) + diff.inSeconds)
                .toString();
      }

      controller.dataEntryList.forEach((element) {
        test.add({
          "email": element.email,
          "st": element.st,
          "total": element.total,
          "date": getDateInFormat(date: element.date!),
          "time": getStringTimeFromDateTime(date: element.time!)
        });
      });
    }

    return jsonEncode(test);
  }

  String getStringTimeFromDateTime({required DateTime date}) {
    return "${strDigits(date.hour)}:${strDigits(date.minute)}:${strDigits(date.second)}";
  }

  String getContent(
      {required int rowIndex,
      required int columnIndex,
      required DetailScreenController controller}) {
    if (rowIndex == 0) {
      return "${DateFormat("dd-MM-yyyy").format(getDateFromString(controller.attendanceDetailsList[columnIndex].date!, formatter: "yyyy-MM-dd"))}";
    } else {
      if (!isNullEmptyOrFalse(
          controller.attendanceDetailsList[columnIndex].data)) {
        return getTotalTime(int.parse(controller
            .attendanceDetailsList[columnIndex].data!.last.total
            .toString()));
      }
      return getTotalTime(0);
    }
  }

  String getContact2(
      {required int rowIndex,
      required int columnIndex,
      required DetailScreenController controller}) {
    if (rowIndex == 0) {
      return getStringFromTime(
          time: getTimeFromDateTime(
              dateTime: controller.dataEntryList[columnIndex].time!));
    } else {
      return "${controller.dataEntryList[columnIndex].st!.toUpperCase()}";
    }
  }
}

String getStringFromTime({required TimeOfDay time}) {
  return "${strDigits(time.hour)}:${strDigits(time.minute)}";
}

String getDateInFormat({required DateTime date}) {
  return "${strDigits(date.year)}-${strDigits(date.month)}-${strDigits(date.day)}";
}

String getStringFromDateTime({required DateTime time}) {
  return "${strDigits(time.hour)}:${strDigits(time.minute)}:${strDigits(time.second)}";
}

TimeOfDay getTimeFromDateTime({required DateTime dateTime}) {
  return TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
}

String getTotalTime(int sec) {
  Duration diff = Duration(seconds: sec);
  // totalSecond = int.parse(checkInOutModel.data!.total.toString());
  String h = strDigits(diff.inHours.remainder(24));
  String mm = strDigits(diff.inMinutes.remainder(60));
  String ss = strDigits(diff.inSeconds.remainder(60));
  return '$h : $mm : $ss';
}
