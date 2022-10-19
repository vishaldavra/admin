import 'dart:io';

import 'package:argon_admin/app/constants/color_constant.dart';
import 'package:argon_admin/app/constants/sizeConstant.dart';
import 'package:argon_admin/main.dart';
import 'package:argon_admin/utilities/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:path/path.dart' as p;
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../constants/api_constant.dart';
import '../controllers/create_user_screen_controller.dart';

class CreateUserScreenView extends GetWidget<CreateUserScreenController> {
  @override
  Widget build(BuildContext context) {
    MySize().init(context);
    return WillPopScope(child: Obx(() {
      return SafeArea(
        child: Scaffold(
            body: (controller.hasData.isFalse)
                ? Center(
                    child:
                        CircularProgressIndicator(color: appTheme.primaryTheme),
                  )
                : SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: MySize.getWidth(200),
                          vertical: MySize.getHeight(50)),
                      child: Form(
                        key: controller.formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Center(
                              child: InkWell(
                                onTap: () async {
                                  var xFile = await controller.picker
                                      .pickImage(source: ImageSource.gallery);
                                  controller.image = xFile!.obs;
                                  String fileName = "";
                                  if (!isNullEmptyOrFalse(controller.image)) {
                                    fileName = p.basenameWithoutExtension(
                                        controller.image!.value.path);
                                    controller.isImagePicked.value = true;
                                    controller.selectedImagePath.value =
                                        controller.image!.value.path;
                                  } else {
                                    fileName = "";
                                  }
                                  controller.image!.refresh();
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      MySize.getHeight(1000)),
                                  child: Container(
                                    height: MySize.getHeight(120),
                                    width: MySize.getWidth(120),
                                    child: (controller.isForEdit.isTrue &&
                                            !isNullEmptyOrFalse(
                                                controller.imageFromServer))
                                        ? (controller.isImagePicked.isTrue)
                                            ? Image.network(
                                                controller
                                                    .selectedImagePath.value,
                                                fit: BoxFit.cover,
                                              )
                                            : ClipRRect(
                                                child: Container(
                                                  child: getImageByLink(
                                                    boxFit: BoxFit.cover,
                                                    url: imageUrl +
                                                        controller
                                                            .imageFromServer
                                                            .value
                                                            .toString(),
                                                    height: 50,
                                                    width: 50,
                                                  ),
                                                  height: MySize.getHeight(
                                                      MySize.getHeight(100)),
                                                  width: MySize.getWidth(100),
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        MySize.getHeight(1000)),
                                              )
                                        : (controller.isImagePicked.isTrue)
                                            ? Image.network(
                                                controller
                                                    .selectedImagePath.value,
                                                fit: BoxFit.cover,
                                              )
                                            : Image(
                                                image: AssetImage(
                                                    "assets/user_image.png"),
                                              ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: MySize.getHeight(100)),
                            Center(
                              child: Wrap(
                                  alignment: WrapAlignment.center,
                                  spacing: MySize.getWidth(100),
                                  runSpacing: MySize.getHeight(10),
                                  children: [
                                    Container(
                                        width: MySize.getWidth(500),
                                        child: getTextField(
                                            hintText: "Enter First name",
                                            textEditingController:
                                                controller.firstNameController,
                                            validator: (val) {
                                              if (isNullEmptyOrFalse(val)) {
                                                return "Please Enter First Name";
                                              }
                                              return null;
                                            })),
                                    Container(
                                        width: MySize.getWidth(500),
                                        child: getTextField(
                                            hintText: "Enter Last name",
                                            textEditingController:
                                                controller.lastNameController,
                                            validator: (val) {
                                              if (isNullEmptyOrFalse(val)) {
                                                return "Please Enter Last Name";
                                              }
                                              return null;
                                            })),
                                    Container(
                                        width: MySize.getWidth(500),
                                        child: getTextField(
                                            hintText: "Enter Email address",
                                            readonly:
                                                (controller.isForEdit.value)
                                                    ? true
                                                    : false,
                                            textEditingController:
                                                controller.emailController,
                                            validator: (val) {
                                              if (isNullEmptyOrFalse(val)) {
                                                return "Please Enter Email Address";
                                              }
                                              return null;
                                            })),
                                    Container(
                                      width: MySize.getWidth(500),
                                      child: Row(
                                        children: [
                                          Row(
                                            children: [
                                              Radio(
                                                  value: "Male",
                                                  groupValue: controller
                                                      .selectGender.value,
                                                  onChanged: (val) {
                                                    controller.selectGender
                                                        .value = val.toString();
                                                  }),
                                              Text("Male"),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Radio(
                                                  value: "Female",
                                                  groupValue: controller
                                                      .selectGender.value,
                                                  onChanged: (val) {
                                                    controller.selectGender
                                                        .value = val.toString();
                                                  }),
                                              Text("Female"),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                        width: MySize.getWidth(500),
                                        child: getTextField(
                                            hintText: "Enter address",
                                            textEditingController:
                                                controller.addressController,
                                            validator: (val) {
                                              if (isNullEmptyOrFalse(val)) {
                                                return "Please Enter Address";
                                              }
                                              return null;
                                            })),
                                    PopupMenuButton<int>(
                                      offset: Offset(0, MySize.getHeight(50)),
                                      itemBuilder: (context) {
                                        return List.generate(
                                            controller.roleList.length,
                                            (index) => PopupMenuItem(
                                                  child: Text(controller
                                                      .roleList[index]),
                                                  onTap: () {
                                                    controller.role.value =
                                                        controller
                                                            .roleList[index];
                                                    controller.role.refresh();
                                                  },
                                                ));
                                      },
                                      child: Container(
                                        height: MySize.getHeight(52),
                                        width: MySize.getWidth(500),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.grey.shade300),
                                          borderRadius: BorderRadius.circular(
                                            MySize.getHeight(10),
                                          ),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: MySize.getWidth(16)),
                                        child: Row(
                                          children: [
                                            Text(
                                              controller.role.value,
                                              style: TextStyle(
                                                  fontSize:
                                                      MySize.getHeight(16)),
                                            ),
                                            Spacer(),
                                            Icon(Icons.arrow_drop_down,
                                                color: Colors.black),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                        width: MySize.getWidth(500),
                                        child: getTextField(
                                            hintText: "Enter Mobile number",
                                            textEditingController: controller
                                                .mobileNumberController,
                                            textInputFormatter: [
                                              FilteringTextInputFormatter.allow(
                                                  RegExp('[0-9.,]')),
                                              LengthLimitingTextInputFormatter(
                                                  10),
                                            ],
                                            validator: (val) {
                                              if (isNullEmptyOrFalse(val)) {
                                                return "Please Enter Mobile Number";
                                              } else if (val!.length < 10) {
                                                return "Please Enter Valid Mobile Number";
                                              }
                                              return null;
                                            })),
                                    Container(
                                        width: MySize.getWidth(500),
                                        child: getTextField(
                                            hintText: "Enter Salary",
                                            textEditingController:
                                                controller.salaryController,
                                            textInputFormatter: [
                                              FilteringTextInputFormatter.allow(
                                                  RegExp('[0-9.,]')),
                                              LengthLimitingTextInputFormatter(
                                                  18),
                                            ],
                                            validator: (val) {
                                              if (isNullEmptyOrFalse(val)) {
                                                return "Please Enter Salary";
                                              }
                                              return null;
                                            })),
                                    InkWell(
                                      onTap: () {
                                        showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime(2020),
                                                lastDate: DateTime.now())
                                            .then((pickedDate) {
                                          // Check if no date is selected
                                          if (pickedDate == null) {
                                            return;
                                          }
                                          controller.selectedDate.value =
                                              "${pickedDate.year}/${pickedDate.month}/${pickedDate.day}";
                                        });
                                      },
                                      child: Container(
                                        height: MySize.getHeight(52),
                                        width: MySize.getWidth(500),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.grey.shade300),
                                          borderRadius: BorderRadius.circular(
                                            MySize.getHeight(10),
                                          ),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: MySize.getWidth(16)),
                                        child: Row(
                                          children: [
                                            Text(
                                              controller.selectedDate.value,
                                              style: TextStyle(
                                                  fontSize:
                                                      MySize.getHeight(16)),
                                            ),
                                            Spacer(),
                                            Icon(Icons.calendar_today,
                                                color: Colors.black),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                        width: MySize.getWidth(500),
                                        child: getTextField(
                                            hintText: "Create Password",
                                            textEditingController:
                                                controller.passwordController,
                                            validator: (val) {
                                              if (isNullEmptyOrFalse(val)) {
                                                return "Please Enter Password";
                                              }
                                              return null;
                                            })),
                                  ]),
                            ),
                            SizedBox(height: MySize.getHeight(40)),
                            Center(
                              child: InkWell(
                                onTap: () {
                                  if (controller.formKey.currentState!
                                      .validate()) {
                                    if (controller.role.value !=
                                        "select role") {
                                      if (controller.isForEdit.value) {
                                        controller.updateUser(context: context);
                                      } else {
                                        if (controller.isImagePicked.isTrue) {
                                          controller.getSubmitApi(
                                              context: context);
                                        } else {
                                          getSnackBar(
                                              context: context,
                                              text: "Please set profile.");
                                        }
                                      }
                                    } else {
                                      getSnackBar(
                                          context: context,
                                          text: "Please select role first.");
                                    }
                                  }
                                },
                                child: Container(
                                  height: MySize.getHeight(60),
                                  width: MySize.getWidth(500),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(
                                          MySize.getHeight(15))),
                                  child: Text(
                                    (controller.isForEdit.value)
                                        ? "Update"
                                        : "Submit",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )),
      );
    }), onWillPop: () async {
      box.write(ArgumentConstant.isForEdit, false);
      return true;
    });
  }
}
