import 'package:flutter/material.dart';
import 'package:yo_ui/yo_ui.dart';

/// Loading overlay untuk menampilkan loading state di atas konten
class YoLoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final String? message;
  final Widget child;
  final Color? overlayColor;
  final YoLoadingType loadingType;
  final bool showBackground;

  const YoLoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
    this.message,
    this.overlayColor,
    this.loadingType = YoLoadingType.spinner,
    this.showBackground = true,
  });

  /// Show fullscreen loading dialog
  static Future<void> show({
    required BuildContext context,
    String? message,
    bool barrierDismissible = false,
    YoLoadingType loadingType = YoLoadingType.spinner,
  }) async {
    await showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: Colors.black.withAlpha(128),
      builder: (context) => PopScope(
        canPop: barrierDismissible,
        child: _FullScreenLoading(message: message, loadingType: loadingType),
      ),
    );
  }

  /// Hide loading dialog safely
  static void hide(BuildContext context) {
    if (Navigator.of(context, rootNavigator: true).canPop()) {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  /// Show loading and execute async task, then hide
  static Future<T?> showWhile<T>({
    required BuildContext context,
    required Future<T> Function() task,
    String? message,
    YoLoadingType loadingType = YoLoadingType.spinner,
  }) async {
    show(context: context, message: message, loadingType: loadingType);
    try {
      final result = await task();
      if (context.mounted) hide(context);
      return result;
    } catch (e) {
      if (context.mounted) hide(context);
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          AnimatedOpacity(
            opacity: isLoading ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 200),
            child: Container(
              color: overlayColor ?? Colors.black.withAlpha(128),
              child: Center(
                child: _LoadingContent(
                  message: message,
                  loadingType: loadingType,
                  showBackground: showBackground,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _FullScreenLoading extends StatelessWidget {
  final String? message;
  final YoLoadingType loadingType;

  const _FullScreenLoading({
    this.message,
    this.loadingType = YoLoadingType.spinner,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.all(40),
      child: _LoadingContent(
        message: message,
        loadingType: loadingType,
        showBackground: true,
      ),
    );
  }
}

class _LoadingContent extends StatelessWidget {
  final String? message;
  final YoLoadingType loadingType;
  final bool showBackground;

  const _LoadingContent({
    this.message,
    this.loadingType = YoLoadingType.spinner,
    this.showBackground = true,
  });

  @override
  Widget build(BuildContext context) {
    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        YoLoading(size: 36, type: loadingType),
        if (message != null) ...[
          const YoSpace.height(16),
          YoText(
            message!,
            style: TextStyle(
              color: showBackground ? context.gray600 : Colors.white,
              fontSize: 14,
            ),
            align: TextAlign.center,
          ),
        ],
      ],
    );

    if (!showBackground) return content;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: context.backgroundColor,
        borderRadius: BorderRadius.circular(context.yoRadiusLg),
        boxShadow: YoBoxShadow.elevated(context),
      ),
      child: content,
    );
  }
}
