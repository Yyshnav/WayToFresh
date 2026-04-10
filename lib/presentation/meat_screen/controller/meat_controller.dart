import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../homescreen/product_item_model.dart';
import 'package:waytofresh/core/utils/image_constants.dart';
import 'package:waytofresh/core/network/dio_client.dart';

class MeatController extends GetxController {
  RxBool showOnboarding = true.obs;
  RxString selectedCategory = "All meats".obs;
  RxInt selectedBottomTab = 0.obs;
  RxBool isLoading = false.obs;

  final List<String> categories = ["All meats", "Wagyu", "Tenderloin", "Sirloin", "Ribs", "Lamb", "Chicken"];

  final List<String> bannerImages = [
    ImageConstant.imgMeatHero,
    ImageConstant.imgMeatDeals,
    ImageConstant.imgRawWagyu,
  ];

  RxList<ProductItemModel> meatProducts = <ProductItemModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    isLoading.value = true;
    try {
      // Fetch products that belong to Meat & Fish category or have a meat_type
      final response = await DioClient().dio.get('products/', queryParameters: {
        'category_name': 'Meat & Fish', // Or use ID if known, but name is safer if DB just seeded
      });

      if (response.statusCode == 200) {
        final List results = response.data['results'] ?? [];
        meatProducts.assignAll(results.map((m) => ProductItemModel.fromMap(m)).toList());
      }
    } catch (e) {
      debugPrint("Error fetching meat products: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void toggleOnboarding() {
    showOnboarding.value = false;
  }

  void selectCategory(String category) {
    selectedCategory.value = category;
  }

  void selectBottomTab(int index) {
    selectedBottomTab.value = index;
    // Optional: Reset top category when switching species
    selectedCategory.value = "All meats";
  }

  List<ProductItemModel> get filteredMeatProducts {
    return meatProducts.where((p) {
      // 1. Filter by Main Species (Bottom Tab)
      bool matchesTab = true;
      final type = p.meatType.value.toLowerCase();
      final title = p.title.value.toLowerCase();

      if (selectedBottomTab.value == 0) {
        // "Meat" Tab: Beef, Pork, or non-chicken/lamb
        matchesTab = type == 'beef' || type == 'pork' || (!type.contains('chicken') && !type.contains('lamb'));
      } else if (selectedBottomTab.value == 1) {
        // "Chicken" Tab
        matchesTab = type == 'chicken' || title.contains('chicken');
      } else if (selectedBottomTab.value == 2) {
        // "Mutton" Tab
        matchesTab = type == 'lamb' || title.contains('lamb') || title.contains('mutton');
      }

      if (!matchesTab) return false;

      // 2. Filter by Top Category
      if (selectedCategory.value != "All meats") {
        final cat = selectedCategory.value.toLowerCase();
        if (!title.contains(cat) && !p.filterCategoryName.value.toLowerCase().contains(cat)) {
          return false;
        }
      }

      return true;
    }).toList();
  }
}
