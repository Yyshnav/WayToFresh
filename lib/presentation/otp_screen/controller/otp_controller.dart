import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waytofresh/routes/app_routes.dart';
import 'dart:async';

class OtpController extends GetxController {
  final TextEditingController otpController =
      TextEditingController(); // Or use separate controllers for each digit if custom
  RxInt timerSeconds = 30.obs;
  Timer? _timer;
  RxString phoneNumber = "".obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      phoneNumber.value = Get.arguments.toString();
    }
    startTimer();
  }

  @override
  void onClose() {
    otpController.dispose();
    _timer?.cancel();
    super.onClose();
  }

  void startTimer() {
    timerSeconds.value = 30;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timerSeconds.value > 0) {
        timerSeconds.value--;
      } else {
        _timer?.cancel();
      }
    });
  }

  void onResendTap() {
    startTimer();
    // Logic to resend OTP
  }

  void onVerifyTap(String otp) {
    // Logic to verify OTP
    if (otp.length == 4) {
      // Assuming 4 digit OTP
      Get.offAllNamed(AppRoutes.homeScreen);
    } else {
      Get.snackbar("Error", "Please enter a valid OTP");
    }
  }

  void onBackTap() {
    Get.back();
  }
}
