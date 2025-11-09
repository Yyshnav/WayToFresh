import 'package:get/get.dart';

/// This class is used in the [CategoryScreen] screen with GetX.

class CategoryModel {
  Rx<String>? searchText;
  Rx<String>? deliveryLocation;
  Rx<String>? deliveryTime;

  CategoryModel({
    this.searchText,
    this.deliveryLocation,
    this.deliveryTime,
  }) {
    searchText = searchText ?? Rx("");
    deliveryLocation =
        deliveryLocation ?? Rx("Sujal Dave, Ratanada, Jodhpur (Raj)");
    deliveryTime = deliveryTime ?? Rx("16 minutes");
  }
}
