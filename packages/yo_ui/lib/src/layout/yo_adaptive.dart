import 'package:flutter/material.dart';

/// Breakpoints untuk responsive design
class YoBreakpoints {
  YoBreakpoints._();

  /// Mobile: 0 - 599
  static const double mobile = 0;

  /// Tablet: 600 - 1023
  static const double tablet = 600;

  /// Desktop: 1024 - 1439
  static const double desktop = 1024;

  /// Large Desktop: 1440+
  static const double largeDesktop = 1440;
}

/// Device type enum
enum YoDeviceType { mobile, tablet, desktop, largeDesktop }

/// Adaptive Design System - nilai yang menyesuaikan berdasarkan screen size
class YoAdaptive {
  YoAdaptive._();

  /// Get current device type
  static YoDeviceType getDeviceType(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= YoBreakpoints.largeDesktop) return YoDeviceType.largeDesktop;
    if (width >= YoBreakpoints.desktop) return YoDeviceType.desktop;
    if (width >= YoBreakpoints.tablet) return YoDeviceType.tablet;
    return YoDeviceType.mobile;
  }

  /// Check device type
  static bool isMobile(BuildContext context) =>
      getDeviceType(context) == YoDeviceType.mobile;

  static bool isTablet(BuildContext context) =>
      getDeviceType(context) == YoDeviceType.tablet;

  static bool isDesktop(BuildContext context) =>
      getDeviceType(context) == YoDeviceType.desktop ||
      getDeviceType(context) == YoDeviceType.largeDesktop;

  /// Responsive value helper
  static T value<T>(
    BuildContext context, {
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    final type = getDeviceType(context);
    switch (type) {
      case YoDeviceType.largeDesktop:
      case YoDeviceType.desktop:
        return desktop ?? tablet ?? mobile;
      case YoDeviceType.tablet:
        return tablet ?? mobile;
      case YoDeviceType.mobile:
        return mobile;
    }
  }

  // ===== ADAPTIVE SPACING =====

  /// Extra small spacing (4-6-8)
  static double spacingXs(BuildContext context) =>
      value(context, mobile: 4, tablet: 5, desktop: 6);

  /// Small spacing (8-10-12)
  static double spacingSm(BuildContext context) =>
      value(context, mobile: 8, tablet: 10, desktop: 12);

  /// Medium spacing (16-20-24)
  static double spacingMd(BuildContext context) =>
      value(context, mobile: 16, tablet: 20, desktop: 24);

  /// Large spacing (24-28-32)
  static double spacingLg(BuildContext context) =>
      value(context, mobile: 24, tablet: 28, desktop: 32);

  /// Extra large spacing (32-40-48)
  static double spacingXl(BuildContext context) =>
      value(context, mobile: 32, tablet: 40, desktop: 48);

  /// 2x extra large spacing (48-56-64)
  static double spacing2xl(BuildContext context) =>
      value(context, mobile: 48, tablet: 56, desktop: 64);

  // ===== ADAPTIVE PADDING =====

  /// Page/screen padding
  static EdgeInsets pagePadding(BuildContext context) {
    final h = value<double>(context, mobile: 16, tablet: 24, desktop: 32);
    final v = value<double>(context, mobile: 16, tablet: 20, desktop: 24);
    return EdgeInsets.symmetric(horizontal: h, vertical: v);
  }

  /// Card padding
  static EdgeInsets cardPadding(BuildContext context) {
    final p = value<double>(context, mobile: 16, tablet: 20, desktop: 24);
    return EdgeInsets.all(p);
  }

  /// Section padding (vertical spacing between sections)
  static EdgeInsets sectionPadding(BuildContext context) {
    final v = value<double>(context, mobile: 24, tablet: 32, desktop: 48);
    return EdgeInsets.symmetric(vertical: v);
  }

  /// List item padding
  static EdgeInsets listItemPadding(BuildContext context) {
    final h = value<double>(context, mobile: 16, tablet: 20, desktop: 24);
    final v = value<double>(context, mobile: 12, tablet: 14, desktop: 16);
    return EdgeInsets.symmetric(horizontal: h, vertical: v);
  }

  /// Button padding
  static EdgeInsets buttonPadding(BuildContext context) {
    final h = value<double>(context, mobile: 16, tablet: 20, desktop: 24);
    final v = value<double>(context, mobile: 12, tablet: 14, desktop: 16);
    return EdgeInsets.symmetric(horizontal: h, vertical: v);
  }

  /// Input field padding
  static EdgeInsets inputPadding(BuildContext context) {
    final h = value<double>(context, mobile: 16, tablet: 18, desktop: 20);
    final v = value<double>(context, mobile: 14, tablet: 16, desktop: 18);
    return EdgeInsets.symmetric(horizontal: h, vertical: v);
  }

  // ===== ADAPTIVE BORDER RADIUS =====

  /// Small radius (4-6-8)
  static double radiusSm(BuildContext context) =>
      value(context, mobile: 4, tablet: 6, desktop: 8);

  /// Medium radius (8-10-12)
  static double radiusMd(BuildContext context) =>
      value(context, mobile: 8, tablet: 10, desktop: 12);

  /// Large radius (12-14-16)
  static double radiusLg(BuildContext context) =>
      value(context, mobile: 12, tablet: 14, desktop: 16);

  /// Extra large radius (16-20-24)
  static double radiusXl(BuildContext context) =>
      value(context, mobile: 16, tablet: 20, desktop: 24);

  /// BorderRadius helpers
  static BorderRadius borderRadiusSm(BuildContext context) =>
      BorderRadius.circular(radiusSm(context));

  static BorderRadius borderRadiusMd(BuildContext context) =>
      BorderRadius.circular(radiusMd(context));

  static BorderRadius borderRadiusLg(BuildContext context) =>
      BorderRadius.circular(radiusLg(context));

  static BorderRadius borderRadiusXl(BuildContext context) =>
      BorderRadius.circular(radiusXl(context));

  // ===== ADAPTIVE FONT SIZE =====

  /// Display text (28-36-44)
  static double fontDisplay(BuildContext context) =>
      value(context, mobile: 28, tablet: 36, desktop: 44);

  /// Headline text (22-26-32)
  static double fontHeadline(BuildContext context) =>
      value(context, mobile: 22, tablet: 26, desktop: 32);

  /// Title text (18-20-24)
  static double fontTitle(BuildContext context) =>
      value(context, mobile: 18, tablet: 20, desktop: 24);

  /// Body text (14-15-16)
  static double fontBody(BuildContext context) =>
      value(context, mobile: 14, tablet: 15, desktop: 16);

  /// Caption text (12-13-14)
  static double fontCaption(BuildContext context) =>
      value(context, mobile: 12, tablet: 13, desktop: 14);

  // ===== ADAPTIVE ICON SIZE =====

  /// Small icon (18-20-22)
  static double iconSm(BuildContext context) =>
      value(context, mobile: 18, tablet: 20, desktop: 22);

  /// Medium icon (22-24-26)
  static double iconMd(BuildContext context) =>
      value(context, mobile: 22, tablet: 24, desktop: 26);

  /// Large icon (28-32-36)
  static double iconLg(BuildContext context) =>
      value(context, mobile: 28, tablet: 32, desktop: 36);

  // ===== ADAPTIVE LAYOUT =====

  /// Maximum content width
  static double maxContentWidth(BuildContext context) =>
      value(context, mobile: double.infinity, tablet: 720, desktop: 1200);

  /// Grid columns count
  static int gridColumns(BuildContext context) =>
      value(context, mobile: 2, tablet: 3, desktop: 4);

  /// Grid spacing
  static double gridSpacing(BuildContext context) =>
      value(context, mobile: 12, tablet: 16, desktop: 20);
}

