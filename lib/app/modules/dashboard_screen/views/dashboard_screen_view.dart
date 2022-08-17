import 'package:argon_admin/app/constants/api_constant.dart';
import 'package:argon_admin/app/constants/color_constant.dart';
import 'package:argon_admin/app/constants/sizeConstant.dart';
import 'package:argon_admin/app/modules/all_user_list/views/all_user_list_view.dart';
import 'package:argon_admin/app/modules/apply_holiday/views/apply_holiday_view.dart';
import 'package:argon_admin/app/modules/detail_screen/views/detail_screen_view.dart';
import 'package:argon_admin/app/modules/leave_screen/views/leave_screen_view.dart';
import 'package:argon_admin/main.dart';
import 'package:argon_admin/utilities/text_field.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../models/all_users_data_model.dart';
import '../../../routes/app_pages.dart';
import '../controllers/dashboard_screen_controller.dart';

class DashboardScreenView extends GetWidget<DashboardScreenController> {
  @override
  Widget build(BuildContext context) {
    MySize().init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
        return Container(
          height: MySize.screenHeight,
          width: MySize.screenWidth,
          decoration: const BoxDecoration(color: Color(0xff01a7fe)),
          child: Row(
            children: [
              getDrawerSection(controller: controller, context: context),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(color: Color(0xff01a7fe)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      topSection(context: context, controller: controller),
                      Expanded(
                          child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AnimatedContainer(
                              duration: Duration(milliseconds: 350),
                              height: MySize.getHeight(45),
                              color: const Color(0xff01a7fe),
                              margin: EdgeInsets.only(
                                  top: MySize.getHeight(
                                      (controller.isDashboardSelected.isTrue)
                                          ? 90
                                          : ((controller.isLeaveSelected.isTrue)
                                              ? 150
                                              : 210))),
                              alignment: Alignment.center,
                              child: const Image(
                                image: AssetImage("assets/Rectangle 4.png"),
                              )),
                          Expanded(
                            child: Column(
                              children: [
                                Expanded(
                                  child: Container(
                                    // height: MySize.getHeight(800),

                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade100,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(
                                              MySize.getHeight(75))),
                                    ),
                                    alignment: Alignment.center,
                                    child: (controller
                                            .isDashboardSelected.isTrue)
                                        ? ((controller.isDetailsSelected.isTrue)
                                            ? DetailScreenView()
                                            : AllUserListView())
                                        : ((controller.isLeaveSelected.isTrue)
                                            ? LeaveScreenView()
                                            : ApplyHolidayView()),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  getDrawerSection(
      {required BuildContext context,
      required DashboardScreenController controller}) {
    return Container(
      color: (ResponsiveWidget.isMediumScreen(context))
          ? Colors.transparent
          : Color(0xff01a7fe),
      child: Padding(
        padding: Spacing.only(left: 70),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Space.height(55),
            Container(
                height: MySize.getHeight(65),
                child: const Image(
                  image: AssetImage("assets/Logo2.png"),
                  fit: BoxFit.contain,
                )),
            Space.height(80),
            InkWell(
              onTap: () {
                if (controller.isDashboardSelected.isFalse) {
                  controller.isDetailsSelected.value = false;
                }
                controller.isDashboardSelected.value = true;
                controller.isLeaveSelected.value = false;
                controller.isHolidaySelected.value = false;
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      height: MySize.getHeight(30),
                      width: MySize.getWidth(30),
                      child: const Image(
                        image: AssetImage("assets/ic_dashboard.png"),
                        fit: BoxFit.contain,
                      )),
                  Space.width(20),
                  Text(
                    "Dashboard",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: MySize.getHeight(20)),
                  ),
                ],
              ),
            ),
            Space.height(30),
            InkWell(
              onTap: () {
                controller.isDashboardSelected.value = false;
                controller.isLeaveSelected.value = true;
                controller.isHolidaySelected.value = false;
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      height: MySize.getHeight(30),
                      width: MySize.getWidth(30),
                      child: const Image(
                        image: AssetImage("assets/ic_leave.png"),
                        fit: BoxFit.contain,
                      )),
                  Space.width(20),
                  Text(
                    "Leave",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: MySize.getHeight(20)),
                  ),
                ],
              ),
            ),
            Space.height(30),
            InkWell(
              onTap: () {
                controller.isDashboardSelected.value = false;
                controller.isLeaveSelected.value = false;
                controller.isHolidaySelected.value = true;
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      height: MySize.getHeight(30),
                      width: MySize.getWidth(30),
                      child: const Image(
                        image: AssetImage("assets/holiday_icon.png"),
                        fit: BoxFit.contain,
                      )),
                  Space.width(20),
                  Text(
                    "Holiday",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: MySize.getHeight(20)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  topSection(
      {required BuildContext context,
      required DashboardScreenController controller}) {
    return Container(
      height: MySize.getHeight(100),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            height: MySize.getHeight(27),
            width: MySize.getWidth(27),
            child: Stack(
              children: [
                Image(
                  image: AssetImage("assets/ic_noti.png"),
                ),
                Positioned(
                  right: MySize.getWidth(4),
                  top: 0,
                  child: Container(
                      height: MySize.getHeight(8),
                      width: MySize.getWidth(8),
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10000))),
                ),
              ],
            ),
          ),
          Space.width(25),
          ClipRRect(
            child: Container(
              child: getImageByLink(
                boxFit: BoxFit.cover,
                url: "",
                height: 50,
                width: 50,
              ),
              height: MySize.getHeight(MySize.getHeight(50)),
              width: MySize.getWidth(50),
            ),
            borderRadius: BorderRadius.circular(MySize.getHeight(1000)),
          ),
          Space.width(10),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "HR admin panel",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
              Text(
                "HR Manager",
                style: TextStyle(
                    fontSize: MySize.getHeight(14),
                    color: Colors.white,
                    fontWeight: FontWeight.normal),
              ),
            ],
          ),
          Space.width(10),
          Icon(
            Icons.keyboard_arrow_down,
            size: MySize.getHeight(30),
            color: Colors.white,
          ),
          Space.width(100),
        ],
      ),
    );
  }

  openImageDialog({required BuildContext context, required String imageLink}) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Container(
              height: MySize.getHeight(400),
              width: MySize.getWidth(400),
              child: getImageByLink(url: imageLink, height: 400, width: 400),
            ),
          );
        });
  }

  deleteUserDialog({required BuildContext context, required User user}) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(MySize.getHeight(15))),
            content: Container(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Text(
                  "Are you sure to delete this user",
                  style: TextStyle(),
                ),
                SizedBox(height: MySize.getHeight(20)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Container(
                          height: MySize.getHeight(40),
                          width: MySize.getWidth(100),
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius:
                                  BorderRadius.circular(MySize.getHeight(10))),
                          alignment: Alignment.center,
                          child: Text(
                            "Cancel",
                            style: TextStyle(color: Colors.white),
                          )),
                    ),
                    SizedBox(width: MySize.getWidth(20)),
                    InkWell(
                      onTap: () {
                        Get.back();
                        controller.deleteUser(
                            context: context, email: user.email!);
                      },
                      child: Container(
                          height: MySize.getHeight(40),
                          width: MySize.getWidth(100),
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius:
                                  BorderRadius.circular(MySize.getHeight(10))),
                          alignment: Alignment.center,
                          child: Text(
                            "Delete",
                            style: TextStyle(color: Colors.white),
                          )),
                    ),
                  ],
                ),
              ]),
            ),
          );
        });
  }
}
