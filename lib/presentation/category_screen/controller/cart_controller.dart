import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartController extends GetxController {
  var selectedIndex = 0.obs;
  var cartItems = <int, int>{}.obs; // productIndex -> quantity

  // Loading states
  var isFirstLoad = true.obs;
  var isLoadingMore = false.obs;

  var selectedPaymentMethod = 'Cash on Delivery'.obs;

  final List<String> categories = [
    "Vegetables & Fruits",
    "Chips & Namkeen",
    "Bakery & Snacks",
    "Dairy, Bread & Eggs",
    "Drinks & Juices",
    "Sweets & Chocolates",
  ];

  final List<Map<String, dynamic>> allProducts = [
    {
      "name": "Organic Onion",
      "weight": "1 kg",
      "price": 33,
      "category": 0,
      "rating": 4.5,
      "image": "assets/images/onion.jpg",
    },
    {
      "name": "Fresh Tomato",
      "weight": "1 kg",
      "price": 25,
      "category": 0,
      "rating": 4.2,
      "image": "assets/images/tomato.png",
    },
    {
      "name": "Green Capsicum",
      "weight": "500 g",
      "price": 40,
      "category": 0,
      "rating": 4.7,
      "image": "assets/images/image 41.png", // Placeholder
    },
    {
      "name": "Fresh Carrot",
      "weight": "1 kg",
      "price": 45,
      "category": 0,
      "rating": 4.3,
      "image": "assets/images/image 42.png", // Placeholder
    },
    {
      "name": "Broccoli",
      "weight": "1 pc",
      "price": 35,
      "category": 0,
      "rating": 4.6,
      "image": "assets/images/brocoli.jpg",
    },
    {
      "name": "Apple",
      "weight": "1 kg",
      "price": 120,
      "category": 0,
      "rating": 4.8,
      "image": "assets/images/image 21.png", // Placeholder
    },
    {
      "name": "Banana",
      "weight": "1 dozen",
      "price": 40,
      "category": 0,
      "rating": 4.1,
      "image": "assets/images/image 22.png", // Placeholder
    },
    {
      "name": "Orange",
      "weight": "1 kg",
      "price": 80,
      "category": 0,
      "rating": 4.5,
      "image": "assets/images/image 23.png", // Placeholder
    },
    {
      "name": "Avocado",
      "weight": "1 pc",
      "price": 60,
      "category": 0,
      "rating": 4.6,
      "image": "assets/images/image 24.png",
    },
    {
      "name": "Dragon Fruit",
      "weight": "1 pc",
      "price": 90,
      "category": 0,
      "rating": 4.4,
      "image": "assets/images/image 25.png",
    },
    {
      "name": "Kiwi",
      "weight": "3 pcs",
      "price": 75,
      "category": 0,
      "rating": 4.3,
      "image": "assets/images/image 31.png",
    },
    {
      "name": "Fresh Cuts Mix",
      "weight": "250 g",
      "price": 55,
      "category": 0,
      "rating": 4.2,
      "image": "assets/images/image 32.png", // Placeholder
    },
    {
      "name": "Spinach",
      "weight": "200 g",
      "price": 20,
      "category": 0,
      "rating": 4.5,
      "image": "assets/images/image 33.png", // Placeholder
    },
    {
      "name": "Organic Lettuce",
      "weight": "1 pc",
      "price": 30,
      "category": 0,
      "rating": 4.7,
      "image": "assets/images/image 34.png", // Placeholder
    },
    // Adding some mock items for other categories so they aren't empty
    {
      "name": "Lay's Classic",
      "weight": "50 g",
      "price": 20,
      "category": 1,
      "rating": 4.5,
      "image": "assets/images/lays.png",
    },
    {
      "name": "Brittania Cake",
      "weight": "1 pc",
      "price": 30,
      "category": 2,
      "rating": 4.0,
      "image": "assets/images/biscut1.png",
    },
    // Home Items
    {
      "name": "Golden Glass \nWooden Lid Candle (Oudh)",
      "weight": "1 pc",
      "price": 79,
      "category": 99,
      "rating": 4.8,
      "image":
          "assets/images/image 54.png", // Ensure this matches ImageConstant path logic or use placeholder
    },
    {
      "name": "Royal Gulab Jamun \nBy Bikano",
      "weight": "1 kg",
      "price": 79,
      "category": 99,
      "rating": 4.5,
      "image": "assets/images/image 57.png",
    },
    {
      "name": "Bikaji Bhujia",
      "weight": "400 g",
      "price": 79,
      "category": 99,
      "rating": 4.4,
      "image": "assets/images/image 54.png",
    },
    // Meat Screen Items (Category 6)
    {
      "name": "One Pot Biryani!",
      "weight": "1 Portion",
      "price": 350, // estimated
      "category": 6,
      "rating": 4.8,
      "image": "assets/images/meat.jpg",
      "description":
          "Chicken biryani is a quick version of the classic authentic biryani.",
    },
    {
      "name": "Boneless Chicken Breast",
      "weight": "1 kg",
      "price":
          12.99, // Keeping value as number, display formatting handles currency
      "category": 6,
      "rating": 4.8,
      "image": "assets/images/meat.jpg",
      "description":
          "Skinless, premium quality chicken breast - perfect for grilling, baking, or stir-fry.",
    },
    {
      "name": "Say Crispy!",
      "weight": "1 Portion",
      "price": 250,
      "category": 6,
      "rating": 4.5,
      "image": "assets/images/meat.jpg",
      "description":
          "Chicken pieces that have been coated with seasoned flour and pan-fried.",
    },
    {
      "name": "Grass-Fed Beef Steak",
      "weight": "1 kg",
      "price": 24.99,
      "category": 6,
      "rating": 4.9,
      "image": "assets/images/meat.jpg",
      "description":
          "100% grass-fed beef steak, aged to perfection. Tender and juicy cuts.",
    },
    {
      "name": "Fresh Lamb Chops",
      "weight": "1 kg",
      "price": 18.99,
      "category": 6,
      "rating": 4.7,
      "image": "assets/images/meat.jpg",
      "description":
          "Tender lamb chops, perfectly trimmed. Ideal for roasting or grilling.",
    },
    {
      "name": "Atlantic Salmon Fillets",
      "weight": "1 kg",
      "price": 16.99,
      "category": 6,
      "rating": 4.6,
      "image": "assets/images/meat.jpg",
      "description":
          "Fresh Atlantic salmon fillets rich in omega-3 fatty acids.",
    },
    {
      "name": "Baby Back Pork Ribs",
      "weight": "1 kg",
      "price": 14.99,
      "category": 6,
      "rating": 4.5,
      "image": "assets/images/meat.jpg",
      "description": "Tender pork ribs ready for slow cooking or BBQ grilling.",
    },
    {
      "name": "Chicken Drumsticks",
      "weight": "1 kg",
      "price": 8.99,
      "category": 6,
      "rating": 4.6,
      "image": "assets/images/meat.jpg",
      "description": "Juicy chicken drumsticks, perfect for frying or baking.",
    },
    {
      "name": "Lean Ground Beef",
      "weight": "1 kg",
      "price": 10.99,
      "category": 6,
      "rating": 4.7,
      "image": "assets/images/meat.jpg",
      "description":
          "Versatile lean ground beef for burgers, tacos, and sauces.",
    },
    {
      "name": "Pork Chops",
      "weight": "500 g",
      "price": 9.99,
      "category": 6,
      "rating": 4.5,
      "image": "assets/images/meat.jpg",
      "description": "Thick-cut pork chops, tender and flavor-packed.",
    },
    {
      "name": "Turkey Breast",
      "weight": "1 kg",
      "price": 13.99,
      "category": 6,
      "rating": 4.8,
      "image": "assets/images/meat.jpg",
      "description": "Lean and healthy turkey breast, great for roasting.",
    },
  ];

  /// Finds product by name, or adds it if not found. Returns index.
  int getOrRegisterProduct(dynamic product) {
    String name = "";
    double price = 0.0;
    String image = "";

    // Handle both Map and ProductItemModel for flexibility
    if (product is Map<String, dynamic>) {
      name = product['name'] ?? "";
      price = (product['price'] ?? 0).toDouble();
      image = product['image'] ?? "";
    } else {
      // Assuming ProductItemModel has .title.value, .price.value, .image
      name = product.title.value;
      price = (product.price.value ?? 0).toDouble();
      image = product.image ?? "";
    }

    String searchName = name.replaceAll('\n', ' ').trim();
    int index = allProducts.indexWhere(
      (p) => (p['name'] as String).replaceAll('\n', ' ').trim() == searchName,
    );

    if (index == -1) {
      allProducts.add({
        "name": name,
        "price": price,
        "image": image,
        "category": 99, // General/Other
        "weight": "1 unit",
        "rating": 4.0,
      });
      index = allProducts.length - 1;
    }
    return index;
  }

  @override
  void onInit() {
    super.onInit();
    // Check if arguments were passed (e.g., from Home Best Sellers)
    if (Get.arguments != null && Get.arguments is int) {
      selectedIndex.value = Get.arguments;
    }
    // Simulate initial loading
    _simulateInitialLoad();
  }

  void _simulateInitialLoad() async {
    isFirstLoad.value = true;
    await Future.delayed(const Duration(seconds: 2));
    isFirstLoad.value = false;
  }

  Future<void> refreshProducts() async {
    await Future.delayed(const Duration(seconds: 2));
    // In a real app, refresh logic
  }

  Future<void> loadMoreProducts() async {
    if (isLoadingMore.value) return;
    isLoadingMore.value = true;
    await Future.delayed(const Duration(seconds: 2));
    isLoadingMore.value = false;
  }

  List<Map<String, dynamic>> get filteredProducts {
    return allProducts
        .where((p) => p["category"] == selectedIndex.value)
        .toList();
  }

  int get totalCartItems {
    return cartItems.values.fold(0, (sum, quantity) => sum + quantity);
  }

  double get totalCartPrice {
    double total = 0;
    cartItems.forEach((index, quantity) {
      total += allProducts[index]["price"] * quantity;
    });
    return total;
  }

  void addToCart(int productIndex) {
    cartItems.update(productIndex, (value) => value + 1, ifAbsent: () => 1);
  }

  void removeFromCart(int productIndex) {
    if (cartItems.containsKey(productIndex)) {
      if (cartItems[productIndex]! > 1) {
        cartItems[productIndex] = cartItems[productIndex]! - 1;
      } else {
        cartItems.remove(productIndex);
      }
    }
  }

  void setCategory(int index) {
    selectedIndex.value = index;
  }

  void clearCart() {
    cartItems.clear();
  }

  // Dynamic Theming Logic
  CategoryTheme get currentTheme =>
      categoryThemes[selectedIndex.value] ?? categoryThemes[0]!;

  final Map<int, CategoryTheme> categoryThemes = {
    0: CategoryTheme(
      // Vegetables - Organic Green
      primaryColor: const Color(0xFF2E7D32),
      gradientBegin: const Color(0xFFE8F5E9),
      gradientEnd: const Color(0xFFC8E6C9),
      pattern: BackgroundPattern.leaves,
    ),
    1: CategoryTheme(
      // Chips - Energetic Orange
      primaryColor: const Color(0xFFE65100),
      gradientBegin: const Color(0xFFFFF3E0),
      gradientEnd: const Color(0xFFFFE0B2),
      pattern: BackgroundPattern.circles,
    ),
    2: CategoryTheme(
      // Bakery - Warm Brown
      primaryColor: const Color(0xFF795548),
      gradientBegin: const Color(0xFFEFEBE9),
      gradientEnd: const Color(0xFFD7CCC8),
      pattern: BackgroundPattern.waves,
    ),
    3: CategoryTheme(
      // Dairy - Fluid Blue
      primaryColor: const Color(0xFF1565C0),
      gradientBegin: const Color(0xFFE3F2FD),
      gradientEnd: const Color(0xFFBBDEFB),
      pattern: BackgroundPattern.waves,
    ),
    4: CategoryTheme(
      // Drinks - Vibrant Red
      primaryColor: const Color(0xFFC62828),
      gradientBegin: const Color(0xFFFFEBEE),
      gradientEnd: const Color(0xFFFFCDD2),
      pattern: BackgroundPattern.circles,
    ),
    5: CategoryTheme(
      // Sweets - Playful Pink
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
