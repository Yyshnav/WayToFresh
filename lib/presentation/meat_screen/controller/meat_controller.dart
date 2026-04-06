import 'package:get/get.dart';
import '../../homescreen/product_item_model.dart';
import 'package:waytofresh/core/utils/image_constants.dart';

class MeatController extends GetxController {
  RxBool showOnboarding = true.obs;
  RxString selectedCategory = "All meats".obs;
  RxInt selectedBottomTab = 0.obs;

  final List<String> categories = ["All meats", "Wagyu", "Tenderloin", "Sirloin", "Ribs", "Lamb", "Chicken"];

  final List<String> bannerImages = [
    ImageConstant.imgMeatHero,
    ImageConstant.imgMeatDeals,
    ImageConstant.imgRawWagyu,
  ];

  RxList<ProductItemModel> meatProducts = <ProductItemModel>[
    ProductItemModel(
      title: "Premium Wagyu",
      images: [ImageConstant.imgRawWagyu],
      price: 120,
      deliveryTime: "20 MINS",
      description: "Highly marbled raw Wagyu beef, tender and flavorful.",
      size: "1 kg",
      unit: "Premium Cut",
    ),
    ProductItemModel(
      title: "Beef Tenderloin",
      images: [ImageConstant.imgRawTenderloin],
      price: 85,
      deliveryTime: "15 MINS",
      description: "Lean and tender beef cut, perfect for steaks.",
      size: "500 g",
      unit: "Fresh Cut",
    ),
    ProductItemModel(
      title: "Beef Ribs",
      images: [ImageConstant.imgRawRibs],
      price: 95,
      deliveryTime: "30 MINS",
      description: "Prime beef short ribs, perfect for slow cooking.",
      size: "1 kg",
      unit: "Bone-in Cut",
    ),
    ProductItemModel(
      title: "Lamb Chops",
      images: [ImageConstant.imgRawLamb],
      price: 75,
      deliveryTime: "20 MINS",
      description: "Succulent raw lamb chops.",
      size: "500 g",
      unit: "Curry Cut",
    ),
    ProductItemModel(
      title: "Sirloin Steak",
      images: [ImageConstant.imgRawTenderloin], // Placeholder
      price: 65,
      deliveryTime: "18 MINS",
      description: "Firm and flavorful sirloin cut.",
      size: "500 g",
      unit: "Boneless",
    ),
    ProductItemModel(
      title: "Fresh Ribs",
      images: [ImageConstant.imgRawRibs],
      price: 55,
      deliveryTime: "25 MINS",
      description: "High-quality pork ribs.",
      size: "1 kg",
      unit: "Prime Cut",
    ),
    ProductItemModel(
      title: "Chicken Breast",
      images: [ImageConstant.imgRawLamb], // Placeholder
      price: 45,
      deliveryTime: "15 MINS",
      description: "Lean and healthy chicken breast.",
      size: "1 kg",
      unit: "Skinless",
    ),
    ProductItemModel(
      title: "Lamb Leg",
      images: [ImageConstant.imgRawLamb],
      price: 110,
      deliveryTime: "35 MINS",
      description: "Juicy and tender whole lamb leg.",
      size: "2 kg",
      unit: "Whole Leg",
    ),
  ].obs;

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
      // For simplicity, I'll filter by title content since my models don't have a species field yet
      // In a real app, this would be a specific field.
      if (selectedBottomTab.value == 0) return !p.title.value.toLowerCase().contains("chicken") && !p.title.value.toLowerCase().contains("lamb");
      if (selectedBottomTab.value == 1) return p.title.value.toLowerCase().contains("chicken");
      if (selectedBottomTab.value == 2) return p.title.value.toLowerCase().contains("lamb") || p.title.value.toLowerCase().contains("mutton");
      return true;
    }).toList();
  }
}
