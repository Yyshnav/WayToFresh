import 'package:flutter/material.dart';
import 'package:waytofresh/core/utils/size_utils.dart';
import 'package:waytofresh/theme/theme_helper.dart';

import './custom_image_view.dart';

/**
 * A customizable icon button widget with configurable background color, padding, and icon.
 * 
 * This widget provides a circular icon button with customizable styling options including
 * background color, padding, and icon image. It's designed to be responsive and reusable
 * across different screen sizes.
 * 
 * @param iconPath - Path to the icon image (required)
 * @param onPressed - Callback function when button is pressed
 * @param backgroundColor - Background color of the button
 * @param padding - Internal padding of the button
 * @param margin - External margin of the button
 * @param width - Width of the button
 * @param height - Height of the button
 */
class CustomIconButton extends StatelessWidget {
  CustomIconButton({
    Key? key,
    required this.iconPath,
    this.onPressed,
    this.backgroundColor,
    this.padding,
    this.margin,
    this.width,
    this.height,
  }) : super(key: key);

  /// Path to the icon image
  final String iconPath;

  /// Callback function triggered when the button is pressed
  final VoidCallback? onPressed;

  /// Background color of the button
  final Color? backgroundColor;

  /// Internal padding of the button
  final EdgeInsetsGeometry? padding;

  /// External margin of the button
  final EdgeInsetsGeometry? margin;

  /// Width of the button
  final double? width;

  /// Height of the button
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? 32.h,
      height: height ?? 32.h,
      margin: margin ?? EdgeInsets.only(right: 6.h),
      decoration: BoxDecoration(
        color: backgroundColor ?? appTheme.blackCustom,
        borderRadius: BorderRadius.circular(16.h),
      ),
      child: IconButton(
        onPressed: onPressed,
        padding: padding ?? EdgeInsets.all(6.h),
        icon: CustomImageView(
          imagePath: iconPath,
          width: 20.h,
          height: 20.h,
          fit: BoxFit.contain,
        ),
        iconSize: 20.h,
        constraints: BoxConstraints(),
      ),
    );
  }
}
