import 'package:flutter/material.dart';
import 'package:waytofresh/theme/text_style_helper.dart';
import 'package:waytofresh/theme/theme_helper.dart';

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
                          Icons.keyboard_arrow_down,
                          color: textColor,
                          size: 24,
                        ),
                      ],
                    ),
                    // Bottom Row: Address
                    Flexible(
                      child: Text(
                        address ?? "Select Location",
                        style: TextStyleHelper.instance.body12RegularPoppins
                            .copyWith(
                              color: textColor.withOpacity(0.9),
                              fontSize: 12,
                            ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
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
                child: Icon(Icons.person, color: textColor, size: 24),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
