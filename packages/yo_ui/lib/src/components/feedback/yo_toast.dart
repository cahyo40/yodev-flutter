import 'package:flutter/material.dart';
import 'package:yo_ui/yo_ui.dart';

/// Toast notification widget
class YoToast {
  /// Show error toast
  static void error({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onTap,
  }) {
    _show(
      context: context,
      message: message,
      type: YoToastType.error,
      duration: duration,
      onTap: onTap,
    );
  }

  /// Show info toast
  static void info({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onTap,
  }) {
    _show(
      context: context,
      message: message,
      type: YoToastType.info,
      duration: duration,
      onTap: onTap,
    );
  }

  /// Show success toast
  static void success({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onTap,
  }) {
    _show(
      context: context,
      message: message,
      type: YoToastType.success,
      duration: duration,
      onTap: onTap,
    );
  }

  /// Show warning toast
  static void warning({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onTap,
  }) {
    _show(
      context: context,
      message: message,
      type: YoToastType.warning,
      duration: duration,
      onTap: onTap,
    );
  }

  /// Show custom toast
  static void _show({
    required BuildContext context,
    required String message,
    required YoToastType type,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onTap,
  }) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => _YoToastWidget(
        message: message,
        type: type,
        onTap: onTap,
        onDismiss: () {
          overlayEntry.remove();
        },
      ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(duration, () {
      if (overlayEntry.mounted) {
        overlayEntry.remove();
      }
    });
  }
}

/// Toast type enum
enum YoToastType {
  success,
  error,
  info,
  warning,
}

/// Toast widget
class _YoToastWidget extends StatefulWidget {
  final String message;
  final YoToastType type;
  final VoidCallback? onTap;
  final VoidCallback onDismiss;

  const _YoToastWidget({
    required this.message,
    required this.type,
    this.onTap,
    required this.onDismiss,
  });

  @override
  State<_YoToastWidget> createState() => _YoToastWidgetState();
}

class _YoToastWidgetState extends State<_YoToastWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 16,
      left: 16,
      right: 16,
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Material(
            color: Colors.transparent,
            child: GestureDetector(
              onTap: () {
                widget.onTap?.call();
                widget.onDismiss();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: _getBackgroundColor(context),
                  borderRadius: BorderRadius.circular(context.yoRadiusLg),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(26),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(
                      _getIcon(),
                      color: Colors.white,
                      size: 24,
                    ),
                    const YoSpace.width(12),
                    Expanded(
                      child: YoText(
                        widget.message,
                        style: context.yoBodyMedium.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: widget.onDismiss,
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));
    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(_controller);

    _controller.forward();
  }

  Color _getBackgroundColor(BuildContext context) {
    switch (widget.type) {
      case YoToastType.success:
        return context.successColor;
      case YoToastType.error:
        return context.errorColor;
      case YoToastType.info:
        return context.infoColor;
      case YoToastType.warning:
        return context.warningColor;
    }
  }

  IconData _getIcon() {
    switch (widget.type) {
      case YoToastType.success:
        return Icons.check_circle;
      case YoToastType.error:
        return Icons.error;
      case YoToastType.info:
        return Icons.info;
      case YoToastType.warning:
        return Icons.warning;
    }
  }
}
