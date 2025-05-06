import 'dart:developer';

import 'package:flutter/material.dart';

class ResponsiveHelper {
  final Size screenSize;

  ResponsiveHelper(this.screenSize);

  double get width => screenSize.width;
  double get height => screenSize.height;

  bool get isLandscape => width > height;
  bool get isTablet => screenSize.shortestSide >= 600;

  int get crossAxisCount {
    if (width >= 1200) return 5;
    if (width >= 900) return 4;
    if (width >= 600) return 3;
    return 2;
  }

  double get childAspectRatio {
    if (isTablet) {
      return isLandscape ? 2.5 : 2.0;
    } else {
      return isLandscape ? 2.0 : 1.7;
    }
  }

  double fontSize(double size) {
    if (width >= 1200) return size;
    if (width >= 900) return size - 2;
    // if (width >= 600) return size - 4;
    return size - 4;
  }

  double imageSize(double size) {
    log("screenSize.shortestSide ${screenSize.shortestSide}");
    if (width >= 1200) return size;
    if (width >= 900) return size - 15;
    return size - 30;
  }
}
