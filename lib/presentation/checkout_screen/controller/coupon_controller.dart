import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/coupon_model.dart';

class CouponController extends GetxController {
  final coupons = <Coupon>[].obs;
  final appliedCoupon = Rxn<Coupon>();
  final discountAmount = 0.0.obs;
  final showConfetti = false.obs;

  final TextEditingController searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    loadCoupons();
  }

  void loadCoupons() {
    // Mock data based on the image provided
    coupons.assignAll([
      Coupon(
        code: "TRYNEW",
        title: "TRYNEW",
        description:
            "Use code TRYNEW & get 20% off on orders above ₹699. Maximum discount ₹200",
        discountValue: 20,
        isPercentage: true,
        minOrderValue: 699,
        maxDiscount: 200,
      ),
      Coupon(
        code: "FREED100",
        title: "FREED100",
        description: "Flat ₹100 off on all orders.",
        discountValue: 100,
        isPercentage: false,
        minOrderValue: 0,
      ),
      Coupon(
        code: "SALE50",
        title: "SALE50",
        description:
            "Big Sale - Flat 50% off on everything on orders above ₹1000. Maximum discount ₹550",
        discountValue: 50,
        isPercentage: true,
        minOrderValue: 1000,
        maxDiscount: 550,
      ),
      Coupon(
        code: "NEW50",
        title: "NEW50",
        description:
            "New customer offer - Flat 50% off on everything on orders above ₹299. Maximum discount ₹250",
        discountValue: 50,
        isPercentage: true,
        minOrderValue: 299,
        maxDiscount: 250,
      ),
      Coupon(
        code: "GIFTPROMO4",
        title: "GIFTPROMO4",
        description: "Save 50% off. For any product in grocery store.",
        discountValue: 50,
        isPercentage: true,
        minOrderValue: 0,
        maxDiscount: 500,
      ),
    ]);
  }

  void applyCoupon(BuildContext context, Coupon coupon, double orderValue) {
    if (orderValue < coupon.minOrderValue) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.info_outline, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Coupon Not Applicable",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      "Add items worth ₹${(coupon.minOrderValue - orderValue).toStringAsFixed(2)} more to use this offer.",
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          backgroundColor: Colors.red.shade800,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          duration: const Duration(seconds: 4),
        ),
      );
      return;
    }

    double discount = 0.0;
    if (coupon.isPercentage) {
      discount = (orderValue * coupon.discountValue) / 100;
      if (discount > coupon.maxDiscount) {
        discount = coupon.maxDiscount;
      }
    } else {
      discount = coupon.discountValue;
    }

    // Ensure discount doesn't exceed order value
    if (discount > orderValue) {
      discount = orderValue;
    }

    appliedCoupon.value = coupon;
    discountAmount.value = discount;
    showConfetti.value = true;
    Get.back();
    // Success feedback is provided by confetti animation
  }

  void applyCode(BuildContext context, String code, double orderValue) {
    final coupon = coupons.firstWhereOrNull(
      (c) => c.code == code.toUpperCase(),
    );
    if (coupon != null) {
      applyCoupon(context, coupon, orderValue);
    } else {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Invalid Code",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      "The coupon code you entered is not valid.",
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
          backgroundColor: Colors.red.shade800,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  void removeCoupon() {
    appliedCoupon.value = null;
    discountAmount.value = 0.0;
    Get.snackbar(
      "Removed",
      "Coupon removed successfully",
      backgroundColor: Colors.orange.shade50,
      colorText: Colors.orange,
    );
  }
}
