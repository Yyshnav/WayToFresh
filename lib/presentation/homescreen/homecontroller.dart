import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waytofresh/core/utils/image_constants.dart';
import 'package:waytofresh/presentation/category_screen/models/categoryitemmodel.dart';
import 'package:waytofresh/presentation/homescreen/grocery_category_item_model.dart';
import 'package:waytofresh/presentation/homescreen/home_model.dart';
import 'package:waytofresh/presentation/homescreen/product_item_model.dart';
import 'package:waytofresh/routes/app_routes.dart';
import 'package:waytofresh/theme/theme_helper.dart';

class HomeController extends GetxController {
  late TextEditingController searchController;
  Rx<HomeModel> homeModelObj = HomeModel().obs;

  // ✅ Added for bottom bar hide/show animation
  RxBool hideBottomBar = false.obs;
  bool hasShownAddressSheet =
      false; // Flag to track if address sheet has been shown

  RxList<ProductItemModel> dailyEssentials = <ProductItemModel>[].obs;
  RxList<ProductItemModel> trendingProducts = <ProductItemModel>[].obs;
  RxList<String> bannerImages = <String>[].obs;
  RxList<CategoryItemModel> categoryItems = <CategoryItemModel>[].obs;
  RxList<ProductItemModel> productItems = <ProductItemModel>[].obs;
  RxList<GroceryCategoryItemModel> groceryCategories =
      <GroceryCategoryItemModel>[].obs;
  // List for pagination
  RxList<ProductItemModel> moreProducts = <ProductItemModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    searchController = TextEditingController();
    _initializeData();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  void _initializeData() {
    // Initialize category items
    categoryItems.value = [
      CategoryItemModel(
        title: "Lights, Diyas\n& Candles".obs,
        imagePath: ImageConstant.imgImage50.obs,
        imageHeight: 80.0.obs,
        imageWidth: 80.0.obs,
      ),
      CategoryItemModel(
        title: "Diwali\nGifts".obs,
        imagePath: ImageConstant.imgImage51.obs,
        imageHeight: 80.0.obs,
        imageWidth: 80.0.obs,
      ),
      CategoryItemModel(
        title: "Appliances\n& Gadgets".obs,
        imagePath: ImageConstant.imgImage51.obs,
        imageHeight: 80.0.obs,
        imageWidth: 80.0.obs,
      ),
      CategoryItemModel(
        title: "Home\n& Living".obs,
        imagePath: ImageConstant.imgImage50.obs,
        imageHeight: 80.0.obs,
        imageWidth: 80.0.obs,
      ),
    ];

    // Initialize product items
    productItems.value = [
      ProductItemModel(
        title: "Golden Glass \nWooden Lid Candle (Oudh)",
        images: [ImageConstant.imgImage54, ImageConstant.imgImage55],
        deliveryTime: "16 MINS",
        price: 79,
      ),
      ProductItemModel(
        title: "Royal Gulab Jamun \nBy Bikano",
        images: [ImageConstant.imgImage57, ImageConstant.imgImage60],
        deliveryTime: "16 MINS",
        price: 79,
      ),
      ProductItemModel(
        title: "Bikaji Bhujia",
        images: [ImageConstant.imgImage54, ImageConstant.imgImage55],
        deliveryTime: "16 MINS",
        price: 79,
      ),
    ];

    // Initialize grocery categories
    groceryCategories.value = [
      GroceryCategoryItemModel(
        title: "Vegetables &\nFruits",
        image: ImageConstant.imgImage46,
        imageHeight: 84.0,
        imageWidth: 60.0,
      ),
      GroceryCategoryItemModel(
        title: "Atta, Dal &\nRice",
        image: ImageConstant.imgImage4650x60,
        imageHeight: 50.0,
        imageWidth: 60.0,
      ),
      GroceryCategoryItemModel(
        title: "Oil, Ghee &\nMasala",
        image: ImageConstant.imgImage4660x60,
        imageHeight: 60.0,
        imageWidth: 60.0,
      ),
      GroceryCategoryItemModel(
        title: "Dairy, Bread &\nMilk",
        image: ImageConstant.imgImage4630x60,
        imageHeight: 30.0,
        imageWidth: 60.0,
      ),
      GroceryCategoryItemModel(
        title: "Biscuits &\nBakery",
        image: ImageConstant.imgImage4650x50,
        imageHeight: 50.0,
        imageWidth: 50.0,
      ),
    ];

    // Mock Data for New Sections
    dailyEssentials.value = [
      ProductItemModel(
        title: "Farm Fresh Milk",
        images: [ImageConstant.milk1, ImageConstant.milk2],
        deliveryTime: "10 MINS",
        price: 32,
        category: 3, // Dairy
      ),
      ProductItemModel(
        title: "Brown Bread",
        images: [ImageConstant.milk2, ImageConstant.milk3],
        deliveryTime: "12 MINS",
        price: 45,
        category: 3, // Dairy
      ),
      ProductItemModel(
        title: "Free Range Eggs",
        images: [ImageConstant.milk3, ImageConstant.milk1],
        deliveryTime: "15 MINS",
        price: 89,
        category: 3, // Dairy
      ),
      ProductItemModel(
        title: "Salted Butter",
        images: [ImageConstant.milk1, ImageConstant.milk2],
        deliveryTime: "8 MINS",
        price: 56,
        category: 3, // Dairy
      ),
    ];

    trendingProducts.value = [
      ProductItemModel(
        title: "Spicy Lays",
        images: [ImageConstant.lays, ImageConstant.kurukure],
        deliveryTime: "8 MINS",
        price: 20,
        category: 1, // Chips
      ),
      ProductItemModel(
        title: "Kurkure Masala",
        images: [ImageConstant.kurukure, ImageConstant.lays],
        deliveryTime: "8 MINS",
        price: 20,
        category: 1, // Chips
      ),
      ProductItemModel(
        title: "Coca Cola",
        images: [ImageConstant.coke, ImageConstant.lays],
        deliveryTime: "10 MINS",
        price: 40,
        category: 4, // Drinks
      ),
      ProductItemModel(
        title: "Dairy Milk Silk",
        images: [ImageConstant.diarymilk, ImageConstant.lays],
        deliveryTime: "5 MINS",
        price: 80,
        category: 5, // Sweets
      ),
    ];

    bannerImages.value = [
      ImageConstant.imgImage55, // Placeholder banners
      ImageConstant.imgImage60,
      ImageConstant.imgImage55,
    ];
  }

  void onSearchChanged(String value) {
    homeModelObj.value.searchText?.value = value;
    // Implement search functionality here
  }

  void onCategoryTap(CategoryItemModel category) {
    Get.toNamed(AppRoutes.categoryScreen);
  }

  void onProductAddTap(ProductItemModel product) {
    Get.snackbar(
      'Product Added',
      '${product.title.value} added to cart',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: appTheme.green_600,
      colorText: appTheme.whiteCustom,
    );
  }

  void onGroceryCategoryTap(GroceryCategoryItemModel category) {
    Get.toNamed(AppRoutes.categoryScreen);
  }
}
