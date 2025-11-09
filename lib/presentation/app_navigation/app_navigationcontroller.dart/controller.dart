

import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:waytofresh/presentation/app_navigation/models/app_navigationmodel.dart';

/// A controller class for the AppNavigationScreen.
///
/// This class manages the state of the AppNavigationScreen, including the
/// current appNavigationModelObj
class AppNavigationController extends GetxController {
  Rx<AppNavigationModel> appNavigationModelObj = AppNavigationModel().obs;
}
