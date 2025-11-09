// import 'package:flutter/material.dart';
// import 'package:waytofresh/core/app_expote.dart';
// import 'package:waytofresh/theme/theme_helper.dart';

// /// A helper class for managing text styles in the application
// class TextStyleHelper {
//   static TextStyleHelper? _instance;

//   TextStyleHelper._();

//   static TextStyleHelper get instance {
//     _instance ??= TextStyleHelper._();
//     return _instance!;
//   }

//   // Title Styles
//   // Medium text styles for titles and subtitles

//   TextStyle get title20RegularRoboto => TextStyle(
//         fontSize: 20.fSize,
//         fontWeight: FontWeight.w400,
//         fontFamily: 'Roboto',
//       );

//   TextStyle get title20BoldPTSerif => TextStyle(
//         fontSize: 20.fSize,
//         fontWeight: FontWeight.w700,
//         fontFamily: 'PT Serif',
//         color: appTheme.white_A700,
//       );

//   TextStyle get title20BoldPoppins => TextStyle(
//         fontSize: 20.fSize,
//         fontWeight: FontWeight.w700,
//         fontFamily: 'Poppins',
//       );

//   // Body Styles
//   // Standard text styles for body content

//   TextStyle get body15BoldPoppins => TextStyle(
//         fontSize: 15.fSize,
//         fontWeight: FontWeight.w700,
//         fontFamily: 'Poppins',
//         color: appTheme.black_900,
//       );

//   TextStyle get body14BoldPoppins => TextStyle(
//         fontSize: 14.fSize,
//         fontWeight: FontWeight.w700,
//         fontFamily: 'Poppins',
//         color: appTheme.black_900,
//       );

//   TextStyle get body12RegularPoppins => TextStyle(
//         fontSize: 12.fSize,
//         fontWeight: FontWeight.w400,
//         fontFamily: 'Poppins',
//         color: appTheme.gray_500,
//       );

//   TextStyle get body12BoldPoppins => TextStyle(
//         fontSize: 12.fSize,
//         fontWeight: FontWeight.w700,
//         fontFamily: 'Poppins',
//       );

//   // Label Styles
//   // Small text styles for labels, captions, and hints

//   TextStyle get label10RegularPoppins => TextStyle(
//         fontSize: 10.fSize,
//         fontWeight: FontWeight.w400,
//         fontFamily: 'Poppins',
//         color: appTheme.black_900,
//       );

//   TextStyle get label10SemiBoldPoppins => TextStyle(
//         fontSize: 10.fSize,
//         fontWeight: FontWeight.w600,
//         fontFamily: 'Poppins',
//         color: appTheme.black_900,
//       );

//   TextStyle get label8BoldInter => TextStyle(
//         fontSize: 8.fSize,
//         fontWeight: FontWeight.w700,
//         fontFamily: 'Inter',
//         color: appTheme.black_900,
//       );
// }

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waytofresh/core/app_expote.dart';
import 'package:waytofresh/theme/theme_helper.dart';

/// A helper class for managing text styles in the application
class TextStyleHelper {
  static TextStyleHelper? _instance;

  TextStyleHelper._();

  static TextStyleHelper get instance {
    _instance ??= TextStyleHelper._();
    return _instance!;
  }

  // Title Styles
  // Medium text styles for titles and subtitles

  TextStyle get title20RegularRoboto => GoogleFonts.poppins(
    fontSize: 20.fSize,
    fontWeight: FontWeight.w400,
    color: appTheme.black_900,
  );

  TextStyle get title20BoldPTSerif => GoogleFonts.poppins(
    fontSize: 20.fSize,
    fontWeight: FontWeight.w700,
    color: appTheme.white_A700,
  );

  TextStyle get title20BoldPoppins => GoogleFonts.poppins(
    fontSize: 20.fSize,
    fontWeight: FontWeight.w700,
    color: appTheme.black_900,
  );

  // Body Styles
  // Standard text styles for body content

  TextStyle get body15BoldPoppins => GoogleFonts.poppins(
    fontSize: 15.fSize,
    fontWeight: FontWeight.w700,
    color: appTheme.black_900,
  );

  TextStyle get body14BoldPoppins => GoogleFonts.poppins(
    fontSize: 14.fSize,
    fontWeight: FontWeight.w700,
    color: appTheme.black_900,
  );

  TextStyle get body12RegularPoppins => GoogleFonts.poppins(
    fontSize: 12.fSize,
    fontWeight: FontWeight.w400,
    color: appTheme.gray_500,
  );

  TextStyle get body12BoldPoppins => GoogleFonts.poppins(
    fontSize: 12.fSize,
    fontWeight: FontWeight.w700,
    color: appTheme.black_900,
  );

  // Label Styles
  // Small text styles for labels, captions, and hints

  TextStyle get label10RegularPoppins => GoogleFonts.poppins(
    fontSize: 10.fSize,
    fontWeight: FontWeight.w400,
    color: appTheme.black_900,
  );

  TextStyle get label10SemiBoldPoppins => GoogleFonts.poppins(
    fontSize: 10.fSize,
    fontWeight: FontWeight.w600,
    color: appTheme.black_900,
  );

  TextStyle get label8BoldInter => GoogleFonts.poppins(
    fontSize: 8.fSize,
    fontWeight: FontWeight.w700,
    color: appTheme.black_900,
  );
}
