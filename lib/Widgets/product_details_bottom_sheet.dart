import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:waytofresh/core/app_expote.dart';
import 'package:waytofresh/presentation/homescreen/product_item_model.dart';
import 'package:waytofresh/theme/text_style_helper.dart';
import '../../../../widgets/custom_image_view.dart';
import '../presentation/category_screen/controller/cart_controller.dart';

class ProductDetailsBottomSheet extends StatefulWidget {
  final ProductItemModel product;

  const ProductDetailsBottomSheet({Key? key, required this.product})
    : super(key: key);

  @override
  State<ProductDetailsBottomSheet> createState() =>
      _ProductDetailsBottomSheetState();
}

class _ProductDetailsBottomSheetState extends State<ProductDetailsBottomSheet> {
  final PageController _pageController = PageController();
  final RxInt _currentPage = 0.obs;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.find<CartController>();

    // Use stable ID for cart operations
    final int productId = widget.product.id.value;

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.h),
          topRight: Radius.circular(24.h),
        ),
      ),
      child: Column(
        children: [
          // 1. Header
          _buildHeader(),

          // 2. Scrollable Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),

                  // Product Image Carousel
                  Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Container(
                        height: 250.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(16.h),
                        ),
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: widget.product.images.length,
                          onPageChanged: (index) => _currentPage.value = index,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.all(20.h),
                              child: CustomImageView(
                                imagePath: widget.product.images[index],
                                fit: BoxFit.contain,
                              ),
                            );
                          },
                        ),
                      ),
                      // Dot Indicators
                      Positioned(
                        bottom: 12.h,
                        child: Obx(
                          () => Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              widget.product.images.length,
                              (index) => AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                margin: EdgeInsets.symmetric(horizontal: 4.h),
                                height: 8.h,
                                width: _currentPage.value == index ? 20.h : 8.h,
                                decoration: BoxDecoration(
                                  color: _currentPage.value == index
                                      ? Color(0xFF07575B)
                                      : Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(4.h),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 24.h),

                  // Title and Favorite
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          widget.product.title.value,
                          style: TextStyleHelper.instance.title20BoldPTSerif
                              .copyWith(
                                fontSize: 22.fSize,
                                color: Color(0xFF07575B),
                              ),
                        ),
                      ),
                      Icon(CupertinoIcons.heart, color: Colors.grey),
                    ],
                  ),

                  SizedBox(height: 8.h),

                  // Weight / Quantity Hint
                  Text(
                    widget.product.unit.value,
                    style: TextStyleHelper.instance.title20BoldPoppins.copyWith(
                      color: Colors.grey,
                    ),
                  ),

                  SizedBox(height: 16.h),

                  // Price and Delivery Badge
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "₹${widget.product.price.value}",
                            style: TextStyleHelper.instance.title20BoldPTSerif
                                .copyWith(
                                  fontSize: 24.fSize,
                                  color: Theme.of(context).primaryColor,
                                ),
                          ),
                          Obx(() => Text(
                            "₹${widget.product.originalPrice.value}",
                            style: TextStyleHelper.instance.label10RegularPoppins.copyWith(
                              decoration: TextDecoration.lineThrough,
                              color: Colors.grey,
                              fontSize: 14.fSize,
                            ),
                          )),
                        ],
                      ),
                      Spacer(),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.h,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.purple.shade50,
                          borderRadius: BorderRadius.circular(12.h),
                        ),
                        child: Row(
                          children: [
                            Icon(CupertinoIcons.bolt, color: Colors.purple, size: 16.h),
                            SizedBox(width: 4.h),
                            Text(
                              "Available on fast delivery",
                              style: TextStyle(
                                fontSize: 10.fSize,
                                color: Colors.purple,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 16.h),

                  // Rating
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8.h),
                        decoration: BoxDecoration(
                          color: const Color(0xFF07575B),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(CupertinoIcons.info_circle, color: Colors.white, size: 16.h),
                      ),
                      SizedBox(width: 12.h),
                      Container(
                        padding: EdgeInsets.all(8.h),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade100,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          CupertinoIcons.checkmark_seal,
                          color: Colors.orange,
                          size: 16.h,
                        ),
                      ),
                      Spacer(),
                      Icon(CupertinoIcons.star_fill, color: Color(0xFF07575B), size: 20.h),
                      SizedBox(width: 4.h),
                      Text(
                        "${widget.product.rating.value} Rating",
                        style: TextStyleHelper.instance.body14BoldPoppins
                            .copyWith(color: const Color(0xFF07575B)),
                      ),
                    ],
                  ),

                  SizedBox(height: 24.h),

                  Text(
                    widget.product.description.value,
                    style: TextStyleHelper.instance.body12BoldPoppins.copyWith(
                      color: Colors.grey.shade600,
                      height: 1.5,
                    ),
                  ),

                  SizedBox(height: 24.h),

                  // About Product Section
                  Text(
                    "About Product",
                    style: TextStyleHelper.instance.title20BoldPTSerif.copyWith(
                      fontSize: 18.fSize,
                      color: const Color(0xFF07575B),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  if (widget.product.shelfLife.value.isNotEmpty)
                    _buildAboutItem(
                      CupertinoIcons.time,
                      "Shelf Life",
                      widget.product.shelfLife.value,
                    ),
                  if (widget.product.manufacturerName.value.isNotEmpty)
                    _buildAboutItem(
                      CupertinoIcons.house,
                      "Manufacturer",
                      widget.product.manufacturerName.value,
                    ),

                  SizedBox(height: 32.h),

                  // Related Items Section
                  Text(
                    "You Might Also Like",
                    style: TextStyleHelper.instance.title20BoldPTSerif.copyWith(
                      fontSize: 18.fSize,
                      color: Color(0xFF07575B),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  _buildRelatedItems(cartController),

                  SizedBox(height: 120.h), // Bottom spacing
                ],
              ),
            ),
          ),

          // 3. Bottom Bar
          _buildBottomBar(cartController, productId),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.all(16.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleAvatar(
            backgroundColor: Colors.grey.shade100,
            child: IconButton(
              icon: Icon(CupertinoIcons.chevron_down, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          Text(
            "Product Details",
            style: TextStyleHelper.instance.body14BoldPoppins.copyWith(
              fontSize: 16.fSize,
            ),
          ),
          Stack(
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey.shade100,
                child: Icon(CupertinoIcons.cart, color: Colors.black),
              ),
              // We could add a badge here if we had access to total count easily without prop drilling or Get.find
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(CartController controller, int id) {
    return Container(
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          // Quantity Selector
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.h, vertical: 8.h),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(30.h),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => controller.removeFromCart(id),
                  child: Icon(CupertinoIcons.minus_circle, color: Colors.grey),
                ),
                SizedBox(width: 12.h),
                Obx(
                  () => Text(
                    "${controller.cartItems[id] ?? 1}", // Default to 1 for visual if 0, logic handled elsewhere usually
                    style: TextStyleHelper.instance.body14BoldPoppins,
                  ),
                ),
                SizedBox(width: 12.h),
                GestureDetector(
                  onTap: () => controller.addToCart(id),
                  child: Icon(
                    CupertinoIcons.plus_circle,
                    color: Color(0xFF07575B),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(width: 16.h),

          // Add to Cart Button
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                if ((controller.cartItems[id] ?? 0) == 0) {
                  controller.registerProduct(widget.product);
                  controller.addToCart(id);
                }
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFC6E872), // Lime green
                foregroundColor: Color(0xFF07575B), // Dark text
                padding: EdgeInsets.symmetric(vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.h),
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(CupertinoIcons.cart, size: 20.h),
                  SizedBox(width: 8.h),
                  Text(
                    "Add to cart",
                    style: TextStyle(
                      fontSize: 14.fSize,
                      fontWeight: FontWeight.bold,
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

  Widget _buildAboutItem(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.h),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8.h),
            ),
            child: Icon(icon, size: 20.h, color: Colors.grey.shade700),
          ),
          SizedBox(width: 12.h),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12.fSize,
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14.fSize,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRelatedItems(CartController controller) {
    final related = controller.allProducts
        .where(
          (p) =>
              p['category'] == widget.product.category.value &&
              p['name'] != widget.product.title.value,
        )
        .take(5)
        .toList();

    if (related.isEmpty) return SizedBox.shrink();

    return SizedBox(
      height: 180.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: related.length,
        separatorBuilder: (context, index) => SizedBox(width: 16.h),
        itemBuilder: (context, index) {
          final item = related[index];
          final pModel = ProductItemModel.fromMap(item);
          return GestureDetector(
            onTap: () {
              Navigator.pop(context); // Close current sheet
              Get.bottomSheet(
                ProductDetailsBottomSheet(product: pModel),
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
              );
            },
            child: Container(
              width: 130.h,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16.h),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(8.h),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(16.h),
                        ),
                      ),
                      child: CustomImageView(
                        imagePath: pModel.image,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          pModel.title.value,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12.fSize,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          "₹${pModel.price.value}",
                          style: TextStyle(
                            fontSize: 14.fSize,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF07575B),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
