import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:waytofresh/core/utils/size_utils.dart';
import 'package:waytofresh/theme/theme_helper.dart';
import 'package:waytofresh/routes/app_routes.dart';

class ActiveOrderBanner extends StatelessWidget {
  final Map<String, dynamic> order;

  const ActiveOrderBanner({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String storeName = "WayToFresh"; // Mocked store name
    String status = order['status_display'] ?? "Preparing your order";
    
    // Type-safe grand total handling
    dynamic rawTotal = order['grand_total'];
    String price = rawTotal != null ? "₹$rawTotal" : "₹0";
    
    String rawTime = order['estimated_delivery_time'] ?? "25 mins";
    // Convert ranges to single time (e.g. "25-35 mins" -> "25 mins")
    String estimatedTime = rawTime.contains('-') 
        ? "${rawTime.split('-').first} ${rawTime.split(' ').last}" 
        : rawTime;

    return GestureDetector(
      onTap: () {
        Get.toNamed(AppRoutes.orderTrackingScreen, arguments: order['id']);
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 60.h),
        padding: EdgeInsets.symmetric(horizontal: 8.h, vertical: 8.h), // Reduced from 16.h to give more room for text
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25.h),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: Row(
          children: [
            // Animated Lottie Scooter
            Container(
              height: 38.h, // Slightly larger than the old icon circle
              width: 38.h,
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                shape: BoxShape.circle,
              ),
              child: ClipOval(
                child: Lottie.asset(
                  'assets/Delivery Scooter1.json',
                  fit: BoxFit.cover,
                  repeat: true,
                ),
              ),
            ),
            SizedBox(width: 6.h), // Reduced from 12.h

            // Text Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    storeName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w900, // Thicker
                      fontSize: 14.fSize,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            status,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.grey.shade800,
                              fontWeight: FontWeight.w600,
                              fontSize: 11.fSize,
                            ),
                          ),
                        ),
                        Text(
                          " | Pay $price",
                          maxLines: 1,
                          style: TextStyle(
                            color: appTheme.red_A700,
                            fontWeight: FontWeight.w800,
                            fontSize: 11.fSize,
                          ),
                        ),
                        Icon(CupertinoIcons.chevron_right, size: 9.h, color: appTheme.red_A700),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Arrival Bubble
            Container(
              padding: EdgeInsets.symmetric(horizontal: 6.h, vertical: 4.h), // Reduced from 10.h
              decoration: BoxDecoration(
                color: const Color(0xFF4CAF50), // Fresh Green
                borderRadius: BorderRadius.circular(10.h),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "arriving in",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 8.fSize,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    estimatedTime,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13.fSize,
                      fontWeight: FontWeight.w900,
                      height: 1.0,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
