import 'package:get/get.dart';
import '../controller/gold_promotion_controller.dart';

class GoldPromotionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => GoldPromotionController());
  }
}
