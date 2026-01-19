import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  RxString name = "Md Abu Ubayda".obs;
  RxString phone = "+8801712346789".obs;
  RxString image = "https://via.placeholder.com/150".obs; // Placeholder for now

  RxBool isDarkMode = false.obs;

  @override
  void onInit() {
    super.onInit();
    isDarkMode.value = Get.isDarkMode;
  }

  void onBackTap() {
    Get.back();
  }

  void onMenuTap(String title) {
    // Handle menu taps
    print("Tapped on $title");
  }

  void toggleTheme(bool value) {
    isDarkMode.value = value;
    Get.changeThemeMode(value ? ThemeMode.dark : ThemeMode.light);
  }
}
