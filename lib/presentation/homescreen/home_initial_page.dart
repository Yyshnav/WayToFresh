// import 'package:flutter/material.dart';
// import 'package:waytofresh/core/app_expote.dart';
// import 'package:waytofresh/core/utils/image_constants.dart';
// import 'package:waytofresh/presentation/homescreen/homecontroller.dart';

// import '../../widgets/custom_blinkit_app_bar.dart';
// import '../../widgets/custom_image_view.dart';
// import './widgets/category_item_widget.dart';
// import './widgets/grocery_category_item_widget.dart';
// import './widgets/product_item_widget.dart';

// class HomeInitialPage extends StatelessWidget {
//   HomeInitialPage({Key? key}) : super(key: key);

//   HomeController controller = Get.put(HomeController());

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: appTheme.white_A700,
//       body: Column(
//         children: [
//           _buildHeader(),
//           Expanded(
//             child: SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _buildMegaSaleBanner(),
//                   SizedBox(height: 22.h),
//                   _buildProductsSection(),
//                   SizedBox(height: 22.h),
//                   _buildGrocerySection(),
//                   SizedBox(height: 12.h),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // Widget _buildHeader() {
//   //   return Container(
//   //     width: double.infinity,
//   //     padding: EdgeInsets.symmetric(vertical: 20.h),
//   //     decoration: BoxDecoration(color: appTheme.red_A700),
//   //     child: Column(
//   //       spacing: 16.h,
//   //       children: [
//   //         CustomBlinkitAppBar(
//   //           locationLabel: "HOME",
//   //           address: "Sujal Dave, Ratanada, Jodhpur (Raj)",
//   //           onActionPressed: () {
//   //             // Handle profile action
//   //           },
//   //           onLocationPressed: () {
//   //             // Handle location selection
//   //           },
//   //         ),
//   //         _buildSearchBar(),
//   //       ],
//   //     ),
//   //   );
//   // }

//   // Widget _buildSearchBar() {
//   //   return Container(
//   //     margin: EdgeInsets.symmetric(horizontal: 14.h),
//   //     child: TextFormField(
//   //       controller: controller.searchController,
//   //       decoration: InputDecoration(
//   //         hintText: 'Search "ice-cream"',
//   //         hintStyle: TextStyleHelper.instance.body12RegularPoppins,
//   //         prefixIcon: Padding(
//   //           padding: EdgeInsets.all(12.h),
//   //           child: CustomImageView(
//   //             imagePath: ImageConstant.imgSearchinterfacesymbol1,
//   //             height: 14.h,
//   //             width: 14.h,
//   //           ),
//   //         ),
//   //         suffixIcon: Padding(
//   //           padding: EdgeInsets.all(12.h),
//   //           child: CustomImageView(
//   //             imagePath: ImageConstant.imgMic1,
//   //             height: 14.h,
//   //             width: 14.h,
//   //           ),
//   //         ),
//   //         filled: true,
//   //         fillColor: appTheme.white_A700,
//   //         border: OutlineInputBorder(
//   //           borderRadius: BorderRadius.circular(10.h),
//   //           borderSide: BorderSide(color: appTheme.gray_400, width: 1.h),
//   //         ),
//   //         enabledBorder: OutlineInputBorder(
//   //           borderRadius: BorderRadius.circular(10.h),
//   //           borderSide: BorderSide(color: appTheme.gray_400, width: 1.h),
//   //         ),
//   //         focusedBorder: OutlineInputBorder(
//   //           borderRadius: BorderRadius.circular(10.h),
//   //           borderSide: BorderSide(color: appTheme.gray_400, width: 1.h),
//   //         ),
//   //         contentPadding: EdgeInsets.symmetric(horizontal: 26.h, vertical: 8.h),
//   //       ),
//   //       onChanged: (value) {
//   //         controller.onSearchChanged(value);
//   //       },
//   //     ),
//   //   );
//   // }
//   Widget _buildSearchBar() {
//     return Container(
//       margin: EdgeInsets.only(left: 14.h, right: 14.h, bottom: 4.h),
//       padding: EdgeInsets.symmetric(horizontal: 26.h, vertical: 8.h),
//       decoration: BoxDecoration(
//         color: appTheme.white_A700,
//         borderRadius: BorderRadius.circular(10.h),
//         border: Border.all(color: appTheme.gray_400, width: 1.h),
//       ),
//       child: Row(
//         children: [
//           CustomImageView(
//             imagePath: ImageConstant.imgSearchinterfacesymbol1,
//             height: 14.h,
//             width: 14.h,
//           ),
//           SizedBox(width: 12.h),
//           Expanded(
//             child: TextFormField(
//               controller: controller.searchController,
//               style: TextStyleHelper.instance.body12RegularPoppins.copyWith(
//                 color: appTheme.black_900,
//               ),
//               decoration: InputDecoration(
//                 hintText: "Search \"ice-cream\"",
//                 hintStyle: TextStyleHelper.instance.body12RegularPoppins,
//                 border: InputBorder.none,
//                 isDense: true,
//                 contentPadding: EdgeInsets.zero,
//               ),
//               onChanged: (value) => controller.onSearchChanged(value),
//             ),
//           ),
//           SizedBox(width: 12.h),
//           GestureDetector(
//             // onTap: () => controller.onVoiceSearchPressed(),
//             child: CustomImageView(
//               imagePath: ImageConstant.imgMic1,
//               height: 14.h,
//               width: 14.h,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildHeader() {
//     return Container(
//       width: double.infinity,
//       padding: EdgeInsets.symmetric(vertical: 20.h),
//       decoration: const BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topCenter,
//           end: Alignment.bottomCenter,
//           colors: [Color(0xFF3A1414), Color(0xFF4B1E1E), Color(0xFF6E2C1A)],
//           stops: [0.0, 0.5, 1.0],
//         ),
//       ),

