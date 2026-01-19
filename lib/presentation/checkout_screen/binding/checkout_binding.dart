import 'package:get/get.dart';
import '../../category_screen/controller/cart_controller.dart';
import '../controller/address_controller.dart';

class CheckoutBinding extends Bindings {
  @override
  void dependencies() {
    // Ensure CartController is available.
    // If it's already put by CatScreen binding, this might find it,
    // or we can lazy put it again if accessed directly.
    // Usually it's kept alive since it's a singleton-like service for the cart.
    if (!Get.isRegistered<CartController>()) {
      Get.lazyPut(() => CartController());
    }
    Get.lazyPut(() => AddressController());
  }
}
