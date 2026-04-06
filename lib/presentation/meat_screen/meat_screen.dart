import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'dart:ui';
import 'package:waytofresh/core/app_expote.dart';
import 'package:waytofresh/core/utils/image_constants.dart';
import 'package:waytofresh/theme/theme_helper.dart';
import 'package:waytofresh/widgets/custom_image_view.dart';
import 'controller/meat_controller.dart';
import 'package:waytofresh/presentation/category_screen/widgets/cart_summary.dart';
import 'package:waytofresh/presentation/category_screen/controller/cart_controller.dart';
import 'package:waytofresh/presentation/homescreen/widgets/home_carousel.dart';

class MeatScreen extends GetView<MeatController> {
  const MeatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
        if (controller.showOnboarding.value) {
          return _buildOnboarding(context);
        } else {
          return _buildMainContent(context);
        }
      }),
      bottomNavigationBar: Obx(() {
        if (controller.showOnboarding.value) return const SizedBox.shrink();
        return _buildBottomNav(context);
      }),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: BottomNavigationBar(
        elevation: 0,
        backgroundColor: Colors.white,
        currentIndex: controller.selectedBottomTab.value,
        onTap: (index) {
          controller.selectBottomTab(index);
          HapticFeedback.mediumImpact();
        },
        selectedItemColor: const Color(0xFF800000),
        unselectedItemColor: Colors.grey.shade400,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.h),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 12.h),
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.square_grid_2x2, size: 24.h),
            activeIcon: Icon(CupertinoIcons.square_grid_2x2_fill, size: 24.h),
            label: "Meat",
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.ant, size: 24.h), // Placeholder for chicken
            activeIcon: Icon(CupertinoIcons.ant_fill, size: 24.h),
            label: "Chicken",
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.circle_grid_hex, size: 24.h), // Placeholder for mutton
            activeIcon: Icon(CupertinoIcons.circle_grid_hex_fill, size: 24.h),
            label: "Mutton",
          ),
        ],
      ),
    );
  }

  // 1. ONBOARDING VIEW
  Widget _buildOnboarding(BuildContext context) {
    return Stack(
      children: [
        // Background Image
        Positioned.fill(
          child: CustomImageView(
            imagePath: ImageConstant.imgMeatHero,
            fit: BoxFit.cover,
          ),
        ),
        // Dark Overlay
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.4),
                  Colors.black.withOpacity(0.9),
                ],
              ),
            ),
          ),
        ),
        // Text Content
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.h, vertical: 60.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Explore the best meat\nto eat in the town",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 34.h,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),
              SizedBox(height: 15.h),
              Text(
                "We're here to provide the best meat both in\nterms of quality and price.",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 14.h,
                  height: 1.5,
                ),
              ),
              SizedBox(height: 40.h),
              // Glassmorphic Button
              GestureDetector(
                onTap: () => controller.toggleOnboarding(),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 18.h),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFFD35400),
                        const Color(0xFFE67E22),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(15.h),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF800000).withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "Start Exploring",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.h,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // 2. MAIN CONTENT VIEW
  Widget _buildMainContent(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Row
                  _buildHeader(context),
                  SizedBox(height: 25.h),
                  // Search & Filters
                  _buildGreeting(context),
                  SizedBox(height: 20.h),
                  // New Carousel
                  HomeCarousel(images: controller.bannerImages),
                  SizedBox(height: 20.h),
                  _buildCategoryTabs(context),
                  SizedBox(height: 25.h),
                  // Product Grid
                  _buildProductGrid(context),
                  SizedBox(height: 25.h),
                  // Deals Banner
                  _buildDealsBanner(context),
                  SizedBox(height: 80.h), // Space for cart summary
                ],
              ),
            ),
          ),
          // Cart Summary (from original)
          Obx(() {
            final cartController = Get.find<CartController>();
            if (cartController.totalCartItems > 0) {
              return Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: CartSummary(
                  controller: cartController,
                  onTap: () => Get.toNamed(AppRoutes.checkoutScreen),
                ),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CircleAvatar(
          radius: 22.h,
          backgroundColor: Colors.grey.shade200,
          child: Icon(CupertinoIcons.person, color: Colors.grey.shade600),
        ),
        Container(
          padding: EdgeInsets.all(10.h),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
              ),
            ],
          ),
          child: Icon(CupertinoIcons.bell, size: 22.h),
        ),
      ],
    );
  }

  Widget _buildGreeting(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Hi Vaishnav ✨ 👋", // Added sparkles for premium feel
          style: TextStyle(
            fontSize: 16.h,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          "Find the best meat to eat",
          style: TextStyle(
            fontSize: 26.h,
            fontWeight: FontWeight.bold,
            color: appTheme.black_900,
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryTabs(BuildContext context) {
    return SizedBox(
      height: 90.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: controller.categories.length,
        itemBuilder: (context, index) {
          String category = controller.categories[index];
          
          String getCategoryImageUrl(String name) {
            String lower = name.toLowerCase();
            if (lower.contains("chicken")) return ImageConstant.imgRawLamb;
            if (lower.contains("lamb") || lower.contains("mutton")) return ImageConstant.imgRawLamb;
            if (lower.contains("ribs")) return ImageConstant.imgRawRibs;
            if (lower.contains("wagyu")) return ImageConstant.imgRawWagyu;
            if (lower.contains("tenderloin") || lower.contains("sirloin") || lower.contains("beef") || lower.contains("steak")) return ImageConstant.imgRawTenderloin;
            return ImageConstant.imgMeatHero;
          }
          
          String imageUrl = getCategoryImageUrl(category);

          return Obx(() {
            bool isSelected = controller.selectedCategory.value == category;
            return GestureDetector(
              onTap: () {
                controller.selectCategory(category);
                HapticFeedback.lightImpact();
              },
              child: Container(
                margin: EdgeInsets.only(right: 16.h, left: index == 0 ? 16.h : 0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOutBack,
                      width: isSelected ? 64.h : 46.h,
                      height: isSelected ? 64.h : 46.h,
                      child: ClipOval(
                        child: CustomImageView(
                          imagePath: imageUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      category,
                      style: TextStyle(
                        color: isSelected ? const Color(0xFF800000) : Colors.grey.shade600,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        fontSize: 12.h,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
        },
      ),
    );
  }

  Widget _buildProductGrid(BuildContext context) {
    final filteredProducts = controller.filteredMeatProducts;
    if (filteredProducts.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 40.h),
          child: Text(
            "No items found for this category.",
            style: TextStyle(color: Colors.grey, fontSize: 16.h),
          ),
        ),
      );
    }
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 15.h,
        mainAxisSpacing: 15.h,
        childAspectRatio: 0.65, // Increased height for comprehensive info
      ),
      itemCount: filteredProducts.length,
      itemBuilder: (context, index) {
        final product = filteredProducts[index];
        return _buildProductCard(context, product, index);
      },
    );
  }

  Widget _buildProductCard(BuildContext context, dynamic product, int index) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(AppRoutes.productDetailScreen, arguments: product);
      },
      child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.h),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Section
          Expanded(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20.h)),
                  child: CustomImageView(
                    imagePath: product.images[0],
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
                // Like Button
                Positioned(
                  top: 10.h,
                  right: 10.h,
                  child: Container(
                    padding: EdgeInsets.all(6.h),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(CupertinoIcons.heart, size: 16.h, color: Colors.grey),
                  ),
                ),
                // Add Button Overlapping Image
                Positioned(
                  right: 12.h,
                  bottom: -14.h, // Half outside the image
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6.h),
                      border: Border.all(color: const Color(0xFF800000)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      "ADD",
                      style: TextStyle(
                        fontSize: 12.h,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF800000),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Info Section
          Padding(
            padding: EdgeInsets.only(top: 20.h, left: 12.h, right: 12.h, bottom: 12.h), // Top padding avoids overlapping the Add button
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.title.value,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.h),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 2.h),
                Text(
                  product.unit.value,
                  style: TextStyle(fontSize: 11.h, color: Colors.grey.shade600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 6.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      product.size.value,
                      style: TextStyle(fontSize: 12.h, fontWeight: FontWeight.w600, color: Colors.grey.shade800),
                    ),
                    Row(
                      children: [
                        Icon(CupertinoIcons.clock, size: 12.h, color: Color(0xFF800000)),
                        SizedBox(width: 2.h),
                        Text(
                          product.deliveryTime.value,
                          style: TextStyle(fontSize: 10.h, color: Color(0xFF800000), fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Text(
                  "₹${product.price.value}",
                  style: TextStyle(
                    fontSize: 16.h,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF2D3436),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

  Widget _buildDealsBanner(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(15.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.h),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15.h),
            child: CustomImageView(
              imagePath: ImageConstant.imgMeatDeals,
              height: 80.h,
              width: 80.h,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 15.h),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Best meat deals!",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.h,
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  "We'll help you to find meat to eat with best quality.",
                  style: TextStyle(
                    fontSize: 12.h,
                    color: Colors.grey.shade500,
                  ),
                  maxLines: 2,
                ),
              ],
            ),
          ),
          Icon(CupertinoIcons.play_circle_fill, size: 30.h, color: Colors.grey.shade800),
        ],
      ),
    );
  }
}
