import 'dart:convert';

import 'package:argon_admin/app/constants/api_constant.dart';
import 'package:argon_admin/app/data/NetworkClient.dart';
import 'package:argon_admin/app/routes/app_pages.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData;

import '../../../../main.dart';
import '../../../../utilities/custome_dialog.dart';

class LoginPageController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Rx<TextEditingController> emailController = TextEditingController().obs;
  Rx<TextEditingController> passController = TextEditingController().obs;
  RxBool isChecked = false.obs;
  RxBool passwordVisible = true.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  getSingleUserData({required BuildContext context}) async {
    app.resolve<CustomDialogs>().showCircularDialog(context);
    Map<String, dynamic> dict = {};
    dict["username"] = emailController.value.text.trim();
    dict["password"] = passController.value.text.trim();
    FormData formData = FormData.fromMap(dict);
    return NetworkClient.getInstance.callApi(
      context,
      baseUrl,
      ApiConstant.adminLogin,
      MethodType.Post,
      header: NetworkClient.getInstance.getAuthHeaders(),
      params: formData,
      successCallback: (response, message) {
        app.resolve<CustomDialogs>().hideCircularDialog(context);
        Map<String, dynamic> res = jsonDecode(response);
        if (res["status"] == "0") {
          app.resolve<CustomDialogs>().getDialog(
              title: "Failed",
              desc: "Please enter valid user name or password.");
        } else {
          box.write(ArgumentConstant.isUserLogin, true);
          Get.offAllNamed(Routes.DASHBOARD_SCREEN);
        }
      },
      failureCallback: (status, message) {
        app.resolve<CustomDialogs>().hideCircularDialog(context);
        app
            .resolve<CustomDialogs>()
            .getDialog(title: "Failed", desc: "Something went wrong.");
        print(" error");
      },
    );
  }
}
