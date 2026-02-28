import 'package:flutter/material.dart';

import '../../../yo_ui_base.dart';

class YoErrorState extends StatelessWidget {
  final String title;
  final String description;
  final String actionText;
  final VoidCallback onRetry;
  final Object? error;

  const YoErrorState({
    super.key,
    this.title = 'Terjadi Kesalahan',
    this.description = 'Maaf, terjadi kesalahan. Silakan coba lagi',
    this.actionText = 'Coba Lagi',
    required this.onRetry,
    this.error,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: YoColors.error(context).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline,
                size: 64,
                color: YoColors.error(context),
              ),
            ),
            const YoSpace.height(24),
            YoText.titleLarge(
              title,
              align: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const YoSpace.height(8),
            YoText.bodyMedium(
              description,
              align: TextAlign.center,
              color: YoColors.gray600(context),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            if (error != null) ...[
              const YoSpace.height(16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: YoColors.gray100(context),
                  borderRadius: BorderRadius.circular(context.yoRadiusMd),
                ),
                child: YoText.bodySmall(
                  error.toString(),
                  color: YoColors.gray600(context),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
            const YoSpace.height(24),
            YoButton.primary(
              text: actionText,
              onPressed: onRetry,
              size: YoButtonSize.medium,
            ),
          ],
        ),
      ),
    );
  }
}
