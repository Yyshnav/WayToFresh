
import 'package:get/get.dart';

class CategoryItemModel {
  Rx<String> title;
  Rx<String> image;

  CategoryItemModel({
    required String title,
    required String image,
  })  : title = title.obs,
        image = image.obs;
}
