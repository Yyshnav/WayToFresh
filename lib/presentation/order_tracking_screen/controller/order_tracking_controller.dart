import 'dart:async';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import '../../../core/controllers/notification_controller.dart';

enum OrderStatus { placed, shopConfirmed, preparing, packed, riderAssigned, riderPickedUp, outForDelivery, near, delivered }

class OrderTrackingController extends GetxController {
  // ✅ Observables
  final Rx<OrderStatus> currentStatus = OrderStatus.placed.obs;
  final Rx<LatLng> deliveryBoyLocation = const LatLng(-23.9630, -46.3315).obs;
  final RxDouble distanceRemaining = 2.1.obs; // In km
  final RxString estimatedTime = "15:10 - 15:20".obs;
  final RxString deliveryInstructions = "".obs;
  
  // ✅ Input Controller
  final TextEditingController instructionsController = TextEditingController();

  final NotificationController _notifController = Get.find<NotificationController>();

  Timer? _simulationTimer;

  @override
  void onInit() {
    super.onInit();
    // Synchronize controller with observable
    instructionsController.addListener(() {
      deliveryInstructions.value = instructionsController.text;
    });
  }

  void startTracking() {
    _startSimulation();
  }

  @override
  void onClose() {
    _simulationTimer?.cancel();
    instructionsController.dispose();
    super.onClose();
  }

  // ✅ Simulation: Comprehensive Granular Progress
  void _startSimulation() {
    // Stage 1: Placed -> Shop Confirmed (3s)
    Future.delayed(const Duration(seconds: 3), () {
      currentStatus.value = OrderStatus.shopConfirmed;
      _notifController.notifyShopConfirmed();
      
      // Stage 2: Shop Confirmed -> Preparing (4s)
      Future.delayed(const Duration(seconds: 4), () {
        currentStatus.value = OrderStatus.preparing;
        _notifController.notifyPreparing();
        
        // Stage 3: Preparing -> Packed (4s)
        Future.delayed(const Duration(seconds: 4), () {
          currentStatus.value = OrderStatus.packed;
          _notifController.notifyPacked();
          
          // Stage 4: Packed -> Rider Assigned (3s)
          Future.delayed(const Duration(seconds: 3), () {
            currentStatus.value = OrderStatus.riderAssigned;
            _notifController.notifyRiderAssigned();
            _notifController.notifyMessageShop(); // Bonus: Message from shop

            // Stage 5: Rider Assigned -> Rider Picked Up (3s)
            Future.delayed(const Duration(seconds: 3), () {
              currentStatus.value = OrderStatus.riderPickedUp;
              _notifController.notifyRiderPickedUp();
              
              // Stage 6: Rider Picked Up -> Out For Delivery (2s)
              Future.delayed(const Duration(seconds: 2), () {
                currentStatus.value = OrderStatus.outForDelivery;
                _notifController.notifyOutForDelivery();
                _startLiveMovement(); // Start moving marker
              });
            });
          });
        });
      });
    });
  }

  void _startLiveMovement() {
    const destination = LatLng(-23.9618, -46.3322);
    const steps = 100; // Smoother movement
    int currentStep = 0;

    double latStep = (destination.latitude - deliveryBoyLocation.value.latitude) / steps;
    double lngStep = (destination.longitude - deliveryBoyLocation.value.longitude) / steps;

    bool notified5Mins = false;
    bool notifiedNear = false;
    bool notifiedRain = false;

    _simulationTimer = Timer.periodic(const Duration(milliseconds: 350), (timer) {
      if (currentStep < steps) {
        deliveryBoyLocation.value = LatLng(
          deliveryBoyLocation.value.latitude + latStep,
          deliveryBoyLocation.value.longitude + lngStep,
        );
        
        distanceRemaining.value = (2.1 * (1 - (currentStep / steps))).toPrecision(2);
        
        // ✅ 1. Rain Delay alert (at 25% progress)
        if (currentStep == steps ~/ 4 && !notifiedRain) {
          _notifController.notifyRainDelay();
          notifiedRain = true;
        }

        // ✅ 2. Arriving in 5 mins alert (at 55% progress)
        if (currentStep == (steps * 0.55).toInt() && !notified5Mins) {
          _notifController.notifyArrivingIn5Mins();
          _notifController.notifyMessageRider(); // Bonus: Message from rider
          notified5Mins = true;
        }

        // ✅ 3. Rider Near Alert (at 85% progress)
        if (currentStep == (steps * 0.85).toInt() && !notifiedNear) {
          currentStatus.value = OrderStatus.near;
          _notifController.notifyRiderNear();
          notifiedNear = true;
        }

        currentStep++;
      } else {
        currentStatus.value = OrderStatus.delivered;
        _notifController.notifyRiderArrived();
        _notifController.notifyOrderDelivered();
        _notifController.notifyInvoiceSent(); // ✅ Invoice Sent
        
        // Post-Delivery alerts
        Future.delayed(const Duration(seconds: 4), () => _notifController.notifyRateOrder());
        Future.delayed(const Duration(seconds: 8), () => _notifController.notifyRefundInitiated());
        
        timer.cancel();
      }
    });
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