//       child: Column(
//         spacing: 16.h,
//         children: [
//           CustomBlinkitAppBar(
//             locationLabel: "HOME",
//             address: "Sujal Dave, Ratanada, Jodhpur (Raj)",
//             onActionPressed: () {
//               // Handle profile action
//             },
//             onLocationPressed: () {
//               // Handle location selection
//             },
//           ),
//           _buildSearchBar(),
//         ],
//       ),
//     );
//   }

//   Widget _buildMegaSaleBanner() {
//     return Container(
//       width: double.infinity,
//       height: 196.h,
//       child: Stack(
//         children: [
//           // ✅ Vertical brown gradient background
//           Container(
//             width: double.infinity,
//             height: double.infinity,
//             decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//                 colors: [
//                   Color(0xFF6E2C1A),
//                   Color(0xFF4B1E1E),
//                   Color(0xFF3A1414),
//                 ],
//                 stops: [0.0, 0.5, 1.0],
//               ),
//             ),
//           ),
//           Positioned.fill(
//             child: Padding(
//               padding: EdgeInsets.symmetric(horizontal: 15.h),
//               child: Column(
//                 children: [
//                   Row(
//                     children: [
//                       Container(
//                         width: 84.h,
//                         height: 56.h,
//                         child: Stack(
//                           children: [
//                             Positioned(
//                               right: 0,
//                               bottom: 0,
//                               child: CustomImageView(
//                                 imagePath: ImageConstant.imgImage55,
//                                 height: 46.h,
//                                 width: 50.h,
//                               ),
//                             ),
//                             Positioned(
//                               left: 0,
//                               top: 0,
//                               child: CustomImageView(
//                                 imagePath: ImageConstant.imgImage60,
//                                 height: 56.h,
//                                 width: 50.h,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       SizedBox(width: 6.h),
//                       Text(
//                         'Mega Diwali Sale',
//                         style: TextStyleHelper.instance.title20BoldPTSerif
//                             .copyWith(color: Colors.white),
//                       ),
//                       SizedBox(width: 4.h),
//                       Container(
//                         width: 92.h,
//                         height: 56.h,
//                         child: Stack(
//                           children: [
//                             Positioned(
//                               left: 0,
//                               bottom: 2.h,
//                               child: CustomImageView(
//                                 imagePath: ImageConstant.imgImage55,
//                                 height: 46.h,
//                                 width: 50.h,
//                               ),
//                             ),
//                             Positioned(
//                               right: 0,
//                               top: 0,
//                               child: CustomImageView(
//                                 imagePath: ImageConstant.imgImage60,
//                                 height: 56.h,
//                                 width: 50.h,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 2.h),
//                   _buildCategoryTiles(),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildCategoryTiles() {
//     return SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       child: Obx(
//         () => Row(
//           spacing: 8.h,
//           children: controller.categoryItems.map((category) {
//             return CategoryItemWidget(category: category);
//           }).toList(),
//         ),
//       ),
//     );
//   }

//   Widget _buildProductsSection() {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 14.h),
//       child: Obx(
//         () => SingleChildScrollView(
//           scrollDirection: Axis.horizontal,
//           child: Row(
//             children: controller.productItems.map((product) {
//               return Padding(
//                 padding: EdgeInsets.only(right: 8.h),
//                 child: ProductItemWidget(product: product),
//               );
//             }).toList(),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildGrocerySection() {
//     return Padding(
//       padding: EdgeInsets.only(left: 14.h, bottom: 12.h),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         spacing: 6.h,
//         children: [
//           Text(
//             'Grocery & Kitchen',
//             style: TextStyleHelper.instance.body14BoldPoppins,
//           ),
//           SingleChildScrollView(
//             scrollDirection: Axis.horizontal,
//             child: Obx(
//               () => Row(
//                 spacing: 10.h,
//                 children: controller.groceryCategories.map((category) {
//                   return GroceryCategoryItemWidget(category: category);
//                 }).toList(),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:waytofresh/core/app_expote.dart';
import 'package:waytofresh/core/utils/image_constants.dart';
import 'package:waytofresh/presentation/homescreen/homecontroller.dart';

