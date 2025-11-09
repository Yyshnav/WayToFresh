import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:waytofresh/presentation/category_screen/models/categoryitemmodel.dart';


import 'grocery_category_item_model.dart';
import 'product_item_model.dart';

class HomeModel {
  Rx<String>? searchText;
  RxList<CategoryItemModel>? categoryItems;
  RxList<ProductItemModel>? productItems;
  RxList<GroceryCategoryItemModel>? groceryCategories;

  HomeModel({
    this.searchText,
    this.categoryItems,
    this.productItems,
    this.groceryCategories,
  }) {
    searchText = searchText ?? Rx("");
    categoryItems = categoryItems ?? RxList([]);
    productItems = productItems ?? RxList([]);
    groceryCategories = groceryCategories ?? RxList([]);
  }
}
