import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:waytofresh/core/app_expote.dart';
import 'package:waytofresh/presentation/category_screen/controller/cart_controller.dart';
import 'package:waytofresh/theme/text_style_helper.dart';
import 'package:waytofresh/theme/theme_helper.dart';
import 'package:waytofresh/widgets/custom_image_view.dart';
import '../product_item_model.dart';

class HomeProductList extends StatelessWidget {
  final String title;
  final RxList<ProductItemModel> products;

  const HomeProductList({Key? key, required this.title, required this.products})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: TextStyleHelper.instance.title16BoldPoppins),
              Text(
                "See all",
                style: TextStyleHelper.instance.label12SemiBoldPoppins.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 120,
          child: Obx(
            () => ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: products.length,
              separatorBuilder: (context, index) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final product = products[index];
                final cartController = Get.find<CartController>();
                final int productIndex = cartController.getOrRegisterProduct(product);

                return Container(
                  width: 160,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.07),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Product Image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CustomImageView(
                          imagePath: product.image,
                          height: 80,
                          width: 65,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Info Column
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              product.title.value,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '₹${product.price.value}',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            const SizedBox(height: 5),
                            // ADD / Qty Stepper
                            if (productIndex == -1) const SizedBox.shrink() else Obx(() {
                              int qty = cartController.cartItems[productIndex] ?? 0;
                              return qty == 0
                                  ? GestureDetector(
                                      onTap: () => cartController.addToCart(productIndex),
                                      child: Container(
                                        height: 22,
                                        width: 50,
                                        decoration: BoxDecoration(
                                          color: appTheme.green_600,
                                          borderRadius: BorderRadius.circular(11),
                                        ),
                                        child: const Center(
                                          child: Text(
                                            'ADD',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container(
                                      height: 22,
                                      width: 65,
                                      decoration: BoxDecoration(
                                        border: Border.all(color: appTheme.green_600),
                                        borderRadius: BorderRadius.circular(11),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          GestureDetector(
                                            onTap: () => cartController.removeFromCart(productIndex),
                                            child: Icon(CupertinoIcons.minus, size: 13, color: appTheme.green_600),
                                          ),
                                          Text(
                                            '$qty',
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                              color: appTheme.green_600,
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () => cartController.addToCart(productIndex),
                                            child: Icon(CupertinoIcons.add, size: 13, color: appTheme.green_600),
                                          ),
                                        ],
                                      ),
                                    );
                            }),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
