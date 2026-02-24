// File: yo_tab_bar.dart
import 'package:flutter/material.dart';
import 'package:yo_ui/yo_ui.dart';

class YoTabBar extends StatelessWidget implements PreferredSizeWidget {
  final List<YoTabItem> tabs;
  final int currentIndex;
  final ValueChanged<int> onTap;
  final bool isScrollable;
  final Color? indicatorColor;
  final double indicatorWeight;
  final EdgeInsets indicatorPadding;
  final Decoration? indicatorDecoration;
  final Color? labelColor;
  final Color? unselectedLabelColor;
  final TextStyle? labelStyle;
  final TextStyle? unselectedLabelStyle;
  final EdgeInsets labelPadding;
  final double? height;

  const YoTabBar({
    super.key,
    required this.tabs,
    required this.currentIndex,
    required this.onTap,
    this.isScrollable = false,
    this.indicatorColor,
    this.indicatorWeight = 2.0,
    this.indicatorPadding = EdgeInsets.zero,
    this.indicatorDecoration,
    this.labelColor,
    this.unselectedLabelColor,
    this.labelStyle,
    this.unselectedLabelStyle,
    this.labelPadding = EdgeInsets.zero,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.backgroundColor,
        border: Border(bottom: BorderSide(color: context.gray200, width: 1)),
      ),
      child: TabBar(
        tabs: tabs.map((tab) => tab.build(context)).toList(),
        onTap: onTap,
        isScrollable: isScrollable,
        indicatorColor: indicatorColor ?? context.primaryColor,
        indicatorWeight: indicatorWeight,
        indicatorPadding: indicatorPadding,
        indicator: indicatorDecoration != null
            ? TabBarIndicator(decoration: indicatorDecoration!)
            : null,
        labelColor: labelColor ?? context.primaryColor,
        unselectedLabelColor: unselectedLabelColor ?? context.gray500,
        labelStyle: labelStyle ?? context.yoLabelMedium,
        unselectedLabelStyle: unselectedLabelStyle ?? context.yoLabelMedium,
        labelPadding: labelPadding,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height ?? 48.0);
}

class YoTabItem {
  final String text;
  final IconData? icon;
  final Widget? customWidget;
  final String? badge;
  final Color? badgeColor;

  const YoTabItem({
    required this.text,
    this.icon,
    this.customWidget,
    this.badge,
    this.badgeColor,
  });

  const YoTabItem.icon({
    required this.icon,
    required this.text,
    this.badge,
    this.badgeColor,
  }) : customWidget = null;

  Widget build(BuildContext context) {
    if (customWidget != null) return customWidget!;

    return Tab(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18),
                const SizedBox(width: 4),
              ],
              Text(text),
            ],
          ),
          if (badge != null) ...[
            Positioned(
              top: -8,
              right: -8,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: badgeColor ?? context.errorColor,
                  shape: BoxShape.circle,
                ),
                constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                child: Text(
                  badge!,
                  style: TextStyle(
                    color: context.onPrimaryColor,
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                    height: 1,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// TabBar dengan indicator custom
class TabBarIndicator extends Decoration {
  final Decoration decoration;

  const TabBarIndicator({required this.decoration});

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _TabBarIndicatorPainter(decoration, onChanged);
  }
}

class _TabBarIndicatorPainter extends BoxPainter {
  final Decoration decoration;

  _TabBarIndicatorPainter(this.decoration, VoidCallback? onChanged)
    : super(onChanged);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final Rect rect = offset & configuration.size!;
    final decoration = this.decoration;
    decoration
        .createBoxPainter(onChanged!)
        .paint(canvas, rect as Offset, configuration);
  }
}
