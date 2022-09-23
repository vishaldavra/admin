import 'package:argon_admin/utilities/text_field.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../../main.dart';
import '../../../../utilities/custome_dialog.dart';
import '../../../constants/color_constant.dart';
import '../../../constants/sizeConstant.dart';
import '../controllers/apply_holiday_controller.dart';

class ApplyHolidayView extends GetWidget<ApplyHolidayController> {
  @override
  Widget build(BuildContext context) {
    MySize().init(context);
    return GetBuilder<ApplyHolidayController>(
        init: ApplyHolidayController(),
        builder: (controller) {
          return SingleChildScrollView(
            child: Container(
              height: MySize.getHeight(900),
              child: Column(
                children: [
                  getTopSection(controller: controller, context: context),
                  SizedBox(height: MySize.getHeight(20)),
                  Expanded(
                    child: Column(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Form(
                            key: controller.formKey,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      Obx(() {
                                        return Container(
                                          width: MySize.getWidth(300),
                                          child: SfDateRangePicker(
                                            onSelectionChanged:
                                                (DateRangePickerSelectionChangedArgs
                                                    args) {
                                              controller.range.value =
                                                  args.value;

                                              // print(range.endDate);
                                            },
                                            selectionMode:
                                                DateRangePickerSelectionMode
                                                    .range,
                                            //showTodayButton: true,

                                            initialSelectedRange:
                                                controller.range.value,
                                            initialDisplayDate: DateTime.now(),
                                            minDate: DateTime.now(),
                                          ),
                                        );
                                      }),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: MySize.size20!),
                                          child: Container(
                                            width: MySize.getWidth(500),
                                            child: Align(
                                              child: Text(
                                                "Holiday Name:",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize:
                                                      MySize.getHeight(17),
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              alignment: Alignment.centerLeft,
                                            ),
                                          ),
                                        ),
                                        Spacing.height(10),
                                        Container(
                                          width: MySize.getWidth(500),
                                          child: getTextField(
                                              maxLine: 6,
                                              isFillColor: true,
                                              fillColor: Colors.white,
                                              textEditingController: controller
                                                  .reasonController.value,
                                              borderColor: Colors.white,
                                              validator: (val) {
                                                if (val!.isEmpty) {
                                                  return "Please enter name";
                                                }
                                                return null;
                                              }),
                                        ),
                                        Spacing.height(30),
                                        InkWell(
                                          onTap: () {
                                            if (controller.formKey.currentState!
                                                .validate()) {
                                              addHoliday(
                                                  context: context,
                                                  controller: controller);
                                            }
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            width: MySize.getWidth(130),
                                            padding: Spacing.symmetric(
                                                vertical: 7, horizontal: 10),
                                            decoration: BoxDecoration(
                                                color: appTheme.primaryTheme,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        MySize.getHeight(7))),
                                            child: Text(
                                              "Add Holiday",
                                              style: TextStyle(
                                                fontSize: MySize.getHeight(18),
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ]),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Container(
                            padding: EdgeInsets.only(
                              top: MySize.size20!,
                            ),
                            child: Obx(() {
                              return Column(
                                children: [
                                  Text(
                                    "Holidays",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Spacing.height(20),
                                  Expanded(
                                    child: (controller.hasData.value)
                                        ? ((controller
                                                .allHolidayList.isNotEmpty)
                                            ? Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal:
                                                        MySize.getWidth(100)),
                                                child: ListView.separated(
                                                  itemBuilder: (context, i) {
                                                    return Container(
                                                      padding: EdgeInsets
                                                          .symmetric(
                                                              horizontal: MySize
                                                                  .getWidth(15),
                                                              vertical: MySize
                                                                  .size10!),
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                          color: Colors.black,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(MySize
                                                                    .size12!),
                                                      ),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                    "Holiday date : ",
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          MySize
                                                                              .size16,
                                                                    ),
                                                                  ),
                                                                  Space.width(
                                                                      10),
                                                                  Text(
                                                                    controller
                                                                            .allHolidayList[
                                                                                i]
                                                                            .date1
                                                                            .toString() +
                                                                        " - " +
                                                                        controller
                                                                            .allHolidayList[i]
                                                                            .date2
                                                                            .toString(),
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      fontSize:
                                                                          MySize
                                                                              .size16,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  IconButton(
                                                                    onPressed:
                                                                        () {
                                                                      _asyncConfirmDialog(
                                                                          context,
                                                                          i,
                                                                          controller);
                                                                    },
                                                                    icon: Icon(
                                                                      Icons
                                                                          .delete,
                                                                      color: Colors
                                                                          .red,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                          Space.height(5),
                                                          Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                "Reason : ",
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: MySize
                                                                      .size16,
                                                                ),
                                                              ),
                                                              Space.width(10),
                                                              Expanded(
                                                                child: Text(
                                                                  controller
                                                                      .allHolidayList[
                                                                          i]
                                                                      .des
                                                                      .toString(),
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontSize: MySize
                                                                        .size16,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Space.height(10),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                  separatorBuilder:
                                                      (context, i) {
                                                    return Space.height(20);
                                                  },
                                                  itemCount: controller
                                                      .allHolidayList.length,
                                                  reverse: false,
                                                  padding: EdgeInsets.zero,
                                                ),
                                              )
                                            : Center(
                                                child: Text(
                                                    "No any Holidays found."),
                                              ))
                                        : Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                  ),
                                ],
                              );
                            }),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget getTopSection(
      {required BuildContext context,
      required ApplyHolidayController controller}) {
    return Padding(
      padding: Spacing.only(left: MySize.getWidth(80), top: 35, right: 100),
      child: Row(
        children: [
          Text(
            "Holidays",
            style: TextStyle(
                fontWeight: FontWeight.w600, fontSize: MySize.getHeight(30)),
          ),
          Spacer(),
          Space.width(35),
          InkWell(
            onTap: () {
              // Get.toNamed(Routes.CREATE_USER_SCREEN);
            },
            child: Container(
              height: MySize.getHeight(40),
              padding: Spacing.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(MySize.getHeight(10)),
                  color: appTheme.primaryTheme),
              child: Row(
                children: [
                  Container(
                    alignment: Alignment.center,
                    height: MySize.getHeight(25),
                    width: MySize.getWidth(25),
                    child: Image(image: AssetImage("assets/ic_add.png")),
                  ),
                  Space.width(8),
                  Text(
                    "Add Holiday",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: MySize.getHeight(17)),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  addHoliday(
      {required BuildContext context,
      required ApplyHolidayController controller}) {
    DateTime fromDate = controller.range.value.startDate!;
    DateTime? toDate;
    if (controller.range.value.endDate != null) {
      toDate = controller.range.value.endDate!;
    } else {
      toDate = controller.range.value.startDate!;
    }

    bool base = false;
    controller.allHolidayList.forEach((element) {
      if ((toDate!.isBefore(getDateFromString(element.date2!, formatter: 'yyyy-MM-dd')) &&
              fromDate.isAfter(getDateFromString(element.date1!,
                  formatter: 'yyyy-MM-dd'))) ||
          (toDate.isBefore(
                  getDateFromString(element.date2!, formatter: 'yyyy-MM-dd')) &&
              toDate.isAfter(getDateFromString(element.date1!,
                  formatter: 'yyyy-MM-dd'))) ||
          (fromDate.isBefore(
                  getDateFromString(element.date2!, formatter: 'yyyy-MM-dd')) &&
              fromDate.isAfter(getDateFromString(element.date1!,
                  formatter: 'yyyy-MM-dd'))) ||
          (DateTime(
                  getDateFromString(element.date2!, formatter: 'yyyy-MM-dd')
                      .year,
                  getDateFromString(element.date2!, formatter: 'yyyy-MM-dd')
                      .month,
                  getDateFromString(element.date2!, formatter: 'yyyy-MM-dd')
                      .day) ==
              DateTime(toDate.year, toDate.month, toDate.day)) ||
          (DateTime(
                  getDateFromString(element.date2!, formatter: 'yyyy-MM-dd')
                      .year,
                  getDateFromString(element.date2!, formatter: 'yyyy-MM-dd').month,
                  getDateFromString(element.date2!, formatter: 'yyyy-MM-dd').day) ==
              DateTime(fromDate.year, fromDate.month, fromDate.day)) ||
          (DateTime(
                getDateFromString(element.date1!, formatter: 'yyyy-MM-dd').year,
                getDateFromString(element.date1!, formatter: 'yyyy-MM-dd')
                    .month,
                getDateFromString(element.date1!, formatter: 'yyyy-MM-dd').day,
              ) ==
              DateTime(
                toDate.year,
                toDate.month,
                toDate.day,
              )) ||
          (DateTime(
                getDateFromString(element.date1!, formatter: 'yyyy-MM-dd').year,
                getDateFromString(element.date1!, formatter: 'yyyy-MM-dd')
                    .month,
                getDateFromString(element.date1!, formatter: 'yyyy-MM-dd').day,
              ) ==
              DateTime(
                fromDate.year,
                fromDate.month,
                fromDate.day,
              ))) {
        // isDateBetween = true;
        base = true;
      }
    });
    if (!base) {
      controller.callApiForApplyHolidayEntry(context: context);
    } else {
      app.resolve<CustomDialogs>().getDialog(
          title: "Leave", desc: "Already leave applied on selected day.");
    }
    ;
  }

  _asyncConfirmDialog(BuildContext context, int index, controller) async {
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Holiday'),
          content: const Text('Are you sure you want to delete your Holiday?'),
          actions: <Widget>[
            FlatButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: const Text(
                'Delete',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              color: Colors.red,
              onPressed: () {
                Navigator.of(context).pop();
                controller.callApiForDeleteHoliday(
                    context: Get.context!,
                    isFromButton: true,
                    id: controller.allHolidayList[index].id.toString());
              },
            )
          ],
        );
      },
    );
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    controller.range.value = args.value;

    // print(range.endDate);
  }
}
