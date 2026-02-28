// [file name]: yo_badge.dart
import 'package:flutter/material.dart';

import '../../../yo_ui.dart';

enum YoBadgeVariant { primary, secondary, success, warning, error, outline }

enum YoBadgeSize { small, medium, large }

class YoBadge extends StatelessWidget {
  final String text;
  final YoBadgeVariant variant;
  final YoBadgeSize size;
  final Widget? icon;
  final IconPosition iconPosition;
  final Color? backgroundColor;
  final Color? textColor;
  final bool showDot;
  final Color? dotColor;
  final VoidCallback? onTap;

  const YoBadge({
    super.key,
    required this.text,
    this.variant = YoBadgeVariant.primary,
    this.size = YoBadgeSize.medium,
    this.icon,
    this.iconPosition = IconPosition.left,
    this.backgroundColor,
    this.textColor,
    this.showDot = false,
    this.dotColor,
    this.onTap,
  });

  // Named constructors untuk setiap variant
  const YoBadge.primary({
    super.key,
    required this.text,
    this.size = YoBadgeSize.medium,
    this.icon,
    this.iconPosition = IconPosition.left,
    this.textColor,
    this.showDot = false,
    this.dotColor,
    this.onTap,
  })  : variant = YoBadgeVariant.primary,
        backgroundColor = null;

  const YoBadge.secondary({
    super.key,
    required this.text,
    this.size = YoBadgeSize.medium,
    this.icon,
    this.iconPosition = IconPosition.left,
    this.textColor,
    this.showDot = false,
    this.dotColor,
    this.onTap,
  })  : variant = YoBadgeVariant.secondary,
        backgroundColor = null;

  const YoBadge.success({
    super.key,
    required this.text,
    this.size = YoBadgeSize.medium,
    this.icon,
    this.iconPosition = IconPosition.left,
    this.textColor,
    this.showDot = false,
    this.dotColor,
    this.onTap,
  })  : variant = YoBadgeVariant.success,
        backgroundColor = null;

  const YoBadge.warning({
    super.key,
    required this.text,
    this.size = YoBadgeSize.medium,
    this.icon,
    this.iconPosition = IconPosition.left,
    this.textColor,
    this.showDot = false,
    this.dotColor,
    this.onTap,
  })  : variant = YoBadgeVariant.warning,
        backgroundColor = null;

  const YoBadge.error({
    super.key,
    required this.text,
    this.size = YoBadgeSize.medium,
    this.icon,
    this.iconPosition = IconPosition.left,
    this.textColor,
    this.showDot = false,
    this.dotColor,
    this.onTap,
  })  : variant = YoBadgeVariant.error,
        backgroundColor = null;

  const YoBadge.outline({
    super.key,
    required this.text,
    this.size = YoBadgeSize.medium,
    this.icon,
    this.iconPosition = IconPosition.left,
    this.textColor,
    this.showDot = false,
    this.dotColor,
    this.onTap,
  })  : variant = YoBadgeVariant.outline,
        backgroundColor = null;

  // Dot-only badge (untuk notification dots)
  const YoBadge.dot({
    super.key,
    this.text = '',
    this.dotColor,
    this.size = YoBadgeSize.small,
    this.onTap,
  })  : variant = YoBadgeVariant.primary,
        icon = null,
        iconPosition = IconPosition.left,
        backgroundColor = null,
        textColor = null,
        showDot = true;

