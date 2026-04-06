import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'dart:ui';
import '../controller/voice_search_controller.dart';
import '../../../../core/app_expote.dart';

class VoiceSearchBottomSheet extends StatelessWidget {
  const VoiceSearchBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(VoiceSearchController());

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Container(
        decoration: BoxDecoration(
          color: appTheme.gray_900.withOpacity(0.95),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle for bottom sheet
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            
            // Header
            const Text(
              "Hi Sharmada",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              "I'm listening...",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 30),
            
            // Pulsing Animation (Large)
            Obx(() => GestureDetector(
              onTap: () {
                if (controller.isListening.value) {
                  controller.stopListening();
                } else {
                  controller.startListening();
                }
              },
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: controller.isListening.value 
                      ? Colors.blueAccent.withOpacity(0.1) 
                      : Colors.white.withOpacity(0.05),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Wave Animation
                    if (controller.isListening.value)
                      SizedBox(
                        width: 250,
                        height: 250,
                        child: Lottie.network(
                          'https://assets9.lottiefiles.com/packages/lf20_9aaasv2q.json',
                          fit: BoxFit.contain,
                        ),
                      )
                    else
                      const Icon(
                        CupertinoIcons.mic_fill,
                        color: Colors.white30,
                        size: 60,
                      ),
                  ],
                ),
              ),
            )),
            
            const SizedBox(height: 20),
            
            // Live transcription
            Obx(() => Container(
              height: 40,
              alignment: Alignment.center,
              child: Text(
                controller.speechText.value.isEmpty 
                    ? (controller.isListening.value ? "Listening..." : "Tap to speak")
                    : controller.speechText.value,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: controller.speechText.value.isEmpty ? Colors.white38 : Colors.blueAccent,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )),
            
            const SizedBox(height: 40),
            
            // Suggestions
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Try saying",
                style: TextStyle(
                  color: Colors.white38,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildSuggestionChip("Fresh Milk"),
                  const SizedBox(width: 10),
                  _buildSuggestionChip("Ice Cream"),
                  const SizedBox(width: 10),
                  _buildSuggestionChip("Organic Eggs"),
                  const SizedBox(width: 10),
                  _buildSuggestionChip("Bread"),
                ],
              ),
            ),
            
            const SizedBox(height: 30),
            
            // Close Button
            TextButton(
              onPressed: () => Get.back(),
              child: const Text(
                "CANCEL",
                style: TextStyle(
                  color: Colors.white38,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestionChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 14,
        ),
      ),
    );
  }
}
