import 'package:flutter/material.dart';
import 'package:yo_ui/yo_ui.dart';

/// Snackbar dengan berbagai tipe dan preset
class YoSnackBar {
  YoSnackBar._();

  /// Show snackbar dengan konfigurasi lengkap
  static void show({
    required BuildContext context,
    required String message,
    String? actionText,
    VoidCallback? onAction,
    YoSnackBarType type = YoSnackBarType.info,
    Duration duration = const Duration(seconds: 4),
    bool showIcon = true,
    bool floating = true,
    SnackBarAction? customAction,
  }) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        _buildSnackBar(
          context: context,
          message: message,
          actionText: actionText,
          onAction: onAction,
          type: type,
          duration: duration,
          showIcon: showIcon,
          floating: floating,
          customAction: customAction,
        ),
      );
  }

  /// Success snackbar
  static void success(
    BuildContext context,
    String message, {
    VoidCallback? onAction,
    String? actionText,
  }) {
    show(
      context: context,
      message: message,
      type: YoSnackBarType.success,
      onAction: onAction,
      actionText: actionText,
    );
  }

  /// Error snackbar
  static void error(
    BuildContext context,
    String message, {
    VoidCallback? onAction,
    String? actionText,
  }) {
    show(
      context: context,
      message: message,
      type: YoSnackBarType.error,
      onAction: onAction,
      actionText: actionText,
    );
  }

  /// Warning snackbar
  static void warning(
    BuildContext context,
    String message, {
    VoidCallback? onAction,
    String? actionText,
  }) {
    show(
      context: context,
      message: message,
      type: YoSnackBarType.warning,
      onAction: onAction,
      actionText: actionText,
    );
  }

  /// Info snackbar
  static void info(
    BuildContext context,
    String message, {
    VoidCallback? onAction,
    String? actionText,
  }) {
    show(
      context: context,
      message: message,
      type: YoSnackBarType.info,
      onAction: onAction,
      actionText: actionText,
    );
  }

  /// Hide current snackbar
  static void hide(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }

  static SnackBar _buildSnackBar({
    required BuildContext context,
    required String message,
    required String? actionText,
    required VoidCallback? onAction,
    required YoSnackBarType type,
    required Duration duration,
    required bool showIcon,
    required bool floating,
    SnackBarAction? customAction,
  }) {
    final colors = _getColors(context, type);

    return SnackBar(
      backgroundColor: colors.$1,
      behavior: floating ? SnackBarBehavior.floating : SnackBarBehavior.fixed,
      shape: floating
          ? RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
          : null,
      margin: floating ? const EdgeInsets.all(16) : null,
      duration: duration,
      content: Row(
        children: [
          if (showIcon) ...[
            Icon(_getIcon(type), color: colors.$2, size: 20),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: colors.$2, fontSize: 14),
            ),
          ),
        ],
      ),
      action:
          customAction ??
          (actionText != null && onAction != null
              ? SnackBarAction(
                  label: actionText,
                  textColor: colors.$2,
                  onPressed: onAction,
                )
              : null),
    );
  }

  /// Returns (backgroundColor, textColor)
  static (Color, Color) _getColors(BuildContext context, YoSnackBarType type) {
    switch (type) {
      case YoSnackBarType.success:
        return (Colors.green.shade700, Colors.white);
      case YoSnackBarType.error:
        return (Theme.of(context).colorScheme.error, Colors.white);
      case YoSnackBarType.warning:
        return (Colors.orange.shade700, Colors.white);
      case YoSnackBarType.info:
        return (context.primaryColor, Colors.white);
    }
  }

  static IconData _getIcon(YoSnackBarType type) {
    switch (type) {
      case YoSnackBarType.success:
        return Icons.check_circle_rounded;
      case YoSnackBarType.error:
        return Icons.error_rounded;
      case YoSnackBarType.warning:
        return Icons.warning_rounded;
      case YoSnackBarType.info:
        return Icons.info_rounded;
    }
  }
}

enum YoSnackBarType { success, error, warning, info }
