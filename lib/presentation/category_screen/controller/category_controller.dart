import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/categoryitemmodel.dart';
import '../models/category_collection_model.dart';
import 'package:waytofresh/core/network/dio_client.dart';

class CategoryController extends GetxController {
  TextEditingController searchController = TextEditingController();

  RxList<CategoryItemModel> groceryKitchenItems = <CategoryItemModel>[].obs;
  RxList<CategoryItemModel> snacksDrinksItems = <CategoryItemModel>[].obs;
  RxList<CategoryItemModel> householdEssentialsItems = <CategoryItemModel>[].obs;
  RxBool isLoading = true.obs;

  // Live categories from API
  RxList<CategoryCollectionModel> collections = <CategoryCollectionModel>[].obs;

  // Color palette for categories (cycling)
  final List<Color> _colors = [
    const Color(0xFFD4F8C7),
    const Color(0xFFFFF2C2),
    const Color(0xFFFFCCBC),
    const Color(0xFFE8D5FF),
    const Color(0xFFFFCDD2),
    const Color(0xFFB3E5FC),
    const Color(0xFFE2F8C9),
    const Color(0xFFFFE0B2),
  ];

  @override
  void onInit() {
    super.onInit();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      isLoading.value = true;
      final response = await DioClient().dio.get('categories/');
      if (response.statusCode == 200) {
        final list = response.data as List;
        collections.value = list.asMap().entries.map((e) {
          final c = e.value;
          String name = (c['name'] ?? '').toString();
          
          // Smart color selection
          Color categoryColor;
          if (name.toLowerCase().contains('vegetable') || name.toLowerCase().contains('fruit')) {
            categoryColor = _colors[0]; // Green
          } else if (name.toLowerCase().contains('meat') || name.toLowerCase().contains('chicken')) {
            categoryColor = _colors[2]; // Peach/Reddish
          } else {
            categoryColor = _colors[e.key % _colors.length];
          }

          return CategoryCollectionModel(
            id: c['id'],
            title: name,
            imagePath: c['image_url'] ?? '',
            color: categoryColor,
            price: 0,
            itemCount: c['product_count'] ?? 0,
          );
        }).toList();
      }
    } catch (e) {
      // Keep empty list
    } finally {
      isLoading.value = false;
    }
  }

  void onLocationPressed() {}
  void onProfilePressed() {}
  void onSearchChanged(String value) {}
  void onVoiceSearchPressed() {}
  void onCategoryItemPressed(CategoryItemModel item) {}
}
