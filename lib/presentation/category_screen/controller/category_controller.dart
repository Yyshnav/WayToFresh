import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/categoryitemmodel.dart';
import '../models/category_collection_model.dart';
import 'package:waytofresh/core/utils/image_constants.dart';

class CategoryController extends GetxController {
  TextEditingController searchController = TextEditingController();

  RxList<CategoryItemModel> groceryKitchenItems = <CategoryItemModel>[].obs;
  RxList<CategoryItemModel> snacksDrinksItems = <CategoryItemModel>[].obs;
  RxList<CategoryItemModel> householdEssentialsItems =
      <CategoryItemModel>[].obs;

  RxList<CategoryCollectionModel> collections = <CategoryCollectionModel>[
    CategoryCollectionModel(
      title: "Fresh Fruits\n& Vegetable",
      imagePath: ImageConstant.imgImage19, // Broccoli/Veg
      color: Color(0xFFD4F8C7), // Light Green
      price: 7.00,
      itemCount: 245,
    ),
    CategoryCollectionModel(
      title: "Bakery & Snacks",
      imagePath: ImageConstant.biscut3,
      color: Color(0xFFFFF2C2), // Light Yellow
      price: 6.00,
      itemCount: 150,
    ),
    CategoryCollectionModel(
      title: "Meat & Fish",
      imagePath: ImageConstant.imgImage53, // Meat fallback
      color: Color(0xFFFFCCBC), // Light Orange/Peach
      price: 8.00,
      itemCount: 85,
    ),
    CategoryCollectionModel(
      title: "Egg Chicken\nRed",
      imagePath: ImageConstant.imgImage54, // Egg fallback
      color: Color(0xFFFFE0D6), // Very light peach
      price: 6.00,
      itemCount: 40,
    ),
    CategoryCollectionModel(
      title: "Cooking Oil\n& Ghee",
      imagePath: ImageConstant.imgImage18, // Oil fallback
      color: Color(0xFFE2F8C9), // Another Green variant
      price: 6.00,
      itemCount: 120,
    ),
    CategoryCollectionModel(
      title: "Apple & Grape\nJuice",
      imagePath: ImageConstant.drink1,
      color: Color(0xFFFFCDD2), // Light Pink/Red
      price: 6.00,
      itemCount: 65,
    ),
  ].obs;

  @override
  void onInit() {
    super.onInit();
    // Data already loaded
  }

  // Removed _loadDummyData as it is now inline

  void onLocationPressed() {
    // Handle location press
  }

  void onProfilePressed() {
    // Handle profile press
  }

  void onSearchChanged(String value) {
    // Handle search text change
  }

  void onVoiceSearchPressed() {
    // Handle voice search
  }

  void onCategoryItemPressed(CategoryItemModel item) {
    // Handle category item press
  }
}
