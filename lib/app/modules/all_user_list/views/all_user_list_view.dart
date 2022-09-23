import 'package:argon_admin/animation/animated_button.dart';
import 'package:argon_admin/app/constants/api_constant.dart';
import 'package:argon_admin/app/constants/color_constant.dart';
import 'package:argon_admin/app/constants/sizeConstant.dart';
import 'package:argon_admin/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../main.dart';
import '../../../../utilities/text_field.dart';
import '../../../models/all_users_data_model.dart';
import '../controllers/all_user_list_controller.dart';

class AllUserListView extends GetWidget<AllUserListController> {
  @override
  Widget build(BuildContext context) {
    MySize().init(context);
    return GetBuilder<AllUserListController>(
        init: AllUserListController(),
        builder: (controller) {
          return Obx(() {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                getTopSection(context: context, controller: controller),
                Space.height(30),
                Expanded(
                  child: (controller.hasData.isFalse)
                      ? Center(
                          child: CircularProgressIndicator(
                            color: appTheme.primaryTheme,
                          ),
                        )
                      : Padding(
                          padding: Spacing.only(left: 70, right: 100),
                          child: SingleChildScrollView(
                            child: Wrap(
                                alignment: WrapAlignment.start,
                                crossAxisAlignment: WrapCrossAlignment.start,
                                spacing: MySize.getWidth(25),
                                runSpacing: MySize.getHeight(25),
                                children: List.generate(
                                    controller.usersList.length, (index) {
                                  return InkWell(
                                    onTap: () {
                                      box.write(
                                          ArgumentConstant.userEmailForDetail,
                                          controller.usersList[index].email);
                                      controller.dashboardScreenControllerl!
                                          .isDetailsSelected.value = true;
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: MySize.getHeight(160),
                                      width: MySize.getWidth(340),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                              MySize.getHeight(40))),
                                      padding: Spacing.symmetric(
                                          horizontal: 20, vertical: 20),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              InkWell(
                                                child: ClipRRect(
                                                  child: Container(
                                                    child: getImageByLink(
                                                      boxFit: BoxFit.cover,
                                                      url: imageUrl +
                                                          controller
                                                              .usersList[index]
                                                              .img!,
                                                      height: 50,
                                                      width: 50,
                                                    ),
                                                    height: MySize.getHeight(
                                                        MySize.getHeight(70)),
                                                    width: MySize.getWidth(70),
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          MySize.getHeight(
                                                              1000)),
                                                ),
                                                onTap: () {
                                                  openImageDialog(
                                                      context: context,
                                                      imageLink: imageUrl +
                                                          controller
                                                              .usersList[index]
                                                              .img!);
                                                },
                                              ),
                                              Space.width(20),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "${controller.usersList[index].name![0].toUpperCase()}${controller.usersList[index].name!.substring(1)}",
                                                    style: TextStyle(
                                                        fontSize:
                                                            MySize.getHeight(
                                                                18),
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                  Space.height(10),
                                                  SizedBox(
                                                    width: MySize.getWidth(210),
                                                    child: Text(
                                                      controller
                                                          .usersList[index]
                                                          .role!
                                                          .toUpperCase(),
                                                      style: TextStyle(
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          fontSize:
                                                              MySize.getHeight(
                                                                  13),
                                                          color:
                                                              Color(0xff626262),
                                                          fontWeight:
                                                              FontWeight.w600),
                                                      maxLines: 1,
                                                    ),
                                                  ),
                                                  Space.height(10),
                                                  Text(
                                                    controller.usersList[index]
                                                        .mobile!
                                                        .toUpperCase(),
                                                    style: TextStyle(
                                                        fontSize:
                                                            MySize.getHeight(
                                                                13),
                                                        color:
                                                            Color(0xff626262),
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                  Space.height(10),
                                                  Row(
                                                    children: [
                                                      InkWell(
                                                        onTap: () {
                                                          box.write(
                                                              ArgumentConstant
                                                                  .userEmailForEdit,
                                                              controller
                                                                  .usersList[
                                                                      index]
                                                                  .email);
                                                          box.write(
                                                              ArgumentConstant
                                                                  .isForEdit,
                                                              true);
                                                          Get.toNamed(Routes
                                                              .CREATE_USER_SCREEN);
                                                        },
                                                        child: Container(
                                                          height:
                                                              MySize.getHeight(
                                                                  30),
                                                          width:
                                                              MySize.getWidth(
                                                                  80),
                                                          decoration: BoxDecoration(
                                                              color: Color(
                                                                  0xfff3fbff),
                                                              borderRadius: BorderRadius
                                                                  .circular(MySize
                                                                      .getHeight(
                                                                          5))),
                                                          alignment:
                                                              Alignment.center,
                                                          child: Text(
                                                            "Edit",
                                                            style: TextStyle(
                                                                color: appTheme
                                                                    .primaryTheme),
                                                          ),
                                                        ),
                                                        onHover: (text) {},
                                                        hoverColor: appTheme
                                                            .primaryTheme,
                                                      ),
                                                      Space.width(20),
                                                      InkWell(
                                                        onTap: () {
                                                          deleteUserDialog(
                                                              context: context,
                                                              user: controller
                                                                      .usersList[
                                                                  index],
                                                              controller:
                                                                  controller);
                                                        },
                                                        child: Container(
                                                          height:
                                                              MySize.getHeight(
                                                                  30),
                                                          width:
                                                              MySize.getWidth(
                                                                  80),
                                                          decoration: BoxDecoration(
                                                              color: Color(
                                                                  0xfffff8f8),
                                                              borderRadius: BorderRadius
                                                                  .circular(MySize
                                                                      .getHeight(
                                                                          5))),
                                                          alignment:
                                                              Alignment.center,
                                                          child: Text(
                                                            "Delete",
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.red),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                })),
                          ),
                        ),
                ),
              ],
            );
          });
        });
  }

  Widget getTopSection(
      {required BuildContext context,
      required AllUserListController controller}) {
    return Padding(
      padding: Spacing.only(left: MySize.getWidth(80), top: 35, right: 100),
      child: Row(
        children: [
          Text(
            "Dashboard",
            style: TextStyle(
                fontWeight: FontWeight.w600, fontSize: MySize.getHeight(30)),
          ),
          Spacer(),
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
                controller.getFilterData(name: val.toLowerCase().trim());
              },
              suffixIcon: InkWell(
                  onTap: () {
                    controller.searchController.clear();
                    controller.isSearchOn.value = false;
                    controller.getFilterData(name: "");
                    FocusScope.of(context).unfocus();
                  },
                  child: Icon(Icons.close)),
            ),
          ),
          Space.width(35),
          InkWell(
            onTap: () {
              Get.toNamed(Routes.CREATE_USER_SCREEN);
            },
            child: Container(
              height: MySize.getHeight(40),
              width: MySize.getWidth(125),
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
                    "New Add",
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

  deleteUserDialog(
      {required BuildContext context,
      required User user,
      required AllUserListController controller}) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
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
