import 'dart:async';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:waytofresh/core/network/dio_client.dart';
import 'package:waytofresh/presentation/checkout_screen/controller/order_controller.dart';
import '../../../core/controllers/notification_controller.dart';

enum OrderStatus { placed, shopConfirmed, preparing, packed, riderAssigned, riderPickedUp, outForDelivery, near, delivered }

class OrderTrackingController extends GetxController {
  // ✅ Observables
  final Rxn<int> orderId = Rxn<int>();
  final Rx<OrderStatus> currentStatus = OrderStatus.placed.obs;
  final Rx<LatLng> deliveryBoyLocation = const LatLng(18.5204, 73.8567).obs; 
  final Rx<LatLng> destinationLocation = const LatLng(18.5204, 73.8567).obs;
  final RxDouble distanceRemaining = 0.0.obs;
  final RxString estimatedTime = "--".obs;
  final RxString deliveryInstructions = "".obs;
  final RxString riderName = "".obs;
  final RxString riderPhone = "".obs;
  final RxString customerName = "".obs;
  final RxString customerPhone = "".obs;
  final RxString deliveryAddress = "".obs;
  final RxString itemsSummary = "".obs;
  final RxDouble grandTotal = 0.0.obs;
  final RxBool isLoading = false.obs;
  
  // ✅ Input Controller
  final TextEditingController instructionsController = TextEditingController();

  final NotificationController _notifController = Get.find<NotificationController>();

  Timer? _pollingTimer;
  OrderStatus? _lastNotifiedStatus;

  @override
  void onInit() {
    super.onInit();
    // Get Order ID from arguments if available
    if (Get.arguments is int) {
      orderId.value = Get.arguments;
    } else {
      // Fallback: Check OrderController
      try {
        final orderController = Get.find<OrderController>();
        orderId.value = orderController.lastOrderId.value;
      } catch (e) {
        debugPrint("Order ID not found for tracking");
      }
    }

    instructionsController.addListener(() {
      deliveryInstructions.value = instructionsController.text;
    });

    if (orderId.value != null) {
      startTracking();
    }
  }

  void startTracking() {
    _pollingTimer?.cancel();
    fetchTrackingData(); // Initial fetch
    _pollingTimer = Timer.periodic(const Duration(seconds: 5), (_) => fetchTrackingData());
  }

  Future<void> fetchTrackingData() async {
    if (orderId.value == null) return;
    
    try {
      final response = await DioClient().dio.get('orders/${orderId.value}/track/');
      if (response.statusCode == 200) {
        final data = response.data;
        
        // 1. Update Status
        final String statusStr = data['status'];
        final OrderStatus? status = _mapStringToStatus(statusStr);
        if (status != null && status != currentStatus.value) {
          currentStatus.value = status;
          _handleStatusNotifications(status);
        }

        // 2. Update Rider Info
        riderName.value = data['rider_name'] ?? '';
        riderPhone.value = data['rider_phone'] ?? '';
        
        if (data['rider_location'] != null) {
          final lat = double.tryParse(data['rider_location']['latitude']?.toString() ?? '');
          final lng = double.tryParse(data['rider_location']['longitude']?.toString() ?? '');
          if (lat != null && lng != null) {
            deliveryBoyLocation.value = LatLng(lat, lng);
            // In a real app, distanceRemaining would be calculated here
            distanceRemaining.value = 1.2; 
          }
        }

        // 3. Update Destination Info
        if (data['destination_location'] != null) {
          final dLat = double.tryParse(data['destination_location']['latitude']?.toString() ?? '');
          final dLng = double.tryParse(data['destination_location']['longitude']?.toString() ?? '');
          if (dLat != null && dLng != null) {
            destinationLocation.value = LatLng(dLat, dLng);
          }
        }

        // 4. Update Other fields
        customerName.value = data['customer_name'] ?? '';
        customerPhone.value = data['customer_phone'] ?? '';
        deliveryAddress.value = data['delivery_address'] ?? '';
        itemsSummary.value = data['items_summary'] ?? '';
        grandTotal.value = double.tryParse(data['grand_total']?.toString() ?? '') ?? 0.0;
        estimatedTime.value = data['estimated_delivery_time'] ?? '--';
        deliveryInstructions.value = data['delivery_instructions'] ?? '';
        if (instructionsController.text.isEmpty) {
          instructionsController.text = deliveryInstructions.value;
        }
      }
    } catch (e) {
      debugPrint("Error fetching tracking data: $e");
    }
  }

  OrderStatus? _mapStringToStatus(String statusStr) {
    switch (statusStr) {
      case 'placed': return OrderStatus.placed;
      case 'shop_confirmed': return OrderStatus.shopConfirmed;
      case 'preparing': return OrderStatus.preparing;
      case 'packed': return OrderStatus.packed;
      case 'rider_assigned': return OrderStatus.riderAssigned;
      case 'rider_picked_up': return OrderStatus.riderPickedUp;
      case 'out_for_delivery': return OrderStatus.outForDelivery;
      case 'near': return OrderStatus.near;
      case 'delivered': return OrderStatus.delivered;
      default: return null;
    }
  }

  void _handleStatusNotifications(OrderStatus status) {
    if (status == _lastNotifiedStatus) return;
    
    switch (status) {
      case OrderStatus.shopConfirmed: _notifController.notifyShopConfirmed(); break;
      case OrderStatus.preparing: _notifController.notifyPreparing(); break;
      case OrderStatus.packed: _notifController.notifyPacked(); break;
      case OrderStatus.riderAssigned: _notifController.notifyRiderAssigned(); break;
      case OrderStatus.riderPickedUp: _notifController.notifyRiderPickedUp(); break;
      case OrderStatus.outForDelivery: _notifController.notifyOutForDelivery(); break;
      case OrderStatus.near: _notifController.notifyRiderNear(); break;
      case OrderStatus.delivered: 
        _notifController.notifyRiderArrived();
        _notifController.notifyOrderDelivered();
        break;
      default: break;
    }
    _lastNotifiedStatus = status;
  }

  @override
  void onClose() {
    _pollingTimer?.cancel();
    instructionsController.dispose();
    super.onClose();
  }

  int get currentStepIndex {
    switch (currentStatus.value) {
      case OrderStatus.placed:
      case OrderStatus.shopConfirmed:
        return 0;
      case OrderStatus.preparing:
      case OrderStatus.packed:
        return 1;
      case OrderStatus.riderAssigned:
      case OrderStatus.riderPickedUp:
      case OrderStatus.outForDelivery:
      case OrderStatus.near:
        return 2;
      case OrderStatus.delivered:
        return 3;
    }
  }
}
