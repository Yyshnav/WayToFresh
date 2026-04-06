import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:waytofresh/core/app_expote.dart';
import 'package:waytofresh/widgets/custom_image_view.dart';
import 'package:waytofresh/theme/text_style_helper.dart';
import '../models/category_collection_model.dart';

class CategoryCollectionCard extends StatelessWidget {
  final CategoryCollectionModel collection;
  final VoidCallback? onTap;

  const CategoryCollectionCard({Key? key, required this.collection, this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: collection.color,
          borderRadius: BorderRadius.circular(20.h),
        ),
        padding: EdgeInsets.all(12.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              collection.title,
              style: TextStyleHelper.instance.body14BoldPoppins.copyWith(
                fontSize: 16.fSize,
                color: Colors.black87,
                height: 1.2,
              ),
            ),

            SizedBox(height: 10.h),

            // Image
            Center(
              child: CustomImageView(
                imagePath: collection.imagePath,
                height: 100.h,
                width: 100.h,
                fit: BoxFit.contain,
              ),
            ),

            SizedBox(height: 10.h),

            // Bottom Row (Price + Cart Button)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "\$${collection.price.toStringAsFixed(2)}",
                  style: TextStyleHelper.instance.body12BoldPoppins.copyWith(
                    fontSize: 12.fSize,
                    color: Colors.black87,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(8.h),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    CupertinoIcons.bag,
                    color: Colors.white,
                    size: 14.h,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
