import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:waytofresh/core/app_expote.dart';
import 'package:waytofresh/presentation/homescreen/product_item_model.dart';
import 'package:waytofresh/widgets/custom_image_view.dart';
import '../category_screen/controller/cart_controller.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({Key? key}) : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    final ProductItemModel? product = Get.arguments;
    if (product == null) {
      return const Scaffold(
        body: Center(child: Text("Product not found")),
      );
    }
    final CartController cartController = Get.find<CartController>();
    
    // Find index for cart operations
    int productIndex = cartController.allProducts.indexWhere(
      (p) => p['name'] == product.title.value,
    );
    if (productIndex == -1) productIndex = 0; // Fallback

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Hero Image Section
                _buildHeroImage(context, product),

                Padding(
                  padding: EdgeInsets.all(16.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 2. Title and Rating
                      _buildTitleRating(product),
                      SizedBox(height: 12.h),

                      // 3. Price and Quantity
                      _buildPriceQuantity(cartController, productIndex, product),
                      SizedBox(height: 20.h),

                      // 4. Attributes (Size, Energy, Delivery)
                      _buildAttributes(product),
                      SizedBox(height: 24.h),

                      // 5. Tabs (About, Storage, Recipe)
                      _buildTabs(),
                      SizedBox(height: 16.h),
                      _buildTabContent(product),
                      SizedBox(height: 24.h),

                      // 6. Review Section
                      _buildReviewHeader(),
                      SizedBox(height: 12.h),
                      _buildReviewItem(),
                      
                      SizedBox(height: 100.h), // Bottom spacing for button
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 7. Fixed Add to Cart Button
          _buildAddToCartButton(context, cartController, productIndex),
        ],
      ),
    );
  }

  Widget _buildHeroImage(BuildContext context, ProductItemModel product) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(24.h)),
          child: CustomImageView(
            imagePath: product.images[0],
            height: 250.h,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        // Overlay for back button and favorite
        Positioned(
          top: MediaQuery.of(context).padding.top + 10.h,
          left: 20.h,
          right: 20.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildCircleButton(
                icon: CupertinoIcons.chevron_left,
                onTap: () => Get.back(),
              ),
              _buildCircleButton(
                icon: CupertinoIcons.heart,
                onTap: () {
                  HapticFeedback.mediumImpact();
                  // Handle favorite
                },
              ),
            ],
          ),
        ),
        // Indicator Dots
        Positioned(
          bottom: 20.h,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(width: 20.h, height: 4.h, decoration: BoxDecoration(color: const Color(0xFF800000), borderRadius: BorderRadius.circular(2))),
              SizedBox(width: 5.h),
              Container(width: 8.h, height: 4.h, decoration: BoxDecoration(color: Colors.white.withOpacity(0.5), borderRadius: BorderRadius.circular(2))),
              SizedBox(width: 5.h),
              Container(width: 8.h, height: 4.h, decoration: BoxDecoration(color: Colors.white.withOpacity(0.5), borderRadius: BorderRadius.circular(2))),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCircleButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(10.h),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 20.h, color: Colors.black),
      ),
    );
  }

  Widget _buildNonVegIcon() {
    return Container(
      margin: EdgeInsets.only(right: 8.h),
      padding: EdgeInsets.all(2.h),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.red, width: 1.h),
        borderRadius: BorderRadius.circular(4.h),
      ),
      child: Icon(Icons.circle, color: Colors.red, size: 8.h),
    );
  }

  Widget _buildTitleRating(ProductItemModel product) {
    bool isBoneless = product.unit.value.toLowerCase().contains("boneless");

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Row(
                children: [
                  _buildNonVegIcon(),
                  Expanded(
                    child: Text(
                      product.title.value,
                      style: TextStyle(
                        fontSize: 24.h,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF2D3436),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Icon(CupertinoIcons.star_fill, color: const Color(0xFF800000), size: 18.h),
                SizedBox(width: 4.h),
                Text(
                  "${product.rating.value}",
                  style: TextStyle(fontSize: 14.h, fontWeight: FontWeight.bold),
                ),
                Text(
                  " (${product.reviewCount.value} Reviews)",
                  style: TextStyle(fontSize: 12.h, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
        if (isBoneless)
          Container(
            margin: EdgeInsets.only(top: 8.h),
            padding: EdgeInsets.symmetric(horizontal: 10.h, vertical: 4.h),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.08),
              borderRadius: BorderRadius.circular(6.h),
              border: Border.all(color: Colors.red.withOpacity(0.2)),
            ),
            child: Text(
              "Boneless",
              style: TextStyle(fontSize: 12.h, fontWeight: FontWeight.bold, color: Colors.red),
            ),
          ),
      ],
    );
  }

  Widget _buildPriceQuantity(CartController cartController, int index, ProductItemModel product) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "₹${product.price.value}.00",
          style: TextStyle(
            fontSize: 22.h,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF800000),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 4.h, vertical: 4.h),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF7ED),
            borderRadius: BorderRadius.circular(30.h),
          ),
          child: Row(
            children: [
              _buildStepperButton(
                icon: CupertinoIcons.minus,
                onTap: () => cartController.removeFromCart(index),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.h),
                child: Obx(() => Text(
                  "${cartController.cartItems[index] ?? 1}",
                  style: TextStyle(fontSize: 16.h, fontWeight: FontWeight.bold),
                )),
              ),
              _buildStepperButton(
                icon: CupertinoIcons.plus,
                onTap: () => cartController.addToCart(index),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStepperButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Container(
        padding: EdgeInsets.all(8.h),
        decoration: const BoxDecoration(
          color: Color(0xFF800000),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 16.h, color: Colors.white),
      ),
    );
  }

  Widget _buildAttributes(ProductItemModel product) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildAttributeCard("Size", product.size.value, isDropdown: true),
        _buildAttributeCard("Energy", product.energy.value),
        _buildAttributeCard("Delivery", product.deliveryTime.value),
      ],
    );
  }

  Widget _buildAttributeCard(String label, String value, {bool isDropdown = false}) {
    return Container(
      width: 105.h,
      padding: EdgeInsets.all(12.h),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFFFE5D0)),
        borderRadius: BorderRadius.circular(16.h),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: TextStyle(fontSize: 12.h, color: Colors.grey)),
              if (isDropdown) Icon(CupertinoIcons.chevron_down, size: 12.h, color: const Color(0xFF800000)),
            ],
          ),
          SizedBox(height: 4.h),
          Text(value, style: TextStyle(fontSize: 14.h, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildTabButton(0, "About"),
        SizedBox(width: 20.h),
        _buildTabButton(1, "Storage"),
        SizedBox(width: 20.h),
        _buildTabButton(2, "Recipe"),
      ],
    );
  }

  Widget _buildTabButton(int index, String title) {
    bool isSelected = _selectedTab == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTab = index;
        });
        HapticFeedback.lightImpact();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 15.h,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? const Color(0xFF800000) : Colors.grey.shade500,
            ),
          ),
          SizedBox(height: 6.h),
          Container(
            height: 3.h,
            width: 30.h,
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF800000) : Colors.transparent,
              borderRadius: BorderRadius.circular(2.h),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabContent(ProductItemModel product) {
    if (_selectedTab == 0) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            product.description.value,
            style: TextStyle(fontSize: 13.h, color: Colors.grey.shade600, height: 1.5),
          ),
          SizedBox(height: 16.h),
          Text("Marketed By:", style: TextStyle(fontSize: 14.h, fontWeight: FontWeight.bold)),
          SizedBox(height: 4.h),
          Text(
            "WayToFresh Quality Meats\n123 Fresh Lane, Culinary District,\nFood City 50001",
            style: TextStyle(fontSize: 13.h, color: Colors.grey.shade600, height: 1.5),
          ),
        ],
      );
    } else if (_selectedTab == 1) {
      return Text(
        "Store at 0-4°C if cooling, or -18°C for longer periods. Do not wash before freezing. Consume within 2 days of opening.",
        style: TextStyle(fontSize: 13.h, color: Colors.grey.shade600, height: 1.5),
      );
    } else {
      return Text(
        "Chef's Tip:\nMarinate lightly with olive oil, crushed garlic, sea salt, and black pepper. Pan-sear on a hot skillet for 3 mins per side. Let it rest for 5 mins before serving to retain juices.",
        style: TextStyle(fontSize: 13.h, color: Colors.grey.shade600, height: 1.5),
      );
    }
  }

  Widget _buildReviewHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Review", style: TextStyle(fontSize: 16.h, fontWeight: FontWeight.bold)),
        Text("Today, 15:40", style: TextStyle(fontSize: 12.h, color: Colors.grey)),
      ],
    );
  }

  Widget _buildReviewItem() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 20.h,
          backgroundColor: Colors.grey.shade200,
          child: Icon(CupertinoIcons.person, color: Colors.grey.shade500),
        ),
        SizedBox(width: 12.h),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Eleanor Summers", style: TextStyle(fontSize: 14.h, fontWeight: FontWeight.bold)),
              SizedBox(height: 4.h),
              Row(
                children: List.generate(5, (index) => Icon(CupertinoIcons.star_fill, color: const Color(0xFF800000), size: 12.h)),
              ),
              SizedBox(height: 8.h),
              Text(
                "The product is really fresh and the delivery was incredibly fast. Highly recommended!",
                style: TextStyle(fontSize: 13.h, color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAddToCartButton(BuildContext context, CartController controller, int index) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.all(20.h),
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
        child: ElevatedButton(
          onPressed: () {
            controller.addToCart(index);
            HapticFeedback.heavyImpact();
            Get.back();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF800000),
            padding: EdgeInsets.symmetric(vertical: 18.h),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.h)),
            elevation: 0,
          ),
          child: Text(
            "Add to Cart",
            style: TextStyle(fontSize: 16.h, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
