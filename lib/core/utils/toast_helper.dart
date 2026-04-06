import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ToastHelper {
  static void showSuccess(String message, {String? title}) {
    _showToast(
      message,
      title: title ?? "Success",
      backgroundColor: const Color(0xFF07575B),
      icon: Icons.check_circle_outline,
    );
  }

  static void showError(String message, {String? title}) {
    _showToast(
      message,
      title: title ?? "Error",
      backgroundColor: Colors.red.shade800,
      icon: Icons.error_outline,
    );
  }

  static void showInfo(String message, {String? title}) {
    _showToast(
      message,
      title: title ?? "Note",
      backgroundColor: Colors.blue.shade700,
      icon: Icons.info_outline,
    );
  }

  static void showWarning(String message, {String? title}) {
    _showToast(
      message,
      title: title ?? "Warning",
      backgroundColor: Colors.orange.shade800,
      icon: Icons.warning_amber_outlined,
    );
  }

  static void _showToast(
    String message, {
    required String title,
    required Color backgroundColor,
    required IconData icon,
  }) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: backgroundColor,
      colorText: Colors.white,
      borderRadius: 16,
      margin: const EdgeInsets.all(12),
      duration: const Duration(seconds: 3),
      icon: Icon(icon, color: Colors.white, size: 28),
      boxShadows: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
      shouldIconPulse: true,
      dismissDirection: DismissDirection.horizontal,
      leftBarIndicatorColor: Colors.white.withOpacity(0.3),
    );
  }
}
