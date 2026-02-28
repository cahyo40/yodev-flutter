import 'package:flutter/material.dart';
import 'package:yo_ui/yo_ui.dart';

/// Full-screen modal widget
class YoModal {
  /// Show modal
  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    String? title,
    double? height,
    bool isDismissible = true,
    bool showDragHandle = true,
    Color? backgroundColor,
    VoidCallback? onDismiss,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      isDismissible: isDismissible,
      backgroundColor: Colors.transparent,
      builder: (context) => _YoModalSheet(
        title: title,
        height: height,
        showDragHandle: showDragHandle,
        backgroundColor: backgroundColor,
        onDismiss: onDismiss,
        child: child,
      ),
    );
  }
}

class _YoModalSheet extends StatelessWidget {
  final Widget child;
  final String? title;
  final double? height;
  final bool showDragHandle;
  final Color? backgroundColor;
  final VoidCallback? onDismiss;

  const _YoModalSheet({
    required this.child,
    this.title,
    this.height,
    this.showDragHandle = true,
    this.backgroundColor,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final modalHeight = height != null
        ? (height! <= 1 ? screenHeight * height! : height!)
        : screenHeight * 0.9;

    return Container(
      height: modalHeight,
      decoration: BoxDecoration(
        color: backgroundColor ?? context.backgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(context.yoRadiusXl),
          topRight: Radius.circular(context.yoRadiusXl),
        ),
      ),
      child: Column(
        children: [
          if (showDragHandle)
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: context.gray300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          if (title != null)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: YoText(
                      title!,
                      style: context.yoHeadlineSmall,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      onDismiss?.call();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}
