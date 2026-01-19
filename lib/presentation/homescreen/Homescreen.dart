import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:waytofresh/core/utils/image_constants.dart';
import 'package:waytofresh/presentation/category_screen/cat.dart';
import 'package:waytofresh/presentation/homescreen/homecontroller.dart';
import 'package:waytofresh/presentation/category_screen/categoryscreen.dart'
    as grid;
import 'package:waytofresh/routes/app_routes.dart';
import 'package:waytofresh/widgets/custom_bottom_bar.dart';
import './home_initial_page.dart';

class HomeScreen extends GetWidget<HomeController> {
  HomeScreen({Key? key}) : super(key: key);

  final RxInt selectedIndex = 0.obs;

  // ✅ Separate scroll controllers for each tab
  final ScrollController _homeScrollController = ScrollController();
  final ScrollController _categoryScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    // ✅ Add listeners for both scroll controllers
    _homeScrollController.addListener(() => _onScroll(_homeScrollController));
    _categoryScrollController.addListener(
      () => _onScroll(_categoryScrollController),
    );

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            // ✅ Main screen content
            Obx(() {
              return _getCurrentPage();
            }),

            // ✅ Animated Bottom Bar (slides in/out)
            Obx(() {
              return AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                bottom: controller.hideBottomBar.value ? -100 : 0,
                left: 0,
                right: 0,
                child: CustomBottomBar(
                  key: ValueKey(
                    selectedIndex.value,
                  ), // Force rebuild to update colors
                  bottomBarItems: [
                    CustomBottomBarItem(
                      icon: ImageConstant.imgHome1,
                      label: "Home",
                      routeName: AppRoutes.homeScreenInitialPage,
                    ),
                    CustomBottomBarItem(
                      icon: ImageConstant.imgCategory1,
                      label: "Category",
                      routeName: AppRoutes.categoryScreen,
                    ),
                    CustomBottomBarItem(
                      icon: ImageConstant.imgShoppingbag1,
                      label: "Order again",
                      routeName: AppRoutes.categoryScreen,
                    ),
                    CustomBottomBarItem(
                      icon: ImageConstant.imgPrinter1,
                      label: "Print",
                      routeName: AppRoutes.categoryScreen,
                    ),
                  ],
                  selectedIndex: selectedIndex.value,
                  onItemTap: (index) {
                    selectedIndex.value = index;
                  },
                  // ✅ Pass active scroll controller only
                  scrollController: selectedIndex.value == 0
                      ? _homeScrollController
                      : _categoryScrollController,
                  indicatorColor: Theme.of(context).primaryColor,
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  /// 🧠 Detect scroll direction to show/hide bottom bar
  void _onScroll(ScrollController controllerScroll) {
    if (controllerScroll.position.userScrollDirection ==
        ScrollDirection.reverse) {
      controller.hideBottomBar.value = true;
    } else if (controllerScroll.position.userScrollDirection ==
        ScrollDirection.forward) {
      controller.hideBottomBar.value = false;
    }
  }

  /// 🏠 Return current page based on selected tab
  Widget _getCurrentPage() {
    switch (selectedIndex.value) {
      case 0:
        return HomeInitialPage(scrollController: _homeScrollController);
      case 1:
        return grid.CategoryScreen(scrollController: _categoryScrollController);
      default:
        return HomeInitialPage(scrollController: _homeScrollController);
    }
  }
}
