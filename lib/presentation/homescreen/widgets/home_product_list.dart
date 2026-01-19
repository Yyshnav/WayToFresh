import 'package:flutter/material.dart';
import 'package:get/get.dart'; // For RxList
import 'package:waytofresh/theme/text_style_helper.dart';
import '../../../Widgets/product_item_widget.dart';
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
                  color: const Color(0xFF2E7D32),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        const SizedBox(height: 12),
        SizedBox(
          height: 200, // Increased height to prevent overflow
          child: Obx(
            () => ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: products.length,
              separatorBuilder: (context, index) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                return SizedBox(
                  width: 110,
                  child: ProductItemWidget(product: products[index]),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
