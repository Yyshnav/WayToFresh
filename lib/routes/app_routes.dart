// ignore_for_file: must_be_immutable
import 'package:get/get.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:waytofresh/presentation/app_navigation/app_navigation.dart';
import 'package:waytofresh/presentation/app_navigation/binding/app_navigation.dart';
import 'package:waytofresh/presentation/category_screen/binding/category_binding.dart';
import 'package:waytofresh/presentation/category_screen/cat.dart';
import 'package:waytofresh/presentation/category_screen/categoryscreen.dart';
import 'package:waytofresh/presentation/homescreen/Homescreen.dart';
import 'package:waytofresh/presentation/homescreen/homebinding.dart';
import 'package:waytofresh/presentation/checkout_screen/checkout_screen.dart';
import 'package:waytofresh/presentation/checkout_screen/binding/checkout_binding.dart';
import 'package:waytofresh/presentation/login_screen/login_screen.dart';
import 'package:waytofresh/presentation/login_screen/binding/login_binding.dart';
import 'package:waytofresh/presentation/otp_screen/otp_screen.dart';
import 'package:waytofresh/presentation/otp_screen/binding/otp_binding.dart';
import 'package:waytofresh/presentation/splash_screen/splash_screen.dart';
import 'package:waytofresh/presentation/splash_screen/binding/splash_binding.dart';
import 'package:waytofresh/presentation/profile_screen/profile_screen.dart';
import 'package:waytofresh/presentation/profile_screen/binding/profile_binding.dart';
import 'package:waytofresh/presentation/meat_screen/meat_screen.dart';
import 'package:waytofresh/presentation/meat_screen/bulk_order_screen.dart';

class AppRoutes {
  static const String categoryScreen = '/category_screen';
  static const String categoryGridScreen = '/category_grid_screen';
  static const String meatScreen = '/meat_screen'; // New route
  static const String bulkOrderScreen = '/bulk_order_screen';
  static const String homeScreen = '/home_screen';
  static const String homeScreenInitialPage = '/home_screen_initial_page';

  static const String appNavigationScreen = '/app_navigation_screen';
  static const String checkoutScreen = '/checkout_screen';
  static const String loginScreen = '/login_screen';
  static const String otpScreen = '/otp_screen';
  static const String splashScreen = '/splash_screen';
  static const String profileScreen = '/profile_screen'; // Added
  static const String initialRoute = '/splash_screen'; // Start with Splash

  static List<GetPage> pages = [
    GetPage(
      name: splashScreen,
      page: () => const SplashScreen(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: profileScreen,
      page: () => const ProfileScreen(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: loginScreen,
      page: () => const LoginScreen(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: otpScreen,
      page: () => const OtpScreen(),
      binding: OtpBinding(),
    ),
    GetPage(
      name: categoryScreen,
      page: () => const CatScreen(),
      bindings: [CategoryBinding()],
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: categoryGridScreen,
      page: () => const CategoryScreen(),
      bindings: [CategoryBinding()],
    ),
    GetPage(
      name: meatScreen,
      page: () => const MeatScreen(),
      // Add binding if necessary later
    ),
    GetPage(name: bulkOrderScreen, page: () => BulkOrderScreen()),
    GetPage(
      name: homeScreen,
      page: () => HomeScreen(),
      bindings: [HomeBinding()],
    ),
    GetPage(
      name: checkoutScreen,
      page: () => const CheckoutScreen(),
      binding: CheckoutBinding(),
    ),
    GetPage(
      name: appNavigationScreen,
      page: () => AppNavigationScreen(),
      bindings: [AppNavigationBinding()],
    ),
  ];
}
