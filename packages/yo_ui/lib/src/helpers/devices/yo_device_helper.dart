import 'dart:io' show Platform;

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../layout/yo_adaptive.dart';

/// Device helper for hardware/platform specific information
/// For responsive/screen size checks, use YoAdaptive instead
class YoDeviceHelper {
  // === DEVICE INFORMATION (Platform specific) ===

  static Future<Map<String, dynamic>> getDeviceInfo() async {
    final deviceData = <String, dynamic>{};
    final deviceInfo = DeviceInfoPlugin();

    try {
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        deviceData['platform'] = 'Android';
        deviceData['version'] = androidInfo.version.release;
        deviceData['model'] = androidInfo.model;
        deviceData['brand'] = androidInfo.brand;
        deviceData['device'] = androidInfo.device;
        deviceData['id'] = androidInfo.id;
        deviceData['manufacturer'] = androidInfo.manufacturer;
        deviceData['sdkVersion'] = androidInfo.version.sdkInt;
        deviceData['isPhysicalDevice'] = androidInfo.isPhysicalDevice;
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        deviceData['platform'] = 'iOS';
        deviceData['version'] = iosInfo.systemVersion;
        deviceData['model'] = iosInfo.model;
        deviceData['name'] = iosInfo.name;
        deviceData['utsname'] = iosInfo.utsname.machine;
        deviceData['isPhysicalDevice'] = iosInfo.isPhysicalDevice;
      } else if (Platform.isWindows) {
        final windowsInfo = await deviceInfo.windowsInfo;
        deviceData['platform'] = 'Windows';
        deviceData['version'] = windowsInfo.displayVersion;
        deviceData['model'] = windowsInfo.productName;
        deviceData['deviceId'] = windowsInfo.deviceId;
      } else if (Platform.isMacOS) {
        final macInfo = await deviceInfo.macOsInfo;
        deviceData['platform'] = 'macOS';
        deviceData['model'] = macInfo.model;
        deviceData['version'] = macInfo.osRelease;
        deviceData['kernel'] = macInfo.kernelVersion;
      } else if (Platform.isLinux) {
        final linuxInfo = await deviceInfo.linuxInfo;
        deviceData['platform'] = 'Linux';
        deviceData['version'] = linuxInfo.version;
        deviceData['name'] = linuxInfo.name;
        deviceData['id'] = linuxInfo.id;
      }
    } catch (e) {
      deviceData['platform'] = 'Unknown';
      deviceData['error'] = e.toString();
    }

    return deviceData;
  }

  // === SCREEN SIZE CHECKS ===
  // Uses YoAdaptive as single source of truth

  /// @deprecated Use YoAdaptive.isTablet(context) instead
  static bool isTablet(BuildContext context) => YoAdaptive.isTablet(context);

  /// @deprecated Use YoAdaptive.isMobile(context) instead
  static bool isPhone(BuildContext context) => YoAdaptive.isMobile(context);

  // === ORIENTATION ===

  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  static bool isPortrait(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait;
  }

  // === SCREEN SIZE CATEGORIES ===

  static ScreenSize getScreenSize(BuildContext context) {
    final type = YoAdaptive.getDeviceType(context);
    switch (type) {
      case YoDeviceType.mobile:
        return ScreenSize.small;
      case YoDeviceType.tablet:
        return ScreenSize.medium;
      case YoDeviceType.desktop:
      case YoDeviceType.largeDesktop:
        return ScreenSize.large;
    }
  }

  static ScreenHeight getScreenHeight(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    if (height < 600) return ScreenHeight.small;
    if (height < 900) return ScreenHeight.medium;
    return ScreenHeight.large;
  }

  // === DEVICE METRICS ===

  static double getPixelRatio(BuildContext context) {
    return MediaQuery.of(context).devicePixelRatio;
  }

  static double getTextScaleFactor(BuildContext context) {
    return MediaQuery.of(context).textScaler.scale(1.0);
  }

  static Brightness getPlatformBrightness(BuildContext context) {
    return MediaQuery.of(context).platformBrightness;
  }

  // === SAFE AREA AND INSETS ===

  static EdgeInsets getSafeAreaPadding(BuildContext context) {
    return MediaQuery.of(context).padding;
  }

  static EdgeInsets getViewPadding(BuildContext context) {
    return MediaQuery.of(context).viewPadding;
  }

  static EdgeInsets getViewInsets(BuildContext context) {
    return MediaQuery.of(context).viewInsets;
  }

  // === NOTCH AND NAVIGATION BAR ===

  static bool hasNotch(BuildContext context) {
    final padding = MediaQuery.of(context).padding;
    return padding.top > 24;
  }

  static double getNotchHeight(BuildContext context) {
    return MediaQuery.of(context).padding.top;
  }

  static double getBottomNavigationBarHeight(BuildContext context) {
    return MediaQuery.of(context).padding.bottom;
  }

  static double getStatusBarHeight(BuildContext context) {
    return MediaQuery.of(context).padding.top;
  }

  // === KEYBOARD ===

  static bool isKeyboardVisible(BuildContext context) {
    return MediaQuery.of(context).viewInsets.bottom > 0;
  }

  static double getKeyboardHeight(BuildContext context) {
    return MediaQuery.of(context).viewInsets.bottom;
  }

  // === PLATFORM TYPE ===

  static PlatformType getPlatformType() {
    if (kIsWeb) return PlatformType.web;
    if (Platform.isAndroid) return PlatformType.android;
    if (Platform.isIOS) return PlatformType.ios;
    if (Platform.isWindows) return PlatformType.windows;
    if (Platform.isMacOS) return PlatformType.macos;
    if (Platform.isLinux) return PlatformType.linux;
    return PlatformType.unknown;
  }

  static String getPlatformName() {
    if (kIsWeb) return 'Web';
    if (Platform.isAndroid) return 'Android';
    if (Platform.isIOS) return 'iOS';
    if (Platform.isWindows) return 'Windows';
    if (Platform.isMacOS) return 'macOS';
    if (Platform.isLinux) return 'Linux';
    return 'Unknown';
  }

  static bool get isWeb => kIsWeb;
  static bool get isMobile => !kIsWeb && (Platform.isAndroid || Platform.isIOS);
  static bool get isDesktop =>
      !kIsWeb && (Platform.isWindows || Platform.isMacOS || Platform.isLinux);
}

// === ENUMS ===

enum ScreenSize { small, medium, large }

enum ScreenHeight { small, medium, large }

enum PlatformType { android, ios, windows, macos, linux, web, unknown }
