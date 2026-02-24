import 'package:flutter/material.dart';

import '../../yo_ui.dart';

/// Device-specific extensions using YoAdaptive as source of truth
extension YoDeviceExtensions on BuildContext {
  // === SCREEN SIZE CHECKS ===
  // Uses YoAdaptive breakpoints as single source of truth

  bool get isPhone => YoAdaptive.isMobile(this);
  bool get isTablet => YoAdaptive.isTablet(this);

  bool get isLandscape => YoDeviceHelper.isLandscape(this);
  bool get isPortrait => YoDeviceHelper.isPortrait(this);

  // === SCREEN SIZE CATEGORIES ===

  ScreenSize get screenSize => YoDeviceHelper.getScreenSize(this);
  ScreenHeight get screenHeight => YoDeviceHelper.getScreenHeight(this);

  // === SCREEN DIMENSIONS ===

  double get width => MediaQuery.of(this).size.width;
  double get height => MediaQuery.of(this).size.height;

  // === DEVICE METRICS ===

  double get yoPixelRatio => YoDeviceHelper.getPixelRatio(this);
  double get yoTextScaleFactor => YoDeviceHelper.getTextScaleFactor(this);
  Brightness get yoPlatformBrightness =>
      YoDeviceHelper.getPlatformBrightness(this);

  // === SAFE AREA AND INSETS ===

  EdgeInsets get yoSafeArea => YoDeviceHelper.getSafeAreaPadding(this);
  EdgeInsets get yoViewPadding => YoDeviceHelper.getViewPadding(this);
  EdgeInsets get yoViewInsets => YoDeviceHelper.getViewInsets(this);

  // === NOTCH AND NAVIGATION BAR ===

  bool get yoHasNotch => YoDeviceHelper.hasNotch(this);
  double get yoNotchHeight => YoDeviceHelper.getNotchHeight(this);
  double get yoBottomNavBarHeight =>
      YoDeviceHelper.getBottomNavigationBarHeight(this);
  double get yoStatusBarHeight => YoDeviceHelper.getStatusBarHeight(this);

  // === KEYBOARD ===

  bool get yoKeyboardVisible => YoDeviceHelper.isKeyboardVisible(this);
  double get yoKeyboardHeight => YoDeviceHelper.getKeyboardHeight(this);

  // === SCREEN SIZE HELPERS ===

  bool get isSmallScreen => screenSize == ScreenSize.small;
  bool get isMediumScreen => screenSize == ScreenSize.medium;
  bool get isLargeScreen => screenSize == ScreenSize.large;

  // === RESPONSIVE HELPERS ===
  // Uses YoAdaptive.value as single source of truth

  /// Get responsive value based on screen size
  T responsiveValue<T>({required T phone, T? tablet, T? desktop}) {
    return YoAdaptive.value(
      this,
      mobile: phone,
      tablet: tablet,
      desktop: desktop,
    );
  }
}
