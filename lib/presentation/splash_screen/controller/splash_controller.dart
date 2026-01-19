import 'package:get/get.dart';
import 'package:waytofresh/routes/app_routes.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _startTimer();
  }

  void _startTimer() {
    Future.delayed(const Duration(seconds: 3), () {
      Get.offNamed(AppRoutes.loginScreen);
    });
  }
}
