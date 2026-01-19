import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waytofresh/routes/app_routes.dart';

class LoginController extends GetxController {
  final TextEditingController phoneController = TextEditingController();
  RxBool isPhoneValid = false.obs;

  @override
  void onClose() {
    phoneController.dispose();
    super.onClose();
  }

  void onPhoneChanged(String value) {
    if (value.length == 10) {
      isPhoneValid.value = true;
    } else {
      isPhoneValid.value = false;
    }
  }

  void onContinueTap() {
    if (isPhoneValid.value) {
      Get.toNamed(AppRoutes.otpScreen, arguments: phoneController.text);
    }
  }

  void onSkipTap() {
    Get.offAllNamed(AppRoutes.homeScreen);
  }
}
