import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData;
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../../main.dart';
import '../../../../utilities/custome_dialog.dart';
import '../../../constants/api_constant.dart';
import '../../../constants/sizeConstant.dart';
import '../../../data/NetworkClient.dart';
import '../../../models/holidayDataModel.dart';

class ApplyHolidayController extends GetxController {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  Rx<PickerDateRange> range =
      PickerDateRange(DateTime.now(), DateTime.now()).obs;
  Rx<TextEditingController> reasonController = TextEditingController().obs;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  //RxList<Attandance> attandanceList = RxList<Attandance>([]);
  RxBool hasData = false.obs;
  RxList<HolidayData> allHolidayList = RxList<HolidayData>([]);

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      callApiForGetHoliday(context: Get.context!, isFromButton: true);
    });
  }

  @override
  void onReady() {
    super.onReady();
  }

  callApiForApplyHolidayEntry(
      {required BuildContext context, bool isFromButton = false}) {
    FocusScope.of(context).unfocus();
    if (!isFromButton) {
      app.resolve<CustomDialogs>().showCircularDialog(context);
    }
    Map<String, dynamic> dict = {};

    dict["date1"] = DateFormat('yyyy-MM-dd').format(range.value.startDate!);
    if (range.value.endDate != null) {
      dict["date2"] = DateFormat('yyyy-MM-dd').format(range.value.endDate!);
    } else {
      dict["date2"] = DateFormat('yyyy-MM-dd').format(range.value.startDate!);
    }
    dict["select_op"] = "holiday_entry";
    dict["des"] = reasonController.value.text;

    FormData data = FormData.fromMap(dict);

    return NetworkClient.getInstance.callApi(
      context,
      baseUrl,
      ApiConstant.holiday,
      MethodType.Post,
      header: NetworkClient.getInstance.getAuthHeaders(),
      // headers: NetworkClient.getInstance.getAuthHeaders(),
      params: data,
      successCallback: (response, message) {
        // print(response);
        reasonController.value.clear();
        if (!isFromButton) {
          app.resolve<CustomDialogs>().hideCircularDialog(context);
        }
        callApiForGetHoliday(context: Get.context!, isFromButton: true);

        // List data = jsonDecode(response) as List;

        // print(response);
      },
      failureCallback: (status, message) {
        if (!isFromButton) {
          app.resolve<CustomDialogs>().hideCircularDialog(context);
        }
        app.resolve<CustomDialogs>().getDialog(title: "Failed", desc: message);

        // print(" error");
        //
        // print(status);
      },
    );
  }

  callApiForGetHoliday(
      {required BuildContext context, bool isFromButton = false}) {
    FocusScope.of(context).unfocus();
    if (!isFromButton) {
      app.resolve<CustomDialogs>().showCircularDialog(context);
    }
    Map<String, dynamic> dict = {};

    // dict["email"] = box.read(StringConstants.userEmailAddress);
    dict["select_op"] = "get_all_holiday";

    FormData data = FormData.fromMap(dict);
    hasData.value = false;

    return NetworkClient.getInstance.callApi(
      context,
      baseUrl,
      ApiConstant.holiday,
      MethodType.Post,
      header: NetworkClient.getInstance.getAuthHeaders(),
      params: data,
      successCallback: (response, message) {
        // print(response);
        hasData.value = true;

        if (!isFromButton) {
          app.resolve<CustomDialogs>().hideCircularDialog(context);
        }
        Map<String, dynamic> m = jsonDecode(response) as Map<String, dynamic>;
        HolidayDataModel holidayListModel = HolidayDataModel.fromJson(m);
        allHolidayList.clear();
        if (!isNullEmptyOrFalse(holidayListModel.data)) {
          List<HolidayData> reverse = [];
          reverse.addAll(holidayListModel.data!);
          allHolidayList.addAll(reverse.reversed.toList());
        }
      },
      failureCallback: (status, message) {
        hasData.value = true;

        if (!isFromButton) {
          app.resolve<CustomDialogs>().hideCircularDialog(context);
        }
        app.resolve<CustomDialogs>().getDialog(title: "Failed", desc: message);

        //print(" error");

        //print(status);
      },
    );
  }

  callApiForDeleteHoliday({
    required BuildContext context,
    bool isFromButton = false,
    String? id,
  }) {
    FocusScope.of(context).unfocus();
    if (!isFromButton) {
      app.resolve<CustomDialogs>().showCircularDialog(context);
    }
    Map<String, dynamic> dict = {};

    dict["select_op"] = "delete_holiday";
    dict["id"] = id!;
    FormData data = FormData.fromMap(dict);
    hasData.value = false;

    return NetworkClient.getInstance.callApi(
      context,
      baseUrl,
      ApiConstant.holiday,
      MethodType.Post,
      header: NetworkClient.getInstance.getAuthHeaders(),
      params: data,
      successCallback: (response, message) {
        hasData.value = true;

        if (!isFromButton) {
          app.resolve<CustomDialogs>().hideCircularDialog(context);
        }
        Map<String, dynamic> m = jsonDecode(response) as Map<String, dynamic>;
        callApiForGetHoliday(context: Get.context!, isFromButton: true);
      },
      failureCallback: (status, message) {
        hasData.value = true;

        if (!isFromButton) {
          app.resolve<CustomDialogs>().hideCircularDialog(context);
        }
        app.resolve<CustomDialogs>().getDialog(title: "Failed", desc: message);

        //print(" error");

        // print(status);
      },
    );
  }

  @override
  void onClose() {}
  void increment() => count.value++;
}
