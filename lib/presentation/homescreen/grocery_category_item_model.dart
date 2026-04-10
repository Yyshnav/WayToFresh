
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class GroceryCategoryItemModel {
  int? id;
  Rx<String> title;
  Rx<String> image;
  Rx<double> imageHeight;
  Rx<double> imageWidth;

  GroceryCategoryItemModel({
    this.id,
    required String title,
    required String image,
    required double imageHeight,
    required double imageWidth,
  })  : title = title.obs,
        image = image.obs,
        imageHeight = imageHeight.obs,
        imageWidth = imageWidth.obs;
}
