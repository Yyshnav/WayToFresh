// import 'package:flutter/material.dart';
// import 'package:waytofresh/core/app_expote.dart';
// import 'package:waytofresh/core/utils/image_constants.dart';
// import 'package:waytofresh/presentation/homescreen/product_item_model.dart';
// import 'package:waytofresh/theme/text_style_helper.dart';

// import '../../../widgets/custom_image_view.dart';

// class ProductItemWidget extends StatelessWidget {
//   final ProductItemModel product;

//   ProductItemWidget({
//     Key? key,
//     required this.product,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 108.h,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             height: 112.h,
//             width: 92.h,
//             child: Stack(
//               children: [
//                 CustomImageView(
//                   imagePath: product.image.value,
//                   height: 108.h,
//                   width: 92.h,
//                   fit: BoxFit.cover,
//                 ),
//                 Positioned(
//                   bottom: 4.h,
//                   right: 4.h,
//                   child: Container(
//                     padding:
//                         EdgeInsets.symmetric(horizontal: 4.h, vertical: 2.h),
//                     decoration: BoxDecoration(
//                       color: appTheme.white_A700,
//                       border: Border.all(
//                         color: appTheme.green_600,
//                         width: 1.h,
//                       ),
//                       borderRadius: BorderRadius.circular(4.h),
//                     ),
//                     child: Text(
//                       'ADD',
//                       style: TextStyleHelper.instance.label10SemiBoldPoppins
//                           .copyWith(color: appTheme.green_600),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(height: 2.h),
//           Text(
//             product.title.value,
//             style: TextStyleHelper.instance.label8BoldInter,
//           ),
//           SizedBox(height: 2.h),
//           Row(
//             children: [
//               CustomImageView(
//                 imagePath: ImageConstant.imgTimer4,
//                 height: 14.h,
//                 width: 14.h,
//               ),
//               SizedBox(width: 3.h),
//               Text(
//                 product.deliveryTime.value,
//                 style: TextStyleHelper.instance.label10RegularPoppins
//                     .copyWith(color: appTheme.gray_500),
//               ),
//             ],
//           ),
//           Row(
//             children: [
//               CustomImageView(
//                 imagePath: ImageConstant.imgImage5014x14,
//                 height: 14.h,
//                 width: 14.h,
//               ),
//               SizedBox(width: 4.h),
//               Text(
//                 '₹${product.price.value}',
//                 style: TextStyleHelper.instance.body15BoldPoppins,
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:waytofresh/core/app_expote.dart';
import 'package:waytofresh/core/utils/image_constants.dart';
import 'package:waytofresh/presentation/homescreen/product_item_model.dart';
import 'package:waytofresh/theme/text_style_helper.dart';
import '../../../widgets/custom_image_view.dart';

class ProductItemWidget extends StatefulWidget {
  final ProductItemModel product;

  const ProductItemWidget({Key? key, required this.product}) : super(key: key);

  @override
  State<ProductItemWidget> createState() => _ProductItemWidgetState();
}

class _ProductItemWidgetState extends State<ProductItemWidget> {
  int quantity = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 105.h,
      margin: EdgeInsets.symmetric(horizontal: 6.h, vertical: 5.h),
      padding: EdgeInsets.all(5.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.h),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 3, offset: Offset(0, 2)),
        ],
      ),

      // ✅ height removed (auto fit)
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // auto shrink to fit content
        children: [
          /// 🔶 Product Image + ADD / Qty Selector
          Container(
            height: 95.h,
            width: double.infinity,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.h)),
            child: Stack(
              children: [
                CustomImageView(
                  imagePath: widget.product.image.value,
                  height: 95.h,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),

                /// ✅ ADD / Quantity Selector
                Positioned(
                  bottom: 4.h,
                  right: 4.h,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    transitionBuilder: (child, animation) =>
                        ScaleTransition(scale: animation, child: child),
                    child: quantity == 0
                        ? GestureDetector(
                            key: ValueKey('add_button'),
                            onTap: () {
                              setState(() {
                                quantity = 1;
                              });
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (quantity > 1) {
                                        quantity--;
                                      } else {
                                        quantity = 0;
                                      }
                                    });
                                  },
                                  child: Icon(
                                    Icons.remove,
                                    size: 16.h,
                                    color: appTheme.green_600,
                                  ),
                                ),
                                Text(
                                  '$quantity',
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
                                    setState(() {
                                      quantity++;
                                    });
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
                  ),
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
    );
  }
}
