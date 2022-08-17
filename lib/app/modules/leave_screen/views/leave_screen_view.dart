import 'package:argon_admin/app/constants/color_constant.dart';
import 'package:argon_admin/app/constants/sizeConstant.dart';
import 'package:argon_admin/app/routes/app_pages.dart';
import 'package:argon_admin/utilities/text_field.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../models/get_all_leaves_model.dart';
import '../controllers/leave_screen_controller.dart';

class LeaveScreenView extends GetWidget<LeaveScreenController> {
  @override
  Widget build(BuildContext context) {
    MySize().init(context);
    return GetBuilder<LeaveScreenController>(
        init: LeaveScreenController(),
        builder: (controller) {
          return Obx(() {
            return (controller.hasData.isFalse)
                ? Center(
                    child:
                        CircularProgressIndicator(color: appTheme.primaryTheme),
                  )
                : Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        getTopSection(controller: controller, context: context),
                        Space.height(30),
                        Divider(),
                        Padding(
                          padding: Spacing.only(left: 20, right: 50, top: 10),
                          child: Row(
                            children: [
                              Expanded(
                                child: Center(
                                    child: Text(
                                  "Employees Name",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: MySize.getHeight(17)),
                                )),
                              ),
                              Expanded(
                                child: Center(
                                    child: Text(
                                  "From",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: MySize.getHeight(17)),
                                )),
                              ),
                              Expanded(
                                child: Center(
                                    child: Text(
                                  "To",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: MySize.getHeight(17)),
                                )),
                              ),
                              Expanded(
                                child: Center(
                                    child: Text(
                                  "No of Days",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: MySize.getHeight(17)),
                                )),
                              ),
                              Expanded(
                                child: Center(
                                    child: Text(
                                  "Reason",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: MySize.getHeight(17)),
                                )),
                              ),
                              Expanded(
                                child: Center(
                                    child: Text(
                                  "Status",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: MySize.getHeight(17)),
                                )),
                              ),
                              Expanded(
                                child: Center(
                                    child: Text(
                                  "Action",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: MySize.getHeight(17)),
                                )),
                              ),
                            ],
                          ),
                        ),
                        Space.height(10),
                        Expanded(
                          child: ListView.builder(
                              itemCount: controller.allLeaveList.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: Spacing.only(
                                      left: 20, right: 50, top: 5, bottom: 5),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          MySize.getHeight(10)),
                                      color: Colors.white),
                                  padding: Spacing.only(top: 8, bottom: 8),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Center(
                                          child: Container(
                                            child: Text(
                                              controller
                                                  .allLeaveList[index].name!,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            alignment: Alignment.center,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                          child: Center(
                                        child: Text(
                                            "${strDigits(getDateFromString(controller.allLeaveList[index].dateFrom!, formatter: "yyyy-MM-dd").day)} ${DateFormat("MMM").format(getDateFromString(controller.allLeaveList[index].dateFrom!, formatter: "yyyy-MM-dd"))}"),
                                      )),
                                      Expanded(
                                          child: Center(
                                        child: Text(
                                            "${strDigits(getDateFromString(controller.allLeaveList[index].dateTo!, formatter: "yyyy-MM-dd").day)} ${DateFormat("MMM").format(getDateFromString(controller.allLeaveList[index].dateTo!, formatter: "yyyy-MM-dd"))}"),
                                      )),
                                      Expanded(
                                          child: Center(
                                        child: Text(getTotalDays(
                                            startDate: getDateFromString(
                                                controller.allLeaveList[index]
                                                    .dateFrom!,
                                                formatter: "yyyy-MM-dd"),
                                            endDate: getDateFromString(
                                                controller.allLeaveList[index]
                                                    .dateTo!,
                                                formatter: "yyyy-MM-dd"))),
                                      )),
                                      Expanded(
                                          child: Center(
                                        child: Container(
                                          width: MySize.getWidth(150),
                                          alignment: Alignment.center,
                                          child: Text(
                                              controller
                                                  .allLeaveList[index].reason!,
                                              overflow: TextOverflow.ellipsis),
                                        ),
                                      )),
                                      Expanded(
                                        child: Center(
                                          child: Container(
                                            child: PopupMenuButton(
                                              offset: Offset(0, 32),
                                              itemBuilder: (context) {
                                                return List.generate(
                                                  controller.statusList.length,
                                                  (index2) => PopupMenuItem(
                                                    child: Text(
                                                        controller
                                                            .statusList[index2],
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600)),
                                                    onTap: () {
                                                      controller
                                                              .selectedStatusFilter
                                                              .value =
                                                          controller.statusList[
                                                              index2];
                                                      if (index2 == 0) {
                                                        controller
                                                            .leaveRejectAndApprove(
                                                                context:
                                                                    context,
                                                                operation:
                                                                    "verified",
                                                                id: controller
                                                                    .allLeaveList[
                                                                        index]
                                                                    .id!);
                                                      } else {
                                                        controller
                                                            .leaveRejectAndApprove(
                                                                context:
                                                                    context,
                                                                operation:
                                                                    "rejected",
                                                                id: controller
                                                                    .allLeaveList[
                                                                        index]
                                                                    .id!);
                                                      }
                                                    },
                                                  ),
                                                );
                                              },
                                              child: Container(
                                                width: MySize.getWidth(100),
                                                padding: Spacing.symmetric(
                                                    vertical: 3,
                                                    horizontal: 10),
                                                decoration: BoxDecoration(
                                                    color: (controller
                                                                .allLeaveList[
                                                                    index]
                                                                .status ==
                                                            "in_verify")
                                                        ? appTheme.primaryTheme
                                                        : (controller
                                                                    .allLeaveList[
                                                                        index]
                                                                    .status ==
                                                                "verified")
                                                            ? Colors.green
                                                            : Colors.red,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            MySize.getHeight(
                                                                5))),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      (controller
                                                                  .allLeaveList[
                                                                      index]
                                                                  .status ==
                                                              "in_verify")
                                                          ? "Pending"
                                                          : (controller
                                                                      .allLeaveList[
                                                                          index]
                                                                      .status ==
                                                                  "verified")
                                                              ? "Approved"
                                                              : "Rejected",
                                                      style: TextStyle(
                                                          fontSize:
                                                              MySize.getHeight(
                                                                  13),
                                                          color: Colors.white),
                                                    ),
                                                    Icon(
                                                      Icons.arrow_drop_down,
                                                      color: Colors.white,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                          child: InkWell(
                                        onTap: () {
                                          _asyncConfirmDialog(
                                              context, index, controller);
                                        },
                                        child: Center(
                                          child: Text("Delete"),
                                        ),
                                      )),
                                    ],
                                  ),
                                );
                              }),
                        ),
                      ],
                    ),
                  );
          });
        });
  }

  String getTotalDays(
      {required DateTime startDate, required DateTime endDate}) {
    String days = "";
    days = strDigits((endDate.difference(startDate).inDays + 1)).toString();
    return days + " days";
  }

  Widget getTopSection(
      {required BuildContext context,
      required LeaveScreenController controller}) {
    return Padding(
      padding: Spacing.only(left: MySize.getWidth(80), top: 35, right: 100),
      child: Row(
        children: [
          Text(
            "Leaves",
            style: TextStyle(
                fontWeight: FontWeight.w600, fontSize: MySize.getHeight(30)),
          ),
          Spacer(),
          Container(
            child: PopupMenuButton(
                offset: Offset(-8, 50),
                itemBuilder: (context) {
                  return List.generate(
                      controller.filterList.length,
                      (index) => PopupMenuItem(
                            child: Text(controller.filterList[index],
                                style: TextStyle(fontWeight: FontWeight.w600)),
                            onTap: () {
                              controller.selectedFilter.value =
                                  controller.filterList[index];
                              controller.getFilteredData(
                                  status: (index == 0)
                                      ? "all"
                                      : (index == 1)
                                          ? "in_verify"
                                          : (index == 2)
                                              ? "verified"
                                              : "rejected");
                            },
                          ));
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      MySize.getHeight(5),
                    ),
                  ),
                  child: Container(
                    height: MySize.getHeight(40),
                    width: MySize.getWidth(120),
                    padding: Spacing.symmetric(horizontal: 10),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: appTheme.primaryTheme,
                        borderRadius:
                            BorderRadius.circular(MySize.getHeight(5))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          controller.selectedFilter.value,
                          style: TextStyle(color: Colors.white),
                        ),
                        Icon(
                          Icons.arrow_drop_down,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                )),
          ),
          Space.width(35),
          Container(
            height: MySize.getHeight(40),
            width: MySize.getWidth(280),
            child: getTextField(
              textEditingController: controller.searchController,
              isFillColor: true,
              borderColor: Colors.white,
              fillColor: Colors.white,
              hintText: "Search...",
              prefixIcon: Padding(
                padding: Spacing.all(10),
                child: Image(image: AssetImage("assets/ic_serch.png")),
              ),
              onChanged: (val) {
                // controller.getFilterData(name: val.toLowerCase().trim());
              },
              suffixIcon: InkWell(
                  onTap: () {
                    controller.searchController.clear();
                    controller.isSearchOn.value = false;
                    // controller.getFilterData(name: "");
                    FocusScope.of(context).unfocus();
                  },
                  child: Icon(Icons.close)),
            ),
          ),
        ],
      ),
    );
  }

  _asyncConfirmDialog(
      BuildContext context, int index, LeaveScreenController controller) async {
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Leave'),
          content: const Text('Are you sure you want to delete your Leave?'),
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
                controller.leaveRejectAndApprove(
                  context: context,
                  operation: "delete_leave",
                  id: controller.allLeaveList[index].id!,
                );
              },
            )
          ],
        );
      },
    );
  }

  openDialogForLeave(
      {required BuildContext context,
      required LeaveData leaveData,
      required LeaveScreenController controller}) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          Get.back();
                          controller.leaveRejectAndApprove(
                              context: context,
                              operation: "rejected",
                              id: leaveData.id!);
                        },
                        child: Container(
                          height: MySize.getHeight(40),
                          width: MySize.getWidth(100),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(MySize.getHeight(5)),
                            color: Colors.red,
                          ),
                          child: Text("Reject",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: MySize.getHeight(20))),
                        ),
                      ),
                      Space.width(20),
                      InkWell(
                        onTap: () {
                          Get.back();

                          controller.leaveRejectAndApprove(
                              context: context,
                              operation: "verified",
                              id: leaveData.id!);
                        },
                        child: Container(
                          height: MySize.getHeight(40),
                          width: MySize.getWidth(100),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(MySize.getHeight(5)),
                            color: Colors.green,
                          ),
                          child: Text("Approve",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: MySize.getHeight(20))),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }
}
