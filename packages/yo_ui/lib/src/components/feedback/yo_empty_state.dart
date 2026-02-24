import 'package:flutter/material.dart';
import 'package:yo_ui/yo_ui.dart';

/// State widget untuk menampilkan kondisi kosong, error, atau tidak ada koneksi
class YoEmptyState extends StatelessWidget {
  final String title;
  final String description;
  final Widget? icon;
  final String? actionText;
  final VoidCallback? onAction;
  final String? secondaryActionText;
  final VoidCallback? onSecondaryAction;
  final YoEmptyStateType type;
  final Object? error;
  final bool showErrorDetails;

  const YoEmptyState({
    super.key,
    required this.title,
    required this.description,
    this.icon,
    this.actionText,
    this.onAction,
    this.secondaryActionText,
    this.onSecondaryAction,
    this.type = YoEmptyStateType.general,
    this.error,
    this.showErrorDetails = false,
  });

  /// No data state
  const YoEmptyState.noData({
    super.key,
    this.title = 'Tidak ada data',
    this.description = 'Data yang Anda cari tidak ditemukan',
    this.actionText,
    this.onAction,
    this.secondaryActionText,
    this.onSecondaryAction,
  }) : icon = const Icon(Icons.inbox_outlined),
       type = YoEmptyStateType.noData,
       error = null,
       showErrorDetails = false;

  /// No connection state
  const YoEmptyState.noConnection({
    super.key,
    this.title = 'Tidak ada koneksi',
    this.description = 'Periksa koneksi internet Anda dan coba lagi',
    this.actionText = 'Coba Lagi',
    this.onAction,
    this.secondaryActionText,
    this.onSecondaryAction,
  }) : icon = const Icon(Icons.wifi_off_rounded),
       type = YoEmptyStateType.noConnection,
       error = null,
       showErrorDetails = false;

  /// Error state (menggantikan YoErrorState)
  const YoEmptyState.error({
    super.key,
    this.title = 'Terjadi kesalahan',
    this.description = 'Maaf, terjadi kesalahan. Silakan coba lagi',
    this.actionText = 'Coba Lagi',
    this.onAction,
    this.secondaryActionText,
    this.onSecondaryAction,
    this.error,
    this.showErrorDetails = false,
  }) : icon = const Icon(Icons.error_outline_rounded),
       type = YoEmptyStateType.error;

  /// Search not found
  const YoEmptyState.searchNotFound({
    super.key,
    this.title = 'Tidak ditemukan',
    this.description = 'Coba gunakan kata kunci lain',
    this.actionText,
    this.onAction,
    this.secondaryActionText,
    this.onSecondaryAction,
  }) : icon = const Icon(Icons.search_off_rounded),
       type = YoEmptyStateType.search,
       error = null,
       showErrorDetails = false;

  /// Custom empty state dengan image
  factory YoEmptyState.custom({
    Key? key,
    required String title,
    required String description,
    required Widget image,
    String? actionText,
    VoidCallback? onAction,
  }) {
    return YoEmptyState(
      key: key,
      title: title,
      description: description,
      icon: image,
      actionText: actionText,
      onAction: onAction,
      type: YoEmptyStateType.general,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon with background for error type
            if (icon != null) ...[
              _buildIcon(context),
              const SizedBox(height: 24),
            ],

            // Title
            Text(
              title,
              style: context.yoTitleLarge,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 8),

            // Description
            Text(
              description,
              style: context.yoBodyMedium.copyWith(color: context.gray600),
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),

            // Error details
            if (error != null && showErrorDetails) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: context.gray100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  error.toString(),
                  style: context.yoBodySmall.copyWith(color: context.gray600),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],

            // Actions
            if (actionText != null && onAction != null) ...[
              const SizedBox(height: 24),
              YoButton.primary(text: actionText!, onPressed: onAction),
            ],

            if (secondaryActionText != null && onSecondaryAction != null) ...[
              const SizedBox(height: 12),
              YoButton.ghost(
                text: secondaryActionText!,
                onPressed: onSecondaryAction,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildIcon(BuildContext context) {
    final iconColor = _getIconColor(context);

    // Error type gets background
    if (type == YoEmptyStateType.error) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: iconColor.withAlpha(26),
          shape: BoxShape.circle,
        ),
        child: IconTheme(
          data: IconThemeData(size: 48, color: iconColor),
          child: icon!,
        ),
      );
    }

    return IconTheme(
      data: IconThemeData(size: 64, color: iconColor),
      child: icon!,
    );
  }

  Color _getIconColor(BuildContext context) {
    switch (type) {
      case YoEmptyStateType.noData:
      case YoEmptyStateType.search:
        return context.gray400;
      case YoEmptyStateType.noConnection:
        return context.warningColor;
      case YoEmptyStateType.error:
        return Theme.of(context).colorScheme.error;
      case YoEmptyStateType.general:
        return context.primaryColor;
    }
  }
}

enum YoEmptyStateType { general, noData, noConnection, error, search }
