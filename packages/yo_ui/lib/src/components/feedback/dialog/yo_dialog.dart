import 'package:flutter/material.dart';
import 'package:yo_ui/yo_ui.dart';

/// Dialog dasar dengan berbagai konfigurasi
class YoDialog extends StatelessWidget {
  final String title;
  final String? message;
  final Widget? content;
  final List<Widget>? actions;
  final Widget? icon;
  final bool showCloseButton;
  final VoidCallback? onClose;
  final bool centerTitle;
  final double? maxWidth;

  const YoDialog({
    super.key,
    required this.title,
    this.message,
    this.content,
    this.actions,
    this.icon,
    this.showCloseButton = false,
    this.onClose,
    this.centerTitle = true,
    this.maxWidth,
  });

  /// Show dialog dengan return value
  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    String? message,
    Widget? content,
    List<Widget>? actions,
    Widget? icon,
    bool showCloseButton = false,
    bool centerTitle = true,
    bool barrierDismissible = true,
    double? maxWidth,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => YoDialog(
        title: title,
        message: message,
        content: content,
        actions: actions,
        icon: icon,
        showCloseButton: showCloseButton,
        centerTitle: centerTitle,
        maxWidth: maxWidth,
      ),
    );
  }

  /// Info dialog
  static Future<void> info({
    required BuildContext context,
    required String title,
    required String message,
    String buttonText = 'OK',
  }) {
    return show(
      context: context,
      title: title,
      message: message,
      icon: Icon(
        Icons.info_outline_rounded,
        color: context.primaryColor,
        size: 48,
      ),
      actions: [
        YoButton.primary(
          text: buttonText,
          onPressed: () => Navigator.of(context).pop(),
          expanded: true,
        ),
      ],
    );
  }

  /// Success dialog
  static Future<void> success({
    required BuildContext context,
    required String title,
    required String message,
    String buttonText = 'OK',
  }) {
    return show(
      context: context,
      title: title,
      message: message,
      icon: const Icon(
        Icons.check_circle_outline_rounded,
        color: Colors.green,
        size: 48,
      ),
      actions: [
        YoButton.primary(
          text: buttonText,
          onPressed: () => Navigator.of(context).pop(),
          expanded: true,
        ),
      ],
    );
  }

  /// Error dialog
  static Future<void> error({
    required BuildContext context,
    required String title,
    required String message,
    String buttonText = 'OK',
  }) {
    return show(
      context: context,
      title: title,
      message: message,
      icon: Icon(
        Icons.error_outline_rounded,
        color: Theme.of(context).colorScheme.error,
        size: 48,
      ),
      actions: [
        YoButton.primary(
          text: buttonText,
          onPressed: () => Navigator.of(context).pop(),
          expanded: true,
        ),
      ],
    );
  }

  /// Warning dialog
  static Future<void> warning({
    required BuildContext context,
    required String title,
    required String message,
    String buttonText = 'OK',
  }) {
    return show(
      context: context,
      title: title,
      message: message,
      icon: const Icon(
        Icons.warning_amber_rounded,
        color: Colors.orange,
        size: 48,
      ),
      actions: [
        YoButton.primary(
          text: buttonText,
          onPressed: () => Navigator.of(context).pop(),
          expanded: true,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: context.backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(context.yoRadiusXl)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth ?? 400),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: centerTitle
                ? CrossAxisAlignment.center
                : CrossAxisAlignment.start,
            children: [
              // Close button
              if (showCloseButton)
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: Icon(Icons.close, color: context.gray500, size: 20),
                    onPressed: onClose ?? () => Navigator.of(context).pop(),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 32,
                      minHeight: 32,
                    ),
                  ),
                ),

              // Icon
              if (icon != null) ...[icon!, const YoSpace.height(16)],

              // Title
              YoText.titleLarge(
                title,
                align: centerTitle ? TextAlign.center : TextAlign.start,
              ),

              // Message
              if (message != null) ...[
                const YoSpace.height(12),
                YoText.bodyMedium(
                  message!,
                  color: context.gray600,
                  align: centerTitle ? TextAlign.center : TextAlign.start,
                ),
              ],

              // Custom content
              if (content != null) ...[const YoSpace.height(16), content!],

              // Actions
              if (actions != null && actions!.isNotEmpty) ...[
                const YoSpace.height(24),
                _buildActions(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActions() {
    if (actions!.length == 1) {
      return YoBox(width: double.infinity, child: actions!.first);
    }

    return Row(
      children: actions!.asMap().entries.map((entry) {
        final isLast = entry.key == actions!.length - 1;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: isLast ? 0 : 12),
            child: entry.value,
          ),
        );
      }).toList(),
    );
  }
}
