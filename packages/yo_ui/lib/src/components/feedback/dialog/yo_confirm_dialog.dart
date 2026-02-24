import 'package:flutter/material.dart';
import 'package:yo_ui/yo_ui.dart';

/// Confirmation dialog dengan berbagai preset
class YoConfirmDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final bool isDestructive;
  final Widget? icon;
  final bool showCancelButton;
  final bool isLoading;

  const YoConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmText = 'Ya',
    this.cancelText = 'Batal',
    this.onConfirm,
    this.onCancel,
    this.isDestructive = false,
    this.icon,
    this.showCancelButton = true,
    this.isLoading = false,
  });

  /// Show confirm dialog dan return true/false
  static Future<bool?> show({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = 'Ya',
    String cancelText = 'Batal',
    bool isDestructive = false,
    Widget? icon,
    bool showCancelButton = true,
    bool barrierDismissible = true,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (ctx) => YoConfirmDialog(
        title: title,
        message: message,
        confirmText: confirmText,
        cancelText: cancelText,
        isDestructive: isDestructive,
        icon: icon,
        showCancelButton: showCancelButton,
        onConfirm: () => Navigator.of(ctx).pop(true),
        onCancel: () => Navigator.of(ctx).pop(false),
      ),
    );
  }

  /// Destructive confirm (delete, remove, etc)
  static Future<bool?> showDestructive({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = 'Hapus',
    String cancelText = 'Batal',
  }) {
    return show(
      context: context,
      title: title,
      message: message,
      confirmText: confirmText,
      cancelText: cancelText,
      isDestructive: true,
      icon: const Icon(Icons.warning_amber_rounded, size: 48),
    );
  }

  /// Simple confirm with custom icon
  static Future<bool?> showWithIcon({
    required BuildContext context,
    required String title,
    required String message,
    required Widget icon,
    String confirmText = 'Ya',
    String cancelText = 'Batal',
  }) {
    return show(
      context: context,
      title: title,
      message: message,
      confirmText: confirmText,
      cancelText: cancelText,
      icon: icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final confirmColor = isDestructive
        ? theme.colorScheme.error
        : theme.colorScheme.primary;

    return Dialog(
      backgroundColor: context.backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            if (icon != null) ...[
              IconTheme(
                data: IconThemeData(
                  color: isDestructive
                      ? theme.colorScheme.error
                      : theme.colorScheme.primary,
                  size: 48,
                ),
                child: icon!,
              ),
              const SizedBox(height: 16),
            ],

            // Title
            Text(
              title,
              style: context.yoTitleLarge.copyWith(
                color: isDestructive ? theme.colorScheme.error : null,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 12),

            // Message
            Text(
              message,
              style: context.yoBodyMedium.copyWith(color: context.gray600),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 24),

            // Buttons
            if (showCancelButton)
              Row(
                children: [
                  Expanded(
                    child: YoButton.outline(
                      text: cancelText,
                      onPressed:
                          onCancel ?? () => Navigator.of(context).pop(false),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: YoButton.custom(
                      text: confirmText,
                      backgroundColor: confirmColor,
                      onPressed: isLoading ? null : onConfirm,
                      isLoading: isLoading,
                    ),
                  ),
                ],
              )
            else
              SizedBox(
                width: double.infinity,
                child: YoButton.custom(
                  text: confirmText,
                  backgroundColor: confirmColor,
                  onPressed: isLoading ? null : onConfirm,
                  isLoading: isLoading,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
