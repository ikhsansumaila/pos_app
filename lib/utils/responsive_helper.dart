import 'package:flutter/material.dart';

class ResponsiveHelper {
  final Size screenSize;

  ResponsiveHelper(this.screenSize);

  double get width => screenSize.width;
  double get height => screenSize.height;

  bool get isLandscape => width > height;
  bool get isTablet => screenSize.shortestSide >= 600;

  // int get crossAxisCount {
  //   if (width >= 1200) return 5;
  //   if (width >= 900) return 4;
  //   if (width >= 600) return 3;
  //   return 2;
  // }

  double get childAspectRatio {
    if (isTablet && isLandscape) return 3.7; // tablet (landscape)
    if (isTablet) return 2.0; // tablet (portrait)
    if (isLandscape) return 2.0; // smartphone (landscape)
    return 1.7; // smartphone (portrait)
  }

  double fontSize(double size) {
    if (isTablet && isLandscape) return size; // tablet (landscape)
    if (isTablet) return size - 2; // tablet (portrait)
    if (isLandscape) return size - 6; // smartphone (landscape)
    return size - 8; // smartphone (portrait)
  }

  double imageSize(double size) {
    if (isTablet && isLandscape) return size; // tablet (landscape)
    if (isTablet) return size - (10 / 100 * size); // tablet (portrait)
    if (isLandscape) return size - (30 / 100 * size); // smartphone (landscape)
    return size - (50 / 100 * size); // smartphone (portrait)
  }
}
