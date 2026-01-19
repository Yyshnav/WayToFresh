import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/cart_controller.dart';
import '../../homescreen/product_item_model.dart';
import '../../../../Widgets/product_details_bottom_sheet.dart';

class ProductCard extends StatelessWidget {
  final Map<String, dynamic> product;
  final int productIndex;
  final CartController controller;

  const ProductCard({
    super.key,
    required this.product,
    required this.productIndex,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      bool isInCart = controller.cartItems.containsKey(productIndex);
      int quantity = isInCart ? controller.cartItems[productIndex]! : 0;

      return GestureDetector(
        onTap: () {
          Get.bottomSheet(
            ProductDetailsBottomSheet(
              product: ProductItemModel.fromMap(product),
            ),
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(
                        4,
                      ), // Reduced padding for larger image feel
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                      ),
                      child: product["image"] != null
                          ? Image.asset(
                              product["image"],
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Center(
                                    child: Icon(
                                      Icons.image_not_supported_outlined,
                                      size: 32,
                                      color: Colors.grey,
                                    ),
                                  ),
                            )
                          : const Center(
                              child: Icon(
                                Icons.shopping_basket_outlined,
                                size: 32,
                                color: Colors.grey,
                              ),
                            ),
                    ),
                    // Time Badge
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.timer_outlined,
                              size: 10,
                              color: Colors.black87,
                            ),
                            const SizedBox(width: 2),
                            const Text(
                              "12 MINS",
                              style: TextStyle(
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Product Details
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product["name"],
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product["weight"],
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Price and Add Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "₹${product["price"]}",
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              "₹${(product["price"] * 1.2).toInt()}",
                              style: TextStyle(
                                fontSize: 11,
                                decoration: TextDecoration.lineThrough,
                                color: Colors.grey.shade400,
                              ),
                            ),
                          ],
                        ),

                        if (!isInCart)
                          GestureDetector(
                            onTap: () => controller.addToCart(productIndex),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: controller.currentTheme.primaryColor,
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                "ADD",
                                style: TextStyle(
                                  color: controller.currentTheme.primaryColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                        else
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6, // Reduced from 8
                              vertical: 4, // Reduced from 5
                            ),
                            decoration: BoxDecoration(
                              color: controller.currentTheme.primaryColor,
                              borderRadius: BorderRadius.circular(
                                6,
                              ), // Slightly tighter radius
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                GestureDetector(
                                  onTap: () =>
                                      controller.removeFromCart(productIndex),
                                  child: const Icon(
                                    Icons.remove,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 6), // Reduced from 8
                                Text(
                                  '$quantity',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(width: 6), // Reduced from 8
                                GestureDetector(
                                  onTap: () =>
                                      controller.addToCart(productIndex),
                                  child: const Icon(
                                    Icons.add,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