import '../../widgets/custom_blinkit_app_bar.dart';
import '../../widgets/custom_image_view.dart';
import './widgets/category_item_widget.dart';
import './widgets/grocery_category_item_widget.dart';
import './widgets/product_item_widget.dart';

class HomeInitialPage extends StatefulWidget {
  final ScrollController scrollController;

  const HomeInitialPage({Key? key, required this.scrollController})
    : super(key: key);

  @override
  State<HomeInitialPage> createState() => _HomeInitialPageState();
}

class _HomeInitialPageState extends State<HomeInitialPage> {
  final HomeController controller = Get.put(HomeController());
  bool _isHeaderVisible = true;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (widget.scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      if (_isHeaderVisible) {
        setState(() => _isHeaderVisible = false);
      }
    } else if (widget.scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      if (!_isHeaderVisible) {
        setState(() => _isHeaderVisible = true);
      }
    }
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // ✅ Animated Header (Hides on scroll)
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: _isHeaderVisible ? 120 : 0,
            curve: Curves.easeInOut,
            child: _isHeaderVisible ? _buildHeader() : const SizedBox.shrink(),
          ),

          // ✅ Scrollable Body
          Expanded(
            child: SingleChildScrollView(
              controller: widget.scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // _buildSearchBar(),
                  // const SizedBox(height: 22),
                  _buildMegaSaleBanner(context),
                  const SizedBox(height: 22),
                  _buildFrequentlyBoughtSection(),
                  const SizedBox(height: 22),
                  _buildProductsSection(),
                  const SizedBox(height: 22),
                  _buildGrocerySection(),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: EdgeInsets.only(left: 14.h, right: 14.h, bottom: 4.h),
      padding: EdgeInsets.symmetric(horizontal: 26.h, vertical: 8.h),
      decoration: BoxDecoration(
        color: appTheme.white_A700,
        borderRadius: BorderRadius.circular(10.h),
        border: Border.all(color: appTheme.gray_400, width: 1.h),
      ),
      child: Row(
        children: [
          CustomImageView(
            imagePath: ImageConstant.imgSearchinterfacesymbol1,
            height: 14.h,
            width: 14.h,
          ),
          SizedBox(width: 12.h),
          Expanded(
            child: TextFormField(
              controller: controller.searchController,
              style: TextStyleHelper.instance.body12RegularPoppins.copyWith(
                color: appTheme.black_900,
              ),
              decoration: InputDecoration(
                hintText: "Search \"ice-cream\"",
                hintStyle: TextStyleHelper.instance.body12RegularPoppins,
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              onChanged: (value) => controller.onSearchChanged(value),
            ),
          ),
          SizedBox(width: 12.h),
          CustomImageView(
            imagePath: ImageConstant.imgMic1,
            height: 14.h,
            width: 14.h,
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: 10.h,
        bottom: 6.h, // 🔽 slightly reduced bottom padding to avoid overflow
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFE53935), Color(0xFFE53935), Color(0xFFE53935)],
        ),
      ),
      child: SafeArea(
        // ✅ ensures layout stays within screen bounds
        bottom: false, // avoid double-padding with system insets
        child: Column(
          mainAxisSize: MainAxisSize.min, // ✅ shrink to content height
          children: [
            CustomBlinkitAppBar(
              locationLabel: "HOME",
              address: "Trycode Innovations",
              onActionPressed: () {},
              onLocationPressed: () {},
            ),
            SizedBox(height: 6.h),
            _buildSearchBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildMegaSaleBanner(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFE53935), Color(0xFFFF6B6B), Color(0xFFFFC1C1)],
          stops: [0.0, 0.5, 1.0],
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 15.h, vertical: 10.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSideImages(context, left: true),
              SizedBox(width: MediaQuery.of(context).size.width * 0.02),
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'Buy Fresh, Eat Fresh',
                    textAlign: TextAlign.center,
                    style: TextStyleHelper.instance.title20BoldPTSerif.copyWith(
                      color: Colors.white,
                      fontSize: MediaQuery.of(context).size.width * 0.045,
                    ),
                  ),
                ),
              ),
              SizedBox(width: MediaQuery.of(context).size.width * 0.02),
              _buildSideImages(context, left: false),
            ],
          ),
          SizedBox(height: 10.h),
          _buildCategoryTiles(),
        ],
      ),
    );
  }

  Widget _buildSideImages(BuildContext context, {required bool left}) {
    double screenWidth = MediaQuery.of(context).size.width;
    double imageBlockWidth = screenWidth * 0.22;
    double imageBlockHeight = screenWidth * 0.14;
    double innerImageWidth = imageBlockWidth * 0.6;
    double innerImageHeight = imageBlockHeight * 0.8;

    return SizedBox(
      width: imageBlockWidth,
      height: imageBlockHeight,
      child: Stack(
        children: [
          Positioned(
            left: left ? 0 : null,
            right: left ? null : 0,
            bottom: 0,
            child: CustomImageView(
              imagePath: ImageConstant.imgImage55,
              height: innerImageHeight,
              width: innerImageWidth,
            ),
          ),
          Positioned(
            right: left ? 0 : null,
            left: left ? null : 0,
            top: 0,
            child: CustomImageView(
              imagePath: ImageConstant.imgImage60,
              height: innerImageHeight * 1.1,
              width: innerImageWidth,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTiles() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Obx(
        () => Row(
          spacing: 8.h,
          children: controller.categoryItems.map((category) {
            return CategoryItemWidget(category: category);
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildProductsSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.h),
      child: Obx(
        () => SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: controller.productItems.map((product) {
              return Padding(
                padding: EdgeInsets.only(right: 8.h),
                child: ProductItemWidget(product: product),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildFrequentlyBoughtSection() {
    final categories = [
      _CategoryItem(
        title: "Vegetables & Fruits",
        images: [
          ImageConstant.imgImage19,
          ImageConstant.imgImage18,
          ImageConstant.imgImage20,
          ImageConstant.imgImage20,
        ],
        moreCount: 19,
      ),
      _CategoryItem(
        title: "Chips & Namkeen",
        images: [
          ImageConstant.lays,
          ImageConstant.kurukure,
          ImageConstant.kurukure,
          ImageConstant.lays,
        ],
        moreCount: 44,
      ),
      _CategoryItem(
        title: "Bakery & Snacks",
        images: [
          ImageConstant.biscut1,
          ImageConstant.biscut2,
          ImageConstant.biscut3,
          ImageConstant.biscut1,
        ],
        moreCount: 19,
      ),
      _CategoryItem(
        title: "Diary, Bread & eggs",
        images: [
          ImageConstant.milk1,
          ImageConstant.milk2,
          ImageConstant.milk3,
          ImageConstant.milk1,
        ],
        moreCount: 8,
      ),
      _CategoryItem(
        title: "Drinks & Juices",
        images: [
          ImageConstant.coke,
          ImageConstant.sevenup,
          ImageConstant.mirinda,
          ImageConstant.drink1,
        ],
        moreCount: 19,
      ),
      _CategoryItem(
        title: "Sweets and Chocolates",
        images: [
          ImageConstant.diarymilk,
          ImageConstant.milkybar,
          ImageConstant.milkybar,
          ImageConstant.diarymilk,
        ],
        moreCount: 15,
      ),
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Best Seller",
            style: TextStyleHelper.instance.body14BoldPoppins,
          ),
          SizedBox(height: 10.h),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: categories.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10.h,
              mainAxisSpacing: 10.h,
              childAspectRatio: 0.68,
            ),
            itemBuilder: (context, index) {
              final cat = categories[index];
              return LayoutBuilder(
                builder: (context, constraints) {
                  final imageGridHeight = constraints.maxHeight * 0.55;
                  return Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF6F7F7),
                      borderRadius: BorderRadius.circular(16.h),
                    ),
                    padding: EdgeInsets.all(8.h),
                    child: Column(
                      children: [
                        SizedBox(
                          height: imageGridHeight,
                          width: double.infinity,
                          child: GridView.builder(
                            padding: EdgeInsets.zero,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 5,
                                  mainAxisSpacing: 5,
                                  childAspectRatio: 1.1,
                                ),
                            itemCount: cat.images.length,
                            itemBuilder: (context, i) => ClipRRect(
                              borderRadius: BorderRadius.circular(6.h),
                              child: CustomImageView(
                                imagePath: cat.images[i],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          "+${cat.moreCount} more",
                          style: TextStyle(
                            fontSize: 10.fSize,
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 3.h),
                        Text(
                          cat.title,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11.fSize,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildGrocerySection() {
    return Padding(
      padding: EdgeInsets.only(left: 14.h, bottom: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 6.h,
        children: [
          Text(
            'Grocery & Kitchen',
            style: TextStyleHelper.instance.body14BoldPoppins,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Obx(
              () => Row(
                spacing: 10.h,
                children: controller.groceryCategories.map((category) {
                  return GroceryCategoryItemWidget(category: category);
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryItem {
  final String title;
  final List<String> images;
  final int moreCount;

  _CategoryItem({
    required this.title,
    required this.images,
    required this.moreCount,
  });
}
