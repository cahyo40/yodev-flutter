import 'package:flutter/material.dart';

class YoSpacing {
  // Spacing scale
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;

  // Border radius
  static const BorderRadius borderRadiusSm = BorderRadius.all(
    Radius.circular(4),
  );
  static const BorderRadius borderRadiusMd = BorderRadius.all(
    Radius.circular(8),
  );
  static const BorderRadius borderRadiusLg = BorderRadius.all(
    Radius.circular(12),
  );
  static const BorderRadius borderRadiusXl = BorderRadius.all(
    Radius.circular(16),
  );

  // Container max widths
  static const double containerSm = 640;
  static const double containerMd = 768;
  static const double containerLg = 1024;
  static const double containerXl = 1280;
}
