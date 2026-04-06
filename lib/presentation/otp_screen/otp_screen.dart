import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:waytofresh/theme/theme_helper.dart';
import 'controller/otp_controller.dart';

class OtpScreen extends GetView<OtpController> {
  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Default Pinput Theme removed as package is missing

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            CupertinoIcons.back,
            color: Theme.of(context).iconTheme.color,
          ),
          onPressed: controller.onBackTap,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Verify your number',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                  color: Theme.of(context).textTheme.titleLarge?.color,
                ),
              ),
              const SizedBox(height: 8),
              Obx(
                () => Text(
                  'Enter the 4-digit code sent to +91 ${controller.phoneNumber.value}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // OTP Input with Gradient Border
              Center(
                child: Container(
                  padding: const EdgeInsets.all(2), // Gradient Border Width
                  decoration: BoxDecoration(
                    gradient: appTheme.primaryGradient,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Container(
                    width: 250,
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: TextField(
                      controller: controller.otpController,
                      keyboardType: TextInputType.number,
                      maxLength: 4,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        letterSpacing: 16,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.titleLarge?.color,
                      ),
                      decoration: InputDecoration(
                        counterText: "",
                        hintText: "- - - -",
                        hintStyle: TextStyle(
                          fontSize: 24,
                          letterSpacing: 16,
                          color: Colors.grey.shade300,
                        ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        // Removing underline borders to look like a clean box
                      ),
                      onChanged: (val) {
                        if (val.length == 4) controller.onVerifyTap(val);
                      },
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Timer and Resend
              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      controller.timerSeconds.value > 0
                          ? "Resend code in ${controller.timerSeconds.value}s"
                          : "Did not receive the code?",
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    if (controller.timerSeconds.value == 0)
                      TextButton(
                        onPressed: controller.onResendTap,
                        child: Text(
                          "Resend",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                            decorationColor: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
