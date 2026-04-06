

enum OrderStatus {
  placed,
  preparing,
  onTheWay,
  delivered,
  cancelled
}

class OrderItemModel {
  final String id;
  final DateTime date;
  final List<String> itemNames;
  final double totalAmount;
  final OrderStatus status;

  OrderItemModel({
    required this.id,
    required this.date,
    required this.itemNames,
    required this.totalAmount,
    required this.status,
  });

  String get statusText {
    switch (status) {
      case OrderStatus.placed: return "Order Placed";
      case OrderStatus.preparing: return "Preparing";
      case OrderStatus.onTheWay: return "On the way";
      case OrderStatus.delivered: return "Delivered";
      case OrderStatus.cancelled: return "Cancelled";
    }
  }
}
