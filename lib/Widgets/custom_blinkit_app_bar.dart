// import 'package:flutter/material.dart';
// import 'package:waytofresh/core/utils/image_constants.dart';
// import 'package:waytofresh/core/utils/size_utils.dart';
// import 'package:waytofresh/theme/text_style_helper.dart';
// import 'package:waytofresh/theme/theme_helper.dart';

// import './custom_image_view.dart';

// /**
//  * CustomBlinkitAppBar - A customizable app bar component for Blinkit-style delivery apps
//  *
//  * This component provides a delivery-focused app bar with delivery time, location display,
//  * and customizable theming options. It includes a title section, delivery time,
//  * location with dropdown, and an action button.
//  *
//  * @param title - The main title text (e.g., "Blinkit in")
//  * @param deliveryTime - The delivery time text (e.g., "16 minutes")
//  * @param locationLabel - The location label text (e.g., "HOME")
//  * @param address - The full address text
//  * @param actionIcon - The icon path for the action button
//  * @param onActionPressed - Callback function when action button is pressed
//  * @param onLocationPressed - Callback function when location section is pressed
//  * @param isDarkTheme - Whether to use dark theme colors
//  * @param height - Custom height for the app bar
//  */
// class CustomBlinkitAppBar extends StatelessWidget
//     implements PreferredSizeWidget {
//   const CustomBlinkitAppBar({
//     Key? key,
//     this.title,
//     this.deliveryTime,
//     this.locationLabel,
//     this.address,
//     this.actionIcon,
//     this.onActionPressed,
//     this.onLocationPressed,
//     this.isDarkTheme,
//     this.height,
//   }) : super(key: key);

//   /// Main title text displayed at the top
//   final String? title;

//   /// Delivery time text displayed prominently
//   final String? deliveryTime;

//   /// Location label text (e.g., "HOME", "WORK")
//   final String? locationLabel;

//   /// Full address text displayed after the location label
//   final String? address;

//   /// Icon path for the action button
//   final String? actionIcon;

//   /// Callback function triggered when action button is pressed
//   final VoidCallback? onActionPressed;

//   /// Callback function triggered when location section is pressed
//   final VoidCallback? onLocationPressed;

//   /// Whether to use dark theme styling
//   final bool? isDarkTheme;

//   /// Custom height for the app bar
//   final double? height;

//   @override
//   Size get preferredSize => Size.fromHeight(height ?? 60.h);

//   @override
//   Widget build(BuildContext context) {
//     final bool useDarkTheme = isDarkTheme ?? false;
//     final Color textColor =
//         useDarkTheme ? appTheme.whiteCustom : appTheme.blackCustom;
//     final Color buttonBackgroundColor =
//         useDarkTheme ? appTheme.blackCustom : appTheme.whiteCustom;

