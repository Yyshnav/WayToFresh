import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:waytofresh/presentation/homescreen/homecontroller.dart';



class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController());
  }
}
