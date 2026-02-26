import 'package:flutter/widgets.dart';

class SizeConfig {
  static late double screenWidth;
  static late double screenHeight;
  static late double scaleWidth;
  static late double scaleHeight;

  static const double figmaWidth = 375; // Figma ka design width
  static const double figmaHeight = 812; // Figma ka design height
  // Tablet dimensions
  static const double tabletFigmaWidth = 820; // Tablet design width
  static const double tabletFigmaHeight = 1180; // Tablet design height
  static late bool isTablet; // ✅ NEW: Tablet detection

  static void init(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);
    screenWidth = mediaQueryData.size.width;
    screenHeight = mediaQueryData.size.height;

    // ✅ Tablet detection (600+ width is typically tablet)
    isTablet = screenWidth >= 600;

    if (isTablet) {
      // Tablet ka scale
      scaleWidth = screenWidth / tabletFigmaWidth;
      scaleHeight = screenHeight / tabletFigmaHeight;
    } else {
      // Phone ka scale
      scaleWidth = screenWidth / figmaWidth;
      scaleHeight = screenHeight / figmaHeight;
    }
  }

  // Width adjust karne ka function
  static double w(double width) => width * scaleWidth;

  // Height adjust karne ka function
  static double h(double height) => height * scaleHeight;

  // Font size adjust karne ka function
  static double sp(double fontSize) => fontSize * scaleWidth;
}
