import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../homescreen/product_item_model.dart';
import 'package:waytofresh/core/network/dio_client.dart';

class GoldPromotionController extends GetxController {
  RxBool isVegMode = false.obs;
  RxString selectedCategory = "All".obs;
  RxList<ProductItemModel> allProducts = <ProductItemModel>[].obs;
  RxList<ProductItemModel> filteredProducts = <ProductItemModel>[].obs;
  RxBool isLoading = false.obs;

  final TextEditingController searchController = TextEditingController();

  void _applyFilters() {
    filteredProducts.assignAll(allProducts.where((product) {
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
    }).toList());
  }

  @override
  void onInit() {
    super.onInit();
    fetchGoldProducts();

    // Wire up reactive filter triggers
    ever(isVegMode, (_) => _applyFilters());
    ever(selectedCategory, (_) => _applyFilters());
    ever(allProducts, (_) => _applyFilters());

    // Search listener
    searchController.addListener(_applyFilters);
  }

  Future<void> fetchGoldProducts() async {
    isLoading.value = true;
    try {
      final response = await DioClient().dio.get('products/', queryParameters: {
        'is_gold_promotion': true,
      });

      if (response.statusCode == 200) {
        final List results = response.data['results'] ?? [];
        allProducts.assignAll(results.map((m) => ProductItemModel.fromMap(m)).toList());
        _applyFilters();
      }
    } catch (e) {
      debugPrint("Error fetching gold products: $e");
    } finally {
      isLoading.value = false;
    }
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
}
