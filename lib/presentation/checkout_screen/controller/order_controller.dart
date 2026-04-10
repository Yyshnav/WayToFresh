import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:collection/collection.dart';
import 'package:waytofresh/core/network/dio_client.dart';

class OrderController extends GetxController {
  final isPlacingOrder = false.obs;
  final lastOrderId = Rxn<int>();
  final lastOrderTotal = 0.0.obs;
  final estimatedTime = '25 - 35 mins'.obs;
  
  // ✅ Active Order tracking
  final activeOrder = Rxn<Map<String, dynamic>>();

  @override
  void onInit() {
    super.onInit();
    fetchActiveOrder();
  }

  Future<void> fetchActiveOrder() async {
    try {
      final response = await DioClient().dio.get('orders/');
      if (response.statusCode == 200) {
        final List results = response.data['results'] ?? response.data;
        // Find first order that is NOT delivered or cancelled
        final active = results.firstWhereOrNull((o) => 
          !['delivered', 'cancelled'].contains(o['status'])
        );
        activeOrder.value = active;
      }
    } catch (e) {
      debugPrint('Error fetching active order: $e');
    }
  }

  Future<bool> placeOrder({
    required double orderTotal,
    int? addressId,
    String paymentMethod = 'cod',
    String? couponCode,
    String deliveryInstructions = '',
  }) async {
    isPlacingOrder.value = true;
    try {
      final Map<String, dynamic> body = {
        'address_id': addressId, 
        'payment_method': paymentMethod,
        'delivery_instructions': deliveryInstructions,
      };
      if (couponCode != null && couponCode.isNotEmpty) {
        body['coupon_code'] = couponCode;
      }

      final response = await DioClient().dio.post('orders/create/', data: body);

      if (response.statusCode == 201) {
        final data = response.data;
        lastOrderId.value = data['id'];
        lastOrderTotal.value = double.tryParse(data['grand_total']?.toString() ?? '') ?? orderTotal;
        estimatedTime.value = data['estimated_delivery_time'] ?? '25 - 35 mins';
        
        // Refresh active order immediately
        fetchActiveOrder();
        return true;
      }
    } catch (e) {
      debugPrint('Error placing order: $e');
    } finally {
      isPlacingOrder.value = false;
    }
    return false;
  }
}
