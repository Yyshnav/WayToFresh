import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:waytofresh/Widgets/custom_image_view.dart';
import 'package:waytofresh/core/app_expote.dart';
import 'package:waytofresh/core/utils/image_constants.dart';
import 'package:waytofresh/theme/theme_helper.dart';
import 'package:waytofresh/widgets/custom_blinkit_app_bar.dart';
import 'controller/category_controller.dart';

class CategoryScreen extends StatefulWidget {
  final ScrollController? scrollController;

  const CategoryScreen({Key? key, this.scrollController}) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final CategoryController controller = Get.put(CategoryController());
  bool _isHeaderVisible = true;
  late ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.scrollController ?? ScrollController();
    _controller.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_controller.position.userScrollDirection == ScrollDirection.reverse) {
      if (_isHeaderVisible) {
        setState(() => _isHeaderVisible = false);
      }
    } else if (_controller.position.userScrollDirection ==
        ScrollDirection.forward) {
      if (!_isHeaderVisible) {
        setState(() => _isHeaderVisible = true);
      }
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.white_A700,
      body: CustomScrollView(
        controller: _controller,
        slivers: [
          // ✅ Animated header that hides on scroll
          SliverToBoxAdapter(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              height: _isHeaderVisible ? null : 0,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: _isHeaderVisible ? 1 : 0,
                child: _buildHeader(),
              ),
            ),
          ),

          // ✅ Scrollable content
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                _buildGroceryKitchenSection(),
                const SizedBox(height: 16),
                _buildSnacksDrinksSection(),
                const SizedBox(height: 16),
                _buildHouseholdEssentialsSection(),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ✅ HEADER (with gradient + SafeArea)
  Widget _buildHeader() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFE53935), Color(0xFFFF6B6B), Color(0xFFFFC1C1)],
          stops: [0.0, 0.5, 1.0],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomBlinkitAppBar(
                locationLabel: "HOME",
                address: "Trycode Innovations Calicut",
                onLocationPressed: controller.onLocationPressed,
                onActionPressed: controller.onProfilePressed,
              ),
              SizedBox(height: 6.h),
              _buildSearchBar(),
            ],
          ),
        ),
      ),
    );
  }

  // ✅ SEARCH BAR
  Widget _buildSearchBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 14.h),
      padding: EdgeInsets.symmetric(horizontal: 26.h, vertical: 8.h),
      decoration: BoxDecoration(
        color: appTheme.white_A700,
        borderRadius: BorderRadius.circular(10.h),
        border: Border.all(color: appTheme.gray_400, width: 1.h),
      ),
      child: Row(
        children: [
          CustomImageView(
            imagePath: ImageConstant.imgSearchinterfacesymbol1,
            height: 14.h,
            width: 14.h,
          ),
          SizedBox(width: 12.h),
          Expanded(
            child: TextFormField(
              controller: controller.searchController,
              style: TextStyleHelper.instance.body12RegularPoppins.copyWith(
                color: appTheme.black_900,
              ),
              decoration: InputDecoration(
                hintText: "Search \"ice-cream\"",
                hintStyle: TextStyleHelper.instance.body12RegularPoppins,
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              onChanged: controller.onSearchChanged,
            ),
          ),
          SizedBox(width: 12.h),
          GestureDetector(
            onTap: controller.onVoiceSearchPressed,
            child: CustomImageView(
              imagePath: ImageConstant.imgMic1,
              height: 14.h,
              width: 14.h,
            ),
          ),
        ],
      ),
    );
  }

  // ✅ GROCERY & KITCHEN SECTION
  Widget _buildGroceryKitchenSection() {
    return Container(
      margin: EdgeInsets.only(top: 24.h, left: 14.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Grocery & Kitchen",
            style: TextStyleHelper.instance.body14BoldPoppins,
          ),
          SizedBox(height: 6.h),
          SizedBox(
            height: 240.h,
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.zero,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 114 / 70,
                crossAxisSpacing: 8.h,
                mainAxisSpacing: 8.h,
              ),
              itemCount: controller.groceryKitchenItems.length,
              itemBuilder: (context, index) {
                final item = controller.groceryKitchenItems[index];
                return GestureDetector(
                  onTap: () => controller.onCategoryItemPressed(item),
                  child: Column(
                    children: [
                      Container(
                        height: 78.h,
                        width: 70.h,
                        decoration: BoxDecoration(
                          color: appTheme.teal_50,
                          borderRadius: BorderRadius.circular(10.h),
                        ),
                        child: Center(
                          child: CustomImageView(
                            imagePath: item.imagePath.value,
                            height: item.imageHeight.value.h,
                            width: item.imageWidth.value.h,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        item.title.value,
                        textAlign: TextAlign.center,
                        style: TextStyleHelper.instance.label10RegularPoppins,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ✅ SNACKS & DRINKS SECTION
  Widget _buildSnacksDrinksSection() {
    return Container(
      margin: EdgeInsets.only(top: 16.h, left: 14.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Snacks & Drinks",
            style: TextStyleHelper.instance.body14BoldPoppins,
          ),
          SizedBox(height: 10.h),
          SizedBox(
            height: 118.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.zero,
              itemCount: controller.snacksDrinksItems.length,
              separatorBuilder: (_, __) => SizedBox(width: 8.h),
              itemBuilder: (context, index) {
                final item = controller.snacksDrinksItems[index];
                return GestureDetector(
                  onTap: () => controller.onCategoryItemPressed(item),
                  child: Column(
                    children: [
                      Container(
                        height: 78.h,
                        width: 70.h,
                        decoration: BoxDecoration(
                          color: appTheme.teal_50,
                          borderRadius: BorderRadius.circular(10.h),
                        ),
                        child: Center(
                          child: CustomImageView(
                            imagePath: item.imagePath.value,
                            height: item.imageHeight.value.h,
                            width: item.imageWidth.value.h,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        item.title.value,
                        textAlign: TextAlign.center,
                        style: TextStyleHelper.instance.label10RegularPoppins,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ✅ HOUSEHOLD ESSENTIALS SECTION
  Widget _buildHouseholdEssentialsSection() {
    return Container(
      margin: EdgeInsets.only(top: 8.h, left: 14.h, bottom: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Household Essentials",
            style: TextStyleHelper.instance.body14BoldPoppins,
          ),
          SizedBox(height: 12.h),
          SizedBox(
            height: 78.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.zero,
              itemCount: controller.householdEssentialsItems.length,
              separatorBuilder: (_, __) => SizedBox(width: 8.h),
              itemBuilder: (context, index) {
                final item = controller.householdEssentialsItems[index];
                return GestureDetector(
                  onTap: () => controller.onCategoryItemPressed(item),
                  child: Container(
                    height: 78.h,
                    width: 70.h,
                    decoration: BoxDecoration(
                      color: appTheme.teal_50,
                      borderRadius: BorderRadius.circular(10.h),
                    ),
                    child: Center(
                      child: CustomImageView(
                        imagePath: item.imagePath.value,
                        height: item.imageHeight.value.h,
                        width: item.imageWidth.value.h,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
