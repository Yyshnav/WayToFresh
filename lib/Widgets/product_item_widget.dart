import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:waytofresh/core/app_expote.dart';
import 'package:waytofresh/core/utils/image_constants.dart';
import 'package:waytofresh/presentation/homescreen/product_item_model.dart';
import 'package:waytofresh/theme/text_style_helper.dart';
import 'package:waytofresh/widgets/custom_image_view.dart';
import 'package:waytofresh/presentation/category_screen/controller/cart_controller.dart';
import 'animate_fade_slide.dart';
import 'package:waytofresh/widgets/product_details_bottom_sheet.dart';

class ProductItemWidget extends StatefulWidget {
  final ProductItemModel product;
  final Duration delay;

  const ProductItemWidget({
    Key? key,
    required this.product,
    this.delay = Duration.zero,
  }) : super(key: key);

  @override
  State<ProductItemWidget> createState() => _ProductItemWidgetState();
}

class _ProductItemWidgetState extends State<ProductItemWidget> {
  // Local state removed in favor of CartController

  @override
  Widget build(BuildContext context) {
    return AnimateFadeSlide(delay: widget.delay, child: _buildContent(context));
  }

  Widget _buildContent(BuildContext context) {
    final cartController = Get.find<CartController>();

    return GestureDetector(
      onTap: () {
        Get.bottomSheet(
          ProductDetailsBottomSheet(product: widget.product),
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
        );
      },
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 2.h, vertical: 5.h),
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
              height: 64.h,
              width: double.infinity,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.h),
              ),
              child: Stack(
                children: [
                  CustomImageView(
                    imagePath: widget.product.image,
                    height: 64.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),

                  /// ✅ ADD / Quantity Selector (SMALL)
                  Positioned(
                    bottom: 4.h,
                    right: 4.h,
                    child: Obx(() {
                      // Use stable ID for cart state
                      final int productId = widget.product.id.value;
                      int qty = cartController.cartItems[productId] ?? 0;
                      
                      return AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        transitionBuilder: (child, animation) =>
                            ScaleTransition(scale: animation, child: child),
                        child: qty == 0
                            ? GestureDetector(
                                key: const ValueKey('add_button'),
                                onTap: () {
                                  cartController.registerProduct(widget.product);
                                  cartController.addToCart(productId);
                                },
                                child: Container(
                                  height: 22.h,
                                  width: 22.h,
                                  decoration: BoxDecoration(
                                    color: appTheme.green_600,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: appTheme.green_600.withOpacity(0.3),
                                        blurRadius: 6,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    CupertinoIcons.add,
                                    color: Colors.white,
                                    size: 14.h,
                                  ),
                                ),
                              )
                            : Container(
                                key: const ValueKey('qty_selector'),
                                height: 22.h,
                                width: 62.h,
                                decoration: BoxDecoration(
                                  color: appTheme.white_A700,
                                  border: Border.all(
                                    color: appTheme.green_600,
                                    width: 1.h,
                                  ),
                                  borderRadius: BorderRadius.circular(11.h), // Pill shape
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 4.h),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        cartController.removeFromCart(
                                          productId,
                                        );
                                      },
                                      child: Icon(
                                        CupertinoIcons.minus,
                                        size: 12.h,
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
                                            fontSize: 9.fSize,
                                          ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        cartController.addToCart(productId);
                                      },
                                      child: Icon(
                                        CupertinoIcons.add,
                                        size: 12.h,
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '₹${widget.product.price.value}',
                      style: TextStyleHelper.instance.body15BoldPoppins.copyWith(
                        fontSize: 13.fSize,
                        height: 1.1,
                      ),
                    ),
                    Obx(() => Text(
                      '₹${widget.product.originalPrice.value}',
                      style: TextStyleHelper.instance.label8BoldInter.copyWith(
                        decoration: TextDecoration.lineThrough,
                        color: appTheme.gray_500,
                        fontSize: 9.fSize,
                        fontWeight: FontWeight.normal,
                        height: 1.0,
                      ),
                    )),
                  ],
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
