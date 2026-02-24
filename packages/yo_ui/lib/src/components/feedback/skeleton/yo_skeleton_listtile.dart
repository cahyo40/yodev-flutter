// [file name]: yo_skeleton_list_tile.dart
import 'package:flutter/material.dart';

import '../../../../yo_ui.dart';

class YoSkeletonListTile extends StatelessWidget {
  final bool hasLeading;
  final bool hasSubtitle;
  final bool hasTrailing;
  final YoSkeletonType type;
  final Color? baseColor;
  final Color? highlightColor;
  final bool enabled;
  final double verticalPadding;

  const YoSkeletonListTile({
    super.key,
    this.hasLeading = true,
    this.hasSubtitle = true,
    this.hasTrailing = true,
    this.type = YoSkeletonType.shimmer,
    this.baseColor,
    this.highlightColor,
    this.enabled = true,
    this.verticalPadding = 8.0,
  });

  const YoSkeletonListTile.withLeading({
    super.key,
    this.hasSubtitle = true,
    this.hasTrailing = true,
    this.type = YoSkeletonType.shimmer,
    this.baseColor,
    this.highlightColor,
    this.enabled = true,
    this.verticalPadding = 8.0,
  }) : hasLeading = true;

  const YoSkeletonListTile.withoutLeading({
    super.key,
    this.hasSubtitle = true,
    this.hasTrailing = true,
    this.type = YoSkeletonType.shimmer,
    this.baseColor,
    this.highlightColor,
    this.enabled = true,
    this.verticalPadding = 8.0,
  }) : hasLeading = false;

  @override
  Widget build(BuildContext context) {
    if (!enabled) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: verticalPadding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Leading widget (avatar/icon)
          if (hasLeading) ...[
            YoSkeleton.circle(
              size: 40,
              type: type,
              baseColor: baseColor,
              highlightColor: highlightColor,
              enabled: enabled,
            ),
            const SizedBox(width: 16),
          ],

          // Title and subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                YoSkeleton.line(
                  width: _getTitleWidth(context),
                  height: 16,
                  type: type,
                  baseColor: baseColor,
                  highlightColor: highlightColor,
                  enabled: enabled,
                ),
                if (hasSubtitle) ...[
                  const SizedBox(height: 8),
                  YoSkeleton.line(
                    width: _getSubtitleWidth(context),
                    height: 12,
                    type: type,
                    baseColor: baseColor,
                    highlightColor: highlightColor,
                    enabled: enabled,
                  ),
                ],
              ],
            ),
          ),

          // Trailing widget
          if (hasTrailing) ...[
            const SizedBox(width: 16),
            YoSkeleton.rounded(
              width: 60,
              height: 24,
              type: type,
              baseColor: baseColor,
              highlightColor: highlightColor,
              enabled: enabled,
            ),
          ],
        ],
      ),
    );
  }

  double _getTitleWidth(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final leadingSpace = hasLeading ? 56.0 : 0.0;
    final trailingSpace = hasTrailing ? 76.0 : 0.0;

    return screenWidth - leadingSpace - trailingSpace - 32;
  }

  double _getSubtitleWidth(BuildContext context) {
    final titleWidth = _getTitleWidth(context);
    return titleWidth * 0.7;
  }
}
