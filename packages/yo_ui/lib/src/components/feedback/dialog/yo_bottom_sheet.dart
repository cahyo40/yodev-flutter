import 'package:flutter/material.dart';
import 'package:yo_ui/yo_ui.dart';

/// Bottom sheet dengan header, konten, dan aksi
class YoBottomSheet extends StatelessWidget {
  final String? title;
  final Widget child;
  final List<Widget>? actions;
  final double? maxHeight;
  final EdgeInsetsGeometry? contentPadding;
  final bool showDragHandle;
  final bool showDivider;
  final bool isScrollable;

  const YoBottomSheet({
    super.key,
    this.title,
    required this.child,
    this.actions,
    this.maxHeight,
    this.contentPadding,
    this.showDragHandle = true,
    this.showDivider = false,
    this.isScrollable = true,
  });

  /// Show modal bottom sheet
  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    String? title,
    List<Widget>? actions,
    double? maxHeight,
    EdgeInsetsGeometry? contentPadding,
    bool isScrollControlled = true,
    bool useRootNavigator = false,
    bool isDismissible = true,
    bool enableDrag = true,
    bool showDragHandle = true,
    bool showDivider = false,
    bool isScrollable = true,
    RouteSettings? routeSettings,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      useRootNavigator: useRootNavigator,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black54,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      routeSettings: routeSettings,
      builder: (context) => YoBottomSheet(
        title: title,
        actions: actions,
        maxHeight: maxHeight,
        contentPadding: contentPadding,
        showDragHandle: showDragHandle,
        showDivider: showDivider,
        isScrollable: isScrollable,
        child: child,
      ),
    );
  }

  /// Show bottom sheet with list items
  static Future<T?> showList<T>({
    required BuildContext context,
    required List<YoBottomSheetItem<T>> items,
    String? title,
    bool showDragHandle = true,
  }) {
    return show<T>(
      context: context,
      title: title,
      showDragHandle: showDragHandle,
      isScrollable: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: items.map((item) => _buildListItem(context, item)).toList(),
      ),
    );
  }

  static Widget _buildListItem<T>(
    BuildContext context,
    YoBottomSheetItem<T> item,
  ) {
    return ListTile(
      leading:
          item.icon != null ? Icon(item.icon, color: item.iconColor) : null,
      title: YoText(item.title),
      subtitle: item.subtitle != null ? YoText(item.subtitle!) : null,
      trailing: item.trailing,
      enabled: item.enabled,
      onTap: () {
        // Execute custom action if provided
        item.onTap?.call();
        // Pop with value
        Navigator.of(context).pop(item.value);
      },
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
    );
  }

  @override
  Widget build(BuildContext context) {
    final maxSheetHeight =
        maxHeight ?? MediaQuery.of(context).size.height * 0.85;
    final safeAreaBottom = MediaQuery.of(context).padding.bottom;

    return Container(
      margin: EdgeInsets.only(bottom: safeAreaBottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          if (showDragHandle) ...[
            const YoSpace.height(8),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: context.gray400,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const YoSpace.height(8),
          ],

          // Content container
          Container(
            constraints: BoxConstraints(maxHeight: maxSheetHeight),
            decoration: BoxDecoration(
              color: context.backgroundColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(context.yoRadiusXl),
                topRight: Radius.circular(context.yoRadiusXl),
              ),
              boxShadow: YoBoxShadow.elevated(context),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                if (title != null) ...[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: YoText.titleLarge(
                            title!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (actions != null) ...actions!,
                      ],
                    ),
                  ),
                  if (showDivider) Divider(height: 1, color: context.gray200),
                ],

                // Content
                if (isScrollable)
                  Flexible(
                    child: SingleChildScrollView(
                      padding: contentPadding ?? const EdgeInsets.all(20),
                      child: child,
                    ),
                  )
                else
                  Padding(
                    padding: contentPadding ?? const EdgeInsets.all(20),
                    child: child,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Item untuk bottom sheet list
class YoBottomSheetItem<T> {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final Color? iconColor;
  final Widget? trailing;
  final T value;
  final VoidCallback? onTap;
  final bool enabled;

  const YoBottomSheetItem({
    required this.title,
    required this.value,
    this.subtitle,
    this.icon,
    this.iconColor,
    this.trailing,
    this.onTap,
    this.enabled = true,
  });
}
