import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:waytofresh/core/app_expote.dart';
import 'package:waytofresh/theme/text_style_helper.dart';
import 'package:waytofresh/theme/theme_helper.dart';
import 'package:waytofresh/core/controllers/notification_controller.dart';
import 'package:waytofresh/presentation/notification_screen/notification_screen.dart';

class CustomBlinkitAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String? locationLabel;
  final String? address;
  final VoidCallback? onActionPressed;
  final VoidCallback? onLocationPressed;
  final bool? isDarkTheme;
  final double? height;

  const CustomBlinkitAppBar({
    Key? key,
    this.locationLabel,
    this.address,
    this.onActionPressed,
    this.onLocationPressed,
    this.isDarkTheme,
    this.height,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(height ?? 60);

  @override
  Widget build(BuildContext context) {
    final bool useDarkTheme = isDarkTheme ?? false;
    final Color textColor = useDarkTheme
        ? appTheme.whiteCustom
        : appTheme.blackCustom;

    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor:
          Colors.transparent, // Transparent to show gradient behind
      elevation: 0,
      toolbarHeight: height ?? 60,
      titleSpacing: 0,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: onLocationPressed,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Top Row: "Home" + Arrow
                    Row(
                      children: [
                        Text(
                          locationLabel ?? "Home",
                          style: TextStyleHelper.instance.title20BoldPoppins
                              .copyWith(
                                color: textColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          CupertinoIcons.chevron_down,
                          color: textColor,
                          size: 24,
                        ),
                      ],
                    ),
                    // Bottom Row: Address
                    Text(
                        address ?? "Select Location",
                        style: TextStyleHelper.instance.body12RegularPoppins
                            .copyWith(
                              color: textColor.withOpacity(0.9),
                              fontSize: 12,
                            ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                  ],
                ),
              ),
            ),
            // Meat Mode Toggle Button
            InkWell(
              onTap: () {
                HapticFeedback.mediumImpact();
                Get.toNamed(AppRoutes.meatScreen);
              },
              borderRadius: BorderRadius.circular(20),
              child: Container(
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF800000), Color(0xFF600000)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF800000).withOpacity(0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "🥩",
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "Meat",
                      style: TextStyleHelper.instance.body12RegularPoppins.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Notification Icon (New)
            Obx(() {
              final notifController = Get.find<NotificationController>();
              final unreadCount = notifController.unreadCount;
              return InkWell(
                onTap: () {
                  HapticFeedback.lightImpact();
                  Get.to(() => NotificationScreen());
                },
                borderRadius: BorderRadius.circular(50),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Icon(CupertinoIcons.bell, color: textColor, size: 24),
                      if (unreadCount > 0)
                        Positioned(
                          right: -2,
                          top: -2,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                            constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                            child: Text(
                              '$unreadCount',
                              style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            }),
            // Profile Icon
            InkWell(
              onTap: onActionPressed,
              borderRadius: BorderRadius.circular(50),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(CupertinoIcons.person, color: textColor, size: 24),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
