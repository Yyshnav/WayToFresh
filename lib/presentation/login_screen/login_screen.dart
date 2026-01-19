import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waytofresh/core/app_expote.dart';
import 'package:waytofresh/theme/theme_helper.dart';
import 'package:waytofresh/widgets/custom_image_view.dart';
import 'controller/login_controller.dart';
import 'dart:math';

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        height: Get.height,
        width: Get.width,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFA1D6E0), Color(0xFF1995AD), Color(0xFF07575B)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header with Skip
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: controller.onSkipTap,
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(
                          0.2,
                        ), // Glassy look
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        'Skip login',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Grid Background (Simulated)
                      SizedBox(
                        height: Get.height * 0.45,
                        width: double.infinity,
                        child: Stack(
                          children: [
                            // Background Grid
                            GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 5, // 5 columns
                                    childAspectRatio: 0.8,
                                    crossAxisSpacing: 16,
                                    mainAxisSpacing: 16,
                                  ),
                              itemCount: 20,
                              padding: const EdgeInsets.all(16),
                              itemBuilder: (context, index) {
                                // Randomly pick an image or color placeholder
                                // Using local assets if available or just placeholders
                                final opacity =
                                    1.0 -
                                    (index / 20.0); // Simple Fade effect logic
                                return Opacity(
                                  opacity:
                                      0.2 +
                                      (Random().nextDouble() *
                                          0.3), // Lower opacity for blending
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(
                                        0.3,
                                      ), // Glassy tiles
                                      borderRadius: BorderRadius.circular(12),
                                      image: DecorationImage(
                                        image: AssetImage(
                                          'assets/images/image_${(index % 5) + 50}.png',
                                        ), // Just assuming some assets exist or fallback
                                        onError:
                                            (
                                              exception,
                                              stackTrace,
                                            ) {}, // Safe fail
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),

                            // Gradient Overlay at bottom to fade into background
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              height: 100,
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      // Fade to the bottom color of the background gradient approx
                                      // Or just transparent to allow full bleed,
                                      // but the grid needs to fade out?
                                      // Let's fade to the dominant bottom color or just transparent opacity
                                      Color(0xFF07575B).withOpacity(0.8),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            // Logo in Center
                            Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width:
                                        80, // Increased width for longer text
                                    height: 80, // Increased height
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors
                                          .white, // White box for logo on colored bg
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black12,
                                          blurRadius: 10,
                                          spreadRadius: 2,
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Way To\nFresh",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Color(
                                            0xFF1995AD,
                                          ), // Colored text
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    "Buy Fresh, Eat Fresh",
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Poppins',
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "Log in or Sign Up",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'Poppins',
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Phone Input Field
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Container(
                          padding: const EdgeInsets.all(
                            2,
                          ), // Gradient Divider Width
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFFA1D6E0),
                                Color(0xFF1995AD),
                                Color(0xFF07575B),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 4,
                            ),
                            child: Row(
                              children: [
                                Text(
                                  "+91",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  height: 20,
                                  width: 1,
                                  color: Colors.grey.shade300,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: TextField(
                                    controller: controller.phoneController,
                                    keyboardType: TextInputType.phone,
                                    maxLength: 10,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                    decoration: const InputDecoration(
                                      hintText: "Enter mobile number",
                                      border: InputBorder.none,
                                      counterText: "",
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                    onChanged: controller.onPhoneChanged,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Continue Button
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Obx(
                          () => Container(
                            width: double.infinity,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              gradient: controller.isPhoneValid.value
                                  ? LinearGradient(
                                      colors: [
                                        Color(0xFFA1D6E0),
                                        Color(0xFF1995AD),
                                        Color(0xFF07575B),
                                      ],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    )
                                  : null,
                              color: controller.isPhoneValid.value
                                  ? null
                                  : Colors.grey.shade400,
                            ),
                            child: ElevatedButton(
                              onPressed: controller.isPhoneValid.value
                                  ? controller.onContinueTap
                                  : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                              child: Text(
                                "Continue",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "By continuing, you agree to our Terms of Service & Privacy Policy",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey.shade500,
                        ),
                      ),
                      const SizedBox(height: 20), // Bottom padding
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