/// Extension for easy access via context
extension YoAdaptiveContext on BuildContext {
  // Device Type
  YoDeviceType get deviceType => YoAdaptive.getDeviceType(this);
  bool get isMobile => YoAdaptive.isMobile(this);
  bool get isTablet => YoAdaptive.isTablet(this);
  bool get isDesktop => YoAdaptive.isDesktop(this);

  // Spacing
  double get adaptiveXs => YoAdaptive.spacingXs(this);
  double get adaptiveSm => YoAdaptive.spacingSm(this);
  double get adaptiveMd => YoAdaptive.spacingMd(this);
  double get adaptiveLg => YoAdaptive.spacingLg(this);
  double get adaptiveXl => YoAdaptive.spacingXl(this);

  // Padding
  EdgeInsets get adaptivePagePadding => YoAdaptive.pagePadding(this);
  EdgeInsets get adaptiveCardPadding => YoAdaptive.cardPadding(this);
  EdgeInsets get adaptiveSectionPadding => YoAdaptive.sectionPadding(this);
  EdgeInsets get adaptiveListPadding => YoAdaptive.listItemPadding(this);

  // Border Radius
  BorderRadius get adaptiveRadiusSm => YoAdaptive.borderRadiusSm(this);
  BorderRadius get adaptiveRadiusMd => YoAdaptive.borderRadiusMd(this);
  BorderRadius get adaptiveRadiusLg => YoAdaptive.borderRadiusLg(this);
  BorderRadius get adaptiveRadiusXl => YoAdaptive.borderRadiusXl(this);

  // Font Size
  double get adaptiveFontDisplay => YoAdaptive.fontDisplay(this);
  double get adaptiveFontHeadline => YoAdaptive.fontHeadline(this);
  double get adaptiveFontTitle => YoAdaptive.fontTitle(this);
  double get adaptiveFontBody => YoAdaptive.fontBody(this);

  // Icon Size
  double get adaptiveIconSm => YoAdaptive.iconSm(this);
  double get adaptiveIconMd => YoAdaptive.iconMd(this);
  double get adaptiveIconLg => YoAdaptive.iconLg(this);

  // Layout
  double get adaptiveMaxWidth => YoAdaptive.maxContentWidth(this);
  int get adaptiveGridColumns => YoAdaptive.gridColumns(this);
  double get adaptiveGridSpacing => YoAdaptive.gridSpacing(this);
}
