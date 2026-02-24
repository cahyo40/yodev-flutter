// File: yo_divider.dart
import 'package:flutter/material.dart';
import 'package:yo_ui/yo_ui.dart';

class YoDivider extends StatelessWidget {
  final double height;
  final double thickness;
  final double indent;
  final double endIndent;
  final Color? color;
  final Axis direction;

  const YoDivider({
    super.key,
    this.height = 1.0,
    this.thickness = 1.0,
    this.indent = 0.0,
    this.endIndent = 0.0,
    this.color,
    this.direction = Axis.horizontal,
  });

  const YoDivider.horizontal({
    super.key,
    this.height = 1.0,
    this.thickness = 1.0,
    this.indent = 0.0,
    this.endIndent = 0.0,
    this.color,
  }) : direction = Axis.horizontal;

  const YoDivider.vertical({
    super.key,
    this.height = 1.0,
    this.thickness = 1.0,
    this.indent = 0.0,
    this.endIndent = 0.0,
    this.color,
  }) : direction = Axis.vertical;

  // Predefined variants using context colors
  const YoDivider.light({
    super.key,
    this.height = 1.0,
    this.thickness = 0.5,
    this.indent = 0.0,
    this.endIndent = 0.0,
    this.direction = Axis.horizontal,
  }) : color = null; // Will use context color

  const YoDivider.dark({
    super.key,
    this.height = 1.0,
    this.thickness = 1.0,
    this.indent = 0.0,
    this.endIndent = 0.0,
    this.direction = Axis.horizontal,
  }) : color = null; // Will use context color

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? context.gray300;

    if (direction == Axis.vertical) {
      return VerticalDivider(
        width: height,
        thickness: thickness,
        indent: indent,
        endIndent: endIndent,
        color: effectiveColor,
      );
    }

    return Divider(
      height: height,
      thickness: thickness,
      indent: indent,
      endIndent: endIndent,
      color: effectiveColor,
    );
  }
}
