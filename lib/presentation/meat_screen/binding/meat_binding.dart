import 'package:get/get.dart';
import '../controller/meat_controller.dart';

class MeatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MeatController());
  }
}
