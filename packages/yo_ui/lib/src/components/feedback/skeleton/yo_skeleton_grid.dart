// [file name]: yo_skeleton_grid.dart
import 'package:flutter/material.dart';

import '../../../../yo_ui.dart';

class YoSkeletonGrid extends StatelessWidget {
  final int itemCount;
  final int crossAxisCount;
  final double childAspectRatio;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final YoSkeletonType type;
  final Color? baseColor;
  final Color? highlightColor;
  final bool enabled;

  const YoSkeletonGrid({
    super.key,
    this.itemCount = 6,
    this.crossAxisCount = 2,
    this.childAspectRatio = 1.0,
    this.crossAxisSpacing = 8,
    this.mainAxisSpacing = 8,
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

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio,
        crossAxisSpacing: crossAxisSpacing,
        mainAxisSpacing: mainAxisSpacing,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return YoSkeletonCard(
          hasImage: true,
          hasTitle: true,
          hasDescription: false,
          hasActions: false,
          type: type,
          baseColor: baseColor,
          highlightColor: highlightColor,
          enabled: enabled,
        );
      },
    );
  }
}
