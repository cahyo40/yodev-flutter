import 'package:flutter/material.dart';
import 'package:yo_ui/yo_ui.dart';

/// Drawer widget with header, items, and footer
class YoDrawer extends StatelessWidget {
  final Widget? header;
  final List<YoDrawerItem> items;
  final Widget? footer;
  final double width;
  final Color? backgroundColor;
  final double elevation;

  const YoDrawer({
    super.key,
    this.header,
    required this.items,
    this.footer,
    this.width = 280,
    this.backgroundColor,
    this.elevation = 16.0,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: width,
      elevation: elevation,
      backgroundColor: backgroundColor ?? context.backgroundColor,
      child: SafeArea(
        child: Column(
          children: [
            if (header != null) header!,
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: items.length,
                itemBuilder: (_, i) => items[i]._build(context),
              ),
            ),
            if (footer != null) footer!,
          ],
        ),
      ),
    );
  }
}

/// Drawer item configuration
class YoDrawerItem {
  final IconData? icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool isSelected;
  final bool isDivider;
  final bool isHeader;
  final Color? selectedColor;
  final Color? iconColor;
  final Color? textColor;

  const YoDrawerItem({
    this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.isSelected = false,
    this.isDivider = false,
    this.isHeader = false,
    this.selectedColor,
    this.iconColor,
    this.textColor,
  });

  /// Create a divider
  const YoDrawerItem.divider()
      : icon = null,
        title = '',
        subtitle = null,
        trailing = null,
        onTap = null,
        isSelected = false,
        isDivider = true,
        isHeader = false,
        selectedColor = null,
        iconColor = null,
        textColor = null;

  /// Create a section header
  const YoDrawerItem.header(this.title)
      : icon = null,
        subtitle = null,
        trailing = null,
        onTap = null,
        isSelected = false,
        isDivider = false,
        isHeader = true,
        selectedColor = null,
        iconColor = null,
        textColor = null;

  Widget _build(BuildContext context) {
    if (isDivider) {
      return const Divider(height: 1);
    }

    if (isHeader) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: YoText(
          title.toUpperCase(),
          style: context.yoBodySmall.copyWith(
            color: context.gray500,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      );
    }

    final color = isSelected ? (selectedColor ?? context.primaryColor) : null;

    return ListTile(
      leading: icon != null
          ? Icon(
              icon,
              color: iconColor ?? (isSelected ? color : context.gray600),
              size: 22,
            )
          : null,
      title: YoText(
        title,
        style: context.yoBodyMedium.copyWith(
          color: textColor ?? (isSelected ? color : context.textColor),
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      subtitle: subtitle != null
          ? YoText(
              subtitle!,
              style: context.yoBodySmall.copyWith(color: context.gray500),
            )
          : null,
      trailing: trailing,
      onTap: onTap,
      selected: isSelected,
      selectedColor: color,
      selectedTileColor: color?.withAlpha(26),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      dense: true,
    );
  }
}

/// Drawer header with user info
class YoDrawerHeader extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final String? imageUrl;
  final Widget? avatar;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Gradient? gradient;
  final Widget? trailing;

  const YoDrawerHeader({
    super.key,
    this.title,
    this.subtitle,
    this.imageUrl,
    this.avatar,
    this.onTap,
    this.backgroundColor,
    this.gradient,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor ?? context.primaryColor,
        gradient: gradient ?? context.primaryGradient,
      ),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            // Avatar
            avatar ??
                (imageUrl != null
                    ? YoAvatar.image(imageUrl: imageUrl!, size: YoAvatarSize.lg)
                    : const YoAvatar.icon(
                        icon: Icons.person,
                        size: YoAvatarSize.lg,
                      )),
            const YoSpace.width(12),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (title != null)
                    YoText(
                      title!,
                      style: context.yoTitleSmall.copyWith(
                        color: context.onPrimaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  if (subtitle != null) ...[
                    const YoSpace.height(2),
                    YoText(
                      subtitle!,
                      style: context.yoBodySmall.copyWith(
                        color: context.onPrimaryColor.withAlpha(204),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),

            // Trailing
            if (trailing != null)
              trailing!
            else if (onTap != null)
              Icon(
                Icons.keyboard_arrow_down,
                color: context.onPrimaryColor.withAlpha(178),
              ),
          ],
        ),
      ),
    );
  }
}

/// Drawer footer
class YoDrawerFooter extends StatelessWidget {
  final String? text;
  final String? version;
  final VoidCallback? onTap;
  final Widget? child;

  const YoDrawerFooter({
    super.key,
    this.text,
    this.version,
    this.onTap,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    if (child != null) return child!;

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: context.gray200)),
        ),
        child: Row(
          children: [
            if (text != null)
              Expanded(
                child: YoText(
                  text!,
                  style: context.yoBodySmall.copyWith(color: context.gray500),
                ),
              ),
            if (version != null)
              YoText(
                'v$version',
                style: context.yoBodySmall.copyWith(color: context.gray400),
              ),
          ],
        ),
      ),
    );
  }
}
