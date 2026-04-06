import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:waytofresh/core/app_expote.dart';
import 'package:waytofresh/core/utils/image_constants.dart';
import 'package:waytofresh/Widgets/product_item_widget.dart';
import 'package:waytofresh/presentation/search_screen/controller/search_controller.dart';
import 'package:waytofresh/widgets/custom_image_view.dart';

import 'package:waytofresh/presentation/checkout_screen/controller/address_controller.dart';
import 'package:waytofresh/presentation/checkout_screen/widgets/address_bottom_sheet.dart';
import 'package:waytofresh/presentation/profile_screen/binding/profile_binding.dart';
import 'package:waytofresh/presentation/profile_screen/profile_screen.dart';
import 'package:waytofresh/widgets/custom_blinkit_app_bar.dart';

class SearchScreen extends GetWidget<SearchScreenController> {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.searchResults.isEmpty) {
                return _buildNoResults();
              }

              return _buildSearchResultsGrid();
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(top: 8.h, bottom: 12.h),
      decoration: BoxDecoration(
        gradient: appTheme.primaryGradient,
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Obx(() {
              final addressController = Get.find<AddressController>();
              return CustomBlinkitAppBar(
                locationLabel: "Home",
                address: addressController.currentAddress.value.isNotEmpty
                    ? addressController.currentAddress.value
                    : "Select Location",
                onActionPressed: () {
                  Get.to(
                    () => const ProfileScreen(),
                    binding: ProfileBinding(),
                  );
                },
                isDarkTheme: true,
                onLocationPressed: () {
                  Get.bottomSheet(
                    const AddressBottomSheet(),
                    isScrollControlled: true,
                  );
                },
              );
            }),
            SizedBox(height: 6.h),
            _buildSearchBar(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 14.h, right: 14.h),
      padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 8.h),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(10.h),
        border: Border.all(color: appTheme.gray_400, width: 1.h),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Icon(
              CupertinoIcons.back,
              size: 16.h,
              color: appTheme.blackCustom,
            ),
          ),
          SizedBox(width: 8.h),
          CustomImageView(
            imagePath: ImageConstant.imgSearchinterfacesymbol1,
            height: 14.h,
            width: 14.h,
          ),
          SizedBox(width: 12.h),
          Expanded(
            child: TextFormField(
              controller: controller.searchController,
              autofocus: true,
              style: TextStyleHelper.instance.body12RegularPoppins.copyWith(
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
              decoration: InputDecoration(
                hintText: "Search \"ice-cream\"",
                hintStyle: TextStyleHelper.instance.body12RegularPoppins,
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              onChanged: (value) => controller.onSearchChanged(value),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResultsGrid() {
    return Padding(
      padding: EdgeInsets.all(14.h),
      child: GridView.builder(
        itemCount: controller.searchResults.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10.h,
          mainAxisSpacing: 10.h,
          childAspectRatio: 0.98,
        ),
        itemBuilder: (context, index) {
          return ProductItemWidget(
            product: controller.searchResults[index],
            delay: Duration(milliseconds: (index % 6) * 100),
          );
        },
      ),
    );
  }

  Widget _buildNoResults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(CupertinoIcons.search, size: 80, color: Colors.grey.shade300),
          SizedBox(height: 16.h),
          Text(
            "No matching products found",
            style: TextStyleHelper.instance.body14BoldPoppins.copyWith(
              color: Colors.grey.shade500,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            "Try searching for something else",
            style: TextStyleHelper.instance.body12RegularPoppins.copyWith(
              color: Colors.grey.shade400,
            ),
          ),
        ],
      ),
    );
  }
}
