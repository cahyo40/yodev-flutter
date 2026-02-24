// File: yo_tooltip.dart
import 'package:flutter/material.dart';
import 'package:yo_ui/yo_ui.dart';

class YoTooltip extends StatelessWidget {
  final String message;
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  final Color? backgroundColor;
  final Color? textColor;
  final Duration waitDuration;
  final bool preferBelow;

  const YoTooltip({
    super.key,
    required this.message,
    required this.child,
    this.padding,
    this.borderRadius = 8.0,
    this.backgroundColor,
    this.textColor,
    this.waitDuration = const Duration(milliseconds: 500),
    this.preferBelow = true,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: message,
      padding: padding ?? EdgeInsets.all(context.yoSpacingSm),
      decoration: BoxDecoration(
        color: backgroundColor ?? context.gray800,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      textStyle: context.yoBodySmall.copyWith(
        color: textColor ?? context.onBackgroundColor,
      ),
      waitDuration: waitDuration,
      preferBelow: preferBelow,
      child: child,
    );
  }
}
