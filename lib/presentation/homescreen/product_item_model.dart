import 'package:waytofresh/core/app_expote.dart';

class ProductItemModel {
  Rx<String> title;
  RxList<String> images;
  Rx<String> deliveryTime;
  Rx<int> price;
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

  ProductItemModel({
    required String title,
    required List<String> images,
    required String deliveryTime,
    required int price,
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
  }) : title = title.obs,
       images = images.obs,
       deliveryTime = deliveryTime.obs,
       price = price.obs,
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
       filterCategoryName = (filterCategoryName ?? "All").obs;

  factory ProductItemModel.fromMap(Map<String, dynamic> map) {
    return ProductItemModel(
      title: map['name'] ?? '',
      images: [map['image'] ?? ''],
      deliveryTime: map['deliveryTime'] ?? '25 mins',
      price: (map['price'] as num?)?.toInt() ?? 0,
      unit: map['weight'],
      description: map['description'],
      shelfLife: map['shelfLife'],
      manufacturerName: map['manufacturerName'],
      category: map['category'],
      isVeg: map['isVeg'] as bool? ?? false,
      filterCategoryName: map['categoryName'] as String? ?? 'All',
    );
  }

  // Helper for backward compatibility or single image access
  String get image => images.isNotEmpty ? images.first : '';
}
