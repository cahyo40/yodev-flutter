import 'package:flutter/material.dart';

class YoThemeCopyWith {
  static ThemeData copyWithColors({
    required ThemeData baseTheme,
    Color? primary,
    Color? secondary,
    Color? accent,
    Color? background,
    Color? surface,
  }) {
    return baseTheme.copyWith(
      colorScheme: baseTheme.colorScheme.copyWith(
        primary: primary,
        secondary: secondary,
        surface: surface,
      ),
    );
  }

  static ThemeData copyWithFonts({
    required ThemeData baseTheme,
    String? primaryFont,
    String? secondaryFont,
    String? monoFont,
  }) {
    return baseTheme.copyWith(
      textTheme: _updateTextThemeFonts(
        baseTheme.textTheme,
        primaryFont,
        secondaryFont,
        monoFont,
      ),
    );
  }

  static TextTheme _updateTextThemeFonts(
    TextTheme textTheme,
    String? primaryFont,
    String? secondaryFont,
    String? monoFont,
  ) {
    // Implementasi update font family di text theme
    return textTheme;
  }
}
