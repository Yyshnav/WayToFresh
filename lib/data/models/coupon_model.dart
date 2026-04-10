class Coupon {
  final String code;
  final String title;
  final String description;
  final double discountValue; // Can be percentage or flat amount
  final bool isPercentage;
  final double minOrderValue;
  final double maxDiscount; // For percentage coupons

  Coupon({
    required this.code,
    required this.title,
    required this.description,
    required this.discountValue,
    required this.isPercentage,
    required this.minOrderValue,
    this.maxDiscount = double.infinity,
  });

  factory Coupon.fromMap(Map<String, dynamic> map) {
    return Coupon(
      code: map['code'] ?? '',
      title: map['title'] ?? map['code'] ?? '',
      description: map['description'] ?? '',
      discountValue: double.tryParse(map['discount_value'].toString()) ?? 0.0,
      isPercentage: map['is_percentage'] ?? true,
      minOrderValue: double.tryParse(map['min_order_value'].toString()) ?? 0.0,
      maxDiscount: double.tryParse(map['max_discount']?.toString() ?? '') ?? double.infinity,
    );
  }
}
