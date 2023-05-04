import 'package:argon_admin/app/constants/app_module.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:kiwi/kiwi.dart';
import 'package:month_year_picker/month_year_picker.dart';

import 'app/routes/app_pages.dart';

late KiwiContainer app;
GetStorage box = GetStorage();
void main() async {
  await GetStorage.init();
  app = KiwiContainer();
  setup();
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Argon Admin",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      localizationsDelegates: [
        MonthYearPickerLocalizations.delegate,
      ],
    ),
  );
}
