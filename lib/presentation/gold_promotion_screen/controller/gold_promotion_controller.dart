import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../homescreen/product_item_model.dart';
import '../../../core/utils/image_constants.dart';

class GoldPromotionController extends GetxController {
  RxBool isVegMode = false.obs;
  RxString selectedCategory = "All".obs;
  RxList<ProductItemModel> allProducts = <ProductItemModel>[].obs;
  RxList<ProductItemModel> filteredProducts = <ProductItemModel>[].obs;

  final TextEditingController searchController = TextEditingController();

  void _applyFilters() {
    filteredProducts.value = allProducts.where((product) {
      // 1. Veg Mode Filtering
      if (isVegMode.value && !product.isVeg.value) return false;

      // 2. Category Filtering
      final cat = selectedCategory.value;
      if (cat != "All" && cat != "Explore") {
        if (product.filterCategoryName.value != cat &&
            !product.filterCategoryName.value.contains(cat)) {
          return false;
        }
      }

      // 3. Search Filtering
      if (searchController.text.isNotEmpty) {
        final query = searchController.text.toLowerCase();
        if (!product.title.value.toLowerCase().contains(query)) return false;
      }

      return true;
    }).toList();
  }

  @override
  void onInit() {
    super.onInit();
    _loadMockProducts();

    // Wire up reactive filter triggers
    ever(isVegMode, (_) => _applyFilters());
    ever(selectedCategory, (_) => _applyFilters());
    ever(allProducts, (_) => _applyFilters());

    // Search listener
    searchController.addListener(_applyFilters);
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  void selectCategory(String categoryName) {
    selectedCategory.value = categoryName;
  }

  void toggleVegMode(bool value) {
    isVegMode.value = value;
  }

  void _loadMockProducts() {
    allProducts.addAll([
      // WAGYU & PREMIUM
      ProductItemModel(
        title: "Premium Wagyu",
        images: [ImageConstant.imgRawWagyu],
        deliveryTime: "20 MINS",
        price: 120,
        isVeg: false,
        filterCategoryName: "Specials",
        description: "Highly marbled raw Wagyu beef, tender and flavorful.",
        size: "1 kg",
      ),
      ProductItemModel(
        title: "Beef Tenderloin",
        images: [ImageConstant.imgRawTenderloin],
        deliveryTime: "15 MINS",
        price: 85,
        isVeg: false,
        filterCategoryName: "Beef",
        description: "Lean and tender beef cut, perfect for steaks.",
        size: "500 g",
      ),
      ProductItemModel(
        title: "Beef Ribs",
        images: [ImageConstant.imgRawRibs],
        deliveryTime: "30 MINS",
        price: 95,
        isVeg: false,
        filterCategoryName: "Beef",
        description: "Prime beef short ribs, perfect for slow cooking.",
        size: "1 kg",
      ),
      
      // CHICKEN
      ProductItemModel(
        title: "Chicken Breast Boneless",
        images: [ImageConstant.imgRawLamb], // using placeholder
        deliveryTime: "15 MINS",
        price: 45,
        isVeg: false,
        filterCategoryName: "Chicken",
        description: "Lean and healthy chicken breast.",
        size: "1 kg",
      ),
      ProductItemModel(
        title: "Chicken Curry Cut",
        images: [ImageConstant.imgRawLamb],
        deliveryTime: "18 MINS",
        price: 55,
        isVeg: false,
        filterCategoryName: "Chicken",
        size: "500 g",
      ),
      
      // LAMB & MUTTON
      ProductItemModel(
        title: "Lamb Chops",
        images: [ImageConstant.imgRawLamb],
        deliveryTime: "20 MINS",
        price: 75,
        isVeg: false,
        filterCategoryName: "Lamb",
        description: "Succulent raw lamb chops.",
        size: "500 g",
      ),
      ProductItemModel(
        title: "Lamb Leg",
        images: [ImageConstant.imgRawLamb],
        deliveryTime: "35 MINS",
        price: 110,
        isVeg: false,
        filterCategoryName: "Lamb",
        description: "Juicy and tender whole lamb leg.",
        size: "2 kg",
      ),
      
      // GROCERIES / MISC
      ProductItemModel(
        title: "Fresh Onions",
        images: [ImageConstant.imgImage4650x50],
        deliveryTime: "10 MINS",
        price: 30,
        isVeg: true,
        filterCategoryName: "All",
        unit: "Loose",
      ),
      ProductItemModel(
        title: "Farm Fresh Tomatoes",
        images: [ImageConstant.imgImage4660x60],
        deliveryTime: "10 MINS",
        price: 25,
        isVeg: true,
        filterCategoryName: "All",
        unit: "Loose",
      ),
    ]);
  }
}
