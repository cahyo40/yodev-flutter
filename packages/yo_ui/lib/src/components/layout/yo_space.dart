import 'package:flutter/material.dart';
import 'package:yo_ui/yo_ui.dart';

/// Adaptive Space widget yang menyesuaikan ukuran berdasarkan screen size
class YoSpace extends StatelessWidget {
  final double? width;
  final double? height;
  final bool adaptive;

  const YoSpace({super.key, this.width, this.height, this.adaptive = false});

  // ===== STATIC SPACERS =====

  const YoSpace.width(double w, {super.key})
    : width = w,
      height = null,
      adaptive = false;

  const YoSpace.height(double h, {super.key})
    : width = null,
      height = h,
      adaptive = false;

  // Predefined static spacing
  const YoSpace.xs({super.key}) : width = 4, height = 4, adaptive = false;

  const YoSpace.sm({super.key}) : width = 8, height = 8, adaptive = false;

  const YoSpace.md({super.key}) : width = 16, height = 16, adaptive = false;

  const YoSpace.lg({super.key}) : width = 24, height = 24, adaptive = false;

  const YoSpace.xl({super.key}) : width = 32, height = 32, adaptive = false;

  // Width-only spacers
  const YoSpace.widthXs({super.key})
    : width = 4,
      height = null,
      adaptive = false;

  const YoSpace.widthSm({super.key})
    : width = 8,
      height = null,
      adaptive = false;

  const YoSpace.widthMd({super.key})
    : width = 16,
      height = null,
      adaptive = false;

  const YoSpace.widthLg({super.key})
    : width = 24,
      height = null,
      adaptive = false;

  const YoSpace.widthXl({super.key})
    : width = 32,
      height = null,
      adaptive = false;

  // Height-only spacers
  const YoSpace.heightXs({super.key})
    : width = null,
      height = 4,
      adaptive = false;

  const YoSpace.heightSm({super.key})
    : width = null,
      height = 8,
      adaptive = false;

  const YoSpace.heightMd({super.key})
    : width = null,
      height = 16,
      adaptive = false;

  const YoSpace.heightLg({super.key})
    : width = null,
      height = 24,
      adaptive = false;

  const YoSpace.heightXl({super.key})
    : width = null,
      height = 32,
      adaptive = false;

  // ===== ADAPTIVE SPACERS =====

  /// Adaptive extra small spacing (menyesuaikan screen size)
  const YoSpace.adaptiveXs({super.key})
    : width = null,
      height = null,
      adaptive = true;

  /// Adaptive small spacing
  const YoSpace.adaptiveSm({super.key})
    : width = 1,
      height = 1,
      adaptive = true;

  /// Adaptive medium spacing
  const YoSpace.adaptiveMd({super.key})
    : width = 2,
      height = 2,
      adaptive = true;

  /// Adaptive large spacing
  const YoSpace.adaptiveLg({super.key})
    : width = 3,
      height = 3,
      adaptive = true;

  /// Adaptive extra large spacing
  const YoSpace.adaptiveXl({super.key})
    : width = 4,
      height = 4,
      adaptive = true;

  @override
  Widget build(BuildContext context) {
    if (adaptive) {
      // Use adaptive sizing based on marker value
      final size = _getAdaptiveSize(context);
      return SizedBox(width: size, height: size);
    }

    return SizedBox(width: width, height: height);
  }

  double _getAdaptiveSize(BuildContext context) {
    // width/height digunakan sebagai marker untuk ukuran
    final marker = (width ?? height ?? 0).toInt();

    switch (marker) {
      case 0:
        return YoAdaptive.spacingXs(context);
      case 1:
        return YoAdaptive.spacingSm(context);
      case 2:
        return YoAdaptive.spacingMd(context);
      case 3:
        return YoAdaptive.spacingLg(context);
      case 4:
        return YoAdaptive.spacingXl(context);
      default:
        return YoAdaptive.spacingMd(context);
    }
  }
}

/// Adaptive SizedBox untuk layout
class YoBox extends StatelessWidget {
  final Widget? child;
  final double? width;
  final double? height;

  const YoBox({super.key, this.child, this.width, this.height});

  /// Full width box
  const YoBox.expand({super.key, this.child})
    : width = double.infinity,
      height = double.infinity;

  /// Full width only
  const YoBox.expandWidth({super.key, this.child, this.height})
    : width = double.infinity;

  /// Full height only
  const YoBox.expandHeight({super.key, this.child, this.width})
    : height = double.infinity;

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: width, height: height, child: child);
  }
}
