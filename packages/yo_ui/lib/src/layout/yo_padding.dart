import 'package:flutter/material.dart';
import 'package:yo_ui/yo_ui.dart';

/// Padding presets dengan dukungan adaptive
class YoPadding {
  YoPadding._();

  // ===== STATIC ALL =====
  static const EdgeInsets all4 = EdgeInsets.all(4);
  static const EdgeInsets all8 = EdgeInsets.all(8);
  static const EdgeInsets all12 = EdgeInsets.all(12);
  static const EdgeInsets all16 = EdgeInsets.all(16);
  static const EdgeInsets all20 = EdgeInsets.all(20);
  static const EdgeInsets all24 = EdgeInsets.all(24);
  static const EdgeInsets all32 = EdgeInsets.all(32);

  // ===== STATIC SYMMETRIC HORIZONTAL =====
  static const EdgeInsets horizontal4 = EdgeInsets.symmetric(horizontal: 4);
  static const EdgeInsets horizontal8 = EdgeInsets.symmetric(horizontal: 8);
  static const EdgeInsets horizontal12 = EdgeInsets.symmetric(horizontal: 12);
  static const EdgeInsets horizontal16 = EdgeInsets.symmetric(horizontal: 16);
  static const EdgeInsets horizontal20 = EdgeInsets.symmetric(horizontal: 20);
  static const EdgeInsets horizontal24 = EdgeInsets.symmetric(horizontal: 24);
  static const EdgeInsets horizontal32 = EdgeInsets.symmetric(horizontal: 32);

  // ===== STATIC SYMMETRIC VERTICAL =====
  static const EdgeInsets vertical4 = EdgeInsets.symmetric(vertical: 4);
  static const EdgeInsets vertical8 = EdgeInsets.symmetric(vertical: 8);
  static const EdgeInsets vertical12 = EdgeInsets.symmetric(vertical: 12);
  static const EdgeInsets vertical16 = EdgeInsets.symmetric(vertical: 16);
  static const EdgeInsets vertical20 = EdgeInsets.symmetric(vertical: 20);
  static const EdgeInsets vertical24 = EdgeInsets.symmetric(vertical: 24);
  static const EdgeInsets vertical32 = EdgeInsets.symmetric(vertical: 32);

  // ===== STATIC ONLY =====
  static const EdgeInsets top4 = EdgeInsets.only(top: 4);
  static const EdgeInsets top8 = EdgeInsets.only(top: 8);
  static const EdgeInsets top12 = EdgeInsets.only(top: 12);
  static const EdgeInsets top16 = EdgeInsets.only(top: 16);
  static const EdgeInsets top24 = EdgeInsets.only(top: 24);

  static const EdgeInsets bottom4 = EdgeInsets.only(bottom: 4);
  static const EdgeInsets bottom8 = EdgeInsets.only(bottom: 8);
  static const EdgeInsets bottom12 = EdgeInsets.only(bottom: 12);
  static const EdgeInsets bottom16 = EdgeInsets.only(bottom: 16);
  static const EdgeInsets bottom24 = EdgeInsets.only(bottom: 24);

  static const EdgeInsets left4 = EdgeInsets.only(left: 4);
  static const EdgeInsets left8 = EdgeInsets.only(left: 8);
  static const EdgeInsets left12 = EdgeInsets.only(left: 12);
  static const EdgeInsets left16 = EdgeInsets.only(left: 16);
  static const EdgeInsets left24 = EdgeInsets.only(left: 24);

  static const EdgeInsets right4 = EdgeInsets.only(right: 4);
  static const EdgeInsets right8 = EdgeInsets.only(right: 8);
  static const EdgeInsets right12 = EdgeInsets.only(right: 12);
  static const EdgeInsets right16 = EdgeInsets.only(right: 16);
  static const EdgeInsets right24 = EdgeInsets.only(right: 24);

  // ===== ADAPTIVE PADDING =====

  /// Adaptive page padding (adjusts to screen size)
  static EdgeInsets page(BuildContext context) =>
      YoAdaptive.pagePadding(context);

  /// Adaptive card padding
  static EdgeInsets card(BuildContext context) =>
      YoAdaptive.cardPadding(context);

  /// Adaptive section padding
  static EdgeInsets section(BuildContext context) =>
      YoAdaptive.sectionPadding(context);

  /// Adaptive list item padding
  static EdgeInsets listItem(BuildContext context) =>
      YoAdaptive.listItemPadding(context);

  /// Adaptive button padding
  static EdgeInsets button(BuildContext context) =>
      YoAdaptive.buttonPadding(context);

  /// Adaptive input padding
  static EdgeInsets input(BuildContext context) =>
      YoAdaptive.inputPadding(context);

  /// Adaptive all sides
  static EdgeInsets adaptiveAll(
    BuildContext context, {
    YoSpacingSize size = YoSpacingSize.md,
  }) {
    final value = _getAdaptiveValue(context, size);
    return EdgeInsets.all(value);
  }

  /// Adaptive horizontal
  static EdgeInsets adaptiveHorizontal(
    BuildContext context, {
    YoSpacingSize size = YoSpacingSize.md,
  }) {
    final value = _getAdaptiveValue(context, size);
    return EdgeInsets.symmetric(horizontal: value);
  }

  /// Adaptive vertical
  static EdgeInsets adaptiveVertical(
    BuildContext context, {
    YoSpacingSize size = YoSpacingSize.md,
  }) {
    final value = _getAdaptiveValue(context, size);
    return EdgeInsets.symmetric(vertical: value);
  }

  /// Adaptive symmetric
  static EdgeInsets adaptiveSymmetric(
    BuildContext context, {
    YoSpacingSize horizontal = YoSpacingSize.md,
    YoSpacingSize vertical = YoSpacingSize.md,
  }) {
    return EdgeInsets.symmetric(
      horizontal: _getAdaptiveValue(context, horizontal),
      vertical: _getAdaptiveValue(context, vertical),
    );
  }

  // ===== CUSTOM =====

  static EdgeInsets fromLTRB(
    double left,
    double top,
    double right,
    double bottom,
  ) {
    return EdgeInsets.fromLTRB(left, top, right, bottom);
  }

  static EdgeInsets only({
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) {
    return EdgeInsets.only(left: left, top: top, right: right, bottom: bottom);
  }

  // Helper
  static double _getAdaptiveValue(BuildContext context, YoSpacingSize size) {
    switch (size) {
      case YoSpacingSize.xs:
        return YoAdaptive.spacingXs(context);
      case YoSpacingSize.sm:
        return YoAdaptive.spacingSm(context);
      case YoSpacingSize.md:
        return YoAdaptive.spacingMd(context);
      case YoSpacingSize.lg:
        return YoAdaptive.spacingLg(context);
      case YoSpacingSize.xl:
        return YoAdaptive.spacingXl(context);
    }
  }
}

/// Spacing size enum for adaptive values
enum YoSpacingSize { xs, sm, md, lg, xl }
