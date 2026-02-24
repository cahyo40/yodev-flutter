import 'package:flutter/material.dart';
import 'package:yo_ui/yo_ui.dart';

/// Icon position relative to text
enum IconPosition { left, right }

class YoButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final YoButtonVariant variant;
  final YoButtonSize size;
  final YoButtonStyle buttonStyle;
  final Widget? icon;
  final IconPosition iconPosition;
  final Color? textColor;
  final Color? backgroundColor;
  final Color? borderColor;
  final bool borderColorFollowsText;
  final bool isLoading;
  final bool expanded;
  final double? width;
  final double? height;
  final double? borderRadius;

  const YoButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.variant = YoButtonVariant.primary,
    this.size = YoButtonSize.medium,
    this.buttonStyle = YoButtonStyle.rounded,
    this.icon,
    this.iconPosition = IconPosition.left,
    this.textColor,
    this.backgroundColor,
    this.borderColor,
    this.borderColorFollowsText = false,
    this.isLoading = false,
    this.expanded = false,
    this.width,
    this.height,
    this.borderRadius,
  });

  const YoButton.custom({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.size = YoButtonSize.medium,
    this.buttonStyle = YoButtonStyle.rounded,
    this.icon,
    this.iconPosition = IconPosition.left,
    this.textColor,
    this.isLoading = false,
    this.expanded = false,
    this.width,
    this.height,
    this.borderRadius,
  })  : variant = YoButtonVariant.custom,
        borderColor = null,
        borderColorFollowsText = false;

  const YoButton.ghost({
    super.key,
    required this.text,
    required this.onPressed,
    this.size = YoButtonSize.medium,
    this.buttonStyle = YoButtonStyle.rounded,
    this.icon,
    this.iconPosition = IconPosition.left,
    this.textColor,
    this.isLoading = false,
    this.expanded = false,
    this.width,
    this.height,
    this.borderRadius,
  })  : variant = YoButtonVariant.ghost,
        backgroundColor = null,
        borderColor = null,
        borderColorFollowsText = false;

  /// Minimalist flat button
  const YoButton.minimalist({
    super.key,
    required this.text,
    required this.onPressed,
    this.variant = YoButtonVariant.primary,
    this.size = YoButtonSize.medium,
    this.icon,
    this.iconPosition = IconPosition.left,
    this.textColor,
    this.backgroundColor,
    this.isLoading = false,
    this.expanded = false,
    this.width,
    this.height,
    this.borderRadius,
  })  : buttonStyle = YoButtonStyle.minimalist,
        borderColor = null,
        borderColorFollowsText = false;

  /// Modern button with gradient and shadow
  const YoButton.modern({
    super.key,
    required this.text,
    required this.onPressed,
    this.variant = YoButtonVariant.primary,
    this.size = YoButtonSize.medium,
    this.icon,
    this.iconPosition = IconPosition.left,
    this.textColor,
    this.backgroundColor,
    this.isLoading = false,
    this.expanded = false,
    this.width,
    this.height,
    this.borderRadius,
  })  : buttonStyle = YoButtonStyle.modern,
        borderColor = null,
        borderColorFollowsText = false;

  const YoButton.outline({
    super.key,
    required this.text,
    required this.onPressed,
    this.size = YoButtonSize.medium,
    this.buttonStyle = YoButtonStyle.rounded,
    this.icon,
    this.iconPosition = IconPosition.left,
    this.textColor,
    this.borderColor,
    this.borderColorFollowsText = false,
    this.isLoading = false,
    this.expanded = false,
    this.width,
    this.height,
    this.borderRadius,
  })  : variant = YoButtonVariant.outline,
        backgroundColor = null;

  // ===== STYLE-BASED CONSTRUCTORS =====

  /// Pill-shaped button
  const YoButton.pill({
    super.key,
    required this.text,
    required this.onPressed,
    this.variant = YoButtonVariant.primary,
    this.size = YoButtonSize.medium,
    this.icon,
    this.iconPosition = IconPosition.left,
    this.textColor,
    this.backgroundColor,
    this.isLoading = false,
    this.expanded = false,
    this.width,
    this.height,
  })  : buttonStyle = YoButtonStyle.pill,
        borderRadius = null,
        borderColor = null,
        borderColorFollowsText = false;

  // ===== FACTORY CONSTRUCTORS =====

  const YoButton.primary({
    super.key,
    required this.text,
    required this.onPressed,
    this.size = YoButtonSize.medium,
    this.buttonStyle = YoButtonStyle.rounded,
    this.icon,
    this.iconPosition = IconPosition.left,
    this.textColor,
    this.isLoading = false,
    this.expanded = false,
    this.width,
    this.height,
    this.borderRadius,
  })  : variant = YoButtonVariant.primary,
        backgroundColor = null,
        borderColor = null,
        borderColorFollowsText = false;

  const YoButton.secondary({
    super.key,
    required this.text,
    required this.onPressed,
    this.size = YoButtonSize.medium,
    this.buttonStyle = YoButtonStyle.rounded,
    this.icon,
    this.iconPosition = IconPosition.left,
    this.textColor,
    this.isLoading = false,
    this.expanded = false,
    this.width,
    this.height,
    this.borderRadius,
  })  : variant = YoButtonVariant.secondary,
        backgroundColor = null,
        borderColor = null,
        borderColorFollowsText = false;

  /// Sharp-cornered button
  const YoButton.sharp({
    super.key,
    required this.text,
    required this.onPressed,
    this.variant = YoButtonVariant.primary,
    this.size = YoButtonSize.medium,
    this.icon,
    this.iconPosition = IconPosition.left,
    this.textColor,
    this.backgroundColor,
    this.isLoading = false,
    this.expanded = false,
    this.width,
    this.height,
  })  : buttonStyle = YoButtonStyle.sharp,
        borderRadius = null,
        borderColor = null,
        borderColorFollowsText = false;

  @override
  Widget build(BuildContext context) {
    final style = _getButtonStyle(context);
    final padding = _getPadding();
    final txtStyle = _getTextStyle(context);
    final radius = _getBorderRadius();

    Widget child = isLoading
        ? SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: _getProgressIndicatorColor(context),
            ),
          )
        : Row(
            mainAxisSize: expanded ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: _buildContent(txtStyle),
          );

    final buttonChild = Container(
      padding: padding,
      width: width,
      height: height,
      child: child,
    );

    // Modern style with gradient overlay
    if (buttonStyle == YoButtonStyle.modern &&
        variant == YoButtonVariant.primary) {
      return _buildModernButton(context, buttonChild, radius);
    }

    Widget button = ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: style.copyWith(shape: WidgetStateProperty.all(_getShape(radius))),
      child: buttonChild,
    );

    if (expanded) {
      return SizedBox(width: double.infinity, child: button);
    }

    return button;
  }

  List<Widget> _buildContent(TextStyle textStyle) {
    final textWidget = Flexible(
      child: Text(
        text,
        style: textStyle,
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
      ),
    );

    if (icon == null) return [textWidget];

    final gap = SizedBox(width: _getIconSpacing());
    final iconWidget = IconTheme(
      data: IconThemeData(size: _getIconSize(), color: textStyle.color),
      child: icon!,
    );

    return iconPosition == IconPosition.right
        ? [textWidget, gap, iconWidget]
        : [iconWidget, gap, textWidget];
  }

  Widget _buildModernButton(BuildContext context, Widget child, double radius) {
    final colorScheme = Theme.of(context).colorScheme;
    final bgColor = backgroundColor ?? colorScheme.primary;

    Widget button = GestureDetector(
      onTap: isLoading ? null : onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [bgColor, bgColor.withAlpha(200)],
          ),
          borderRadius: BorderRadius.circular(radius),
          boxShadow: onPressed != null
              ? [
                  BoxShadow(
                    color: bgColor.withAlpha(80),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: child,
      ),
    );

    if (expanded) {
      return SizedBox(width: double.infinity, child: button);
    }
    return button;
  }

  double _getBorderRadius() {
    if (borderRadius != null) return borderRadius!;

    switch (buttonStyle) {
      case YoButtonStyle.pill:
        return 100; // Very high for pill shape
      case YoButtonStyle.sharp:
        return 0;
      case YoButtonStyle.minimalist:
        return 4;
      case YoButtonStyle.modern:
        return 12;
      case YoButtonStyle.rounded:
        return 8;
    }
  }

  ButtonStyle _getButtonStyle(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Get elevation based on style
    final elevation = buttonStyle == YoButtonStyle.minimalist ? 0.0 : 0.0;
    final hoverElevation = buttonStyle == YoButtonStyle.modern ? 2.0 : 1.0;

    switch (variant) {
      case YoButtonVariant.primary:
        return ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          disabledBackgroundColor: colorScheme.onSurface.withAlpha(31),
          disabledForegroundColor: colorScheme.onSurface.withAlpha(97),
          elevation: elevation,
          shadowColor: Colors.transparent,
          padding: EdgeInsets.zero,
        ).copyWith(
          elevation: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.hovered)) return hoverElevation;
            if (states.contains(WidgetState.pressed)) return 0;
            return elevation;
          }),
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return colorScheme.onSurface.withAlpha(31);
            }
            if (states.contains(WidgetState.pressed)) {
              return colorScheme.primary.withAlpha(204);
            }
            if (states.contains(WidgetState.hovered)) {
              return colorScheme.primary.withAlpha(230);
            }
            return colorScheme.primary;
          }),
        );

      case YoButtonVariant.secondary:
        return ElevatedButton.styleFrom(
          backgroundColor: colorScheme.surfaceContainerHighest,
          foregroundColor: colorScheme.onSurface,
          disabledBackgroundColor: colorScheme.onSurface.withAlpha(31),
          disabledForegroundColor: colorScheme.onSurface.withAlpha(97),
          elevation: elevation,
          shadowColor: Colors.transparent,
          padding: EdgeInsets.zero,
        ).copyWith(
          elevation: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.hovered)) return hoverElevation;
            if (states.contains(WidgetState.pressed)) return 0;
            return elevation;
          }),
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return colorScheme.onSurface.withAlpha(31);
            }
            if (states.contains(WidgetState.pressed)) {
              return colorScheme.surfaceContainerHighest.withAlpha(204);
            }
            if (states.contains(WidgetState.hovered)) {
              return colorScheme.surfaceContainerHighest.withAlpha(230);
            }
            return colorScheme.surfaceContainerHighest;
          }),
        );

      case YoButtonVariant.outline:
        final borderWidth = buttonStyle == YoButtonStyle.minimalist ? 1.0 : 1.5;
        // Determine border color: custom > followsText > primary
        final effectiveBorderColor = borderColor ??
            (borderColorFollowsText
                ? (textColor ?? colorScheme.primary)
                : colorScheme.primary);
        return ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: textColor ?? colorScheme.primary,
          disabledBackgroundColor: Colors.transparent,
          disabledForegroundColor: colorScheme.onSurface.withAlpha(97),
          side: BorderSide(
            color: onPressed != null
                ? effectiveBorderColor
                : colorScheme.onSurface.withAlpha(97),
            width: borderWidth,
          ),
          elevation: 0,
          shadowColor: Colors.transparent,
          padding: EdgeInsets.zero,
        ).copyWith(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.hovered)) {
              return (textColor ?? colorScheme.primary).withAlpha(20);
            }
            if (states.contains(WidgetState.pressed)) {
              return (textColor ?? colorScheme.primary).withAlpha(31);
            }
            return Colors.transparent;
          }),
        );

      case YoButtonVariant.ghost:
        return ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: colorScheme.primary,
          disabledBackgroundColor: Colors.transparent,
          disabledForegroundColor: colorScheme.onSurface.withAlpha(97),
          elevation: 0,
          shadowColor: Colors.transparent,
          padding: EdgeInsets.zero,
        ).copyWith(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.hovered)) {
              return colorScheme.primary.withAlpha(20);
            }
            if (states.contains(WidgetState.pressed)) {
              return colorScheme.primary.withAlpha(31);
            }
            return Colors.transparent;
          }),
        );

      case YoButtonVariant.custom:
        final bgColor = backgroundColor ?? colorScheme.primary;
        return ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: _getCustomTextColor(context, bgColor),
          disabledBackgroundColor: bgColor.withAlpha(82),
          disabledForegroundColor: colorScheme.onSurface.withAlpha(97),
          elevation: elevation,
          shadowColor: Colors.transparent,
          padding: EdgeInsets.zero,
        ).copyWith(
          elevation: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.hovered)) return hoverElevation;
            if (states.contains(WidgetState.pressed)) return 0;
            return elevation;
          }),
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return bgColor.withAlpha(82);
            }
            if (states.contains(WidgetState.pressed)) {
              return bgColor.withAlpha(204);
            }
            if (states.contains(WidgetState.hovered)) {
              return bgColor.withAlpha(230);
            }
            return bgColor;
          }),
        );
    }
  }

  Color _getCustomTextColor(BuildContext context, Color bgColor) {
    if (textColor != null) return textColor!;
    final luminance = bgColor.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }

  double _getIconSize() {
    switch (size) {
      case YoButtonSize.small:
        return 16;
      case YoButtonSize.medium:
        return 18;
      case YoButtonSize.large:
        return 20;
    }
  }

  double _getIconSpacing() {
    switch (size) {
      case YoButtonSize.small:
        return 8;
      case YoButtonSize.medium:
        return 10;
      case YoButtonSize.large:
        return 12;
    }
  }

  EdgeInsets _getPadding() {
    // Adjust padding based on style
    final styleMultiplier = buttonStyle == YoButtonStyle.minimalist ? 0.8 : 1.0;

    switch (size) {
      case YoButtonSize.small:
        return EdgeInsets.symmetric(
          horizontal: 16 * styleMultiplier,
          vertical: 10 * styleMultiplier,
        );
      case YoButtonSize.medium:
        return EdgeInsets.symmetric(
          horizontal: 24 * styleMultiplier,
          vertical: 14 * styleMultiplier,
        );
      case YoButtonSize.large:
        return EdgeInsets.symmetric(
          horizontal: 32 * styleMultiplier,
          vertical: 18 * styleMultiplier,
        );
    }
  }

  Color _getProgressIndicatorColor(BuildContext context) {
    switch (variant) {
      case YoButtonVariant.primary:
      case YoButtonVariant.secondary:
      case YoButtonVariant.custom:
        return Theme.of(context).colorScheme.onPrimary;
      case YoButtonVariant.outline:
      case YoButtonVariant.ghost:
        return Theme.of(context).colorScheme.primary;
    }
  }

  OutlinedBorder _getShape(double radius) =>
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius));

  TextStyle _getTextStyle(BuildContext context) {
    final theme = Theme.of(context);
    final baseTextStyle = theme.textTheme;

    Color? txtColor;
    switch (variant) {
      case YoButtonVariant.primary:
      case YoButtonVariant.secondary:
        txtColor = textColor ?? context.onPrimaryColor;
        break;
      case YoButtonVariant.custom:
        txtColor = textColor ?? theme.colorScheme.onPrimary;
        break;
      case YoButtonVariant.outline:
      case YoButtonVariant.ghost:
        txtColor = textColor ?? theme.colorScheme.primary;
        break;
    }

    // Adjust font weight based on style
    final fontWeight = buttonStyle == YoButtonStyle.minimalist
        ? FontWeight.w400
        : FontWeight.w500;

    switch (size) {
      case YoButtonSize.small:
        return baseTextStyle.labelMedium!.copyWith(
          color: txtColor,
          fontWeight: fontWeight,
          letterSpacing: 0.1,
        );
      case YoButtonSize.medium:
        return baseTextStyle.bodyMedium!.copyWith(
          color: txtColor,
          fontWeight: fontWeight,
          letterSpacing: 0.15,
        );
      case YoButtonSize.large:
        return baseTextStyle.bodyLarge!.copyWith(
          color: txtColor,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.15,
        );
    }
  }
}

/// Button sizes
enum YoButtonSize { small, medium, large }

/// Button style presets
enum YoButtonStyle {
  /// Modern style with subtle gradients and shadows
  modern,

  /// Minimalist flat design
  minimalist,

  /// Rounded pill-shaped buttons
  pill,

  /// Sharp corners, bold look
  sharp,

  /// Soft rounded corners (default)
  rounded,
}

/// Button variants for different visual emphasis
enum YoButtonVariant { primary, secondary, outline, ghost, custom }
