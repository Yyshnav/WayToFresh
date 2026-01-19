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
}
