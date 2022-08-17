import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../main.dart';
import '../../../../utilities/custome_dialog.dart';
import '../../../constants/api_constant.dart';
import '../../../constants/sizeConstant.dart';
import '../../../data/NetworkClient.dart';
import '../../../models/all_users_data_model.dart';

class DashboardScreenController extends GetxController {
  TextEditingController searchController = TextEditingController();
  RxList<User> usersList = RxList<User>([]);
  RxList<User> usersDummyList = RxList<User>([]);
  RxBool isDashboardSelected = false.obs;
  RxBool isLeaveSelected = false.obs;
  RxBool isHolidaySelected = true.obs;
  RxBool isDetailsSelected = false.obs;
  RxBool hasData = false.obs;
  RxBool isSearchOn = false.obs;
  @override
  void onInit() {
    getAllUsers(context: Get.context!);
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  getAllUsers({required BuildContext context}) async {
    hasData.value = false;
    usersList.clear();
    usersDummyList.clear();
    Map<String, dynamic> dict = {};
    NetworkClient.getInstance.callApi(
      context,
      baseUrl,
      ApiConstant.getAllUsers,
      MethodType.Get,
      header: NetworkClient.getInstance.getAuthHeaders(),
      params: dict,
      successCallback: (response, message) {
        hasData.value = true;
        String res = response.toString();
        List data = jsonDecode(res);
        data.forEach((element) {
          usersList.add(User.fromJson(element));
          usersDummyList.add(User.fromJson(element));
        });
      },
      failureCallback: (status, message) {
        hasData.value = true;
        app
            .resolve<CustomDialogs>()
            .getDialog(title: "Failed", desc: "Something went wrong.");
        print("error");
      },
    );
  }

  deleteUser({required BuildContext context, required String email}) {
    app.resolve<CustomDialogs>().showCircularDialog(context);
    Map<String, dynamic> dict = {};
    // dict["email"] = email;
    NetworkClient.getInstance.callApi(
      context,
      baseUrl,
      ApiConstant.deleteUser + "?email=$email",
      MethodType.Get,
      params: dict,
      successCallback: (response, message) {
        app.resolve<CustomDialogs>().hideCircularDialog(context);
        getAllUsers(context: context);
        print("Response := $response");
      },
      failureCallback: (status, message) {
        app.resolve<CustomDialogs>().hideCircularDialog(context);
        app
            .resolve<CustomDialogs>()
            .getDialog(title: "Failed", desc: "Something went wrong.");
        print(" error ");
      },
    );
  }

  getFilterData({required String name}) {
    usersList.clear();
    if (isNullEmptyOrFalse(name)) {
      usersList.addAll(usersDummyList);
    } else {
      usersList.addAll(usersDummyList);
      usersList.removeWhere((element) =>
          !(element.name!.toLowerCase().contains(name.toLowerCase())));
    }
    usersList.refresh();
  }
}
