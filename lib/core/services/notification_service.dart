import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import '../controllers/notification_controller.dart';

class NotificationService extends GetxService {
  static NotificationService get to => Get.find();

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  Future<NotificationService> init() async {
    try {
      // 🚨 NOTE: Real Firebase requires google-services.json
      // This is a robust wrapper that fails gracefully until you add the config.
      await Firebase.initializeApp();
      await _setupFCM();
    } catch (e) {
      print("Firebase not initialized: $e");
      print("Please add google-services.json to android/app/ to enable real Push Notifications.");
    }
    return this;
  }

  Future<void> _setupFCM() async {
    // Request permissions
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      // Foreground listener
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        final notifController = Get.find<NotificationController>();
        notifController.showStatusNotification(
          message.notification?.title ?? "New Notification",
          message.notification?.body ?? "",
          saveToHistory: true,
        );
      });
    }
  }

  // ✅ Helper to simulate a push for testing
  void simulatePush(String title, String body) {
    Get.find<NotificationController>().showStatusNotification(
      title,
      body,
      saveToHistory: true,
    );
  }
}
