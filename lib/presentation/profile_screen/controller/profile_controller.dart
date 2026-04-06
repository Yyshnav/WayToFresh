import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waytofresh/presentation/my_orders_screen/my_orders_screen.dart';
import 'package:waytofresh/presentation/my_orders_screen/binding/my_orders_binding.dart';
import 'package:waytofresh/presentation/privacy_policy_screen/privacy_policy_screen.dart';
import 'package:waytofresh/presentation/terms_conditions_screen/terms_conditions_screen.dart';
import 'package:waytofresh/presentation/my_profile_screen/my_profile_screen.dart';

class ProfileController extends GetxController {
  RxString name = "Md Abu Ubayda".obs;
  RxString phone = "+8801712346789".obs;
  RxString image = "https://via.placeholder.com/150".obs; // Placeholder for now

  @override
  void onInit() {
    super.onInit();
  }

  void onBackTap() {
    Get.back();
  }

  void onMenuTap(String title) {
    // Handle menu taps
    if (title == "My Orders") {
      Get.to(
        () => const MyOrdersScreen(),
        binding: MyOrdersBinding(),
        transition: Transition.rightToLeftWithFade,
      );
    } else if (title == "My Profile") {
      Get.to(
        () => const MyProfileScreen(),
        transition: Transition.rightToLeftWithFade,
      );
    } else if (title == "Privacy Policy") {
      Get.to(
        () => const PrivacyPolicyScreen(),
        transition: Transition.rightToLeftWithFade,
      );
    } else if (title == "Terms & Conditions") {
      Get.to(
        () => const TermsConditionsScreen(),
        transition: Transition.rightToLeftWithFade,
      );
    } else if (title == "Logout") {
      _showLogoutDialog();
    }
    print("Tapped on $title");
  }

  void _showLogoutDialog() {
    Get.defaultDialog(
      title: "Logout",
      middleText: "Are you sure you want to logout?",
      textConfirm: "Logout",
      textCancel: "Cancel",
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () {
        // Handle actual logout logic here (e.g., clear tokens)
        Get.offAllNamed('/login_screen'); // Adjust route name as per your app
      },
    );
  }
}
