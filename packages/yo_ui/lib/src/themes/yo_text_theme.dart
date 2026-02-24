import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../yo_ui_base.dart';

class YoTextTheme {
  /* 1. FONT REGISTRY (bisa diubah consumer) --------------------------- */
  static String _primary = 'Poppins';
  static String _secondary = 'Inter';
  static String _mono = 'Space Mono';

  /// Set font using YoFonts enum (recommended)
  /// Panggil 1x di main() sebelum runApp()
  static void setFont({
    YoFonts? primary,
    YoFonts? secondary,
    YoFonts? mono,
  }) {
    if (primary != null) _primary = yoFontFamily[primary]!;
    if (secondary != null) _secondary = yoFontFamily[secondary]!;
    if (mono != null) _mono = yoFontFamily[mono]!;
  }

  /// Set font using string (for custom fonts not in YoFonts)
  /// Panggil 1x di main() jika ingin custom font
  static void setFontFamily({
    String? primary,
    String? secondary,
    String? mono,
  }) {
    if (primary != null) _primary = primary;
    if (secondary != null) _secondary = secondary;
    if (mono != null) _mono = mono;
  }

  /* 2. PRIVATE HELPER (warna, height, letterSpacing) ------------------ */
  static TextStyle _style(
    BuildContext context, {
    required String family,
    required double size,
    required FontWeight weight,
    double? height,
    double? letterSpacing,
    Color? color,
  }) =>
      GoogleFonts.getFont(
        family,
        fontSize: size,
        fontWeight: weight,
        height: height,
        letterSpacing: letterSpacing,
        color: color ?? YoColors.text(context),
      );

  /* 3. DISPLAY ------------------------------------------------------- */
  static TextStyle displayLarge(BuildContext context) => _style(
        context,
        family: _primary,
        size: 57,
        weight: FontWeight.w400,
        height: 1.15,
        letterSpacing: -0.25,
      );

  static TextStyle displayMedium(BuildContext context) => _style(
        context,
        family: _primary,
        size: 45,
        weight: FontWeight.w400,
        height: 1.15,
      );

  static TextStyle displaySmall(BuildContext context) => _style(
        context,
        family: _primary,
        size: 36,
        weight: FontWeight.w400,
        height: 1.15,
      );

  /* 4. HEADLINE ------------------------------------------------------ */
  static TextStyle headlineLarge(BuildContext context) => _style(
        context,
        family: _primary,
        size: 32,
        weight: FontWeight.w400,
        height: 1.2,
      );

  static TextStyle headlineMedium(BuildContext context) => _style(
        context,
        family: _primary,
        size: 28,
        weight: FontWeight.w400,
        height: 1.2,
      );

  static TextStyle headlineSmall(BuildContext context) => _style(
        context,
        family: _primary,
        size: 24,
        weight: FontWeight.w400,
        height: 1.2,
      );

  /* 5. TITLE --------------------------------------------------------- */
  static TextStyle titleLarge(BuildContext context) => _style(
        context,
        family: _primary,
        size: 22,
        weight: FontWeight.w500,
        height: 1.2,
        letterSpacing: 0.15,
      );

  static TextStyle titleMedium(BuildContext context) => _style(
        context,
        family: _primary,
        size: 16,
        weight: FontWeight.w500,
        height: 1.2,
        letterSpacing: 0.15,
      );

  static TextStyle titleSmall(BuildContext context) => _style(
        context,
        family: _primary,
        size: 14,
        weight: FontWeight.w500,
        height: 1.2,
        letterSpacing: 0.1,
      );

  /* 6. BODY ---------------------------------------------------------- */
  static TextStyle bodyLarge(BuildContext context) => _style(
        context,
        family: _secondary,
        size: 16,
        weight: FontWeight.w400,
        height: 1.4,
        letterSpacing: 0.5,
      );

  static TextStyle bodyMedium(BuildContext context) => _style(
        context,
        family: _secondary,
        size: 14,
        weight: FontWeight.w400,
        height: 1.4,
        letterSpacing: 0.25,
      );

  static TextStyle bodySmall(BuildContext context) => _style(
        context,
        family: _secondary,
        size: 12,
        weight: FontWeight.w400,
        height: 1.4,
        letterSpacing: 0.4,
        color: YoColors.gray400(context),
      );

  /* 7. LABEL --------------------------------------------------------- */
  static TextStyle labelLarge(BuildContext context) => _style(
        context,
        family: _secondary,
        size: 14,
        weight: FontWeight.w500,
        height: 1.2,
        letterSpacing: 0.1,
      );

  static TextStyle labelMedium(BuildContext context) => _style(
        context,
        family: _secondary,
        size: 12,
        weight: FontWeight.w500,
        height: 1.2,
        letterSpacing: 0.5,
      );

  static TextStyle labelSmall(BuildContext context) => _style(
        context,
        family: _secondary,
        size: 11,
        weight: FontWeight.w500,
        height: 1.2,
        letterSpacing: 0.5,
      );

  /* 8. MONO (angka, currency, dsb.) ---------------------------------- */
  static TextStyle monoLarge(BuildContext context) => _style(
        context,
        family: _mono,
        size: 16,
        weight: FontWeight.w400,
        height: 1.2,
      );

  static TextStyle monoMedium(BuildContext context) => _style(
        context,
        family: _mono,
        size: 14,
        weight: FontWeight.w400,
        height: 1.2,
      );

  static TextStyle monoSmall(BuildContext context) => _style(
        context,
        family: _mono,
        size: 12,
        weight: FontWeight.w400,
        height: 1.2,
        color: YoColors.gray400(context),
      );

  /* 9. GENERATE TEXT THEME (untuk ThemeData) ------------------------ */
  static TextTheme textTheme(BuildContext context) => TextTheme(
        displayLarge: displayLarge(context),
        displayMedium: displayMedium(context),
        displaySmall: displaySmall(context),
        headlineLarge: headlineLarge(context),
        headlineMedium: headlineMedium(context),
        headlineSmall: headlineSmall(context),
        titleLarge: titleLarge(context),
        titleMedium: titleMedium(context),
        titleSmall: titleSmall(context),
        bodyLarge: bodyLarge(context),
        bodyMedium: bodyMedium(context),
        bodySmall: bodySmall(context),
        labelLarge: labelLarge(context),
        labelMedium: labelMedium(context),
        labelSmall: labelSmall(context),
      );
}
