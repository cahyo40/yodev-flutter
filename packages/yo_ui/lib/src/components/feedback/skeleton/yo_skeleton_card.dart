// [file name]: yo_skeleton_card.dart
import 'package:flutter/material.dart';

import '../../../../yo_ui.dart';

class YoSkeletonCard extends StatelessWidget {
  final bool hasImage;
  final bool hasTitle;
  final bool hasDescription;
  final bool hasActions;
  final int descriptionLines;
  final YoSkeletonType type;
  final Color? baseColor;
  final Color? highlightColor;
  final bool enabled;

  const YoSkeletonCard({
    super.key,
    this.hasImage = true,
    this.hasTitle = true,
    this.hasDescription = true,
    this.hasActions = true,
    this.descriptionLines = 2,
    this.type = YoSkeletonType.shimmer,
    this.baseColor,
    this.highlightColor,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!enabled) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(26),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image placeholder
          if (hasImage) ...[
            YoSkeleton.rounded(
              width: double.infinity,
              height: 160,
              type: type,
              baseColor: baseColor,
              highlightColor: highlightColor,
              enabled: enabled,
            ),
            const SizedBox(height: 16),
          ],

          // Title
          if (hasTitle) ...[
            YoSkeleton.line(
              width: double.infinity,
              height: 20,
              type: type,
              baseColor: baseColor,
              highlightColor: highlightColor,
              enabled: enabled,
            ),
            const SizedBox(height: 8),
          ],

          // Description lines
          if (hasDescription) ..._buildDescriptionLines(context),

          // Action buttons
          if (hasActions) ..._buildActions(context),
        ],
      ),
    );
  }

  List<Widget> _buildDescriptionLines(BuildContext context) {
    return List.generate(descriptionLines, (index) {
      return Padding(
        padding: EdgeInsets.only(bottom: index == descriptionLines - 1 ? 0 : 6),
        child: YoSkeleton.line(
          width: _getDescriptionLineWidth(index),
          height: 12,
          type: type,
          baseColor: baseColor,
          highlightColor: highlightColor,
          enabled: enabled,
        ),
      );
    });
  }

  List<Widget> _buildActions(BuildContext context) {
    return [
      const SizedBox(height: 16),
      Row(
        children: [
          Expanded(
            child: YoSkeleton.rounded(
              height: 36,
              type: type,
              baseColor: baseColor,
              highlightColor: highlightColor,
              enabled: enabled,
            ),
          ),
          const SizedBox(width: 12),
          YoSkeleton.rounded(
            width: 36,
            height: 36,
            type: type,
            baseColor: baseColor,
            highlightColor: highlightColor,
            enabled: enabled,
          ),
        ],
      ),
    ];
  }

  double _getDescriptionLineWidth(int index) {
    // Last line is usually shorter
    if (index == descriptionLines - 1) {
      return 0.6;
    }
    return double.infinity;
  }
}
