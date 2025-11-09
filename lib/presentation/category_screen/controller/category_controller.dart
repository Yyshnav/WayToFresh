import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:waytofresh/core/app_expote.dart';
import 'package:waytofresh/core/utils/image_constants.dart';
import 'package:waytofresh/presentation/category_screen/models/categoryitemmodel.dart';
import 'package:waytofresh/presentation/category_screen/models/categorymodel.dart';

class CategoryController extends GetxController {
  late TextEditingController searchController;

  final categoryModel = Rx<CategoryModel?>(null);
  final isLoading = false.obs;
  final searchQuery = ''.obs;

  // Observable lists for different categories
  final groceryKitchenItems = <CategoryItemModel>[].obs;
  final snacksDrinksItems = <CategoryItemModel>[].obs;
  final householdEssentialsItems = <CategoryItemModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    searchController = TextEditingController();
    categoryModel.value = CategoryModel();
    initializeCategoryItems();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  void initializeCategoryItems() {
    // Initialize Grocery & Kitchen items
    groceryKitchenItems.assignAll([
      CategoryItemModel(
        imagePath: ImageConstant.imgImage4650x50.obs,
        title: "Vegetables &\nFruits".obs,
        imageHeight: 84.0.obs, // Modified: Changed from RxInt to Rx<double>
        imageWidth: 60.0.obs, // Modified: Changed from RxInt to Rx<double>
      ),
      CategoryItemModel(
        imagePath: ImageConstant.imgImage4650x60.obs,
        title: "Atta, Dal &\nRice".obs,
        imageHeight: 50.0.obs, // Modified: Changed from RxInt to Rx<double>
        imageWidth: 60.0.obs, // Modified: Changed from RxInt to Rx<double>
      ),
      CategoryItemModel(
        imagePath: ImageConstant.imgImage4650x50.obs,
        title: "Oil, Ghee &\nMasala".obs,
        imageHeight: 60.0.obs, // Modified: Changed from RxInt to Rx<double>
        imageWidth: 60.0.obs, // Modified: Changed from RxInt to Rx<double>
      ),
      CategoryItemModel(
        imagePath: ImageConstant.imgImage4630x60.obs,
        title: "Diary Milk &\nBread".obs,
        imageHeight: 30.0.obs, // Modified: Changed from RxInt to Rx<double>
        imageWidth: 60.0.obs, // Modified: Changed from RxInt to Rx<double>
      ),
      CategoryItemModel(
        imagePath: ImageConstant.imgImage4650x50.obs,
        title: "Biscuits &\nBakery".obs,
        imageHeight: 50.0.obs, // Modified: Changed from RxInt to Rx<double>
        imageWidth: 50.0.obs, // Modified: Changed from RxInt to Rx<double>
      ),
      CategoryItemModel(
        imagePath: ImageConstant.imgImage21.obs,
        title: "Dry Fruits &\nCereals".obs,
        imageHeight: 60.0.obs, // Modified: Changed from RxInt to Rx<double>
        imageWidth: 60.0.obs, // Modified: Changed from RxInt to Rx<double>
      ),
      CategoryItemModel(
        imagePath: ImageConstant.imgImage22.obs,
        title: "Kitchen &\nAppliances".obs,
        imageHeight: 42.0.obs, // Modified: Changed from RxInt to Rx<double>
        imageWidth: 60.0.obs, // Modified: Changed from RxInt to Rx<double>
      ),
      CategoryItemModel(
        imagePath: ImageConstant.imgImage23.obs,
        title: "Tea &\nCoffees".obs,
        imageHeight: 60.0.obs, // Modified: Changed from RxInt to Rx<double>
        imageWidth: 60.0.obs, // Modified: Changed from RxInt to Rx<double>
      ),
      CategoryItemModel(
        imagePath: ImageConstant.imgImage24.obs,
        title: "Ice Creams &\nmuch more".obs,
        imageHeight: 50.0.obs, // Modified: Changed from RxInt to Rx<double>
        imageWidth: 50.0.obs, // Modified: Changed from RxInt to Rx<double>
      ),
      CategoryItemModel(
        imagePath: ImageConstant.imgImage25.obs,
        title: "Noodles &\nPacket Food".obs,
        imageHeight: 50.0.obs, // Modified: Changed from RxInt to Rx<double>
        imageWidth: 50.0.obs, // Modified: Changed from RxInt to Rx<double>
      ),
    ]);

    // Initialize Snacks & Drinks items
    snacksDrinksItems.assignAll([
      CategoryItemModel(
        imagePath: ImageConstant.imgImage26.obs,
        title: "Chips &\nNamkeens".obs,
        imageHeight: 50.0.obs, // Modified: Changed from RxInt to Rx<double>
        imageWidth: 50.0.obs, // Modified: Changed from RxInt to Rx<double>
      ),
      CategoryItemModel(
        imagePath: ImageConstant.imgImage27.obs,
        title: "Sweets &\nChocalates".obs,
        imageHeight: 34.0.obs, // Modified: Changed from RxInt to Rx<double>
        imageWidth: 60.0.obs, // Modified: Changed from RxInt to Rx<double>
      ),
      CategoryItemModel(
        imagePath: ImageConstant.imgImage28.obs,
        title: "Drinks &\nJuices".obs,
        imageHeight: 36.0.obs, // Modified: Changed from RxInt to Rx<double>
        imageWidth: 70.0.obs, // Modified: Changed from RxInt to Rx<double>
      ),
      CategoryItemModel(
        imagePath: ImageConstant.imgImage29.obs,
        title: "Sauces &\nSpreads".obs,
        imageHeight: 42.0.obs, // Modified: Changed from RxInt to Rx<double>
        imageWidth: 50.0.obs, // Modified: Changed from RxInt to Rx<double>
      ),
      CategoryItemModel(
        imagePath: ImageConstant.imgImage30.obs,
        title: "Beauty &\nCosmetics".obs,
        imageHeight: 50.0.obs, // Modified: Changed from RxInt to Rx<double>
        imageWidth: 50.0.obs, // Modified: Changed from RxInt to Rx<double>
      ),
    ]);

    // Initialize Household Essentials items
    householdEssentialsItems.assignAll([
      CategoryItemModel(
        imagePath: ImageConstant.imgImage36.obs,
        title: "Cleaning".obs,
        imageHeight: 50.0.obs, // Modified: Changed from RxInt to Rx<double>
        imageWidth: 50.0.obs, // Modified: Changed from RxInt to Rx<double>
      ),
      CategoryItemModel(
        imagePath: ImageConstant.imgImage37.obs,
        title: "Laundry".obs,
        imageHeight: 52.0.obs, // Modified: Changed from RxInt to Rx<double>
        imageWidth: 50.0.obs, // Modified: Changed from RxInt to Rx<double>
      ),
      CategoryItemModel(
        imagePath: ImageConstant.imgImage38.obs,
        title: "Kitchen Care".obs,
        imageHeight: 50.0.obs, // Modified: Changed from RxInt to Rx<double>
        imageWidth: 50.0.obs, // Modified: Changed from RxInt to Rx<double>
      ),
      CategoryItemModel(
        imagePath: ImageConstant.imgImage39.obs,
        title: "Home Care".obs,
        imageHeight: 40.0.obs, // Modified: Changed from RxInt to Rx<double>
        imageWidth: 50.0.obs, // Modified: Changed from RxInt to Rx<double>
      ),
      CategoryItemModel(
        imagePath: ImageConstant.imgImage40.obs,
        title: "Personal Care".obs,
        imageHeight: 50.0.obs, // Modified: Changed from RxInt to Rx<double>
        imageWidth: 50.0.obs, // Modified: Changed from RxInt to Rx<double>
      ),
    ]);
  }

  void onSearchChanged(String value) {
    searchQuery.value = value;
    // Implement search functionality if needed
  }

  void onVoiceSearchPressed() {
    // Implement voice search functionality
    Get.snackbar(
      "Voice Search",
      "Voice search feature will be implemented",
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void onLocationPressed() {
    // Handle location selection
    Get.snackbar(
      "Location",
      "Location selection feature will be implemented",
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void onProfilePressed() {
    // Handle profile navigation
    Get.snackbar(
      "Profile",
      "Profile feature will be implemented",
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void onCategoryItemPressed(CategoryItemModel item) {
    // Handle category item selection
    Get.snackbar(
      "Category Selected",
      "Selected: ${item.title.value}",
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
