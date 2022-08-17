import 'dart:convert';
import 'package:argon_admin/app/constants/api_constant.dart';
import 'package:argon_admin/app/constants/sizeConstant.dart';
import 'package:argon_admin/app/data/NetworkClient.dart';
import 'package:argon_admin/app/models/get_all_leaves_model.dart';
import 'package:argon_admin/utilities/custome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart' hide FormData;
import '../../../../main.dart';

class LeaveScreenController extends GetxController {
  TextEditingController searchController = TextEditingController();
  RxBool hasData = false.obs;
  RxBool isSearchOn = false.obs;

  RxList<LeaveData> allLeaveList = RxList<LeaveData>([]);
  RxList<LeaveData> dummyLeaveList = RxList<LeaveData>([]);
  RxList filterList = ["All", "Pending", "Approved", "Rejected"].obs;
  RxString selectedFilter = "All".obs;
  RxList statusList = ["Approved", "Rejected"].obs;

  RxString selectedStatusFilter = "".obs;
  @override
  void onInit() {
    getAllLeaves(context: Get.context!);
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  getAllLeaves({required BuildContext context}) {
    hasData.value = false;
    allLeaveList.clear();
    dummyLeaveList.clear();
    Map<String, dynamic> dict = {};
    dict["select_op"] = "get_all_leave";
    FormData formData = FormData.fromMap(dict);
    NetworkClient.getInstance.callApi(
      context,
      baseUrl,
      ApiConstant.leave,
      MethodType.Post,
      params: formData,
      successCallback: (response, message) {
        hasData.value = true;
        GetAllLeaveModel res = GetAllLeaveModel.fromJson(jsonDecode(response));
        if (!isNullEmptyOrFalse(res.data)) {
          res.data!.forEach((element) {
            allLeaveList.add(element);
            dummyLeaveList.add(element);
          });
          getFilteredData(
              status: (selectedFilter.value == "All")
                  ? "all"
                  : (selectedFilter.value == "Pending")
                      ? "in_verify"
                      : (selectedFilter.value == "Approved")
                          ? "verified"
                          : "rejected");
        }
      },
      failureCallback: (status, message) {
        hasData.value = true;
        app
            .resolve<CustomDialogs>()
            .getDialog(title: "Failed", desc: "Something went wrong.");
        print(" error ");
      },
    );
  }

  leaveRejectAndApprove(
      {required BuildContext context,
      required String operation,
      required String id}) {
    app.resolve<CustomDialogs>().showCircularDialog(context);
    Map<String, dynamic> dict = {};
    dict["select_op"] = operation;
    dict["id"] = id;
    FormData formData = FormData.fromMap(dict);
    NetworkClient.getInstance.callApi(
      context,
      baseUrl,
      ApiConstant.leave,
      MethodType.Post,
      params: formData,
      successCallback: (response, message) {
        app.resolve<CustomDialogs>().hideCircularDialog(context);
        getAllLeaves(context: context);
      },
      failureCallback: (status, message) {
        app.resolve<CustomDialogs>().hideCircularDialog(context);
        hasData.value = true;
        app
            .resolve<CustomDialogs>()
            .getDialog(title: "Failed", desc: "Something went wrong.");
        print(" error ");
      },
    );
  }

  getFilteredData({required status}) {
    allLeaveList.clear();
    allLeaveList.addAll(dummyLeaveList);
    if (status != "all") {
      allLeaveList.removeWhere((element) => element.status != status);
    }
  }
}
