// File: yo_grid.dart
import 'package:flutter/material.dart';
import 'package:yo_ui/yo_ui.dart';

class YoGrid extends StatelessWidget {
  final int crossAxisCount;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final double childAspectRatio;
  final List<Widget> children;
  final EdgeInsets padding;
  final bool shrinkWrap;
  final ScrollPhysics? physics;

  const YoGrid({
    super.key,
    required this.crossAxisCount,
    this.crossAxisSpacing = 0,
    this.mainAxisSpacing = 0,
    this.childAspectRatio = 1.0,
    required this.children,
    this.padding = EdgeInsets.zero,
    this.shrinkWrap = false,
    this.physics,
  });

  // Responsive grid constructor using context extensions
  YoGrid.responsive({
    super.key,
    required BuildContext context,
    int? phoneColumns,
    int? tabletColumns,
    int? desktopColumns,
    double? crossAxisSpacing,
    double? mainAxisSpacing,
    this.childAspectRatio = 1.0,
    required this.children,
    EdgeInsets? padding,
    this.shrinkWrap = false,
    this.physics,
  })  : crossAxisCount = context
            .responsiveValue(
              phone: phoneColumns?.toDouble() ?? 2,
              tablet: tabletColumns?.toDouble() ?? 3,
              desktop: desktopColumns?.toDouble() ?? 4,
            )
            .toInt(),
        crossAxisSpacing = crossAxisSpacing ?? context.yoSpacingSm,
        mainAxisSpacing = mainAxisSpacing ?? context.yoSpacingSm,
        padding = padding ?? EdgeInsets.all(context.yoSpacingMd);

  YoGrid.threeColumn({
    super.key,
    required BuildContext context,
    double? crossAxisSpacing,
    double? mainAxisSpacing,
    this.childAspectRatio = 1.0,
    required this.children,
    EdgeInsets? padding,
    this.shrinkWrap = false,
    this.physics,
  })  : crossAxisCount = 3,
        crossAxisSpacing = crossAxisSpacing ?? context.yoSpacingSm,
        mainAxisSpacing = mainAxisSpacing ?? context.yoSpacingSm,
        padding = padding ?? EdgeInsets.all(context.yoSpacingMd);

  // Common grid layouts using context spacing
  YoGrid.twoColumn({
    super.key,
    required BuildContext context,
    double? crossAxisSpacing,
    double? mainAxisSpacing,
    this.childAspectRatio = 1.0,
    required this.children,
    EdgeInsets? padding,
    this.shrinkWrap = false,
    this.physics,
  })  : crossAxisCount = 2,
        crossAxisSpacing = crossAxisSpacing ?? context.yoSpacingMd,
        mainAxisSpacing = mainAxisSpacing ?? context.yoSpacingMd,
        padding = padding ?? EdgeInsets.all(context.yoSpacingMd);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: crossAxisCount,
      crossAxisSpacing: crossAxisSpacing,
      mainAxisSpacing: mainAxisSpacing,
      childAspectRatio: childAspectRatio,
      padding: padding,
      shrinkWrap: shrinkWrap,
      physics: physics,
      children: children,
    );
  }
}

// Grid item helper widget using context colors
class YoGridItem extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final EdgeInsets padding;
  final BorderRadius borderRadius;
  final BoxBorder? border;
  final List<BoxShadow>? shadow;

  const YoGridItem({
    super.key,
    required this.child,
    this.backgroundColor,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius = BorderRadius.zero,
    this.border,
    this.shadow,
  });

  YoGridItem.card({
    super.key,
    required BuildContext context,
    required this.child,
    EdgeInsets? padding,
    BorderRadius? borderRadius,
  })  : backgroundColor = context.backgroundColor,
        padding = padding ?? EdgeInsets.all(context.yoSpacingMd),
        borderRadius = borderRadius ?? BorderRadius.circular(12),
        border = null,
        shadow = [
          BoxShadow(
            color: context.gray300.withAlpha(77),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ];

  @override
  Widget build(BuildContext context) {
    final effectiveBackgroundColor = backgroundColor ?? context.backgroundColor;

    return Container(
      decoration: BoxDecoration(
        color: effectiveBackgroundColor,
        borderRadius: borderRadius,
        border: border,
        boxShadow: shadow,
      ),
      padding: padding,
      child: child,
    );
  }
}
