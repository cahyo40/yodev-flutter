// lib/src/styles/colors/yo_colors.dart
import 'package:flutter/material.dart';

import '../../yo_ui_base.dart'; // lokasi kYoPalettes & YoCorePalette

/// Kelas warna yang **otomatis** mengikuti skema & brightness aktif.
/// Tidak pernah pakai provider / riverpod / get_it.
class YoColors {
  /* ---------- 1. helper: ambil palette untuk skema & brightness ---------- */
  static YoCorePalette _palette(BuildContext context) {
    // 1. brightness saat ini
    final bright = Theme.of(context).brightness;

    // 2. skema saat ini: simpan di dalam ThemeData.extension
    final ext = Theme.of(context).extension<YoScheme>() ?? const YoScheme();
    return kYoPalettes[ext.scheme]![bright]!;
  }

  /* ---------- 2. warna dinamis (ikut skema & brightness) ----------------- */
  static Color primary(BuildContext context) => _palette(context).primary;
  static Color secondary(BuildContext context) => _palette(context).secondary;
  static Color accent(BuildContext context) => _palette(context).accent;
  static Color text(BuildContext context) => _palette(context).text;
  static Color background(BuildContext context) => _palette(context).background;

  /* ---------- 3. warna semantic (hanya ikut brightness) ------------------ */
  static Color success(BuildContext context) =>
      Theme.of(context).brightness == Brightness.light
      ? lightSuccess
      : darkSuccess;
  static Color warning(BuildContext context) =>
      Theme.of(context).brightness == Brightness.light
      ? lightWarning
      : darkWarning;
  static Color error(BuildContext context) =>
      Theme.of(context).brightness == Brightness.light ? lightError : darkError;
  static Color info(BuildContext context) =>
      Theme.of(context).brightness == Brightness.light ? lightInfo : darkInfo;

  /* ---------- 4. netral & abu-abu (const) -------------------------------- */
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color transparent = Color(0x00000000);

  // Light grey
  static const Color lightGray50 = Color(0xFFF9FAFB);
  static const Color lightGray100 = Color(0xFFF3F4F6);
  static const Color lightGray200 = Color(0xFFE5E7EB);
  static const Color lightGray300 = Color(0xFFD1D5DB);
  static const Color lightGray400 = Color(0xFF9CA3AF);
  static const Color lightGray500 = Color(0xFF6B7280);
  static const Color lightGray600 = Color(0xFF4B5563);
  static const Color lightGray700 = Color(0xFF374151);
  static const Color lightGray800 = Color(0xFF1F2937);
  static const Color lightGray900 = Color(0xFF111827);

  // Dark grey (mirror)
  static const Color darkGray50 = Color(0xFF1F2937);
  static const Color darkGray100 = Color(0xFF374151);
  static const Color darkGray200 = Color(0xFF4B5563);
  static const Color darkGray300 = Color(0xFF6B7280);
  static const Color darkGray400 = Color(0xFF9CA3AF);
  static const Color darkGray500 = Color(0xFFD1D5DB);
  static const Color darkGray600 = Color(0xFFE5E7EB);
  static const Color darkGray700 = Color(0xFFF3F4F6);
  static const Color darkGray800 = Color(0xFFF9FAFB);
  static const Color darkGray900 = Color(0xFFFFFFFF);

  // Semantic const
  static const Color lightSuccess = Color(0xFF00A86B);
  static const Color lightWarning = Color(0xFFFFA500);
  static const Color lightError = Color(0xFFDC3545);
  static const Color lightInfo = Color(0xFF17A2B8);

  static const Color darkSuccess = Color(0xFF00D68F);
  static const Color darkWarning = Color(0xFFFFB84D);
  static const Color darkError = Color(0xFFFF4757);
  static const Color darkInfo = Color(0xFF4DCAFF);

  /* ---------- 5. abu-abu dinamis (ikut brightness) ----------------------- */
  static Color gray50(BuildContext context) =>
      Theme.of(context).brightness == Brightness.light
      ? lightGray50
      : darkGray50;
  static Color gray100(BuildContext context) =>
      Theme.of(context).brightness == Brightness.light
      ? lightGray100
      : darkGray100;
  static Color gray200(BuildContext context) =>
      Theme.of(context).brightness == Brightness.light
      ? lightGray200
      : darkGray200;
  static Color gray300(BuildContext context) =>
      Theme.of(context).brightness == Brightness.light
      ? lightGray300
      : darkGray300;
  static Color gray400(BuildContext context) =>
      Theme.of(context).brightness == Brightness.light
      ? lightGray400
      : darkGray400;
  static Color gray500(BuildContext context) =>
      Theme.of(context).brightness == Brightness.light
      ? lightGray500
      : darkGray500;
  static Color gray600(BuildContext context) =>
      Theme.of(context).brightness == Brightness.light
      ? lightGray600
      : darkGray600;
  static Color gray700(BuildContext context) =>
      Theme.of(context).brightness == Brightness.light
      ? lightGray700
      : darkGray700;
  static Color gray800(BuildContext context) =>
      Theme.of(context).brightness == Brightness.light
      ? lightGray800
      : darkGray800;
  static Color gray900(BuildContext context) =>
      Theme.of(context).brightness == Brightness.light
      ? lightGray900
      : darkGray900;

  /* ---------- 6. gradient dinamis ---------------------------------------- */
  static Gradient primaryGradient(BuildContext context) => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary(context), secondary(context)],
  );
  static Gradient accentGradient(BuildContext context) => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accent(context), secondary(context)],
  );
}

/* ----------------------------------------------------------------------------
   Extension sederhana untuk menyimpan skema aktif di dalam ThemeData
   --------------------------------------------------------------------------- */
@immutable
class YoScheme extends ThemeExtension<YoScheme> {
  final YoColorScheme scheme;
  const YoScheme([this.scheme = YoColorScheme.defaultScheme]);

  @override
  ThemeExtension<YoScheme> copyWith({YoColorScheme? scheme}) =>
      YoScheme(scheme ?? this.scheme);

  @override
  ThemeExtension<YoScheme> lerp(ThemeExtension<YoScheme>? other, double t) =>
      this; // tidak perlu animasi
}
