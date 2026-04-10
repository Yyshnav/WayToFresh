import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:waytofresh/Widgets/custom_image_view.dart';
import 'package:waytofresh/core/app_expote.dart';
import 'package:waytofresh/core/utils/image_constants.dart';
import 'package:waytofresh/theme/theme_helper.dart';
import 'package:waytofresh/widgets/custom_blinkit_app_bar.dart';
import 'package:waytofresh/presentation/checkout_screen/widgets/address_bottom_sheet.dart';
import 'package:waytofresh/presentation/checkout_screen/controller/address_controller.dart';
import 'controller/category_controller.dart';
import 'package:waytofresh/routes/app_routes.dart';

class CategoryScreen extends StatefulWidget {
  final ScrollController? scrollController;

  const CategoryScreen({Key? key, this.scrollController}) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final CategoryController controller = Get.put(CategoryController());
  late ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.scrollController ?? ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          // Address header with gradient, matching Home Screen
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: appTheme.primaryGradient,
            ),
            child: SafeArea(
              bottom: false,
              child: Obx(() {
                final addressController = Get.find<AddressController>();
                return CustomBlinkitAppBar(
                  locationLabel: "Home",
                  address: addressController.currentAddress.value.isNotEmpty
                      ? addressController.currentAddress.value
                      : "Select Location",
                  onActionPressed: () => Get.back(),
                  isDarkTheme: true,
                  onLocationPressed: () {
                    Get.bottomSheet(
                      const AddressBottomSheet(),
                      isScrollControlled: true,
                    );
                  },
                );
              }),
            ),
          ),

          // Rest of category body
          Expanded(
            child: SafeArea(
              top: false,
              child: Column(
                children: [
            // Header Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [],
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  // Search Row
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.h,
                            vertical: 12.h,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(30.h),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                CupertinoIcons.search,
                                color: Theme.of(context).iconTheme.color,
                              ),
                              SizedBox(width: 10.h),
                              Text(
                                "Search...",
                                style: TextStyle(
                                  color: Theme.of(
                                    context,
                                  ).textTheme.bodyMedium?.color,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 12.h),
                      Container(
                        padding: EdgeInsets.all(12.h),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          border: Border.all(color: Colors.grey.shade300),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          CupertinoIcons.slider_horizontal_3,
                          color: Theme.of(context).iconTheme.color,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  // Promo Banner
                  Container(
                    height: 140.h,
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                      color: Color(0xFFE1EAD8), // Slightly darker green
                      borderRadius: BorderRadius.circular(12.h),
                    ),
                    child: Stack(
                      children: [
                        Row(
                          children: [
                            // Left Side - Barcode
                            Container(
                              width: 80.h,
                              padding: EdgeInsets.symmetric(vertical: 8.h),
                              decoration: BoxDecoration(
                                border: Border(
                                  right: BorderSide(
                                    color: Colors.grey.shade400,
                                    width: 1,
                                    style: BorderStyle.none, // Handled by dash
                                  ),
                                ),
                              ),
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // Barcode Lines Simulation
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: List.generate(8, (index) {
                                        // Reduced count
                                        return Container(
                                          height: index % 2 == 0 ? 3.h : 1.5.h,
                                          width: 50.h,
                                          margin: EdgeInsets.symmetric(
                                            vertical: 1.5.h,
                                          ),
                                          color: Colors.black,
                                        );
                                      }),
                                    ),
                                    SizedBox(height: 4.h),
                                    RotatedBox(
                                      quarterTurns: 3,
                                      child: Text(
                                        "Code No.: 2193052",
                                        style: TextStyle(
                                          fontSize: 8.h,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // Dotted Line Separator
                            CustomPaint(
                              size: Size(1, 140.h),
                              painter: DashedLinePainter(),
                            ),
                            // Right Side - Content
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.all(12.h),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 8.h,
                                              vertical: 2.h,
                                            ),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.black54,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Text(
                                              "ALICE GROCERY",
                                              style: TextStyle(
                                                fontSize: 8.h,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 4.h),
                                          Text(
                                            "PROMO COUPON",
                                            style: TextStyle(
                                              fontSize: 14.h,
                                              fontWeight: FontWeight.w900,
                                              color: Colors.black,
                                            ),
                                          ),
                                          Text(
                                            "50% OFF",
                                            style: TextStyle(
                                              fontSize: 32.h,
                                              fontWeight: FontWeight.w900,
                                              color: Colors.black,
                                              height: 1.0,
                                            ),
                                          ),
                                          SizedBox(height: 4.h),
                                          Text(
                                            "For any product in grocery store",
                                            style: TextStyle(
                                              fontSize: 8.h,
                                              color: Colors.black54,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Image
                                    CustomImageView(
                                      imagePath: ImageConstant.imgImage19,
                                      height: 60.h,
                                      width: 60.h,
                                      fit: BoxFit.contain,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        // Notches
                        Positioned(
                          top: -10.h,
                          left: 71.h, // Approx position for separator
                          child: Container(
                            height: 20.h,
                            width: 20.h,
                            decoration: BoxDecoration(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: -10.h,
                          left: 71.h,
                          child: Container(
                            height: 20.h,
                            width: 20.h,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Staggered Grid Content
            Expanded(
              child: Obx(() {
                if (controller.collections.isEmpty)
                  return Center(
                    child: Text(
                      "No Items Found: ${controller.collections.length}",
                    ),
                  );

                return GridView.builder(
                  controller: _controller,
                  padding: EdgeInsets.symmetric(horizontal: 20.h),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 20.h, // Increased spacing
                    mainAxisSpacing: 20.h, // Increased spacing
                    childAspectRatio: 0.75, // Adjusted for smaller circles
                  ),
                  itemCount: controller.collections.length,
                  itemBuilder: (context, index) {
                    var item = controller.collections[index];
                    return GestureDetector(
                      onTap: () {
                        // Navigate to the Sidebar-integrated category view
                        Get.toNamed(
                          AppRoutes.categoryScreen,
                          arguments: index, // Pass the index for the controller to pick up
                        );
                      },
                      child: Column(
                        children: [
                          Container(
                            height: 74.h, // Reduced from 80
                            width: 74.h, // Reduced from 80
                            padding: EdgeInsets.all(14.h),
                            decoration: BoxDecoration(
                              color: item.color,
                              shape: BoxShape.circle,
                            ),
                            child: CustomImageView(
                              imagePath: item.imagePath,
                              fit: BoxFit.contain,
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            item.title,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 11.h, // Slightly smaller text
                              fontWeight: FontWeight.w500,
                              color: Theme.of(
                                context,
                              ).textTheme.bodyLarge?.color,
                              height: 1.2,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    ),
        ],
      ),
    );
  }
}

class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double dashHeight = 5, dashSpace = 3, startY = 0;
    final paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 1;
    while (startY < size.height) {
      canvas.drawLine(Offset(0, startY), Offset(0, startY + dashHeight), paint);
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
