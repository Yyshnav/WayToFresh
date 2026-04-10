import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:waytofresh/presentation/order_tracking_screen/controller/order_tracking_controller.dart';
import 'package:waytofresh/presentation/order_tracking_screen/order_tracking_screen.dart';
import '../category_screen/controller/cart_controller.dart';
import 'controller/address_controller.dart';
import 'widgets/address_bottom_sheet.dart';
import '../coupon_screen/coupon_screen.dart';
import 'controller/coupon_controller.dart';
import 'controller/order_controller.dart';
import '../order_success_screen/order_success_screen.dart';
import 'package:waytofresh/core/utils/toast_helper.dart';
import 'package:waytofresh/core/app_expote.dart';
import 'package:waytofresh/widgets/custom_image_view.dart';
import 'package:waytofresh/core/controllers/notification_controller.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen>
    with TickerProviderStateMixin {
  bool _showLottie = false;
  AnimationController? _lottieController;

  late final CouponController _couponController;
  late final OrderController _orderController;
  Worker? _confettiWorker;

  @override
  void initState() {
    super.initState();
    _lottieController = AnimationController(vsync: this);
    _couponController = Get.put(CouponController());
    _orderController = Get.put(OrderController());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _lottieController ??= AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _confettiWorker?.dispose();
    _lottieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Reusing CartController since it holds the cart data
    final CartController controller = Get.find<CartController>();

    return Stack(
      children: [
        Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            title: Text(
              "Checkout",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Theme.of(context).textTheme.titleLarge?.color,
              ),
            ),
            centerTitle: true,
            backgroundColor: Theme.of(context).cardColor,
            elevation: 0,
            leading: IconButton(
              icon: Icon(
                CupertinoIcons.back,
                color: Theme.of(context).iconTheme.color,
              ),
              onPressed: () => Get.back(),
            ),
            actions: [
              TextButton(
                onPressed: () {},
                child: const Text(
                  "Share",
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: RefreshIndicator(
                  onRefresh: controller.fetchCart,
                  color: const Color(0xFF07575B),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      // Personal Cart Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Personal Cart",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: const Text(
                              "Change",
                              style: TextStyle(color: Colors.green),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Cart Items
                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(
                                context,
                              ).shadowColor.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Obx(
                          () => Column(
                            children: [
                              ...controller.cartItems.entries.toList().asMap().entries.map((itemEntry) {
                                final index = itemEntry.key;
                                final entry = itemEntry.value;
                                final productId = entry.key;
                                final quantity = entry.value;

                                // Find product in current list or cache
                                final product = controller.allProducts.firstWhereOrNull((p) => p["id"] == productId) ?? 
                                               controller.cachedProducts[productId];

                                if (product == null) return const SizedBox.shrink();

                                // Check if it's the last item
                                final isLast = index == controller.cartItems.length - 1;
                                
                                return _buildCartItem(
                                  controller,
                                  productId,
                                  product,
                                  quantity,
                                  isLast,
                                );
                              }).toList(),
                            ],
                          ),
                        ),
                      ),

                   
                      const SizedBox(height: 24),

                      // Coupon Section
                      Container(
                        margin: const EdgeInsets.only(bottom: 24),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(
                                context,
                              ).shadowColor.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () async {
                              await Get.to(
                                () => CouponScreen(
                                  currentOrderValue: controller.totalCartPrice,
                                ),
                              );
                             
                              if (_couponController.showConfetti.value) {
                                _triggerConfetti();
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.deepPurple.shade50,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(
                                      CupertinoIcons.tag,
                                      color: Colors.deepPurple,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Obx(() {
                                          return Text(
                                            _couponController
                                                        .appliedCoupon
                                                        .value ==
                                                    null
                                                ? "Apply Coupon"
                                                : "Coupon Applied: ${_couponController.appliedCoupon.value!.code}",
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          );
                                        }),
                                        Obx(() {
                                          if (_couponController
                                                  .appliedCoupon
                                                  .value !=
                                              null) {
                                            return Text(
                                              "You saved ₹${_couponController.discountAmount.value.toStringAsFixed(0)}",
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.green,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            );
                                          }
                                          return const SizedBox.shrink();
                                        }),
                                      ],
                                    ),
                                  ),
                                  Obx(() {
                                    if (_couponController.appliedCoupon.value !=
                                        null) {
                                      return IconButton(
                                        onPressed: () =>
                                            _couponController.removeCoupon(context),
                                        icon: const Icon(
                                          CupertinoIcons.xmark,
                                          color: Colors.grey,
                                          size: 20,
                                        ),
                                      );
                                    }
                                    return const Icon(
                                      CupertinoIcons.chevron_right,
                                      size: 16,
                                      color: Colors.grey,
                                    );
                                  }),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Bill Details Card
                      Container(
                        margin: const EdgeInsets.only(bottom: 24),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(
                                context,
                              ).shadowColor.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header & Rows
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Bill details",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 16),

                                  // Items Total with Saved Badge
                                  Obx(
                                    () => Row(
                                      children: [
                                        const Icon(
                                          CupertinoIcons.doc_text,
                                          size: 16,
                                          color: Colors.grey,
                                        ),
                                        const SizedBox(width: 8),
                                        const Text(
                                          "Items total",
                                          style: TextStyle(fontSize: 13),
                                        ),
                                        const Spacer(),
                                        Text(
                                          "₹${controller.totalCartPrice.toStringAsFixed(0)}",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 12),

                                  // Delivery Charge
                                  Row(
                                    children: [
                                      const Icon(
                                        CupertinoIcons.bus,
                                        size: 16,
                                        color: Colors.grey,
                                      ),
                                      const SizedBox(width: 8),
                                      const Text(
                                        "Delivery charge",
                                        style: TextStyle(fontSize: 13),
                                      ),
                                      const SizedBox(width: 4),
                                      Icon(
                                        CupertinoIcons.info,
                                        size: 14,
                                        color: Colors.grey.shade400,
                                      ),
                                      const Spacer(),
                                      Text(
                                        "₹15",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey.shade400,
                                          decoration:
                                              TextDecoration.lineThrough,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      const Text(
                                        "FREE",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),

                                  // Coupon Discount Row
                                  Obx(() {
                                    if (_couponController.discountAmount.value > 0) {
                                      return Padding(
                                        padding: const EdgeInsets.only(bottom: 12),
                                        child: Row(
                                          children: [
                                            const Icon(
                                              CupertinoIcons.percent,
                                              size: 16,
                                              color: Colors.green,
                                            ),
                                            const SizedBox(width: 8),
                                            const Text(
                                              "Coupon Discount",
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.green,
                                              ),
                                            ),
                                            const Spacer(),
                                            Text(
                                              "- ₹${_couponController.discountAmount.value.toStringAsFixed(0)}",
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 13,
                                                color: Colors.green,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                    return const SizedBox.shrink();
                                  }),

                                  const SizedBox(height: 4),

                                  Obx(() {
                                    final discount = _couponController.discountAmount.value;
                                    final grandTotal = controller.totalCartPrice - discount;
                                    return Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          "Grand total",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                        Text(
                                          "₹${grandTotal.toStringAsFixed(0)}",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ],
                                    );
                                  }),
                                ],
                              ),
                            ),

                            // Savings Footer (only shown when coupon is applied)
                            Obx(() {
                              final savings = _couponController.discountAmount.value;
                              if (savings <= 0) return const SizedBox.shrink();
                              return Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.green.shade50,
                                  borderRadius: const BorderRadius.vertical(
                                    bottom: Radius.circular(16),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(CupertinoIcons.tag_fill, color: Colors.green, size: 16),
                                    const SizedBox(width: 8),
                                    Text(
                                      "You saved ₹${savings.toStringAsFixed(0)} on this order! 🎉",
                                      style: const TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ],
                        ),
                      ),

                      // Footer / Cancellation Policy
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Cancellation Policy",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Orders cannot be cancelled once packed for delivery. In case of unexpected delays, a refund will be provided, if applicable.",
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey.shade600,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ),
          ],
          ),
          bottomNavigationBar: _buildBottomBar(context, controller),
        ),
        if (_showLottie)
          Align(
            alignment: Alignment.center,
            child: IgnorePointer(
              child: SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: Lottie.asset(
                  'assets/images/Confetti.json',
                  controller: _lottieController,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildCartItem(
    CartController controller,
    int productId,
    dynamic product,
    int quantity,
    bool isLast,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: CustomImageView(
              imagePath: product["image"] ?? product["imagePath"],
              width: 50,
              height: 50,
              fit: BoxFit.contain,
              placeHolder: "assets/images/image 21.png",
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product["name"] ?? "Product",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  product["weight"] ?? "",
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "₹${product["price"]}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => controller.removeFromCart(productId),
                      child: const Icon(
                        CupertinoIcons.minus,
                        color: Colors.white,
                        size: 14,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "$quantity",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => controller.addToCart(productId),
                      child: const Icon(
                        CupertinoIcons.add,
                        color: Colors.white,
                        size: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "₹${product["price"] * quantity}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }


  Widget _buildBottomBar(BuildContext context, CartController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Address Section
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: const Icon(
                    CupertinoIcons.home,
                    color: Color(0xFFFFC107), // Yellow home icon
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            "Delivering to Home",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const Spacer(),
                          InkWell(
                            onTap: () {
                              Get.bottomSheet(
                                const AddressBottomSheet(),
                                isScrollControlled: true,
                              );
                            },
                            child: const Text(
                              "Change",
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Obx(() {
                        final addressController = Get.find<AddressController>();
                        return Text(
                          addressController.currentAddress.value,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Payment + Place Order Row
            Row(
              children: [
                // Payment Method (Left) - Now static COD
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade800,
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Text(
                              "₹",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          "PAY USING",
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Cash on Delivery",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        // color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                  ],
                ),

                const SizedBox(width: 16),

                // Place Order Button (Right - Expanded)
                Expanded(
                  child: ElevatedButton(
                    onPressed: _orderController.isPlacingOrder.value ? null : () async {
                      final double total = controller.totalCartPrice;
                      final String? couponCode = _couponController.appliedCoupon.value?.code;
                      final addressController = Get.find<AddressController>();
                      
                      final success = await _orderController.placeOrder(
                        orderTotal: total,
                        addressId: addressController.selectedAddressId.value,
                        couponCode: couponCode,
                        paymentMethod: 'cod', // Defaulting to COD for now
                      );

                      if (success) {
                        // ✅ Start Real-time Tracking Simulation
                        final trackingController = Get.find<OrderTrackingController>();
                        trackingController.startTracking();

                        // ✅ Trigger Notifications
                        final notif = Get.find<NotificationController>();
                        notif.notifyPaymentSuccess();
                        notif.notifyOrderPlaced();
                        
                        ToastHelper.showSuccess("Order Placed Successfully!");

                        // Optionally clear cart
                        controller.clearCart();

                        // Navigate to Tracking Screen
                        Future.delayed(const Duration(milliseconds: 500), () {
                          Get.to(() => OrderTrackingScreen());
                        });
                      } else {
                        ToastHelper.showError("Failed to place order. Please try again.");
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Obx(() {
                              // items total - coupon discount (delivery is FREE)
                              double finalPrice =
                                  controller.totalCartPrice -
                                  _couponController.discountAmount.value;
                              return Text(
                                "₹${finalPrice.toStringAsFixed(0)}",
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            }),
                            const Text(
                              "TOTAL",
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.white70,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const Row(
                          children: [
                            Text(
                              "Place Order",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Icon(CupertinoIcons.chevron_right, size: 24),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _triggerConfetti() {
    if (mounted) {
      setState(() {
        _showLottie = true;
      });
      _couponController.showConfetti.value = false;

      // Play animation slowly over 4 seconds
      _lottieController?.duration = const Duration(seconds: 4);
      _lottieController?.forward(from: 0);

      // Hide after animation + buffer
      Future.delayed(const Duration(seconds: 4), () {
        if (mounted) {
          setState(() {
            _showLottie = false;
          });
        }
      });
    }
  }

  Widget _buildWishlistItem(String name, String weight, int price, String imagePath) {
    return const SizedBox.shrink();
  }
}
