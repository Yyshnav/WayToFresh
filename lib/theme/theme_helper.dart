import 'package:flutter/material.dart';

LightCodeColors get appTheme => ThemeHelper().themeColor();
ThemeData get theme => ThemeHelper().themeData();

/// Helper class for managing themes and colors.

// ignore_for_file: must_be_immutable
class ThemeHelper {
  // The current app theme
  var _appTheme = "lightCode";

  // A map of custom color themes supported by the app
  // A map of custom color themes supported by the app
  Map<String, LightCodeColors> _supportedCustomColor = {
    'lightCode': LightCodeColors(),
    'darkCode':
        LightCodeColors(), // Using same structure for now, can be specialized
  };

  // A map of color schemes supported by the app
  Map<String, ColorScheme> _supportedColorScheme = {
    'lightCode': ColorSchemes.lightCodeColorScheme,
    'darkCode': ColorSchemes.darkCodeColorScheme,
  };

  /// Returns the lightCode colors for the current theme.
  LightCodeColors _getThemeColors() {
    return _supportedCustomColor[_appTheme] ?? LightCodeColors();
  }

  /// Returns the current theme data.
  ThemeData _getThemeData() {
    var colorScheme =
        _supportedColorScheme[_appTheme] ?? ColorSchemes.lightCodeColorScheme;
    return ThemeData(
      visualDensity: VisualDensity.standard,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.background,
      unselectedWidgetColor: colorScheme.onSurface.withOpacity(0.6),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: colorScheme.surface,
        unselectedItemColor: colorScheme.onSurface.withOpacity(0.6),
        selectedItemColor: colorScheme.primary,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  /// Returns the lightCode colors for the current theme.
  LightCodeColors themeColor() => _getThemeColors();

  /// Returns the current theme data.
  ThemeData themeData() => _getThemeData();
}

class ColorSchemes {
  static final lightCodeColorScheme = ColorScheme.light(
    primary: Color(0xFF07575B),
    onPrimary: Colors.white,
    secondary: Color(0xFF26AF34),
    onSecondary: Colors.white,
    background: Color(0xFFF5F5F5),
    onBackground: Colors.black,
    surface: Colors.white,
    onSurface: Colors.black,
  );

  static final darkCodeColorScheme = ColorScheme.dark(
    primary: Color(0xFF0A8F94), // Lighter Teal for dark mode
    onPrimary: Colors.black,
    secondary: Color(0xFF34D44A), // Lighter Green
    onSecondary: Colors.black,
    background: Color(0xFF121212),
    onBackground: Colors.white,
    surface: Color(0xFF1E1E1E),
    onSurface: Colors.white,
  );
}

class LightCodeColors {
  // App Colors
  Color get white_A700 => Color(0xFFFFFFFF);
  Color get black_900 => Color(0xFF000000);
  Color get gray_500 => Color(0xFF9B9B9B);
  Color get gray_400 => Color(0xFFC5C5C5);
  Color get red_A700 => Color(0xFF800000);
  Color get gray_300 => Color(0xFFE9D3D3);
  Color get green_600 => Color(0xFF26AF34);
  Color get teal_50 => Color(0xFFD9EAEA);
  Color get amber_A200 => Color(0xFFF7CB45);
  Color get teal_50_01 => Color(0xFFD9EBEB);
  Color get teal_100 => Color(0xFFB2DFDB); // Added for ripple
  Color get teal_200 => Color(0xFF80CBC4); // Added for ripple

  // Additional Colors
  Color get transparentCustom => Colors.transparent;
  Color get whiteCustom => Colors.white;
  Color get blackCustom => Colors.black;
  Color get greyCustom => Colors.grey;
  Color get color3F0000 => Color(0x3F000000);

  // Color Shades - Each shade has its own dedicated constant
  Color get grey200 => Colors.grey.shade200;
  Color get grey100 => Colors.grey.shade100;
}
