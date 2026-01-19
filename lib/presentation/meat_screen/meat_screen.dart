import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waytofresh/widgets/custom_image_view.dart';
import 'package:waytofresh/presentation/category_screen/controller/cart_controller.dart';
import 'package:waytofresh/presentation/category_screen/widgets/cart_summary.dart';
import 'package:waytofresh/presentation/homescreen/product_item_model.dart';
import 'package:waytofresh/widgets/product_details_bottom_sheet.dart';
import 'package:waytofresh/presentation/homescreen/widgets/home_carousel.dart';
import 'package:waytofresh/routes/app_routes.dart';
import 'package:waytofresh/presentation/meat_screen/bulk_order_screen.dart';

class MeatScreen extends StatelessWidget {
  const MeatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Inject Controller
    final CartController controller = Get.put(CartController());

    // Filter Meat Products (Category 6)
    final meatProducts = controller.allProducts
        .where((p) => p["category"] == 6)
        .toList();

    return Scaffold(
      // Add gradient background with transparency
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFEF9F0), // Light cream with transparency
              Color(0xFFFEF5E7),
              Color(0xFFFEF0DB),
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Background pattern overlay with transparency
              Positioned.fill(
                child: Opacity(
                  opacity: 0.03,
                  child: Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/meat.jpg"),
                        repeat: ImageRepeat.repeat,
                      ),
                    ),
                  ),
                ),
              ),

              RefreshIndicator(
                onRefresh: controller.refreshProducts,
                color: const Color(0xFF8B4513),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 80),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Glass morphism search bar
                        Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.9),
                                    borderRadius: BorderRadius.circular(30),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 10,
                                        offset: const Offset(0, 5),
                                      ),
                                    ],
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.3),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.search,
                                        color: Colors.black54,
                                      ),
                                      const SizedBox(width: 10),
                                      const Text(
                                        "Search for meat...",
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.9),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.3),
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.tune,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),

                        HomeCarousel(
                          images: [
                            "assets/images/meat.jpg",
                            "assets/images/meat.jpg",
                            "assets/images/meat.jpg",
                            "assets/images/meat.jpg",
                          ],
                        ),
                        const SizedBox(height: 25),

                        // Header with subtle shadow
                        Stack(
                          children: [
                            // Text shadow effect
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Premium Meat Selection",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(
                                      0xFF8B4513,
                                    ).withOpacity(0.3),
                                  ),
                                ),
                                Text(
                                  "Fresh Cuts Delivered",
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(
                                      0xFFB22222,
                                    ).withOpacity(0.3),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  "Premium Meat Selection",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF8B4513),
                                  ),
                                ),
                                Text(
                                  "Fresh Cuts Delivered",
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFB22222),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 25),

                        // Dynamic Product List with glass morphism
                        if (meatProducts.isEmpty)
                          Center(
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                ),
                              ),
                              child: const Text(
                                "No products found.",
                                style: TextStyle(color: Color(0xFF654321)),
                              ),
                            ),
                          )
                        else
                          ListView.separated(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: meatProducts.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 25),
                            itemBuilder: (context, index) {
                              final product = meatProducts[index];
                              final productIndex = controller.allProducts
                                  .indexOf(product);

                              return Container(
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 15,
                                      spreadRadius: 2,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: _buildMeatItem(
                                  number: (index + 1).toString().padLeft(
                                    2,
                                    '0',
                                  ),
                                  title: product["name"],
                                  description:
                                      product["description"] ??
                                      "Delicious meat product",
                                  imagePath: product["image"],
                                  price: "\$${product["price"]}",
                                  buttonColor: index % 2 == 0
                                      ? const Color(0xFF8B4513)
                                      : const Color(0xFFA52A2A),
                                  rating: (product["rating"] as num).toDouble(),
                                  isImageRight: index % 2 == 0,
                                  controller: controller,
                                  productIndex: productIndex,
                                ),
                              );
                            },
                          ),

                        const SizedBox(height: 35),

                        // Bulk Ordering Section
                        _buildBulkOrderSection(),

                        const SizedBox(height: 35),

                        // Categories Section with transparent background
                        Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.4),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Shop by Category",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF8B4513),
                                ),
                              ),
                              const SizedBox(height: 15),
                              SizedBox(
                                height: 110,
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: [
                                    _CategoryItem(
                                      title: "Spring Chicken",
                                      image: "assets/images/meat.jpg",
                                    ),
                                    _CategoryItem(
                                      title: "Mutton Chops",
                                      image: "assets/images/meat.jpg",
                                    ),
                                    _CategoryItem(
                                      title: "Prime Beef",
                                      image: "assets/images/meat.jpg",
                                    ),
                                    _CategoryItem(
                                      title: "Fresh Seafood",
                                      image: "assets/images/meat.jpg",
                                    ),
                                    _CategoryItem(
                                      title: "Pork Ribs",
                                      image: "assets/images/meat.jpg",
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 30),

                        // Best Sellers Section with glass effect
                        Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.4),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Best Sellers",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF8B4513),
                                ),
                              ),
                              const SizedBox(height: 15),
                              SizedBox(
                                height: 220,
                                child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: meatProducts.length,
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(width: 15),
                                  itemBuilder: (context, index) {
                                    final product = meatProducts[index];
                                    final productIndex = controller.allProducts
                                        .indexOf(product);
                                    return Container(
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(
                                              0.05,
                                            ),
                                            blurRadius: 10,
                                            offset: const Offset(0, 5),
                                          ),
                                        ],
                                      ),
                                      child: _MeatProductCard(
                                        product: product,
                                        productIndex: productIndex,
                                        controller: controller,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 30),

                        // Why Choose Us with glass morphism
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.85),
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 15,
                                spreadRadius: 1,
                                offset: const Offset(0, 8),
                              ),
                            ],
                            border: Border.all(
                              color: Colors.white.withOpacity(0.4),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Why Choose Our Meat?",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF8B4513),
                                ),
                              ),
                              const SizedBox(height: 15),
                              _buildSimpleFeature(
                                "✓ 100% Fresh & Quality Checked",
                              ),
                              _buildSimpleFeature(
                                "✓ Hygienic Packaging & Handling",
                              ),
                              _buildSimpleFeature(
                                "✓ Same Day Delivery Available",
                              ),
                              _buildSimpleFeature("✓ Premium Cuts Only"),
                              _buildSimpleFeature("✓ Sustainable Sources"),
                            ],
                          ),
                        ),

                        const SizedBox(height: 30),

                        // Explore More Section
                        Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.4),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Explore More",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF8B4513),
                                ),
                              ),
                              const SizedBox(height: 15),
                              GridView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: 0.65,
                                      crossAxisSpacing: 15,
                                      mainAxisSpacing: 15,
                                    ),
                                itemCount: meatProducts.length,
                                itemBuilder: (context, index) {
                                  final product = meatProducts[index];
                                  final productIndex = controller.allProducts
                                      .indexOf(product);
                                  return Container(
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.05),
                                          blurRadius: 10,
                                          offset: const Offset(0, 5),
                                        ),
                                      ],
                                    ),
                                    child: _GridProductCard(
                                      product: product,
                                      productIndex: productIndex,
                                      controller: controller,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 30),

                        // Floating decorative element at bottom
                        Center(
                          child: Container(
                            width: 100,
                            height: 4,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  const Color(0xFF8B4513).withOpacity(0.3),
                                  const Color(0xFFD2B48C).withOpacity(0.3),
                                  const Color(0xFF8B4513).withOpacity(0.3),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Floating Cart Summary with glass effect
              Obx(() {
                if (controller.totalCartItems > 0) {
                  return Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 20,
                            spreadRadius: 1,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: BackdropFilter(
                          filter: ColorFilter.mode(
                            Colors.white.withOpacity(0.2),
                            BlendMode.srcOver,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                              ),
                            ),
                            child: CartSummary(
                              controller: controller,
                              onTap: () =>
                                  Get.toNamed(AppRoutes.checkoutScreen),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              }),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildMeatItem({
    required String number,
    required String title,
    required String description,
    required String imagePath,
    required String price,
    required Color buttonColor,
    required double rating,
    required bool isImageRight,
    required CartController controller,
    required int productIndex,
  }) {
    return SizedBox(
      height: 200, // Reduced height
      child: GestureDetector(
        onTap: () {
          final productMap = controller.allProducts[productIndex];
          Get.bottomSheet(
            ProductDetailsBottomSheet(
              product: ProductItemModel.fromMap(productMap),
            ),
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
          );
        },
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // 1. Card Background & Image (Centered, Small)
            Positioned.fill(
              child: Container(
                margin: const EdgeInsets.symmetric(
                  vertical: 5,
                ), // Tight margins
                decoration: BoxDecoration(
                  color: Colors.white, // Solid card background
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      spreadRadius: 1,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Stack(
                    children: [
                      // Right-Aligned Small Image with Fade
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: ShaderMask(
                            shaderCallback: (Rect bounds) {
                              return const LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [Colors.black, Colors.transparent],
                              ).createShader(bounds);
                            },
                            blendMode: BlendMode.dstIn,
                            child: Opacity(
                              opacity: 0.9,
                              child: CustomImageView(
                                imagePath: imagePath,
                                height: 180,
                                width: 180,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Light Gradient Overlay (for text readability over the image)
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.white.withOpacity(0.5),
                              Colors.white.withOpacity(0.8),
                            ],
                            stops: const [0.0, 0.6, 1.0],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // 2. Text Content on Top
            Positioned(
              left: 15,
              right: 15,
              bottom: 15,
              top: 15,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Number with glow
                      Stack(
                        children: [
                          Text(
                            number,
                            style: TextStyle(
                              fontSize: 30, // Reduced from 40
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFFD2B48C).withOpacity(0.35),
                            ),
                          ),
                          Text(
                            number,
                            style: const TextStyle(
                              fontSize: 30, // Reduced from 40
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFD2B48C),
                            ),
                          ),
                        ],
                      ),
                      // Rating
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 14,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              rating.toString(),
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF654321),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18, // Reduced from 22
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF654321),
                      height: 1.1,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 12, // Reduced from 13
                      color: Color(0xFF8B7355),
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 10),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          price,
                          style: TextStyle(
                            fontSize: 18, // Reduced from 20
                            fontWeight: FontWeight.bold,
                            color: buttonColor,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Obx(() {
                          final quantity =
                              controller.cartItems[productIndex] ?? 0;
                          if (quantity > 0) {
                            return Container(
                              height: 35, // Explicit smaller height
                              decoration: BoxDecoration(
                                color: buttonColor,
                                borderRadius: BorderRadius.circular(18),
                                boxShadow: [
                                  BoxShadow(
                                    color: buttonColor.withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.remove,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                    onPressed: () =>
                                        controller.removeFromCart(productIndex),
                                    constraints: const BoxConstraints(
                                      minWidth: 35,
                                      minHeight: 35,
                                    ),
                                    padding: EdgeInsets.zero,
                                  ),
                                  Container(
                                    constraints: const BoxConstraints(
                                      minWidth: 15,
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      '$quantity',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.add,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                    onPressed: () =>
                                        controller.addToCart(productIndex),
                                    constraints: const BoxConstraints(
                                      minWidth: 35,
                                      minHeight: 35,
                                    ),
                                    padding: EdgeInsets.zero,
                                  ),
                                ],
                              ),
                            );
                          } else {
                            return SizedBox(
                              height: 35,
                              child: ElevatedButton(
                                onPressed: () =>
                                    controller.addToCart(productIndex),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: buttonColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  elevation: 2,
                                  shadowColor: buttonColor.withOpacity(0.3),
                                ),
                                child: const Text(
                                  "Add to Cart",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            );
                          }
                        }),
                      ],
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

  static Widget _buildSimpleFeature(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(
            Icons.check_circle,
            color: const Color(0xFF8B4513).withOpacity(0.8),
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14, color: Color(0xFF654321)),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildBulkOrderSection() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF8B4513), // Saddle Brown
            Color(0xFFB22222), // Firebrick
            Color(0xFF5D2E0C), // Darker Brown
          ],
          stops: [0.0, 0.5, 1.0],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFB22222).withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 2,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // Decorative background circles
            Positioned(
              right: -30,
              top: -30,
              child: Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
            ),
            Positioned(
              left: -50,
              bottom: -50,
              child: Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black.withOpacity(0.05),
                ),
              ),
            ),

            // Background Image Overlay (Subtle)
            Positioned(
              right: 10,
              bottom: -20,
              child: Opacity(
                opacity: 0.15,
                child: CustomImageView(
                  imagePath: "assets/images/meat.jpg",
                  height: 140,
                  width: 140,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Glassmorphism Tag
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.star, color: Colors.amber, size: 10),
                        SizedBox(width: 4),
                        Text(
                          "EXCLUSIVE",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          "Events & Bulk Ordering",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: -0.5,
                            height: 1.0,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.celebration_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  SizedBox(
                    width: 280,
                    child: Text(
                      "Elevate your celebrations with our premium catering-grade cuts.",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.85),
                        height: 1.3,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () => Get.to(() => BulkOrderScreen()),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF8B4513),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Text(
                            "Get Private Quote",
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 12,
                            ),
                          ),
                          SizedBox(width: 6),
                          Icon(Icons.arrow_forward_rounded, size: 14),
                        ],
                      ),
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
}

class _CategoryItem extends StatelessWidget {
  final String title;
  final String image;

  const _CategoryItem({required this.title, required this.image});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Column(
        children: [
          // Glass morphism circle
          Container(
            height: 70,
            width: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
              border: Border.all(color: Colors.white.withOpacity(0.3)),
            ),
            padding: const EdgeInsets.all(12),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.3),
              ),
              child: CustomImageView(imagePath: image),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0xFF654321),
            ),
          ),
        ],
      ),
    );
  }
}

