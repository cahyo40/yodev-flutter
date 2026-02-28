import 'package:flutter/material.dart';
import 'package:yo_ui/yo_ui.dart';

/// Info banner widget (top of screen)
class YoBanner extends StatefulWidget {
  final String message;
  final YoBannerType type;
  final Widget? action;
  final bool dismissible;
  final VoidCallback? onDismiss;
  final EdgeInsetsGeometry? padding;

  const YoBanner({
    super.key,
    required this.message,
    this.type = YoBannerType.info,
    this.action,
    this.dismissible = true,
    this.onDismiss,
    this.padding,
  });

  @override
  State<YoBanner> createState() => _YoBannerState();
}

/// Banner type enum
enum YoBannerType {
  info,
  warning,
  error,
  success,
}

class _YoBannerState extends State<YoBanner> {
  bool _isVisible = true;

  @override
  Widget build(BuildContext context) {
    if (!_isVisible) return const YoBox();

    return Container(
      color: _getBackgroundColor(context),
      padding: widget.padding ??
          const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Icon(
            _getIcon(),
            color: _getTextColor(context),
            size: 20,
          ),
          const YoSpace.width(12),
          Expanded(
            child: YoText(
              widget.message,
              style: context.yoBodyMedium.copyWith(
                color: _getTextColor(context),
              ),
            ),
          ),
          if (widget.action != null) ...[
            const YoSpace.width(8),
            widget.action!,
          ],
          if (widget.dismissible) ...[
            const YoSpace.width(8),
            IconButton(
              icon: Icon(
                Icons.close,
                color: _getTextColor(context),
                size: 20,
              ),
              onPressed: _dismiss,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ],
      ),
    );
  }

  void _dismiss() {
    setState(() => _isVisible = false);
    widget.onDismiss?.call();
  }

  Color _getBackgroundColor(BuildContext context) {
    switch (widget.type) {
      case YoBannerType.info:
        return context.infoColor.withAlpha(26);
      case YoBannerType.warning:
        return context.warningColor.withAlpha(26);
      case YoBannerType.error:
        return context.errorColor.withAlpha(26);
      case YoBannerType.success:
        return context.successColor.withAlpha(26);
    }
  }

  IconData _getIcon() {
    switch (widget.type) {
      case YoBannerType.info:
        return Icons.info_outline;
      case YoBannerType.warning:
        return Icons.warning_amber_outlined;
      case YoBannerType.error:
        return Icons.error_outline;
      case YoBannerType.success:
        return Icons.check_circle_outline;
    }
  }

  Color _getTextColor(BuildContext context) {
    switch (widget.type) {
      case YoBannerType.info:
        return context.infoColor;
      case YoBannerType.warning:
        return context.warningColor;
      case YoBannerType.error:
        return context.errorColor;
      case YoBannerType.success:
        return context.successColor;
    }
  }
}
