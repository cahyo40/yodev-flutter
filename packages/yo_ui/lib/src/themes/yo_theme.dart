import 'package:flutter/material.dart';

import '../../yo_ui.dart';

class YoTheme {
  static ThemeData lightTheme(
    BuildContext ctx, [
    YoColorScheme scheme = YoColorScheme.defaultScheme,
  ]) {
    final pal = kYoPalettes[scheme]![Brightness.light]!;
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: pal.primary,
        onPrimary: pal.text,
        secondary: pal.secondary,
        onSecondary: pal.text,
        surface: YoColors.lightGray50,
        onSurface: pal.text,
        error: YoColors.lightError,
        onError: YoColors.white,
        surfaceContainerHighest: YoColors.lightGray100,
      ),
      dropdownMenuTheme: YoDropdownTheme.light(ctx),
      scaffoldBackgroundColor: pal.background,
      appBarTheme: AppBarTheme(
        backgroundColor: pal.background,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: pal.text),
        titleTextStyle: TextStyle(
          color: pal.text,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          fontFamily: 'Poppins',
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        color: YoColors.lightGray50,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ctx.yoRadiusLg)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: pal.primary,
          foregroundColor: pal.text,
          textStyle: const TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(ctx.yoRadiusMd)),
          elevation: 0,
        ),
      ),
      textTheme: YoTextTheme.textTheme(ctx),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: pal.primary,
          side: BorderSide(color: pal.primary),
          textStyle: const TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(ctx.yoRadiusMd)),
        ),
      ),
      extensions: [YoScheme(scheme)],
      bottomNavigationBarTheme: YoBottomNavTheme.light(ctx),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: YoColors.lightGray50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ctx.yoRadiusMd),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ctx.yoRadiusMd),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ctx.yoRadiusMd),
          borderSide: BorderSide(color: pal.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ctx.yoRadiusMd),
          borderSide: const BorderSide(color: YoColors.lightError),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ctx.yoRadiusMd),
          borderSide: const BorderSide(color: YoColors.lightError, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: YoColors.lightGray100,
        selectedColor: pal.primary,
        labelStyle: TextStyle(color: pal.text),
        secondaryLabelStyle: TextStyle(color: pal.text),
        brightness: Brightness.light,
      ),
      dividerTheme: const DividerThemeData(
        color: YoColors.lightGray200,
        thickness: 1,
        space: 1,
      ),
    );
  }

  static ThemeData darkTheme(
    BuildContext ctx, [
    YoColorScheme scheme = YoColorScheme.defaultScheme,
  ]) {
    final pal = kYoPalettes[scheme]![Brightness.dark]!;
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: pal.primary,
        onPrimary: pal.text,
        secondary: pal.secondary,
        onSecondary: pal.text,
        surface: YoColors.darkGray50,
        onSurface: pal.text,
        error: YoColors.darkError,
        onError: YoColors.white,
        surfaceContainerHighest: YoColors.darkGray100,
      ),
      dropdownMenuTheme: YoDropdownTheme.dark(ctx),
      scaffoldBackgroundColor: pal.background,
      appBarTheme: AppBarTheme(
        backgroundColor: pal.background,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: pal.text),
        titleTextStyle: TextStyle(
          color: pal.text,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          fontFamily: 'Poppins',
        ),
      ),
      extensions: [YoScheme(scheme)],
      cardTheme: CardThemeData(
        elevation: 2,
        color: YoColors.darkGray50,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ctx.yoRadiusLg)),
      ),
      bottomNavigationBarTheme: YoBottomNavTheme.dark(ctx),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: pal.primary,
          foregroundColor: pal.text,
          textStyle: const TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(ctx.yoRadiusMd)),
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: pal.primary,
          side: BorderSide(color: pal.primary),
          textStyle: const TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(ctx.yoRadiusMd)),
        ),
      ),
      textTheme: YoTextTheme.textTheme(ctx),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: YoColors.darkGray50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ctx.yoRadiusMd),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ctx.yoRadiusMd),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ctx.yoRadiusMd),
          borderSide: BorderSide(color: pal.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ctx.yoRadiusMd),
          borderSide: const BorderSide(color: YoColors.darkError),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ctx.yoRadiusMd),
          borderSide: const BorderSide(color: YoColors.darkError, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        labelStyle: const TextStyle(color: YoColors.darkGray400),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: YoColors.darkGray100,
        selectedColor: pal.primary,
        labelStyle: TextStyle(color: pal.text),
        secondaryLabelStyle: TextStyle(color: pal.text),
        brightness: Brightness.dark,
      ),
      dividerTheme: const DividerThemeData(
        color: YoColors.darkGray200,
        thickness: 1,
        space: 1,
      ),
    );
  }
}
