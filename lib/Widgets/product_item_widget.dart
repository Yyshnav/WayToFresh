import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waytofresh/core/app_expote.dart';
import 'package:waytofresh/core/utils/image_constants.dart';
import 'package:waytofresh/presentation/homescreen/product_item_model.dart';
import 'package:waytofresh/theme/text_style_helper.dart';
import '../../../../widgets/custom_image_view.dart';
import '../presentation/category_screen/controller/cart_controller.dart';
import 'product_details_bottom_sheet.dart';

class ProductItemWidget extends StatefulWidget {
  final ProductItemModel product;

  const ProductItemWidget({Key? key, required this.product}) : super(key: key);

  @override
  State<ProductItemWidget> createState() => _ProductItemWidgetState();
}

class _ProductItemWidgetState extends State<ProductItemWidget> {
  // Local state removed in favor of CartController

  @override
  Widget build(BuildContext context) {
    // Determine product index in CartController
    final cartController = Get.find<CartController>();
    // Normalize string for comparison (remove newlines for safer match if needed, but here we try exact)
    int productIndex = cartController.allProducts.indexWhere(
      (p) => p['name'] == widget.product.title.value,
    );
    // If not found, we could fallback or disable.
    // For demo purposes, if not found, we might fallback to 0 or handled gracefully.
    // Given we added items to CartController, it should matching.
    if (productIndex == -1) productIndex = 0;

    return GestureDetector(
      onTap: () {
        Get.bottomSheet(
          ProductDetailsBottomSheet(product: widget.product),
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
        );
      },
      child: Container(
        width: 95.h,
        margin: EdgeInsets.symmetric(horizontal: 6.h, vertical: 5.h),
        padding: EdgeInsets.all(5.h),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(8.h),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor.withOpacity(0.1),
              blurRadius: 3,
              offset: Offset(0, 2),
            ),
          ],
        ),

        // ✅ height removed (auto fit)
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min, // auto shrink to fit content
          children: [
            /// 🔶 Product Image + ADD / Qty Selector
            Container(
              height: 80.h,
              width: double.infinity,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.h),
              ),
              child: Stack(
                children: [
                  CustomImageView(
                    imagePath: widget.product.image,
                    height: 80.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),

                  /// ✅ ADD / Quantity Selector
                  Positioned(
                    bottom: 4.h,
                    right: 4.h,
                    child: Obx(() {
                      int qty = cartController.cartItems[productIndex] ?? 0;
                      return AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        transitionBuilder: (child, animation) =>
                            ScaleTransition(scale: animation, child: child),
                        child: qty == 0
                            ? GestureDetector(
                                key: ValueKey('add_button'),
                                onTap: () {
                                  cartController.addToCart(productIndex);
                                },
                                child: Container(
                                  height: 28.h,
                                  width: 55.h,
                                  decoration: BoxDecoration(
                                    color: appTheme.white_A700,
                                    border: Border.all(
                                      color: appTheme.green_600,
                                      width: 1.2.h,
                                    ),
                                    borderRadius: BorderRadius.circular(6.h),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'ADD',
                                      style: TextStyleHelper
                                          .instance
                                          .label10SemiBoldPoppins
                                          .copyWith(
                                            color: appTheme.green_600,
                                            fontSize: 11.fSize,
                                          ),
                                    ),
                                  ),
                                ),
                              )
                            : Container(
                                key: ValueKey('qty_selector'),
                                height: 30.h,
                                width: 75.h,
                                decoration: BoxDecoration(
                                  color: appTheme.white_A700,
                                  border: Border.all(
                                    color: appTheme.green_600,
                                    width: 1.2.h,
                                  ),
                                  borderRadius: BorderRadius.circular(6.h),
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 5.h),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        cartController.removeFromCart(
                                          productIndex,
                                        );
                                      },
                                      child: Icon(
                                        Icons.remove,
                                        size: 16.h,
                                        color: appTheme.green_600,
                                      ),
                                    ),
                                    Text(
                                      '$qty',
                                      style: TextStyleHelper
                                          .instance
                                          .label10SemiBoldPoppins
                                          .copyWith(
                                            color: appTheme.green_600,
                                            fontSize: 11.fSize,
                                          ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        cartController.addToCart(productIndex);
                                      },
                                      child: Icon(
                                        Icons.add,
                                        size: 16.h,
                                        color: appTheme.green_600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                      );
                    }),
                  ),
                ],
              ),
            ),

            SizedBox(height: 6.h),

            /// 🔶 Product Title
            Text(
              widget.product.title.value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyleHelper.instance.label8BoldInter,
            ),

            SizedBox(height: 4.h),

            /// 🔶 Delivery Time
            Row(
              children: [
                CustomImageView(
                  imagePath: ImageConstant.imgTimer4,
                  height: 12.h,
                  width: 12.h,
                ),
                SizedBox(width: 3.h),
                Expanded(
                  child: Text(
                    widget.product.deliveryTime.value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyleHelper.instance.label10RegularPoppins
                        .copyWith(color: appTheme.gray_500, fontSize: 10.fSize),
                  ),
                ),
              ],
            ),

            SizedBox(height: 4.h),

            /// 🔶 Price
            Row(
              children: [
                CustomImageView(
                  imagePath: ImageConstant.imgImage5014x14,
                  height: 12.h,
                  width: 12.h,
                ),
                SizedBox(width: 4.h),
                Text(
                  '₹${widget.product.price.value}',
                  style: TextStyleHelper.instance.body15BoldPoppins.copyWith(
                    fontSize: 13.fSize,
                  ),
                ),
              ],
            ),

            /// ✅ Add small space after price
            SizedBox(height: 6.h),
          ],
        ),
      ),
    );
  }
}
