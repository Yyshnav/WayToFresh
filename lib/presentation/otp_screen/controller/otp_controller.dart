import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waytofresh/routes/app_routes.dart';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:waytofresh/core/network/dio_client.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:waytofresh/core/utils/toast_helper.dart';

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

  void onVerifyTap(String otp) async {
    if (otp.length == 4) { // Django OTP is 4 digits
      Get.dialog(const Center(child: CircularProgressIndicator()),
          barrierDismissible: false);
      try {
        final response = await DioClient().dio.post(
          'auth/otp/verify/',
          data: {
            'phone_number': phoneNumber.value,
            'otp': otp,
          },
        );
        
        // Save tokens
        final access = response.data['tokens']['access'];
        final refresh = response.data['tokens']['refresh'];
        const secureStorage = FlutterSecureStorage();
        await secureStorage.write(key: 'access_token', value: access);
        await secureStorage.write(key: 'refresh_token', value: refresh);

        Get.back(); // Close dialog
        Get.offAllNamed(AppRoutes.homeScreen);
      } on DioException catch (e) {
        Get.back();
        ToastHelper.showError(e.response?.data['error'] ?? "Invalid OTP");
      } catch (e) {
        Get.back();
        ToastHelper.showError("Check your connection and try again");
      }
    } else {
      String message = "Please enter a valid 4-digit OTP";
      if (otp.isNotEmpty && otp.length < 4) {
        message = "OTP is incomplete ($otp.length/4 digits)";
      }
      ToastHelper.showWarning(message);
    }
  }

  void onBackTap() {
    Get.back();
  }
}
