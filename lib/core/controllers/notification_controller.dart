import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../presentation/notification_screen/models/notification_model.dart';

class NotificationController extends GetxController {
  // ✅ Observables for In-app History
  final RxList<NotificationModel> notifications = <NotificationModel>[].obs;
  final RxBool isInvoiceSent = false.obs;

  int get unreadCount => notifications.where((n) => !n.isRead).length;

  // ✅ Simulate a notification with consistent Top Position
  void showStatusNotification(String title, String message, {bool isSuccess = true, IconData? customIcon, bool saveToHistory = true}) {
    // Note: Get.closeAllSnackbars() can cause LateInitializationError in some GetX versions.
    // We'll let them queue up naturally for better stability.

    // 1. Save to History
    if (saveToHistory) {
      notifications.insert(0, NotificationModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        message: message,
        timestamp: DateTime.now(),
      ));
    }

    // 2. Show Visual Alert
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: isSuccess ? const Color(0xFF07575B) : Colors.red.shade800,
      colorText: Colors.white,
      borderRadius: 16,
      margin: const EdgeInsets.all(12),
      duration: const Duration(seconds: 4),
      icon: Icon(
        customIcon ?? (isSuccess ? Icons.check_circle_outline : Icons.error_outline),
        color: Colors.white,
        size: 28,
      ),
      mainButton: TextButton(
        onPressed: () => Get.back(),
        child: const Text("DISMISS", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      boxShadows: [
        BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 4))
      ],
      shouldIconPulse: true,
    );
  }

  void markAllAsRead() {
    for (var n in notifications) {
      n.isRead = true;
    }
    notifications.refresh();
  }

  void clearAll() {
    notifications.clear();
  }

  Future<void> refreshNotifications() async {
    // Simulate API fetch delay
    await Future.delayed(const Duration(seconds: 1));
    notifications.refresh();
  }

  // ✅ Simulated triggers
  void notifyPaymentSuccess() => showStatusNotification("Payment Successful 💰", "We've received your payment. Thank you!", customIcon: Icons.payments_outlined);
  void notifyPaymentFailed() => showStatusNotification("Payment Failed ❌", "Your transaction didn't go through. Please try again.", isSuccess: false, customIcon: Icons.error_outline);
  void notifyRefundInitiated() => showStatusNotification("Refund Initiated", "A refund of your payment has been started.", customIcon: Icons.history);
  void notifyRefundCompleted() => showStatusNotification("Refund Completed", "The refund amount has been credited to your account.", customIcon: Icons.account_balance_wallet);
  void notifyOrderPlaced() => showStatusNotification("Order Placed ✅", "Your order has been placed successfully.");
  void notifyShopConfirmed() => showStatusNotification("Shop Confirmed ✅", "The shop has accepted your order.");
  void notifyPreparing() => showStatusNotification("Preparing 🍳", "Your order is being prepared with care.");
  void notifyPacked() => showStatusNotification("Order Packed 📦", "Your items are packed and ready for pickup.");
  void notifyRiderAssigned() => showStatusNotification("Rider Assigned 🛵", "A delivery partner has been assigned to your order.");
  void notifyRiderPickedUp() => showStatusNotification("Rider Picked Up 🛵", "Your rider has picked up the order and is on the way.");
  void notifyOutForDelivery() => showStatusNotification("Out for Delivery 🚚", "Your order is out for delivery!");
  void notifyArrivingIn5Mins() => showStatusNotification("Arriving in 5 mins ⏳", "Your order will be with you in just 5 minutes.");
  void notifyRiderNear() => showStatusNotification("Rider is Near 📍", "Your rider is almost at your location!");
  void notifyRiderArrived() => showStatusNotification("Rider Arrived 📍", "Your delivery partner has reached your doorstep.");
  void notifyOrderDelivered() => showStatusNotification("Order Delivered ✅", "Enjoy your fresh delivery! Hope to see you again.");
  
  // Invoice & Email
  void notifyInvoiceSent() {
    isInvoiceSent.value = true;
    showStatusNotification("Invoice Sent 📧", "A copy of your invoice has been sent to your registered email.", customIcon: Icons.email_outlined);
  }

  // Bonus alerts
  void notifyRainDelay() => showStatusNotification("Rain Delay Alert 🌧️", "Delivery might be slower due to heavy rain. Please stay safe!", customIcon: Icons.cloud_outlined);
  void notifyMessageShop() => showStatusNotification("Message from Shop 🏪", "Shop: 'We've added a surprise gift for you!'", customIcon: Icons.message_outlined);
  void notifyMessageRider() => showStatusNotification("Message from Rider 🛵", "Rider: 'I'll be there in 2 minutes!'", customIcon: Icons.chat_bubble_outline);
  void notifyRateOrder() => showStatusNotification("Rate your order ⭐", "How was your experience? Tap to rate.", customIcon: Icons.star_border);
}
