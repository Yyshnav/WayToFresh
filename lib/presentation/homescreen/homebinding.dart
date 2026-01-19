import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:waytofresh/presentation/homescreen/homecontroller.dart';
import '../category_screen/controller/cart_controller.dart';
import '../checkout_screen/controller/address_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController());
    Get.lazyPut(() => CartController(), fenix: true);
    Get.lazyPut(() => AddressController(), fenix: true);
  }
}
