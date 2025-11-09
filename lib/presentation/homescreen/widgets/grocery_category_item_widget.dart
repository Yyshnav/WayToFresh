import 'package:flutter/material.dart';
import 'package:waytofresh/core/app_expote.dart';
import 'package:waytofresh/presentation/homescreen/grocery_category_item_model.dart';

import '../../../widgets/custom_image_view.dart';

class GroceryCategoryItemWidget extends StatelessWidget {
  final GroceryCategoryItemModel category;

  GroceryCategoryItemWidget({
    Key? key,
    required this.category,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70.h,
      child: Column(
        spacing: 12.h,
        children: [
          Container(
            width: 70.h,
            height: 78.h,
            decoration: BoxDecoration(
              color: appTheme.teal_50,
              borderRadius: BorderRadius.circular(10.h),
            ),
            child: Center(
              child: CustomImageView(
                imagePath: category.image.value,
                height: category.imageHeight.value,
                width: category.imageWidth.value,
                fit: BoxFit.contain,
              ),
            ),
          ),
          Text(
            category.title.value,
            textAlign: TextAlign.center,
            style: TextStyleHelper.instance.label10RegularPoppins,
          ),
        ],
      ),
    );
  }
}
