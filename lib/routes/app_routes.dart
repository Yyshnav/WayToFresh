import 'package:get/get.dart';
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
import 'package:waytofresh/presentation/meat_screen/product_detail_screen.dart';
import 'package:waytofresh/presentation/meat_screen/binding/meat_binding.dart';
import 'package:waytofresh/presentation/meat_screen/bulk_order_screen.dart';
import 'package:waytofresh/presentation/order_tracking_screen/order_tracking_screen.dart';
import 'package:waytofresh/presentation/view_bill_screen/view_bill_screen.dart';
import 'package:waytofresh/presentation/search_screen/search_screen.dart';
import 'package:waytofresh/presentation/search_screen/binding/search_binding.dart';
import 'package:waytofresh/presentation/my_orders_screen/my_orders_screen.dart';
import 'package:waytofresh/presentation/my_orders_screen/binding/my_orders_binding.dart';
import 'package:waytofresh/presentation/gold_promotion_screen/gold_promotion_screen.dart';
import 'package:waytofresh/presentation/gold_promotion_screen/binding/gold_promotion_binding.dart';
import 'package:waytofresh/presentation/category_screen/category_products_screen.dart';

class AppRoutes {
  static const String categoryScreen = '/category_screen';
  static const String categoryGridScreen = '/category_grid_screen';
  static const String meatScreen = '/meat_screen';
  static const String productDetailScreen = '/product_detail_screen';
  static const String bulkOrderScreen = '/bulk_order_screen';
  static const String homeScreen = '/home_screen';
  static const String homeScreenInitialPage = '/home_screen_initial_page';
  static const String appNavigationScreen = '/app_navigation_screen';
  static const String checkoutScreen = '/checkout_screen';
  static const String loginScreen = '/login_screen';
  static const String otpScreen = '/otp_screen';
  static const String splashScreen = '/splash_screen';
  static const String profileScreen = '/profile_screen'; 
  static const String orderTrackingScreen = '/order_tracking_screen';
  static const String viewBillScreen = '/view_bill_screen';
  static const String searchScreen = '/search_screen';
  static const String myOrdersScreen = '/my_orders_screen';
  static const String goldPromotionScreen = '/gold_promotion_screen';
  static const String categoryProductsScreen = '/category_products_screen';
  static const String initialRoute = '/splash_screen';

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
      transition: Transition.cupertino,
    ),
    GetPage(
      name: loginScreen,
      page: () => const LoginScreen(),
      binding: LoginBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: otpScreen,
      page: () => const OtpScreen(),
      binding: OtpBinding(),
      transition: Transition.rightToLeftWithFade,
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
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: meatScreen,
      page: () => const MeatScreen(),
      binding: MeatBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: bulkOrderScreen,
      page: () => BulkOrderScreen(),
      transition: Transition.native,
    ),
    GetPage(
      name: homeScreen,
      page: () => HomeScreen(),
      bindings: [HomeBinding()],
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: checkoutScreen,
      page: () => const CheckoutScreen(),
      binding: CheckoutBinding(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: appNavigationScreen,
      page: () => AppNavigationScreen(),
      bindings: [AppNavigationBinding()],
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: orderTrackingScreen,
      page: () => const OrderTrackingScreen(),
      transition: Transition.native,
    ),
    GetPage(
      name: viewBillScreen,
      page: () => const ViewBillScreen(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: searchScreen,
      page: () => const SearchScreen(),
      binding: SearchBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: myOrdersScreen,
      page: () => const MyOrdersScreen(),
      binding: MyOrdersBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: productDetailScreen,
      page: () => ProductDetailScreen(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: goldPromotionScreen,
      page: () => const GoldPromotionScreen(),
      binding: GoldPromotionBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: categoryProductsScreen,
      page: () => const CategoryProductsScreen(),
      transition: Transition.rightToLeftWithFade,
    ),
  ];
}
