import 'package:waytofresh/core/app_expote.dart';

class ProductItemModel {
  Rx<int> id;
  Rx<String> title;
  RxList<String> images;
  Rx<String> deliveryTime;
  Rx<int> price;
  Rx<int> originalPrice;
  Rx<String> unit;
  Rx<String> description;
  Rx<String> shelfLife;
  Rx<String> manufacturerName;
  Rx<int> category;
  Rx<double> rating;
  Rx<int> reviewCount;
  Rx<String> energy;
  Rx<String> size;
  Rx<bool> isVeg;
  Rx<String> filterCategoryName;
  Rx<String> meatType;

  ProductItemModel({
    int? id,
    required String title,
    required List<String> images,
    required String deliveryTime,
    required int price,
    int? originalPrice,
    String? unit,
    String? description,
    String? shelfLife,
    String? manufacturerName,
    int? category,
    double? rating,
    int? reviewCount,
    String? energy,
    String? size,
    bool? isVeg,
    String? filterCategoryName,
    String? meatType,
  }) : id = (id ?? 0).obs,
       title = title.obs,
       images = images.obs,
       deliveryTime = deliveryTime.obs,
       price = price.obs,
       originalPrice = (originalPrice ?? (price * 1.2).toInt()).obs,
       unit = (unit ?? "1 unit").obs,
       description =
           (description ??
                   "100% satisfaction guarantee. If you experience any of the following issues, missing, poor item, late arrival, unprofessional service...")
               .obs,
       shelfLife = (shelfLife ?? "5 days").obs,
       manufacturerName = (manufacturerName ?? "WayToFresh").obs,
       category = (category ?? 0).obs,
       rating = (rating ?? 4.5).obs,
       reviewCount = (reviewCount ?? 12).obs,
       energy = (energy ?? "450 KCal").obs,
       size = (size ?? "Medium").obs,
       isVeg = (isVeg ?? false).obs,
       filterCategoryName = (filterCategoryName ?? "All").obs,
       meatType = (meatType ?? "none").obs;

  factory ProductItemModel.fromMap(Map<String, dynamic> map) {
    try {
      // Robust parsing helpers
      int toInt(dynamic val, int fallback) {
        if (val == null) return fallback;
        if (val is int) return val;
        return double.tryParse(val.toString())?.toInt() ?? fallback;
      }

      double toDouble(dynamic val, double fallback) {
        if (val == null) return fallback;
        if (val is double) return val;
        if (val is int) return val.toDouble();
        return double.tryParse(val.toString()) ?? fallback;
      }

      return ProductItemModel(
        id: toInt(map['id'], 0),
        title: map['name']?.toString() ?? map['title']?.toString() ?? '',
        images: map['images'] != null && (map['images'] as List).isNotEmpty
            ? (map['images'] as List).map((i) => (i['image_url'] ?? i['image'] ?? '').toString()).toList()
            : [map['primary_image'] ?? map['image'] ?? ''],
        deliveryTime: map['delivery_time']?.toString() ?? '25 mins',
        price: toInt(map['price'], 0),
        originalPrice: map['original_price'] != null ? toInt(map['original_price'], 0) : null,
        unit: map['weight']?.toString() ?? map['unit']?.toString(),
        description: map['description']?.toString(),
        shelfLife: map['shelf_life']?.toString(),
        manufacturerName: map['manufacturer_name']?.toString(),
        energy: map['energy']?.toString(),
        size: map['size']?.toString(),
        category: toInt(map['category'], 0),
        rating: toDouble(map['rating'], 4.5),
        reviewCount: toInt(map['review_count'], 0),
        isVeg: map['is_veg'] as bool? ?? false,
        filterCategoryName: map['category_name']?.toString() ?? 'All',
        meatType: map['meat_type']?.toString() ?? 'none',
      );
    } catch (e, stack) {
      print("❌ Error mapping ProductItemModel: $e");
      print("📦 Source Map: $map");
      print("📚 Stack: $stack");
      // Return a minimal valid object to prevent crash
      return ProductItemModel(
        id: 0,
        title: "Error loading product",
        images: [],
        deliveryTime: "",
        price: 0,
      );
    }
  }

  // Helper for backward compatibility or single image access
  String get image => images.isNotEmpty ? images.first : '';
}
