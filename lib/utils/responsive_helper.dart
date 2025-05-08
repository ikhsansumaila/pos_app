import 'package:flutter/material.dart';

// Case on Samsung Galaxy Tab A9:

// | Orientasi | Width | Height | shortestSide                                                              |
// | --------- | ----- | ------ | ------------------------------------------------------------------------- |
// | Portrait  | 800   | 1340   | **800**                                                                   |
// | Landscape | 1340  | 800    | **800**        → setelah dibagi `devicePixelRatio ≈ 1.45`, menjadi `≈552` |

// 1340 physical px / 1.45 dpr ≈ 800 logical px.
// 800 physical px / 1.45 dpr ≈ 552 logical px.

class ResponsiveHelper {
  final Size screenSize;

  ResponsiveHelper(this.screenSize);

  double get width => screenSize.width;
  double get height => screenSize.height;

  bool get isLandscape => width > height;
  bool get isTablet {
    if (isLandscape) {
      // Dalam landscape, short side bisa kecil karena dpi, jadi pakai pendekatan lebar
      return width >= 1000 || height >= 600;
    } else {
      // Dalam portrait, pendekatan standar
      return screenSize.shortestSide >= 600;
    }
  }

  double get childAspectRatio {
    // Tablet
    if (isTablet && isLandscape) return 3.7; // tablet (landscape)
    if (isTablet) return 2.0; // tablet (portrait)

    // Smartphone
    if (isLandscape) return 2.0; // smartphone (landscape)
    return 1.7; // smartphone (portrait)
  }

  double fontSize(double size) {
    // Tablet
    if (isTablet && isLandscape) return size; // tablet (landscape)
    if (isTablet) return size - 2; // tablet (portrait)

    // Smartphone
    if (isLandscape) return size - 4; // smartphone (landscape)
    return size - 6; // smartphone (portrait)
  }

  double imageSize(double size) {
    if (isTablet && isLandscape) return size; // tablet (landscape)
    if (isTablet) return size - (10 / 100 * size); // tablet (portrait)

    // Smartphone
    if (isLandscape) return size - (30 / 100 * size); // smartphone (landscape)
    return size - (50 / 100 * size); // smartphone (portrait)
  }

  double getProductCardAspectRatio() {
    // Tablet
    if (isTablet && isLandscape) return 0.65; // tablet (landscape)
    if (isTablet) return 0.8; // tablet (portrait)

    // Smartphone
    if (isLandscape) return 0.9; // smartphone (landscape)
    return 1; // smartphone (portrait)
  }

  double getProductImageSize(double size) {
    // Tablet
    if (isTablet && isLandscape) return size; // tablet (landscape)
    if (isTablet) return size + (40 / 100 * size); // tablet (portrait)

    // Smartphone
    if (isLandscape) return size - (30 / 100 * size); // smartphone (landscape)
    return size - (50 / 100 * size); // smartphone (portrait)
  }

  int getProductCardListCount() {
    if (isLandscape) return 4;
    return 2;
  }
}
