import 'package:flutter/material.dart';

class YoCorePalette {
  final Color text;
  final Color background;
  final Color primary;
  final Color secondary;
  final Color accent;

  const YoCorePalette({
    required this.text,
    required this.background,
    required this.primary,
    required this.secondary,
    required this.accent,
  });

  /// Card border color based on primary
  Color get cardBorderColor => primary.withValues(alpha: 0.12);

  /// Card color with subtle primary tint
  Color get cardColor => Color.alphaBlend(
        primary.withValues(alpha: 0.05),
        background,
      );

  Color get onBackground =>
      background.computeLuminance() > 0.5 ? Colors.black : Colors.white;

  /// Text color for content on cards
  Color get onCard =>
      cardColor.computeLuminance() > 0.5 ? Colors.black : Colors.white;

  Color get onPrimary =>
      primary.computeLuminance() > 0.5 ? Colors.black : Colors.white;
}
