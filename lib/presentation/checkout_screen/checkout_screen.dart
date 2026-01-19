import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../category_screen/controller/cart_controller.dart';
import 'controller/address_controller.dart';
import 'widgets/address_bottom_sheet.dart';
import '../coupon_screen/coupon_screen.dart';
import 'controller/coupon_controller.dart';

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
  Worker? _confettiWorker;

  @override
  void initState() {
    super.initState();
    _lottieController = AnimationController(vsync: this);
    _couponController = Get.put(CouponController());

    // Listen to confetti trigger - MOVED to navigation return logic
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
                Icons.arrow_back,
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
                child: SingleChildScrollView(
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
                            children: controller.cartItems.entries.map((entry) {
                              final product = controller.allProducts[entry.key];
                              final quantity = entry.value;
                              // Check if it's the last item to remove separator/bottom margin
                              final isLast =
                                  entry.key == controller.cartItems.keys.last;
                              return _buildCartItem(
                                controller,
                                entry.key,
                                product,
                                quantity,
                                isLast,
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Wishlist Section
                      const Text(
                        "Before you checkout",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 220,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            _buildWishlistItem(
                              "Surf Excel",
                              "1 kg",
                              120,
                              "assets/images/image 21.png",
                            ),
                            _buildWishlistItem(
                              "Too Yumm",
                              "Chips",
                              20,
                              "assets/images/image 25.png",
                            ),
                            _buildWishlistItem(
                              "Kwality Walls",
                              "Ice Cream",
                              250,
                              "assets/images/image 31.png",
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

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
                              // Trigger confetti if a coupon was successfully applied
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
                                      Icons.local_offer,
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
                                            _couponController.removeCoupon(),
                                        icon: const Icon(
                                          Icons.close,
                                          color: Colors.grey,
                                          size: 20,
                                        ),
                                      );
                                    }
                                    return const Icon(
                                      Icons.arrow_forward_ios,
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
                                          Icons.article_outlined,
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
                                        Icons.moped,
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
                                        Icons.info_outline,
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

                                  // Handling Charge
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.shopping_bag_outlined,
                                        size: 16,
                                        color: Colors.grey,
                                      ),
                                      const SizedBox(width: 8),
                                      const Text(
                                        "Handling charge",
                                        style: TextStyle(fontSize: 13),
                                      ),
                                      const SizedBox(width: 4),
                                      Icon(
                                        Icons.info_outline,
                                        size: 14,
                                        color: Colors.grey.shade400,
                                      ),
                                      const Spacer(),
                                      const Text(
                                        "₹2",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),

                                  // Gift Wrapping
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.redeem,
                                        size: 16,
                                        color: Colors.grey,
                                      ),
                                      const SizedBox(width: 8),
                                      const Text(
                                        "Gift wrapping",
                                        style: TextStyle(fontSize: 13),
                                      ),
                                      const Spacer(),
                                      const Text(
                                        "₹35",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),

                                  // Coupon Discount Row
                                  Obx(() {
                                    if (_couponController.discountAmount.value >
                                        0) {
                                      return Row(
                                        children: [
                                          const Icon(
                                            Icons.discount,
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
                                      );
                                    }
                                    return const SizedBox.shrink();
                                  }),

                                  const SizedBox(height: 16),

                                  Obx(() {
                                    double discount =
                                        _couponController.discountAmount.value;
                                    double grandTotal =
                                        controller.totalCartPrice +
                                        2 +
                                        35 -
                                        discount;
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
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

                            // Blue Savings Footer
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                borderRadius: const BorderRadius.vertical(
                                  bottom: Radius.circular(16),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Your total savings",
                                          style: TextStyle(
                                            color: Colors.blue,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                          ),
                                        ),
                                        Text(
                                          "Includes ₹15 savings through free delivery",
                                          style: TextStyle(
                                            color: Colors.blue,
                                            fontSize: 10,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Obx(() {
                                    // Total savings: Delivery fee (15) + Coupon Discount
                                    double totalSavings =
                                        15 +
                                        _couponController.discountAmount.value;
                                    return Text(
                                      "₹${totalSavings.toStringAsFixed(0)}",
                                      style: const TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    );
                                  }),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Feeding India Donation
                      Container(
                        margin: const EdgeInsets.only(bottom: 24),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.orange.shade50,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.volunteer_activism,
                                color: Colors.orange,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Feeding India donation",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    "Working towards a malnutrition free India. Feeding India...read more",
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              "₹1",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.check_box_outline_blank,
                              color: Colors.green,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Footer / Cancellation Policy
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.grey.shade800
                              : Colors.grey.shade100,
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

                      const SizedBox(height: 100), // Space for bottom bar
                    ],
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: _buildBottomBar(context, controller),
        ),
        // Lottie Animation
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
    int index,
    Map<String, dynamic> product,
    int quantity,
    bool isLast,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: isLast ? 0 : 16),
      child: Row(
        children: [
          // Image
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade100),
            ),
            child: product["image"] != null
                ? Image.asset(product["image"], fit: BoxFit.contain)
                : const Icon(Icons.image, color: Colors.grey),
          ),
          const SizedBox(width: 12),
          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product["name"],
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                Text(
                  product["weight"],
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
                const SizedBox(height: 4),
                const Text(
                  "Move to wishlist",
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.black54,
                    decoration: TextDecoration.underline,
                    decorationStyle: TextDecorationStyle.dashed,
                  ),
                ),
              ],
            ),
          ),
          // Counter & Price
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(6),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => controller.removeFromCart(index),
                      child: const Icon(
                        Icons.remove,
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
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => controller.addToCart(index),
                      child: const Icon(
                        Icons.add,
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

  Widget _buildWishlistItem(
    String name,
    String weight,
    int price,
    String imagePath,
  ) {
    return Container(
      width: 140, // Increased width
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                Center(
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const Icon(Icons.local_offer),
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.favorite_border,
                      size: 16,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
          ),
          Text(
            weight,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 11),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "₹$price",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.green),
                  borderRadius: BorderRadius.circular(6),
                  color: Colors.green.shade50,
                ),
                child: const Text(
                  "ADD",
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
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
                    Icons.home_rounded,
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
                          Text(
                            "Delivering to Home",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Spacer(),
                          InkWell(
                            onTap: () {
                              Get.bottomSheet(
                                const AddressBottomSheet(),
                                isScrollControlled: true,
                              );
                            },
                            child: Text(
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
                          child: const Icon(
                            Icons.currency_rupee,
                            size: 10,
                            color: Colors.white,
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
                    onPressed: () {
                      // Place order logic
                      Get.snackbar(
                        "Success",
                        "Order Placed Successfully!",
                        backgroundColor: Colors.green,
                        colorText: Colors.white,
                      );
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
                              // Match the bill calculation: items + handling(2) + giftwrap(35) - coupon
                              double finalPrice =
                                  controller.totalCartPrice +
                                  2 +
                                  35 -
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
                            Icon(Icons.arrow_right, size: 24),
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

  Widget _buildBillRow(
    String label,
    String value, {
    bool isFree = false,
    String? originalPrice,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
          Row(
            children: [
              if (originalPrice != null) ...[
                Text(
                  originalPrice,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
                const SizedBox(width: 6),
              ],
              Text(
                value,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isFree ? FontWeight.bold : FontWeight.w500,
                  color: isFree
                      ? Colors.green
                      : Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
            ],
          ),
        ],
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
}
