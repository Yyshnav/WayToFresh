import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waytofresh/presentation/homescreen/homecontroller.dart';
import 'package:waytofresh/presentation/homescreen/product_item_model.dart';

class SearchScreenController extends GetxController {
  late TextEditingController searchController;
  RxList<ProductItemModel> searchResults = <ProductItemModel>[].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    searchController = TextEditingController();
    // Initial search if any query passed
    String? initialQuery = Get.arguments as String?;
    if (initialQuery != null && initialQuery.isNotEmpty) {
      searchController.text = initialQuery;
      performSearch(initialQuery);
    }
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  void onSearchChanged(String value) {
    if (value.isEmpty) {
      searchResults.clear();
      return;
    }
    performSearch(value);
  }

  Future<void> refreshSearch() async {
    if (searchController.text.isNotEmpty) {
      performSearch(searchController.text);
    }
  }


  void performSearch(String query) {
    isLoading.value = true;
    
    // Combine all products from HomeController to search
    // In a real app, this would be an API call
    try {
      final homeController = Get.find<HomeController>();
      
      List<ProductItemModel> allProducts = [];
      allProducts.addAll(homeController.dailyEssentials);
      allProducts.addAll(homeController.trendingProducts);
      allProducts.addAll(homeController.moreProducts);
      allProducts.addAll(homeController.productItems);

      // Simple case-insensitive filter
      searchResults.value = allProducts
          .where((product) =>
              product.title.value.toLowerCase().contains(query.toLowerCase()))
          .toList();
          
      // De-duplicate if same product exists in multiple lists
      final seen = <String>{};
      searchResults.value = searchResults.where((p) => seen.add(p.title.value)).toList();
      
    } catch (e) {
      // Fallback if HomeController is not found (though it should be)
      searchResults.clear();
    } finally {
      isLoading.value = false;
    }
  }
}
