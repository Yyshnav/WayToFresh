import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waytofresh/routes/app_routes.dart';
import 'package:waytofresh/core/network/dio_client.dart';
import 'package:dio/dio.dart';
import 'package:waytofresh/core/utils/toast_helper.dart';

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

  void onContinueTap() async {
    if (isPhoneValid.value) {
      Get.dialog(const Center(child: CircularProgressIndicator()),
          barrierDismissible: false);
      try {
        await DioClient().dio.post(
          'auth/otp/request/',
          data: {'phone_number': phoneController.text},
        );
        Get.back(); // close dialog
        Get.toNamed(AppRoutes.otpScreen, arguments: phoneController.text);
      } on DioException catch (e) {
        Get.back();
        ToastHelper.showError(e.response?.data['error'] ?? "Failed to send OTP");
      } catch (e) {
        Get.back();
        ToastHelper.showError("Check your connection and try again");
      }
    } else {
      String message = "Please enter a valid 10-digit phone number";
      if (phoneController.text.isNotEmpty && phoneController.text.length < 10) {
        message = "Your phone number is too short (${phoneController.text.length}/10 digits)";
      }
      ToastHelper.showWarning(message);
    }
  }

  void onSkipTap() {
    Get.offAllNamed(AppRoutes.homeScreen);
  }
}