class _GridProductCard extends StatelessWidget {
  final Map<String, dynamic> product;
  final int productIndex;
  final CartController controller;

  const _GridProductCard({
    required this.product,
    required this.productIndex,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.bottomSheet(
          ProductDetailsBottomSheet(product: ProductItemModel.fromMap(product)),
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
          border: Border.all(color: Colors.white.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(15),
                ),
                child: Container(
                  color: Colors.transparent,
                  child: Stack(
                    children: [
                      CustomImageView(
                        imagePath: product["image"],
                        fit: BoxFit.contain,
                      ),
                      // Gradient overlay
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.black.withOpacity(0.05),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product["name"],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF654321),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          product["weight"] ?? "1 kg",
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              "\$${product['price']}",
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFA52A2A),
                              ),
                            ),
                          ),
                        ),
                        Obx(() {
                          final qty = controller.cartItems[productIndex] ?? 0;
                          if (qty == 0) {
                            return Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFF8B4513),
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(
                                      0xFF8B4513,
                                    ).withOpacity(0.3),
                                    blurRadius: 5,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: InkWell(
                                onTap: () => controller.addToCart(productIndex),
                                child: const Padding(
                                  padding: EdgeInsets.all(6),
                                  child: Icon(
                                    Icons.add,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFF8B4513),
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(
                                      0xFF8B4513,
                                    ).withOpacity(0.3),
                                    blurRadius: 5,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  InkWell(
                                    onTap: () =>
                                        controller.removeFromCart(productIndex),
                                    child: const Padding(
                                      padding: EdgeInsets.all(4),
                                      child: Icon(
                                        Icons.remove,
                                        size: 14,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    "$qty",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  InkWell(
                                    onTap: () =>
                                        controller.addToCart(productIndex),
                                    child: const Padding(
                                      padding: EdgeInsets.all(4),
                                      child: Icon(
                                        Icons.add,
                                        size: 14,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                        }),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MeatProductCard extends StatelessWidget {
  final Map<String, dynamic> product;
  final int productIndex;
  final CartController controller;

  const _MeatProductCard({
    required this.product,
    required this.productIndex,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.bottomSheet(
          ProductDetailsBottomSheet(product: ProductItemModel.fromMap(product)),
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
        );
      },
      child: Container(
        width: 150,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
          border: Border.all(color: Colors.white.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(15),
              ),
              child: Container(
                height: 100,
                width: double.infinity,
                color: Colors.transparent,
                child: Stack(
                  children: [
                    CustomImageView(
                      imagePath: product["image"],
                      fit: BoxFit.contain,
                    ),
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black.withOpacity(0.05),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product["name"],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF654321),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          product["weight"] ?? "1 kg",
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              "\$${product["price"]}",
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFA52A2A),
                              ),
                            ),
                          ),
                        ),
                        Obx(() {
                          final qty = controller.cartItems[productIndex] ?? 0;
                          if (qty == 0) {
                            return Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFF8B4513),
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(
                                      0xFF8B4513,
                                    ).withOpacity(0.3),
                                    blurRadius: 5,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: InkWell(
                                onTap: () => controller.addToCart(productIndex),
                                child: const Padding(
                                  padding: EdgeInsets.all(6),
                                  child: Icon(
                                    Icons.add,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFF8B4513),
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(
                                      0xFF8B4513,
                                    ).withOpacity(0.3),
                                    blurRadius: 5,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 4,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    InkWell(
                                      onTap: () => controller.removeFromCart(
                                        productIndex,
                                      ),
                                      child: const Icon(
                                        Icons.remove,
                                        size: 14,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      "$qty",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    InkWell(
                                      onTap: () =>
                                          controller.addToCart(productIndex),
                                      child: const Icon(
                                        Icons.add,
                                        size: 14,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                        }),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