//     return AppBar(
//       automaticallyImplyLeading: false,
//       backgroundColor: appTheme.transparentCustom,
//       elevation: 0,
//       toolbarHeight: height ?? 60.h,
//       titleSpacing: 0,
//       title: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 16.h),
//         child: Row(
//           children: [
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Text(
//                     title ?? "Blinkit in",
//                     style: TextStyleHelper.instance.body12BoldPoppins
//                         .copyWith(height: 1.5),
//                   ),
//                   Text(
//                     deliveryTime ?? "16 minutes",
//                     style: TextStyleHelper.instance.title20BoldPoppins
//                         .copyWith(height: 1.5),
//                   ),
//                   SizedBox(height: 8.h),
//                   GestureDetector(
//                     onTap: onLocationPressed,
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Text(
//                           locationLabel ?? "HOME",
//                           style: TextStyleHelper.instance.body12BoldPoppins
//                               .copyWith(letterSpacing: 1, height: 1.5),
//                         ),
//                         SizedBox(width: 4.h),
//                         Text(
//                           "-",
//                           style: TextStyleHelper.instance.body12BoldPoppins
//                               .copyWith(height: 1.5),
//                         ),
//                         SizedBox(width: 4.h),
//                         Flexible(
//                           child: Text(
//                             address ?? "Sujal Dave, Ratanada, Jodhpur (Raj)",
//                             style: TextStyleHelper.instance.body12RegularPoppins
//                                 .copyWith(height: 1.5),
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//                         SizedBox(width: 10.h),
//                         CustomImageView(
//                           imagePath: ImageConstant.imgArrowDownSignToNavigate,
//                           height: 10.h,
//                           width: 10.h,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(width: 6.h),
//             Container(
//               height: 32.h,
//               width: 32.h,
//               decoration: BoxDecoration(
//                 color: buttonBackgroundColor,
//                 borderRadius: BorderRadius.circular(16.h),
//               ),
//               child: IconButton(
//                 padding: EdgeInsets.all(6.h),
//                 onPressed: onActionPressed,
//                 icon: CustomImageView(
//                   imagePath: actionIcon ??
//                       (useDarkTheme
//                           ? ImageConstant.imgGroup28
//                           : ImageConstant.imgGroup34),
//                   height: 20.h,
//                   width: 20.h,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// lib/widgets/custom_blinkit_app_bar.dart

import 'package:flutter/material.dart';
import 'package:waytofresh/core/utils/image_constants.dart';
import 'package:waytofresh/core/utils/size_utils.dart';
import 'package:waytofresh/theme/text_style_helper.dart';
import 'package:waytofresh/theme/theme_helper.dart';
import './custom_image_view.dart';

class CustomBlinkitAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String? locationLabel;
  final String? address;
  final String? actionIcon;
  final VoidCallback? onActionPressed;
  final VoidCallback? onLocationPressed;
  final bool? isDarkTheme;
  final double? height;

  const CustomBlinkitAppBar({
    Key? key,
    this.locationLabel,
    this.address,
    this.actionIcon,
    this.onActionPressed,
    this.onLocationPressed,
    this.isDarkTheme,
    this.height,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(height ?? 60.h);

  @override
  Widget build(BuildContext context) {
    final bool useDarkTheme = isDarkTheme ?? false;
    final Color textColor = useDarkTheme
        ? appTheme.whiteCustom
        : appTheme.blackCustom;
    final Color buttonBackgroundColor = useDarkTheme
        ? appTheme.blackCustom
        : appTheme.whiteCustom;

    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: appTheme.transparentCustom,
      elevation: 0,
      toolbarHeight: height ?? 60.h,
      titleSpacing: 0,
      title: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.h),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: onLocationPressed,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      locationLabel ?? "Home",
                      style: TextStyleHelper.instance.body14BoldPoppins
                          .copyWith(color: textColor, letterSpacing: 0.5),
                    ),
                    SizedBox(width: 6.h),
                    Text(
                      "-",
                      style: TextStyleHelper.instance.body14BoldPoppins
                          .copyWith(color: textColor),
                    ),
                    SizedBox(width: 6.h),
                    Flexible(
                      child: Text(
                        address ?? "Sujal Dave, Ratanada, Jodhpur (Raj)",
                        style: TextStyleHelper.instance.body12BoldPoppins
                            .copyWith(color: textColor.withOpacity(0.9)),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: 8.h),
                    // CustomImageView(
                    //   imagePath: ImageConstant.imgArrowDownSignToNavigate,
                    //   height: 10.h,
                    //   width: 10.h,
                    // ),
                  ],
                ),
              ),
            ),
            IconButton(
              padding: EdgeInsets.all(6.h),
              onPressed: onActionPressed,
              // icon: CustomImageView(
              //   imagePath:
              //       actionIcon ??
              //       (useDarkTheme
              //           ? ImageConstant.imgGroup28
              //           : ImageConstant.imgGroup34),
              //   height: 20.h,
              //   width: 20.h,
              // ),
              icon: Icon(Icons.person_2_outlined),
            ),
          ],
        ),
      ),
    );
  }
}
