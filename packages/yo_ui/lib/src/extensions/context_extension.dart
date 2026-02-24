import 'package:flutter/material.dart';

import '../layout/yo_adaptive.dart';
import '../themes/yo_text_theme.dart';

/// Context extensions for theme-aware text styles and utilities
extension YoContextExtensions on BuildContext {
  // === TEXT STYLE EXTENSIONS ===

  TextStyle get yoDisplayLarge => YoTextTheme.displayLarge(this);
  TextStyle get yoDisplayMedium => YoTextTheme.displayMedium(this);
  TextStyle get yoDisplaySmall => YoTextTheme.displaySmall(this);
  TextStyle get yoHeadlineLarge => YoTextTheme.headlineLarge(this);
  TextStyle get yoHeadlineMedium => YoTextTheme.headlineMedium(this);
  TextStyle get yoHeadlineSmall => YoTextTheme.headlineSmall(this);
  TextStyle get yoTitleLarge => YoTextTheme.titleLarge(this);
  TextStyle get yoTitleMedium => YoTextTheme.titleMedium(this);
  TextStyle get yoTitleSmall => YoTextTheme.titleSmall(this);
  TextStyle get yoBodyLarge => YoTextTheme.bodyLarge(this);
  TextStyle get yoBodyMedium => YoTextTheme.bodyMedium(this);
  TextStyle get yoBodySmall => YoTextTheme.bodySmall(this);
  TextStyle get yoLabelLarge => YoTextTheme.labelLarge(this);
  TextStyle get yoLabelMedium => YoTextTheme.labelMedium(this);
  TextStyle get yoLabelSmall => YoTextTheme.labelSmall(this);
  TextStyle get yoCurrencyLarge => YoTextTheme.monoLarge(this);
  TextStyle get yoCurrencyMedium => YoTextTheme.monoMedium(this);
  TextStyle get yoCurrencySmall => YoTextTheme.monoSmall(this);

  // === STATIC SPACING (non-adaptive) ===
  // Use context.adaptiveXs, adaptiveSm, etc for adaptive spacing

  double get yoSpacingXs => 4;
  double get yoSpacingSm => 8;
  double get yoSpacingMd => 16;
  double get yoSpacingLg => 24;
  double get yoSpacingXl => 32;

  // === SCREEN HELPERS ===
  // Uses YoAdaptive as single source of truth

  double get yoScreenWidth => MediaQuery.of(this).size.width;
  double get yoScreenHeight => MediaQuery.of(this).size.height;

  /// @deprecated Use context.isMobile instead
  bool get yoIsMobile => YoAdaptive.isMobile(this);

  /// @deprecated Use context.isTablet instead
  bool get yoIsTablet => YoAdaptive.isTablet(this);

  /// @deprecated Use context.isDesktop instead
  bool get yoIsDesktop => YoAdaptive.isDesktop(this);
}
