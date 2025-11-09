
// ignore_for_file: must_be_immutable
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:waytofresh/presentation/app_navigation/app_navigation.dart';
import 'package:waytofresh/presentation/app_navigation/binding/app_navigation.dart';
import 'package:waytofresh/presentation/category_screen/binding/category_binding.dart';
import 'package:waytofresh/presentation/category_screen/categoryscreen.dart';
import 'package:waytofresh/presentation/homescreen/Homescreen.dart';
import 'package:waytofresh/presentation/homescreen/homebinding.dart';

class AppRoutes {
  static const String categoryScreen = '/category_screen';
  static const String homeScreen = '/home_screen';
  static const String homeScreenInitialPage = '/home_screen_initial_page';

  static const String appNavigationScreen = '/app_navigation_screen';
  static const String initialRoute = '/';

  static List<GetPage> pages = [
    GetPage(
      name: categoryScreen,
      page: () => CategoryScreen(),
      bindings: [CategoryBinding()],
    ),
    GetPage(
      name: homeScreen,
      page: () => HomeScreen(),
      bindings: [HomeBinding()],
    ),
    GetPage(
      name: appNavigationScreen,
      page: () => AppNavigationScreen(),
      bindings: [AppNavigationBinding()],
    ),
    GetPage(
      name: initialRoute,
      page: () => AppNavigationScreen(),
      bindings: [AppNavigationBinding()],
    ),
  ];
}
