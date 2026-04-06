import 'package:get/get.dart';
import 'package:waytofresh/presentation/category_screen/controller/cart_controller.dart';
import 'package:waytofresh/presentation/checkout_screen/controller/address_controller.dart';
import 'package:waytofresh/presentation/no_internet_screen/controller/connectivity_controller.dart';
import 'package:waytofresh/core/controllers/notification_controller.dart';
import 'package:waytofresh/presentation/order_tracking_screen/controller/order_tracking_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Global Cart State - Keep it alive throughout the app session
    Get.put(CartController(), permanent: true);
    
    // Global Address State
    Get.put(AddressController(), permanent: true);

    // Global Connectivity Monitoring
    Get.put(ConnectivityController(), permanent: true);

    // Global Notification Handling
    Get.put(NotificationController(), permanent: true);

    // Global Tracking State
    Get.put(OrderTrackingController(), permanent: true);
  }
}
