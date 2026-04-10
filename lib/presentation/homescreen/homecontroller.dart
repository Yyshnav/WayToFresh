import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waytofresh/presentation/category_screen/models/categoryitemmodel.dart';
import 'package:waytofresh/presentation/homescreen/grocery_category_item_model.dart';
import 'package:waytofresh/presentation/homescreen/home_model.dart';
import 'package:waytofresh/presentation/homescreen/product_item_model.dart';
import 'package:waytofresh/routes/app_routes.dart';
import 'package:waytofresh/core/network/dio_client.dart';
import 'package:waytofresh/presentation/category_screen/controller/cart_controller.dart';

class HomeController extends GetxController {
  late TextEditingController searchController;
  Rx<HomeModel> homeModelObj = HomeModel().obs;

  // ✅ Added for bottom bar hide/show animation
  RxBool hideBottomBar = false.obs;
  bool hasShownAddressSheet = false;

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
    initializeData();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  Future<void> initializeData() async {
    try {
      final response = await DioClient().dio.get('home/');
      if (response.statusCode == 200) {
        final data = response.data;
        
        // Parse Banners
        if (data['banners'] != null) {
          bannerImages.assignAll((data['banners'] as List)
              .map((b) => b['image_url'].toString())
              .toList());
        }

        // Parse Categories
        if (data['categories'] != null) {
          categoryItems.assignAll((data['categories'] as List).map((c) {
            return CategoryItemModel(
              id: c['id'],
              title: (c['name'] ?? '').toString().obs,
              imagePath: (c['image_url'] ?? '').toString().obs,
              imageHeight: 80.0.obs,
              imageWidth: 80.0.obs,
            );
          }).toList());
        }

        // Parse Daily Essentials
        if (data['daily_essentials'] != null) {
          dailyEssentials.assignAll((data['daily_essentials'] as List)
              .map((p) => ProductItemModel.fromMap(p))
              .toList());
        }

        // Parse Trending Products
        if (data['trending_products'] != null) {
          trendingProducts.assignAll((data['trending_products'] as List)
              .map((p) => ProductItemModel.fromMap(p))
              .toList());
        }

        // Parse Gold Promotions into productItems
        if (data['gold_promotions'] != null) {
          productItems.assignAll((data['gold_promotions'] as List)
              .map((p) => ProductItemModel.fromMap(p))
              .toList());
        }

        // If none of the sections have products (e.g. admin added but forgot flags),
        // fallback to fetching ALL active products
        if (dailyEssentials.isEmpty && trendingProducts.isEmpty) {
          try {
            final allResp = await DioClient().dio.get('products/');
            if (allResp.statusCode == 200) {
              final results = allResp.data['results'] as List? ?? allResp.data as List? ?? [];
              dailyEssentials.assignAll(results.map((p) => ProductItemModel.fromMap(p)).toList());
            }
          } catch (_) {}
        }
      }
    } catch (e) {
      if (e is num) {
        // Fallback or handle error
      }
    }
  }

  void onSearchChanged(String value) {
    homeModelObj.value.searchText?.value = value;
    // Implement search functionality here
  }

  void onCategoryTap(CategoryItemModel category) {
    Get.toNamed(AppRoutes.categoryScreen);
  }

  void onProductAddTap(ProductItemModel product) {
    try {
      final cartController = Get.find<CartController>();
      cartController.addToCart(product.id.value);
      
      Get.snackbar(
        'Product Added',
        '${product.title.value} added to cart',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      debugPrint("Error adding to cart from home: $e");
    }
  }

  void onGroceryCategoryTap(GroceryCategoryItemModel category) {
    Get.toNamed(AppRoutes.categoryScreen);
  }
}
