import 'package:flutter/material.dart';
import 'package:yo_ui/yo_ui.dart';

/// Breadcrumb trail navigation widget
class YoBreadcrumb extends StatelessWidget {
  final List<YoBreadcrumbItem> items;
  final Widget? separator;
  final int? maxItems;
  final TextStyle? textStyle;
  final TextStyle? activeTextStyle;
  final Color? separatorColor;

  const YoBreadcrumb({
    super.key,
    required this.items,
    this.separator,
    this.maxItems,
    this.textStyle,
    this.activeTextStyle,
    this.separatorColor,
  });

  @override
  Widget build(BuildContext context) {
    final displayItems = maxItems != null && items.length > maxItems!
        ? [
            ...items.take(1),
            YoBreadcrumbItem(label: '...', onTap: null),
            ...items.skip(items.length - (maxItems! - 2)),
          ]
        : items;

    return Wrap(
      spacing: 8,
      runSpacing: 4,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: List.generate(
        displayItems.length * 2 - 1,
        (index) {
          if (index.isEven) {
            final itemIndex = index ~/ 2;
            final item = displayItems[itemIndex];
            final isLast = itemIndex == displayItems.length - 1;

            return InkWell(
              onTap: item.onTap,
              borderRadius: BorderRadius.circular(4),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (item.icon != null) ...[
                      Icon(item.icon, size: 16, color: context.gray600),
                      const SizedBox(width: 4),
                    ],
                    Text(
                      item.label,
                      style: isLast
                          ? (activeTextStyle ??
                              context.yoBodyMedium.copyWith(
                                fontWeight: FontWeight.w600,
                              ))
                          : (textStyle ?? context.yoBodyMedium),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Icon(
              Icons.chevron_right,
              size: 16,
              color: separatorColor ?? context.gray400,
            );
          }
        },
      ),
    );
  }
}

/// Breadcrumb item model
class YoBreadcrumbItem {
  final String label;
  final VoidCallback? onTap;
  final IconData? icon;

  const YoBreadcrumbItem({
    required this.label,
    this.onTap,
    this.icon,
  });
}