  @override
  Widget build(BuildContext context) {
    final Color effectiveBackgroundColor =
        backgroundColor ?? _getBackgroundColor(context);
    final Color effectiveTextColor = textColor ?? _getTextColor(context);
    final Color effectiveDotColor = dotColor ?? _getDotColor(context);

    final padding = _getPadding();
    final textStyle = _getTextStyle(
      context,
    ).copyWith(color: effectiveTextColor);
    final borderRadius = _getBorderRadius(context);

    Widget content = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: effectiveBackgroundColor,
        borderRadius: borderRadius,
        border: variant == YoBadgeVariant.outline
            ? Border.all(color: effectiveTextColor.withAlpha(77), width: 1)
            : null,
      ),
      child: _buildContent(textStyle, effectiveDotColor),
    );

    if (onTap != null) {
      content = InkWell(
        onTap: onTap,
        borderRadius: borderRadius,
        child: content,
      );
    }

    return content;
  }

  Widget _buildContent(TextStyle textStyle, Color dotColor) {
    final children = <Widget>[];

    // Add dot if needed
    if (showDot && text.isEmpty) {
      return Container(
        width: _getDotSize(),
        height: _getDotSize(),
        decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
      );
    }

    if (showDot) {
      children.add(
        Container(
          width: _getDotSize(),
          height: _getDotSize(),
          decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
        ),
      );
      children.add(YoSpace.width(_getIconSpacing()));
    }

    // Add icon if provided
    if (icon != null && iconPosition == IconPosition.left) {
      children.add(
        IconTheme(
          data: IconThemeData(size: _getIconSize(), color: textStyle.color),
          child: icon!,
        ),
      );
      children.add(YoSpace.width(_getIconSpacing()));
    }

    // Add text
    if (text.isNotEmpty) {
      children.add(
        YoText(
          text,
          style: textStyle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      );
    }

    // Add icon if on right side
    if (icon != null && iconPosition == IconPosition.right) {
      children.add(YoSpace.width(_getIconSpacing()));
      children.add(
        IconTheme(
          data: IconThemeData(size: _getIconSize(), color: textStyle.color),
          child: icon!,
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
  }

  Color _getBackgroundColor(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    switch (variant) {
      case YoBadgeVariant.primary:
        return colorScheme.primary;
      case YoBadgeVariant.secondary:
        return colorScheme.surfaceContainerHighest;
      case YoBadgeVariant.success:
        return colorScheme
            .primaryContainer; // Adjust based on your color system
      case YoBadgeVariant.warning:
        return const Color(0xFFFFFBEB); // Light orange
      case YoBadgeVariant.error:
        return colorScheme.errorContainer;
      case YoBadgeVariant.outline:
        return Colors.transparent;
    }
  }

  Color _getTextColor(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    switch (variant) {
      case YoBadgeVariant.primary:
        return colorScheme.onPrimary;
      case YoBadgeVariant.secondary:
        return colorScheme.onSurfaceVariant;
      case YoBadgeVariant.success:
        return const Color(0xFF065F46); // Dark green
      case YoBadgeVariant.warning:
        return const Color(0xFF92400E); // Dark orange
      case YoBadgeVariant.error:
        return colorScheme.onErrorContainer;
      case YoBadgeVariant.outline:
        return colorScheme.onSurface;
    }
  }

  Color _getDotColor(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    switch (variant) {
      case YoBadgeVariant.primary:
        return colorScheme.onPrimary;
      case YoBadgeVariant.secondary:
        return colorScheme.onSurfaceVariant;
      case YoBadgeVariant.success:
        return const Color(0xFF10B981); // Green
      case YoBadgeVariant.warning:
        return const Color(0xFFF59E0B); // Orange
      case YoBadgeVariant.error:
        return colorScheme.error;
      case YoBadgeVariant.outline:
        return colorScheme.primary;
    }
  }

  EdgeInsets _getPadding() {
    switch (size) {
      case YoBadgeSize.small:
        return const EdgeInsets.symmetric(horizontal: 8, vertical: 4);
      case YoBadgeSize.medium:
        return const EdgeInsets.symmetric(horizontal: 12, vertical: 6);
      case YoBadgeSize.large:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
    }
  }

  TextStyle _getTextStyle(BuildContext context) {
    final theme = Theme.of(context);

    switch (size) {
      case YoBadgeSize.small:
        return theme.textTheme.labelSmall!.copyWith(
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
        );
      case YoBadgeSize.medium:
        return theme.textTheme.labelMedium!.copyWith(
          fontWeight: FontWeight.w500,
          letterSpacing: 0.15,
        );
      case YoBadgeSize.large:
        return theme.textTheme.labelLarge!.copyWith(
          fontWeight: FontWeight.w600,
          letterSpacing: 0.15,
        );
    }
  }

  BorderRadius _getBorderRadius(BuildContext context) {
    switch (size) {
      case YoBadgeSize.small:
        return BorderRadius.circular(6);
      case YoBadgeSize.medium:
        return BorderRadius.circular(context.yoRadiusMd);
      case YoBadgeSize.large:
        return BorderRadius.circular(context.yoRadiusLg);
    }
  }

  double _getIconSize() {
    switch (size) {
      case YoBadgeSize.small:
        return 12;
      case YoBadgeSize.medium:
        return 14;
      case YoBadgeSize.large:
        return 16;
    }
  }

  double _getIconSpacing() {
    switch (size) {
      case YoBadgeSize.small:
        return 4;
      case YoBadgeSize.medium:
        return 6;
      case YoBadgeSize.large:
        return 8;
    }
  }

  double _getDotSize() {
    switch (size) {
      case YoBadgeSize.small:
        return 6;
      case YoBadgeSize.medium:
        return 8;
      case YoBadgeSize.large:
        return 10;
    }
  }
}
