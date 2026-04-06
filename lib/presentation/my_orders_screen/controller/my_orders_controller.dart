import 'package:get/get.dart';
import '../models/order_item_model.dart';

class MyOrdersController extends GetxController {
  RxList<OrderItemModel> orders = <OrderItemModel>[].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadMockOrders();
  }

  void _loadMockOrders() {
    isLoading.value = true;
    // Simulate API delay
    Future.delayed(const Duration(milliseconds: 800), () {
      orders.value = [
        OrderItemModel(
          id: "#WF-58421",
          date: DateTime.now().subtract(const Duration(hours: 2)),
          itemNames: ["Fresh Milk", "Brown Bread", "Lays Spicy"],
          totalAmount: 185.0,
          status: OrderStatus.onTheWay,
        ),
        OrderItemModel(
          id: "#WF-58310",
          date: DateTime.now().subtract(const Duration(days: 1)),
          itemNames: ["Farm Eggs", "Salted Butter"],
          totalAmount: 145.0,
          status: OrderStatus.delivered,
        ),
        OrderItemModel(
          id: "#WF-58201",
          date: DateTime.now().subtract(const Duration(days: 3)),
          itemNames: ["Coca Cola", "Kurkure Masala", "Dairy Milk Silk"],
          totalAmount: 220.0,
          status: OrderStatus.delivered,
        ),
      ];
      isLoading.value = false;
    });
  }

  void onOrderTap(OrderItemModel order) {
    // Navigate to tracking or details
    print("Tapped order ${order.id}");
  }
}
