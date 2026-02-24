// File: yo_responsive_builder.dart
import 'package:flutter/material.dart';
import 'package:yo_ui/yo_ui.dart';

class YoResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, ScreenSize screenSize) builder;
  final Widget? fallback;

  const YoResponsiveBuilder({super.key, required this.builder, this.fallback});

  @override
  Widget build(BuildContext context) {
    final screenSize = context.screenSize;

    return builder(context, screenSize);
  }
}

class YoResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const YoResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 1200 && desktop != null) {
          return desktop!;
        } else if (constraints.maxWidth >= 600 && tablet != null) {
          return tablet!;
        } else {
          return mobile;
        }
      },
    );
  }
}
