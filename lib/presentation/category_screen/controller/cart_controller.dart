import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waytofresh/core/network/dio_client.dart';

class CartController extends GetxController {
  // Use index-based selection for instant UI highlighting (0, 1, 2...)
  var selectedIndex = 0.obs;
  var cartItems = <int, int>{}.obs; // productId -> quantity
  var cartItemIds = <int, int>{}.obs; // productId -> cartItemId (backend id)
  var cachedProducts = <int, Map<String, dynamic>>{}.obs; // productId -> details for cart

  // Loading states
  var isFirstLoad = true.obs;
  var isLoadingMore = false.obs;

  var selectedPaymentMethod = 'Cash on Delivery'.obs;

  // 1. Dynamic categories from API
  RxList<String> categories = <String>[].obs;
  RxList<int> categoryIds = <int>[].obs;

  // 2. Mapping from static name to backend ID
  RxMap<String, int> categoryNameToIdMatch = <String, int>{}.obs;
  RxList<Map<String, dynamic>> allProducts = <Map<String, dynamic>>[].obs;

  /// Returns the backend ID for the currently selected index
  int get currentCategoryId {
    if (categoryIds.isEmpty || selectedIndex.value >= categoryIds.length) return 1;
    return categoryIds[selectedIndex.value];
  }

  /// Returns the backend ID for the product
  int getOrRegisterProduct(dynamic product) {
    if (product is Map<String, dynamic>) {
      return product['id'] ?? -1;
    } else if (product != null) {
      return product.id.value;
    }
    return -1;
  }

