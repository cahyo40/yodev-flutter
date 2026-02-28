// File: yo_list_tile.dart
import 'package:flutter/material.dart';
import 'package:yo_ui/yo_ui.dart';

class YoListTile extends StatelessWidget {
  final Widget? leading;
  final String? title;
  final Widget? titleWidget;
  final String? subtitle;
  final Widget? subtitleWidget;
  final Widget? trailing;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool enabled;
  final bool selected;
  final Color? selectedColor;
  final Color? tileColor;
  final EdgeInsetsGeometry? contentPadding;
  final bool dense;
  final VisualDensity? visualDensity;
  final ShapeBorder? shape;
  final ListTileStyle? style;
  final Color? iconColor;
  final Color? textColor;
  final bool isThreeLine;

  const YoListTile({
    super.key,
    this.leading,
    this.title,
    this.titleWidget,
    this.subtitle,
    this.subtitleWidget,
    this.trailing,
    this.onTap,
    this.onLongPress,
    this.enabled = true,
    this.selected = false,
    this.selectedColor,
    this.tileColor,
    this.contentPadding,
    this.dense = false,
    this.visualDensity,
    this.shape,
    this.style,
    this.iconColor,
    this.textColor,
    this.isThreeLine = false,
  }) : assert(
         title != null || titleWidget != null,
         'Either title or titleWidget must be provided',
       );

  // Predefined variants
  YoListTile.simple({
    super.key,
    required String this.title,
    this.subtitle,
    IconData? icon,
    this.trailing,
    this.onTap,
    this.enabled = true,
    this.contentPadding,
  }) : leading = icon != null ? Icon(icon) : null,
       titleWidget = null,
       subtitleWidget = null,
       onLongPress = null,
       selected = false,
       selectedColor = null,
       tileColor = null,
       dense = false,
       visualDensity = null,
       shape = null,
       style = null,
       iconColor = null,
       textColor = null,
       isThreeLine = false;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: leading,
      title: titleWidget ?? (title != null ? YoText(title!) : null),
      subtitle: subtitleWidget ?? (subtitle != null ? YoText(subtitle!) : null),
      trailing: trailing,
      onTap: onTap,
      onLongPress: onLongPress,
      enabled: enabled,
      selected: selected,
      selectedColor: selectedColor ?? context.primaryColor,
      selectedTileColor: (selectedColor ?? context.primaryColor).withAlpha(
        26,
      ),
      tileColor: tileColor,
      contentPadding:
          contentPadding ??
          EdgeInsets.symmetric(
            horizontal: context.yoSpacingMd,
            vertical: context.yoSpacingSm,
          ),
      dense: dense,
      visualDensity: visualDensity,
      shape:
          shape ??
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(context.yoRadiusMd)),
      style: style,
      iconColor: iconColor,
      textColor: textColor,
      isThreeLine: isThreeLine,
    );
  }
}

// Specialized list tiles
class YoListTileWithAvatar extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String? subtitle;
  final String? timestamp;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool hasUnread;
  final bool isOnline;

  const YoListTileWithAvatar({
    super.key,
    required this.imageUrl,
    required this.title,
    this.subtitle,
    this.timestamp,
    this.trailing,
    this.onTap,
    this.hasUnread = false,
    this.isOnline = false,
  });

  @override
  Widget build(BuildContext context) {
    return YoListTile(
      leading: Stack(
        children: [
          YoAvatar.image(imageUrl: imageUrl, size: YoAvatarSize.md),
          if (isOnline)
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: context.successColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: context.backgroundColor, width: 2),
                ),
              ),
            ),
        ],
      ),
      title: title,
      subtitle: subtitle,
      trailing:
          trailing ??
          (timestamp != null
              ? YoText(
                  timestamp!,
                  style: context.yoBodySmall.copyWith(color: context.gray500),
                )
              : null),
      onTap: onTap,
      tileColor: hasUnread ? context.primaryColor.withAlpha(13) : null,
    );
  }
}

class YoListTileWithSwitch extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final IconData? icon;

  const YoListTileWithSwitch({
    super.key,
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return YoListTile(
      leading: icon != null ? Icon(icon) : null,
      title: title,
      subtitle: subtitle,
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeThumbColor: context.primaryColor,
      ),
      onTap: () => onChanged(!value),
    );
  }
}
