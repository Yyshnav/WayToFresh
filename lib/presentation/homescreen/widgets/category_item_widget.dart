import 'package:flutter/material.dart';
import 'package:waytofresh/core/app_expote.dart';
import 'package:waytofresh/presentation/category_screen/models/categoryitemmodel.dart';
import 'package:waytofresh/theme/text_style_helper.dart';

import '../../../widgets/custom_image_view.dart';

class CategoryItemWidget extends StatelessWidget {
  final CategoryItemModel category;

  CategoryItemWidget({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 86.h,
      height: 116.h,
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: 108.h,
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).cardColor, // Use cardColor instead of gray_300
              borderRadius: BorderRadius.circular(10.h),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 98.h,
              child: Stack(
                children: [
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: CustomImageView(
                      imagePath: category.imagePath.string,
                      height: 86.h,
                      width: 86.h,
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 13.h,
                    right: 13.h,
                    child: Text(
                      category.title.value,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyleHelper.instance.label10SemiBoldPoppins,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