  /// Registers product in cache to ensure details persist in cart even if not in current view
  int registerProduct(dynamic product) {
    int id = getOrRegisterProduct(product);
    if (id != -1 && !cachedProducts.containsKey(id)) {
      if (product is Map<String, dynamic>) {
        cachedProducts[id] = product;
      } else {
        cachedProducts[id] = {
          "id": product.id.value,
          "name": product.title.value,
          "price": (product.price.value).toDouble(),
          "image": product.image,
          "weight": product.unit.value,
          "rating": product.rating.value,
          "description": product.description.value,
          "shelf_life": product.shelfLife.value,
          "manufacturer_name": product.manufacturerName.value,
          "energy": product.energy.value,
          "size": product.size.value,
          "is_veg": product.isVeg.value,
          "category_name": product.filterCategoryName.value,
        };
      }
    }
    return id;
  }

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments is int) {
      selectedIndex.value = Get.arguments;
    }
    
    _initializeData();
    fetchCart();
  }

  Future<void> fetchCart() async {
    try {
      final response = await DioClient().dio.get('cart/');
      if (response.statusCode == 200) {
        _syncCartState(response.data);
      }
    } catch (e) {
      // User might not be logged in or other network error
      debugPrint("Error fetching cart: $e");
    }
  }

  void _syncCartState(dynamic data) {
    if (data == null) return;
    
    // Sync quantities and backend IDs
    final List items = data['items'] ?? [];
    
    // Temporary maps to update state bulkly
    Map<int, int> newCartItems = {};
    Map<int, int> newCartItemIds = {};
    
    for (var item in items) {
      final product = item['product'];
      if (product != null) {
        final int pid = product['id'];
        final int qty = item['quantity'];
        final int iid = item['id'];
        
        newCartItems[pid] = qty;
        newCartItemIds[pid] = iid;
        
        // Ensure product detail is cached for UI consistency
        if (!cachedProducts.containsKey(pid)) {
          registerProduct(product);
        }
      }
    }
    
    cartItems.assignAll(newCartItems);
    cartItemIds.assignAll(newCartItemIds);
  }

  Future<void> _initializeData() async {
    isFirstLoad.value = true;
    try {
      // 1. Fetch Categories
      final catResponse = await DioClient().dio.get('categories/');
      if (catResponse.statusCode == 200) {
        final dynamic data = catResponse.data;
        final List lists = (data is Map && data.containsKey('results')) 
            ? data['results'] 
            : (data is List ? data : []);
            
        categories.clear();
        categoryIds.clear();

        // ✅ Add "All Products" as the first option
        categories.add("All Products");
        categoryIds.add(0);

        for (var c in lists) {
          categories.add(c['name'].toString());
          categoryIds.add(c['id']);
        }
      }

      // 2. Fetch Products for active category
      await _fetchProductsByCategory();
    } catch (e) {
      // Handle error gracefully
    } finally {
      isFirstLoad.value = false;
    }
  }

  Future<void> _fetchProductsByCategory() async {
    try {
      final id = currentCategoryId;
      
      // ✅ If ID is 0 (All Products), don't filter by category on server side
      Map<String, dynamic> params = {};
      if (id != 0) {
        params['category'] = id;
      }

      final prodResponse = await DioClient().dio.get(
        'products/',
        queryParameters: params,
      );
      if (prodResponse.statusCode == 200) {
        var results = prodResponse.data['results'] ?? prodResponse.data;
        allProducts.clear();
        for (var p in results) {
          final int? pid = p['id'];
          if (pid == null) continue; // Skip items without ID

          Map<String, dynamic> mapped = {
            "id": pid,
            "name": p['name'] ?? p['title'] ?? "Product",
            "weight": p['weight'] ?? p['unit'] ?? "1 unit",
            "price": double.tryParse(p['price']?.toString() ?? "0") ?? 0.0,
            "original_price": double.tryParse(p['original_price']?.toString() ?? p['mrp']?.toString() ?? "0"),
            "category": p['category'] ?? id,
            "rating": double.tryParse(p['rating']?.toString() ?? "0") ?? 0.0,
            "review_count": int.tryParse(p['review_count']?.toString() ?? "0") ?? 0,
            "image": p['primary_image'] ?? p['image_url'] ?? p['image'] ?? "",
            "images": p['images'] ?? [p['primary_image'] ?? p['image_url'] ?? p['image'] ?? ""],
            "description": p['description'] ?? "",
            "shelf_life": p['shelf_life'] ?? "",
            "manufacturer_name": p['manufacturer_name'] ?? "",
            "energy": p['energy'] ?? "",
            "size": p['size'] ?? "",
            "is_veg": p['is_veg'] ?? false,
            "category_name": p['category_name'] ?? "",
          };
          allProducts.add(mapped);
          
          // If this item is in cart, update cache detail
          if (cartItems.containsKey(p['id'])) {
            cachedProducts[p['id']] = mapped;
          }
        }
      }
    } catch (e) {
      // Silent error
    }
  }

  Future<void> refreshProducts() async {
    await _initializeData();
  }

  Future<void> loadMoreProducts() async {
    if (isLoadingMore.value) return;
    isLoadingMore.value = true;
    await Future.delayed(const Duration(seconds: 2));
    isLoadingMore.value = false;
  }

  List<Map<String, dynamic>> get filteredProducts {
    final targetId = currentCategoryId;
    // ✅ If ID is 0, return all products without filtering
    if (targetId == 0) return allProducts;
    
    return allProducts
        .where((p) => p["category"] == targetId)
        .toList();
  }

  int get totalCartItems {
    return cartItems.values.fold(0, (sum, quantity) => sum + quantity);
  }

  double get totalCartPrice {
    double total = 0;
    cartItems.forEach((id, quantity) {
      // Find price either in current list or cache
      var prod = allProducts.firstWhereOrNull((p) => p["id"] == id) ?? cachedProducts[id];
      if (prod != null) {
        total += (prod["price"] ?? 0) * quantity;
      }
    });
    return total;
  }

  Future<void> addToCart(int productId) async {
    if (productId == -1) return;
    
    // Optimistic UI update
    cartItems.update(productId, (value) => value + 1, ifAbsent: () => 1);

    try {
      final response = await DioClient().dio.post('cart/add/', data: {
        'product_id': productId,
        'quantity': 1,
      });
      if (response.statusCode == 200) {
        _syncCartState(response.data);
      }
    } catch (e) {
      debugPrint("Error adding to cart: $e");
      // Revert optimistic update on failure if needed, or fetch fresh state
      fetchCart();
    }
  }

  Future<void> removeFromCart(int productId) async {
    if (productId == -1) return;
    if (!cartItems.containsKey(productId)) return;

    final currentQty = cartItems[productId]!;
    final itemId = cartItemIds[productId];

    if (itemId == null) {
      // Fallback: if we don't have the backend item ID, refresh cart first
      await fetchCart();
      return;
    }

    try {
      if (currentQty > 1) {
        // Decrease quantity
        // Optimistic
        cartItems[productId] = currentQty - 1;
        
        final response = await DioClient().dio.patch('cart/items/$itemId/', data: {
          'quantity': currentQty - 1,
        });
        if (response.statusCode == 200) {
          _syncCartState(response.data);
        }
      } else {
        // Remove completely
        // Optimistic
        cartItems.remove(productId);
        cartItemIds.remove(productId);
        
        final response = await DioClient().dio.delete('cart/items/$itemId/');
        if (response.statusCode == 200) {
          _syncCartState(response.data);
        }
      }
    } catch (e) {
      debugPrint("Error removing from cart: $e");
      fetchCart();
    }
  }

  // Use index-based selection (as it was before)
  void setCategory(dynamic index) async {
    if (index == null || index is! int) return;
    selectedIndex.value = index;
    await _fetchProductsByCategory();
  }

  Future<void> clearCart() async {
    try {
      final response = await DioClient().dio.delete('cart/clear/');
      if (response.statusCode == 200) {
        cartItems.clear();
        cartItemIds.clear();
      }
    } catch (e) {
      debugPrint("Error clearing cart: $e");
    }
  }

  // Dynamic Theming Logic
  CategoryTheme get currentTheme {
    if (categories.isEmpty || selectedIndex.value >= categories.length) {
      return categoryThemes[0]!;
    }
    
    String name = categories[selectedIndex.value].toLowerCase();
    
    // Explicit name-based themes
    if (name.contains('vegetable') || name.contains('fruit') || name.contains('all products')) {
      return categoryThemes[0]!; // Green / Fresh
    }
    if (name.contains('snack') || name.contains('drink')) {
      return categoryThemes[1]!; // Orange / Energetic
    }
    if (name.contains('meat') || name.contains('chicken') || name.contains('fish')) {
      return categoryThemes[4]!; // Red / High Protein
    }
    if (name.contains('dairy') || name.contains('milk') || name.contains('bakery')) {
      return categoryThemes[2]!; // Brown / Warm
    }
    if (name.contains('household') || name.contains('pet') || name.contains('baby')) {
      return categoryThemes[3]!; // Blue / Trust
    }

    // Fallback to cycling for variety
    int themeIndex = selectedIndex.value % categoryThemes.length;
    return categoryThemes[themeIndex] ?? categoryThemes[0]!;
  }

  final Map<int, CategoryTheme> categoryThemes = {
    0: CategoryTheme(
      primaryColor: const Color(0xFF2E7D32),
      gradientBegin: const Color(0xFFE8F5E9),
      gradientEnd: const Color(0xFFC8E6C9),
      pattern: BackgroundPattern.leaves,
    ),
    1: CategoryTheme(
      primaryColor: const Color(0xFFE65100),
      gradientBegin: const Color(0xFFFFF3E0),
      gradientEnd: const Color(0xFFFFE0B2),
      pattern: BackgroundPattern.circles,
    ),
    2: CategoryTheme(
      primaryColor: const Color(0xFF795548),
      gradientBegin: const Color(0xFFEFEBE9),
      gradientEnd: const Color(0xFFD7CCC8),
      pattern: BackgroundPattern.waves,
    ),
    3: CategoryTheme(
      primaryColor: const Color(0xFF1565C0),
      gradientBegin: const Color(0xFFE3F2FD),
      gradientEnd: const Color(0xFFBBDEFB),
      pattern: BackgroundPattern.waves,
    ),
    4: CategoryTheme(
      primaryColor: const Color(0xFFC62828),
      gradientBegin: const Color(0xFFFFEBEE),
      gradientEnd: const Color(0xFFFFCDD2),
      pattern: BackgroundPattern.circles,
    ),
    5: CategoryTheme(
      primaryColor: const Color(0xFFAD1457),
      gradientBegin: const Color(0xFFFCE4EC),
      gradientEnd: const Color(0xFFF8BBD0),
      pattern: BackgroundPattern.leaves,
    ),
  };
}

enum BackgroundPattern { none, circles, waves, leaves }

class CategoryTheme {
  final Color primaryColor;
  final Color gradientBegin;
  final Color gradientEnd;
  final BackgroundPattern pattern;

  CategoryTheme({
    required this.primaryColor,
    required this.gradientBegin,
    required this.gradientEnd,
    this.pattern = BackgroundPattern.none,
  });

  // Helper for compatibility if needed, using primary color as list
  List<Color> get gradientColors => [gradientBegin, gradientEnd];
}
