import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:waytofresh/presentation/app_navigation/app_navigationcontroller.dart/controller.dart';


/// A binding class for the AppNavigationScreen.
///
/// This class ensures that the AppNavigationController is created when the
/// AppNavigationScreen is first loaded.
class AppNavigationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AppNavigationController());
  }
}
