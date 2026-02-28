import 'dart:io';

import 'package:flutter/material.dart';
import 'package:yo_ui/yo_ui.dart';

/// Avatar widget dengan berbagai konfigurasi
class YoAvatar extends StatelessWidget {
  static const sizeMap = {
    YoAvatarSize.xs: 24.0,
    YoAvatarSize.sm: 32.0,
    YoAvatarSize.md: 40.0,
    YoAvatarSize.lg: 56.0,
    YoAvatarSize.xl: 72.0,
  };
  static const _textSizeMap = {
    YoAvatarSize.xs: 10.0,
    YoAvatarSize.sm: 12.0,
    YoAvatarSize.md: 14.0,
    YoAvatarSize.lg: 18.0,
    YoAvatarSize.xl: 24.0,
  };
  static const _iconSizeMap = {
    YoAvatarSize.xs: 12.0,
    YoAvatarSize.sm: 16.0,
    YoAvatarSize.md: 20.0,
    YoAvatarSize.lg: 28.0,
    YoAvatarSize.xl: 36.0,
  };
  static const _badgeSizeMap = {
    YoAvatarSize.xs: 8.0,
    YoAvatarSize.sm: 10.0,
    YoAvatarSize.md: 12.0,
    YoAvatarSize.lg: 14.0,
    YoAvatarSize.xl: 16.0,
  };
  final String? imageUrl;
  final String? assetPath;
  final File? imageFile;
  final String? text;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? iconColor;
  final YoAvatarSize size;
  final double? customSize;
  final YoAvatarVariant variant;
  final double? borderRadius;
  final bool showBadge;
  final Color? badgeColor;

  final Widget? customBadge;

  final VoidCallback? onTap;

  final double? borderWidth;

  final Color? borderColor;

  const YoAvatar({
    super.key,
    this.imageUrl,
    this.assetPath,
    this.imageFile,
    this.text,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.iconColor,
    this.size = YoAvatarSize.md,
    this.customSize,
    this.variant = YoAvatarVariant.circle,
    this.borderRadius,
    this.showBadge = false,
    this.badgeColor,
    this.customBadge,
    this.onTap,
    this.borderWidth,
    this.borderColor,
  }) : assert(
          imageUrl != null ||
              assetPath != null ||
              imageFile != null ||
              text != null ||
              icon != null,
          'Either imageUrl, assetPath, imageFile, text, or icon must be provided',
        );

  /// Icon avatar
  const YoAvatar.icon({
    super.key,
    required this.icon,
    this.backgroundColor,
    this.iconColor,
    this.size = YoAvatarSize.md,
    this.customSize,
    this.variant = YoAvatarVariant.circle,
    this.borderRadius,
    this.showBadge = false,
    this.badgeColor,
    this.customBadge,
    this.onTap,
    this.borderWidth,
    this.borderColor,
  })  : imageUrl = null,
        assetPath = null,
        imageFile = null,
        text = null,
        textColor = null;

  /// Image avatar (network URL)
  const YoAvatar.image({
    super.key,
    required this.imageUrl,
    this.size = YoAvatarSize.md,
    this.customSize,
    this.variant = YoAvatarVariant.circle,
    this.borderRadius,
    this.showBadge = false,
    this.badgeColor,
    this.customBadge,
    this.onTap,
    this.borderWidth,
    this.borderColor,
  })  : assetPath = null,
        imageFile = null,
        text = null,
        icon = null,
        backgroundColor = null,
        textColor = null,
        iconColor = null;

  /// Text/initials avatar
  const YoAvatar.text({
    super.key,
    required this.text,
    this.backgroundColor,
    this.textColor,
    this.size = YoAvatarSize.md,
    this.customSize,
    this.variant = YoAvatarVariant.circle,
    this.borderRadius,
    this.showBadge = false,
    this.badgeColor,
    this.customBadge,
    this.onTap,
    this.borderWidth,
    this.borderColor,
  })  : imageUrl = null,
        assetPath = null,
        imageFile = null,
        icon = null,
        iconColor = null;

  /// Asset image avatar (from assets folder)
  const YoAvatar.asset({
    super.key,
    required this.assetPath,
    this.size = YoAvatarSize.md,
    this.customSize,
    this.variant = YoAvatarVariant.circle,
    this.borderRadius,
    this.showBadge = false,
    this.badgeColor,
    this.customBadge,
    this.onTap,
    this.borderWidth,
    this.borderColor,
  })  : imageUrl = null,
        imageFile = null,
        text = null,
        icon = null,
        backgroundColor = null,
        textColor = null,
        iconColor = null;

