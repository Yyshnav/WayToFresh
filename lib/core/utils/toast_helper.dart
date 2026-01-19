import 'package:flutter/material.dart';

class ToastHelper {
  static final GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static void showSuccess(String message, {String? title}) {
    _showToast(
      message,
      title: title ?? "Success",
      backgroundColor: Colors.green.shade600,
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
    final messenger = messengerKey.currentState;
    if (messenger == null) return;

    messenger.clearSnackBars();
    messenger.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    message,
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
