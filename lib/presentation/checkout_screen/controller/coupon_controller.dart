import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../data/models/coupon_model.dart';
import '../../../core/network/dio_client.dart';
import 'package:dio/dio.dart';
import '../../../core/utils/toast_helper.dart';

class CouponController extends GetxController {
  final coupons = <Coupon>[].obs;
  final appliedCoupon = Rxn<Coupon>();
  final discountAmount = 0.0.obs;
  final showConfetti = false.obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  final TextEditingController searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    loadCoupons();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  Future<void> loadCoupons() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final response = await DioClient().dio.get('coupons/');
      if (response.statusCode == 200) {
        final List data = response.data['results'] ?? response.data;
        coupons.assignAll(data.map((c) => Coupon.fromMap(c)).toList());
      }
    } catch (e) {
      debugPrint('Error loading coupons: $e');
      errorMessage.value = 'Could not load coupons. Please try again.';
      // Graceful fallback to empty list; CouponScreen will show error state
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> applyCoupon(BuildContext context, Coupon coupon, double orderValue) async {
    await applyCode(context, coupon.code, orderValue);
  }

  Future<void> applyCode(BuildContext context, String code, double orderValue) async {
    if (code.isEmpty) return;
    
    isLoading.value = true;
    try {
      final response = await DioClient().dio.post('coupons/apply/', data: {
        'code': code.toUpperCase(),
        'order_value': orderValue,
      });

      if (response.statusCode == 200) {
        final data = response.data;
        // Find the coupon in our list to keep the full model if possible, 
        // or create a minimal one from response
        Coupon? coupon = coupons.firstWhereOrNull((c) => c.code == data['code']);
        coupon ??= Coupon(
          code: data['code'],
          title: data['title'] ?? data['code'],
          description: '',
          discountValue: double.tryParse(data['discount_amount'].toString()) ?? 0.0,
          isPercentage: false, // Server already calculated the flat discount
          minOrderValue: 0,
        );

        appliedCoupon.value = coupon;
        discountAmount.value = double.tryParse(data['discount_amount'].toString()) ?? 0.0;
        showConfetti.value = true;
        
        ToastHelper.showSuccess("Coupon '${coupon.code}' applied successfully!");
        Get.back();
      }
    } catch (e) {
      debugPrint('Error applying coupon: $e');
      String errorMsg = "Invalid or expired coupon code.";
      
      if (e is DioException && e.response != null && e.response?.data is Map) {
        errorMsg = (e.response?.data as Map)['error'] ?? errorMsg;
      }

      if (context.mounted) {
        ToastHelper.showError(errorMsg);
      }
    } finally {
      isLoading.value = false;
    }
  }

  void removeCoupon(BuildContext context) {
    appliedCoupon.value = null;
    discountAmount.value = 0.0;
    ToastHelper.showInfo("Coupon removed successfully");
  }
}
