import 'package:waytofresh/core/app_expote.dart';


class ProductItemModel {
  Rx<String> title;
  Rx<String> image;
  Rx<String> deliveryTime;
  Rx<int> price;

  ProductItemModel({
    required String title,
    required String image,
    required String deliveryTime,
    required int price,
  })  : title = title.obs,
        image = image.obs,
        deliveryTime = deliveryTime.obs,
        price = price.obs;
}
