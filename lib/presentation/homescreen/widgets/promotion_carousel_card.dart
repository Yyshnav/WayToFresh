import 'package:flutter/material.dart';
import '../../../../core/app_expote.dart';
import '../../../../widgets/custom_image_view.dart';

class PromotionCarouselCard extends StatelessWidget {
  final Color backgroundColor;
  final String title;
  final String subtitle;
  final String footerText;
  final String imagePath;
  final VoidCallback onTap;

  const PromotionCarouselCard({
    Key? key,
    required this.backgroundColor,
    required this.title,
    required this.subtitle,
    required this.footerText,
    required this.imagePath,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.h),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20.h),
        ),
        child: Stack(
          children: [
            // Text Content
            Padding(
              padding: EdgeInsets.all(16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Up To",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.fSize,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28.fSize,
                      fontWeight: FontWeight.w900,
                      height: 1.1,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.fSize,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.h, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8.h),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          footerText,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.fSize,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 4.h),
                        const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                          size: 10,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Illustration
            Positioned(
              right: 0,
              bottom: 0,
              top: 0,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20.h),
                  bottomRight: Radius.circular(20.h),
                ),
                child: CustomImageView(
                  imagePath: imagePath,
                  height: 180.h,
                  width: 150.h,
                  fit: BoxFit.contain,
                  alignment: Alignment.centerRight,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
