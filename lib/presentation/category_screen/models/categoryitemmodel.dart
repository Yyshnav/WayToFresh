import 'package:get/get.dart';

/// This class represents a category item in the CategoryScreen

class CategoryItemModel {
  int? id;
  Rx<String> imagePath;
  Rx<String> title;
  Rx<double> imageHeight;
  Rx<double> imageWidth;

  CategoryItemModel({
    this.id,
    required this.imagePath,
    required this.title,
    required this.imageHeight,
    required this.imageWidth,
  });
}
