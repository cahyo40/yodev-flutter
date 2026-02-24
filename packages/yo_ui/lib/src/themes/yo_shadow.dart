import 'package:flutter/material.dart';

import '../../yo_ui.dart';

/// Utility shadow presets yang otomatis mengikuti tema (dark/light)
/// Semua method return `List<BoxShadow>` siap pakai di BoxDecoration
class YoBoxShadow {
  const YoBoxShadow._();

  /* --------------------------------------------------------------- */
  /* 8. Button – khusus untuk button dengan primary tint             */
  /* --------------------------------------------------------------- */
  static List<BoxShadow> button(
    BuildContext context, {
    double blur = 12,
    double y = 4,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return [
      BoxShadow(
        color: context.primaryColor.withAlpha(isDark ? 89 : 51),
        blurRadius: blur,
        offset: Offset(0, y),
      ),
      BoxShadow(
        color: Colors.black.withAlpha(isDark ? 102 : 31),
        blurRadius: blur * 2,
        offset: Offset(0, y * 2),
      ),
    ];
  }

  /* --------------------------------------------------------------- */
  /* 10. Directional – shadow dengan arah custom                     */
  /* --------------------------------------------------------------- */
  static List<BoxShadow> directional(
    BuildContext context, {
    double x = 4,
    double y = 4,
    double blur = 12,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return [
      BoxShadow(
        color: Colors.black.withAlpha(isDark ? 77 : 20),
        blurRadius: blur,
        offset: Offset(x, y),
      ),
    ];
  }

  /* --------------------------------------------------------------- */
  /* 2. Elevated – bayangan standar untuk elevated surfaces          */
  /* --------------------------------------------------------------- */
  static List<BoxShadow> elevated(
    BuildContext context, {
    double blur = 12,
    double y = 4,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return [
      BoxShadow(
        color: Colors.black.withAlpha(isDark ? 102 : 15),
        blurRadius: blur,
        offset: Offset(0, y),
      ),
      BoxShadow(
        color: Colors.black.withAlpha(isDark ? 77 : 10),
        blurRadius: blur / 2,
        offset: Offset(0, y / 2),
      ),
    ];
  }

  /// Elevation 0 - No shadow
  static List<BoxShadow> elevation0() => none();

  /// Elevation 1 - Raised button, card resting
  static List<BoxShadow> elevation1(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return [
      BoxShadow(
        color: Colors.black.withAlpha(isDark ? 64 : 20),
        blurRadius: 2,
        offset: const Offset(0, 1),
      ),
    ];
  }

  /// Elevation 12 - Dialog
  static List<BoxShadow> elevation12(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return [
      BoxShadow(
        color: Colors.black.withAlpha(isDark ? 128 : 64),
        blurRadius: 24,
        offset: const Offset(0, 12),
      ),
    ];
  }

  /// Elevation 16 - Navigation drawer
  static List<BoxShadow> elevation16(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return [
      BoxShadow(
        color: Colors.black.withAlpha(isDark ? 140 : 77),
        blurRadius: 32,
        offset: const Offset(0, 16),
      ),
    ];
  }

  /// Elevation 2 - Raised button pressed
  static List<BoxShadow> elevation2(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return [
      BoxShadow(
        color: Colors.black.withAlpha(isDark ? 77 : 31),
        blurRadius: 4,
        offset: const Offset(0, 2),
      ),
    ];
  }

  /// Elevation 24 - Modal bottom sheet
  static List<BoxShadow> elevation24(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return [
      BoxShadow(
        color: Colors.black.withAlpha(isDark ? 153 : 89),
        blurRadius: 48,
        offset: const Offset(0, 24),
      ),
    ];
  }

  /// Elevation 3 - Refresh indicator, search bar
  static List<BoxShadow> elevation3(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return [
      BoxShadow(
        color: Colors.black.withAlpha(isDark ? 77 : 31),
        blurRadius: 8,
        offset: const Offset(0, 3),
      ),
    ];
  }

  /// Elevation 4 - App bar, FAB resting
  static List<BoxShadow> elevation4(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return [
      BoxShadow(
        color: Colors.black.withAlpha(isDark ? 89 : 38),
        blurRadius: 10,
        offset: const Offset(0, 4),
      ),
    ];
  }

  /// Elevation 6 - FAB pressed, snackbar
  static List<BoxShadow> elevation6(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return [
      BoxShadow(
        color: Colors.black.withAlpha(isDark ? 102 : 46),
        blurRadius: 12,
        offset: const Offset(0, 6),
      ),
    ];
  }

  /// Elevation 8 - Card modal, drawer
  static List<BoxShadow> elevation8(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return [
      BoxShadow(
        color: Colors.black.withAlpha(isDark ? 115 : 51),
        blurRadius: 16,
        offset: const Offset(0, 8),
      ),
    ];
  }

  static List<BoxShadow> error(
    BuildContext context, {
    double blur = 16,
    double y = 4,
  }) {
    return [
      BoxShadow(
        color: context.errorColor.withAlpha(51),
        blurRadius: blur,
        offset: Offset(0, y),
      ),
    ];
  }

  /* --------------------------------------------------------------- */
  /* 7. Float – bayangan untuk floating elements (FAB, modal)        */
  /* --------------------------------------------------------------- */
  static List<BoxShadow> float(
    BuildContext context, {
    double blur = 24,
    double y = 8,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return [
      BoxShadow(
        color: Colors.black.withAlpha(isDark ? 128 : 31),
        blurRadius: blur,
        offset: Offset(0, y),
      ),
    ];
  }

  /* --------------------------------------------------------------- */
  /* 5. Glow – efek glow untuk highlight elements                    */
  /* --------------------------------------------------------------- */
  static List<BoxShadow> glow(
    BuildContext context, {
    Color? color,
    double blur = 24,
    double spread = 0,
  }) {
    final glowColor = color ?? context.primaryColor;
    return [
      BoxShadow(
        color: glowColor.withAlpha(56),
        blurRadius: blur,
        spreadRadius: spread,
        offset: Offset.zero,
      ),
    ];
  }

  /* --------------------------------------------------------------- */
  /* 13. Hover – shadow for hover state                              */
  /* --------------------------------------------------------------- */
  static List<BoxShadow> hover(
    BuildContext context, {
    double blur = 20,
    double y = 6,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return [
      BoxShadow(
        color: Colors.black.withAlpha(isDark ? 102 : 26),
        blurRadius: blur,
        offset: Offset(0, y),
      ),
      BoxShadow(
        color: context.primaryColor.withAlpha(31),
        blurRadius: blur * 1.5,
        offset: Offset(0, y * 1.5),
      ),
    ];
  }

  static List<BoxShadow> info(
    BuildContext context, {
    double blur = 16,
    double y = 4,
  }) {
    return [
      BoxShadow(
        color: context.infoColor.withAlpha(51),
        blurRadius: blur,
        offset: Offset(0, y),
      ),
    ];
  }

  /* --------------------------------------------------------------- */
  /* 12. Inner – inner shadow effect                                 */
  /* --------------------------------------------------------------- */
  static List<BoxShadow> inner(
    BuildContext context, {
    double blur = 8,
    double spread = -4,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return [
      BoxShadow(
        color: Colors.black.withAlpha(isDark ? 102 : 26),
        blurRadius: blur,
        spreadRadius: spread,
        offset: const Offset(0, 2),
      ),
    ];
  }

  /* --------------------------------------------------------------- */
  /* 17. Elevation levels (Material Design inspired)                 */
  /* --------------------------------------------------------------- */
  /* --------------------------------------------------------------- */
  /* 4. Layered – dua lapisan untuk kesan lebih dalam                */
  /* --------------------------------------------------------------- */
  static List<BoxShadow> layered(
    BuildContext context, {
    double blur1 = 4,
    double blur2 = 12,
    double y1 = 2,
    double y2 = 6,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return [
      BoxShadow(
        color: Colors.black.withAlpha(isDark ? 77 : 10),
        blurRadius: blur1,
        offset: Offset(0, y1),
      ),
      BoxShadow(
        color: Colors.black.withAlpha(isDark ? 51 : 15),
        blurRadius: blur2,
        offset: Offset(0, y2),
      ),
    ];
  }

  /// Large shadow for modals/dialogs
  static List<BoxShadow> lg(BuildContext context) =>
      float(context, blur: 24, y: 8);

  /// Medium shadow for cards
  static List<BoxShadow> md(BuildContext context) =>
      soft(context, blur: 16, y: 4);

  /* --------------------------------------------------------------- */
  /* 11. Neumorphic – shadow for neumorphic design                   */
  /* --------------------------------------------------------------- */
  static List<BoxShadow> neumorphic(
    BuildContext context, {
    double blur = 10,
    double distance = 6,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return [
      // Light shadow (top-left)
      BoxShadow(
        color:
            isDark ? Colors.white.withAlpha(10) : Colors.white.withAlpha(255),
        blurRadius: blur,
        offset: Offset(-distance, -distance),
      ),
      // Dark shadow (bottom-right)
      BoxShadow(
        color: Colors.black.withAlpha(isDark ? 128 : 31),
        blurRadius: blur,
        offset: Offset(distance, distance),
      ),
    ];
  }

  /* --------------------------------------------------------------- */
  /* 9. None – no shadow (untuk consistency)                         */
  /* --------------------------------------------------------------- */
  static List<BoxShadow> none() => [];

  /* --------------------------------------------------------------- */
  /* 15. Outline – subtle outline shadow                             */
  /* --------------------------------------------------------------- */
  static List<BoxShadow> outline(
    BuildContext context, {
    Color? color,
    double blur = 0,
    double spread = 1,
  }) {
    final outlineColor = color ?? context.gray300;
    return [
      BoxShadow(
        color: outlineColor,
        blurRadius: blur,
        spreadRadius: spread,
        offset: Offset.zero,
      ),
    ];
  }

  /* --------------------------------------------------------------- */
  /* 14. Pressed – shadow for pressed/active state                   */
  /* --------------------------------------------------------------- */
  static List<BoxShadow> pressed(
    BuildContext context, {
    double blur = 4,
    double y = 1,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return [
      BoxShadow(
        color: Colors.black.withAlpha(isDark ? 64 : 15),
        blurRadius: blur,
        offset: Offset(0, y),
      ),
    ];
  }

  /* --------------------------------------------------------------- */
  /* 6. Sharp – bayangan tajam untuk subtle divider/border           */
  /* --------------------------------------------------------------- */
  static List<BoxShadow> sharp(
    BuildContext context, {
    double blur = 2,
    double y = 1,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return [
      BoxShadow(
        color: Colors.black.withAlpha(isDark ? 64 : 20),
        blurRadius: blur,
        offset: Offset(0, y),
      ),
    ];
  }

  /// Small shadow for subtle elevation
  static List<BoxShadow> sm(BuildContext context) =>
      soft(context, blur: 8, y: 2);

  /* --------------------------------------------------------------- */
  /* 1. Soft – bayangan halus untuk card, sheet, tile                */
  /* --------------------------------------------------------------- */
  static List<BoxShadow> soft(
    BuildContext context, {
    double blur = 16,
    double y = 4,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return [
      BoxShadow(
        color: Colors.black.withAlpha(isDark ? 89 : 20),
        blurRadius: blur,
        offset: Offset(0, y),
      ),
    ];
  }

  /* --------------------------------------------------------------- */
  /* PRESET SHORTCUTS                                                 */
  /* --------------------------------------------------------------- */

  /* --------------------------------------------------------------- */
  /* 16. Success/Error/Warning/Info – colored shadows                */
  /* --------------------------------------------------------------- */
  static List<BoxShadow> success(
    BuildContext context, {
    double blur = 16,
    double y = 4,
  }) {
    return [
      BoxShadow(
        color: context.successColor.withAlpha(51),
        blurRadius: blur,
        offset: Offset(0, y),
      ),
    ];
  }

  /* --------------------------------------------------------------- */
  /* 3. Primary Tinted – bayangan berwarna primary (brand)           */
  /* --------------------------------------------------------------- */
  static List<BoxShadow> tinted(
    BuildContext context, {
    double blur = 20,
    double y = 6,
  }) {
    return [
      BoxShadow(
        color: context.primaryColor.withAlpha(46),
        blurRadius: blur,
        offset: Offset(0, y),
      ),
    ];
  }

  static List<BoxShadow> warning(
    BuildContext context, {
    double blur = 16,
    double y = 4,
  }) {
    return [
      BoxShadow(
        color: context.warningColor.withAlpha(51),
        blurRadius: blur,
        offset: Offset(0, y),
      ),
    ];
  }

  /// Extra large shadow for floating elements
  static List<BoxShadow> xl(BuildContext context) =>
      float(context, blur: 32, y: 12);

  /// 2XL shadow for maximum depth
  static List<BoxShadow> xxl(BuildContext context) =>
      float(context, blur: 48, y: 16);
}
