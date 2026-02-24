import 'package:flutter/material.dart';

import 'yo_adaptive.dart';

/// @deprecated Use YoAdaptive instead
/// This class is kept for backward compatibility
class YoResponsive {
  /// @deprecated Use YoAdaptive.isMobile(context) instead
  static bool isMobile(BuildContext context) => YoAdaptive.isMobile(context);

  /// @deprecated Use YoAdaptive.isTablet(context) instead
  static bool isTablet(BuildContext context) => YoAdaptive.isTablet(context);

  /// @deprecated Use YoAdaptive.isDesktop(context) instead
  static bool isDesktop(BuildContext context) => YoAdaptive.isDesktop(context);

  /// @deprecated Use `YoAdaptive.value<T>()` instead
  static T responsiveValue<T>(
    BuildContext context, {
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    return YoAdaptive.value<T>(
      context,
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
    );
  }

  /// @deprecated Use `YoAdaptive.value<Widget>()` instead
  static Widget responsiveWidget({
    required BuildContext context,
    required Widget mobile,
    Widget? tablet,
    Widget? desktop,
  }) {
    return YoAdaptive.value<Widget>(
      context,
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
    );
  }
}