  /// File image avatar (from device storage)
  // ignore: prefer_const_constructors_in_immutables
  YoAvatar.file({
    super.key,
    required this.imageFile,
    this.size = YoAvatarSize.md,
    this.customSize,
    this.variant = YoAvatarVariant.circle,
    this.borderRadius,
    this.showBadge = false,
    this.badgeColor,
    this.customBadge,
    this.onTap,
    this.borderWidth,
    this.borderColor,
  })  : imageUrl = null,
        assetPath = null,
        text = null,
        icon = null,
        backgroundColor = null,
        textColor = null,
        iconColor = null;

  /// Get pixel size from enum or custom size
  double get pixelSize => customSize ?? sizeMap[size]!;

  double get _effectiveTextSize =>
      customSize != null ? customSize! * 0.35 : _textSizeMap[size]!;

  double get _effectiveIconSize =>
      customSize != null ? customSize! * 0.5 : _iconSizeMap[size]!;

  double get _effectiveBadgeSize =>
      customSize != null ? customSize! * 0.25 : _badgeSizeMap[size]!;

  @override
  Widget build(BuildContext context) {
    final avatarSize = pixelSize;
    final effectiveBorderRadius = _getBorderRadius(avatarSize);

    Widget avatarContent = Container(
      width: avatarSize,
      height: avatarSize,
      decoration: BoxDecoration(
        borderRadius: effectiveBorderRadius,
        color: backgroundColor ?? context.gray100,
        border: borderWidth != null
            ? Border.all(
                color: borderColor ?? context.backgroundColor,
                width: borderWidth!,
              )
            : null,
      ),
      child: _buildContent(context, avatarSize),
    );

    if (onTap != null) {
      avatarContent = GestureDetector(onTap: onTap, child: avatarContent);
    }

    if (showBadge || customBadge != null) {
      return Stack(
        clipBehavior: Clip.none,
        children: [
          avatarContent,
          Positioned(
            top: 0,
            right: 0,
            child: customBadge ?? _buildBadge(context),
          ),
        ],
      );
    }

    return avatarContent;
  }

  Widget _buildBadge(BuildContext context) {
    final badgeSize = _effectiveBadgeSize;
    return Container(
      width: badgeSize,
      height: badgeSize,
      decoration: BoxDecoration(
        color: badgeColor ?? context.primaryColor,
        shape: BoxShape.circle,
        border: Border.all(color: context.backgroundColor, width: 1.5),
      ),
    );
  }

  Widget _buildContent(BuildContext context, double avatarSize) {
    // Network image
    if (imageUrl != null) {
      return ClipRRect(
        borderRadius: _getBorderRadius(avatarSize),
        child: Image.network(
          imageUrl!,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          errorBuilder: (_, __, ___) => _buildFallback(context),
          loadingBuilder: (_, child, progress) {
            if (progress == null) return child;
            return Center(
              child: YoBox(
                width: _effectiveIconSize,
                height: _effectiveIconSize,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  value: progress.expectedTotalBytes != null
                      ? progress.cumulativeBytesLoaded /
                          progress.expectedTotalBytes!
                      : null,
                ),
              ),
            );
          },
        ),
      );
    }

    // Asset image
    if (assetPath != null) {
      return ClipRRect(
        borderRadius: _getBorderRadius(avatarSize),
        child: Image.asset(
          assetPath!,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          errorBuilder: (_, __, ___) => _buildFallback(context),
        ),
      );
    }

    // File image
    if (imageFile != null) {
      return ClipRRect(
        borderRadius: _getBorderRadius(avatarSize),
        child: Image.file(
          imageFile!,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          errorBuilder: (_, __, ___) => _buildFallback(context),
        ),
      );
    }

    return _buildFallback(context);
  }

  Widget _buildFallback(BuildContext context) {
    if (text != null) {
      return Center(
        child: YoText(
          _getInitials(text!),
          color: textColor ?? context.gray600,
          fontSize: _effectiveTextSize,
          fontWeight: FontWeight.w600,
        ),
      );
    }

    return Center(
      child: Icon(
        icon ?? Icons.person,
        size: _effectiveIconSize,
        color: iconColor ?? context.gray500,
      ),
    );
  }

  BorderRadius _getBorderRadius(double avatarSize) {
    switch (variant) {
      case YoAvatarVariant.circle:
        return BorderRadius.circular(avatarSize / 2);
      case YoAvatarVariant.rounded:
        return BorderRadius.circular(borderRadius ?? YoSpacing.radiusMd);
      case YoAvatarVariant.square:
        return BorderRadius.circular(borderRadius ?? YoSpacing.radiusSm);
    }
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length == 1) {
      return parts[0].length > 1
          ? parts[0].substring(0, 2).toUpperCase()
          : parts[0].toUpperCase();
    }
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }
}

enum YoAvatarSize { xs, sm, md, lg, xl }

enum YoAvatarVariant { circle, rounded, square }
