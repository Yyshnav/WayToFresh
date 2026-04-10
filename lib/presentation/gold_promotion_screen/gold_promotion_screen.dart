import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../core/app_expote.dart';
import '../../widgets/custom_image_view.dart';
import '../../widgets/product_item_widget.dart';
import './controller/gold_promotion_controller.dart';
import '../checkout_screen/controller/address_controller.dart';
import '../../core/utils/image_constants.dart';
import './widgets/gold_shine_animation.dart';
import './widgets/golden_envelope_banner.dart';

class GoldPromotionScreen extends GetView<GoldPromotionController> {
  const GoldPromotionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(context),
      body: RefreshIndicator(
        onRefresh: controller.fetchGoldProducts,
        color: const Color(0xFFFFD700), // Gold
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              _buildGoldenHeader(context),
              _buildCategoryFilters(context),
              _buildFilterChips(context),
              _buildRecommendedSection(context),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final addressController = Get.find<AddressController>();
    return AppBar(
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black87),
        onPressed: () => Get.back(),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.location_on, color: Colors.red, size: 16),
              const SizedBox(width: 4),
              Text(
                "Home",
                style: TextStyleHelper.instance.body14BoldPoppins.copyWith(color: Colors.black),
              ),
              const Icon(Icons.keyboard_arrow_down, color: Colors.black, size: 16),
            ],
          ),
          Obx(() => Text(
                addressController.currentAddress.value.isNotEmpty
                    ? addressController.currentAddress.value
                    : "Select Location",
                style: TextStyleHelper.instance.label10RegularPoppins.copyWith(color: Colors.grey),
                overflow: TextOverflow.ellipsis,
              )),
        ],
      ),
      actions: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "VEG MODE",
              style: TextStyleHelper.instance.label8BoldInter.copyWith(color: Colors.grey[700]),
            ),
            Obx(() => CupertinoSwitch(
                  value: controller.isVegMode.value,
                  onChanged: (value) => controller.toggleVegMode(value),
                  activeColor: Colors.green,
                )),
          ],
        ),
        const SizedBox(width: 16),
      ],
    );
  }

  // Combined gold hero: AppBar area + search bar + golden envelope banner all share one gradient
  Widget _buildGoldenHeader(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFFFF8E1), // pale gold top
            Color(0xFFFFE082), // richer gold bottom
          ],
        ),
      ),
      child: Column(
        children: [
          // Push content below the AppBar (status bar + App bar height)
          SizedBox(height: MediaQuery.of(context).padding.top + kToolbarHeight),
          // Search bar sits inside the gold section
          _buildSearchBar(context),
          // The golden envelope banner (remove its own background so it inherits)
          const GoldenEnvelopeBanner(),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 8.h),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 8.h),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12.h),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Row(
          children: [
            const Icon(Icons.search, color: Colors.red, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: controller.searchController,
                style: TextStyleHelper.instance.body12RegularPoppins.copyWith(color: Colors.black),
                decoration: InputDecoration(
                  hintText: 'Search "chicken"',
                  hintStyle: TextStyleHelper.instance.body12RegularPoppins.copyWith(color: Colors.grey),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
            const Icon(Icons.mic, color: Colors.red, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryFilters(BuildContext context) {
    final categories = [
      {'name': 'Explore', 'icon': Icons.stars_rounded},
      {'name': 'All', 'icon': null},
      {'name': 'Specials', 'icon': Icons.local_offer},
      {'name': 'Chicken', 'icon': null},
      {'name': 'Lamb', 'icon': null},
      {'name': 'Beef', 'icon': null},
    ];

    return Container(
      height: 90.h,
      margin: EdgeInsets.only(top: 16.h),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.h),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final cat = categories[index];
          final catName = cat['name'] as String;
          
          return Obx(() {
            final isSelected = controller.selectedCategory.value == catName;
            
            return GestureDetector(
              onTap: () => controller.selectCategory(catName),
              child: Container(
                margin: EdgeInsets.only(right: 20.h),
                child: Column(
                  children: [
                    Container(
                      width: 50.h,
                      height: 50.h,
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.red[50] : Colors.grey[100],
                        shape: BoxShape.circle,
                        border: isSelected ? Border.all(color: Colors.red.withOpacity(0.5), width: 2) : null,
                      ),
                      child: cat['icon'] != null
                          ? Icon(cat['icon'] as IconData, color: isSelected ? Colors.red : Colors.grey[600])
                          : ClipOval(
                              child: CustomImageView(
                                imagePath: ImageConstant.imgImage20,
                                fit: BoxFit.cover,
                              ),
                            ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      catName,
                      style: TextStyleHelper.instance.label10SemiBoldPoppins.copyWith(
                        color: isSelected ? Colors.red : Colors.black,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    if (isSelected)
                      Container(
                        height: 3,
                        width: 30,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(2),
                        ),
                        margin: const EdgeInsets.only(top: 2),
                      ),
                  ],
                ),
              ),
            );
          });
        },
      ),
    );
  }

  Widget _buildFilterChips(BuildContext context) {
    final filters = ["Filters", "Under ₹200", "Under 30 mins", "Great Offers"];
    return Container(
      height: 40.h,
      margin: EdgeInsets.symmetric(vertical: 8.h),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.h),
        itemCount: filters.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(right: 8.h),
            child: FilterChip(
              label: Text(
                filters[index],
                style: TextStyleHelper.instance.label10RegularPoppins,
              ),
              onSelected: (val) {},
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.h),
                side: BorderSide(color: Colors.grey[300]!),
              ),
              avatar: index == 0 ? const Icon(Icons.tune, size: 14) : null,
            ),
          );
        },
      ),
    );
  }

  Widget _buildRecommendedSection(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "RECOMMENDED FOR YOU",
            style: TextStyle(
              fontSize: 10.fSize,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          Obx(() {
            final items = controller.filteredProducts;
            if (items.isEmpty) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 40.h),
                  child: Text("No items match your filters", style: TextStyle(color: Colors.grey)),
                ),
              );
            }
            
            return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: items.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.9,
                ),
                itemBuilder: (context, index) {
                  return TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0.0, end: 1.0),
                    // We key the animation to the product title so it replays when filtering changes
                    key: ValueKey(items[index].title.value),
                    duration: Duration(milliseconds: 400 + ((index % 4) * 100)),
                    curve: Curves.easeOutCubic,
                    builder: (context, value, child) {
                      return Opacity(
                        opacity: value,
                        child: Transform.translate(
                          offset: Offset(0, 30 * (1 - value)),
                          child: child,
                        ),
                      );
                    },
                    child: GoldShineAnimation(
                      child: ProductItemWidget(
                        product: items[index],
                      ),
                    ),
                  );
                },
              );
          }),
        ],
      ),
    );
  }
}

class EnvelopeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 20); // Go down left side
    // Inverted curve (concave) at the bottom
    path.quadraticBezierTo(size.width / 2, size.height + 15, size.width, size.height - 20);
    path.lineTo(size.width, 0); // Go up right side
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
