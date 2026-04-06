import 'package:get/get.dart';
import 'package:waytofresh/presentation/search_screen/controller/search_controller.dart';

class SearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SearchScreenController());
  }
}
