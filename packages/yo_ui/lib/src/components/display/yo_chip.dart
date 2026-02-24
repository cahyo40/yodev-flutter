import 'package:flutter/material.dart';
import 'package:yo_ui/yo_ui.dart';

enum YoChipVariant { filled, outlined, tonal }

enum YoChipSize { small, medium, large }

/// Chip widget dengan berbagai variant dan preset
class YoChip extends StatelessWidget {
  final String label;
  final YoChipVariant variant;
  final YoChipSize size;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final double? borderRadius;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final VoidCallback? onDeleted;
  final bool selected;
  final _ChipPreset? _preset;

  const YoChip({
    super.key,
    required this.label,
    this.variant = YoChipVariant.filled,
    this.size = YoChipSize.medium,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.borderRadius,
    this.leading,
    this.trailing,
    this.onTap,
    this.onDeleted,
    this.selected = false,
  }) : _preset = null;

  /// Primary chip
  const YoChip.primary({
    super.key,
    required this.label,
    this.size = YoChipSize.medium,
    this.variant = YoChipVariant.filled,
    this.leading,
    this.trailing,
    this.onTap,
    this.onDeleted,
    this.selected = false,
    this.borderRadius,
  }) : backgroundColor = null,
       textColor = null,
       borderColor = null,
       _preset = _ChipPreset.primary;

  /// Success chip
  const YoChip.success({
    super.key,
    required this.label,
    this.size = YoChipSize.medium,
    this.variant = YoChipVariant.filled,
    this.leading,
    this.trailing,
    this.onTap,
    this.onDeleted,
    this.selected = false,
    this.borderRadius,
  }) : backgroundColor = null,
       textColor = null,
       borderColor = null,
       _preset = _ChipPreset.success;

  /// Error chip
  const YoChip.error({
    super.key,
    required this.label,
    this.size = YoChipSize.medium,
    this.variant = YoChipVariant.filled,
    this.leading,
    this.trailing,
    this.onTap,
    this.onDeleted,
    this.selected = false,
    this.borderRadius,
  }) : backgroundColor = null,
       textColor = null,
       borderColor = null,
       _preset = _ChipPreset.error;

  /// Warning chip
  const YoChip.warning({
    super.key,
    required this.label,
    this.size = YoChipSize.medium,
    this.variant = YoChipVariant.filled,
    this.leading,
    this.trailing,
    this.onTap,
    this.onDeleted,
    this.selected = false,
    this.borderRadius,
  }) : backgroundColor = null,
       textColor = null,
       borderColor = null,
       _preset = _ChipPreset.warning;

  /// Info chip
  const YoChip.info({
    super.key,
    required this.label,
    this.size = YoChipSize.medium,
    this.variant = YoChipVariant.filled,
    this.leading,
    this.trailing,
    this.onTap,
    this.onDeleted,
    this.selected = false,
    this.borderRadius,
  }) : backgroundColor = null,
       textColor = null,
       borderColor = null,
       _preset = _ChipPreset.info;

  @override
  Widget build(BuildContext context) {
    final colors = _getColors(context);
    final padding = _getPadding();
    final radius = borderRadius ?? _getBorderRadius();

    Widget content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (leading != null) ...[leading!, const SizedBox(width: 4)],
        Text(label, style: _getTextStyle(context).copyWith(color: colors.text)),
        if (trailing != null) ...[const SizedBox(width: 4), trailing!],
        if (onDeleted != null) ...[
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onDeleted,
            child: Icon(Icons.close, size: _getIconSize(), color: colors.text),
          ),
        ],
      ],
    );

    final decoration = BoxDecoration(
      color: colors.background,
      borderRadius: BorderRadius.circular(radius),
      border: variant == YoChipVariant.outlined
          ? Border.all(color: colors.border)
          : null,
      boxShadow: variant == YoChipVariant.tonal
          ? [
              BoxShadow(
                color: colors.background.withAlpha(128),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ]
          : null,
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(radius),
          child: Container(
            padding: padding,
            decoration: decoration,
            child: content,
          ),
        ),
      );
    }

    return Container(padding: padding, decoration: decoration, child: content);
  }

  _ChipColors _getColors(BuildContext context) {
    // Handle presets
    if (_preset != null) {
      return _getPresetColors(context, _preset);
    }

    // Handle variants
    switch (variant) {
      case YoChipVariant.filled:
        return _ChipColors(
          background: backgroundColor ?? context.primaryColor,
          text: textColor ?? Colors.white,
          border: borderColor ?? Colors.transparent,
        );
      case YoChipVariant.outlined:
        return _ChipColors(
          background: Colors.transparent,
          text: textColor ?? context.primaryColor,
          border: borderColor ?? context.primaryColor,
        );
      case YoChipVariant.tonal:
        return _ChipColors(
          background: backgroundColor ?? context.primaryColor.withAlpha(26),
          text: textColor ?? context.primaryColor,
          border: Colors.transparent,
        );
    }
  }

  _ChipColors _getPresetColors(BuildContext context, _ChipPreset preset) {
    final isFilled = variant == YoChipVariant.filled;

    Color baseColor;
    switch (preset) {
      case _ChipPreset.primary:
        baseColor = context.primaryColor;
        break;
      case _ChipPreset.success:
        baseColor = Colors.green;
        break;
      case _ChipPreset.error:
        baseColor = Theme.of(context).colorScheme.error;
        break;
      case _ChipPreset.warning:
        baseColor = Colors.orange;
        break;
      case _ChipPreset.info:
        baseColor = Colors.blue;
        break;
    }

    if (isFilled) {
      return _ChipColors(
        background: baseColor,
        text: Colors.white,
        border: Colors.transparent,
      );
    } else if (variant == YoChipVariant.outlined) {
      return _ChipColors(
        background: Colors.transparent,
        text: baseColor,
        border: baseColor,
      );
    } else {
      return _ChipColors(
        background: baseColor.withAlpha(26),
        text: baseColor,
        border: Colors.transparent,
      );
    }
  }

  EdgeInsets _getPadding() {
    switch (size) {
      case YoChipSize.small:
        return const EdgeInsets.symmetric(horizontal: 8, vertical: 4);
      case YoChipSize.medium:
        return const EdgeInsets.symmetric(horizontal: 12, vertical: 6);
      case YoChipSize.large:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
    }
  }

  double _getBorderRadius() {
    switch (size) {
      case YoChipSize.small:
        return 12;
      case YoChipSize.medium:
        return 16;
      case YoChipSize.large:
        return 20;
    }
  }

  double _getIconSize() {
    switch (size) {
      case YoChipSize.small:
        return 14;
      case YoChipSize.medium:
        return 16;
      case YoChipSize.large:
        return 18;
    }
  }

  TextStyle _getTextStyle(BuildContext context) {
    switch (size) {
      case YoChipSize.small:
        return context.yoLabelSmall;
      case YoChipSize.medium:
        return context.yoLabelMedium;
      case YoChipSize.large:
        return context.yoLabelLarge;
    }
  }
}

enum _ChipPreset { primary, success, error, warning, info }

class _ChipColors {
  final Color background;
  final Color text;
  final Color border;

  const _ChipColors({
    required this.background,
    required this.text,
    required this.border,
  });
}
