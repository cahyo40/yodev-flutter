import 'package:flutter/material.dart';
import 'package:yo_ui/yo_ui.dart';

/// Overlapping avatars untuk menampilkan grup user
class YoAvatarOverlap extends StatelessWidget {
  final List<String> imageUrls;
  final List<YoAvatar>? avatars;
  final double overlap;
  final YoAvatarSize size;
  final int maxDisplay;
  final Widget? moreBuilder;
  final VoidCallback? onTapMore;
  final YoAvatarVariant variant;

  const YoAvatarOverlap({
    super.key,
    required this.imageUrls,
    this.overlap = 0.3,
    this.size = YoAvatarSize.md,
    this.maxDisplay = 4,
    this.moreBuilder,
    this.onTapMore,
    this.variant = YoAvatarVariant.circle,
  }) : avatars = null;

  /// Dengan custom avatars
  const YoAvatarOverlap.custom({
    super.key,
    required this.avatars,
    this.overlap = 0.3,
    this.size = YoAvatarSize.md,
    this.maxDisplay = 4,
    this.moreBuilder,
    this.onTapMore,
    this.variant = YoAvatarVariant.circle,
  }) : imageUrls = const [];

  @override
  Widget build(BuildContext context) {
    final displayCount = _getDisplayCount();
    final remainingCount = _getRemainingCount();
    final avatarSize = YoAvatar.sizeMap[size]!;
    final offsetAmount = avatarSize * overlap;

    return YoBox(
      height: avatarSize,
      width: _calculateWidth(
        displayCount,
        remainingCount,
        avatarSize,
        offsetAmount,
      ),
      child: Stack(
        children: [
          ..._buildAvatars(displayCount, offsetAmount),
          if (remainingCount > 0)
            Positioned(
              left: displayCount * (avatarSize - offsetAmount),
              child: _buildMoreAvatar(remainingCount, context),
            ),
        ],
      ),
    );
  }

  int _getDisplayCount() {
    final total = avatars != null ? avatars!.length : imageUrls.length;
    return total > maxDisplay ? maxDisplay : total;
  }

  int _getRemainingCount() {
    final total = avatars != null ? avatars!.length : imageUrls.length;
    return total > maxDisplay ? total - maxDisplay : 0;
  }

  double _calculateWidth(
    int displayCount,
    int remainingCount,
    double avatarSize,
    double offset,
  ) {
    final count = displayCount + (remainingCount > 0 ? 1 : 0);
    return avatarSize + (count - 1) * (avatarSize - offset);
  }

  List<Widget> _buildAvatars(int count, double offset) {
    final avatarSize = YoAvatar.sizeMap[size]!;

    return List.generate(count, (index) {
      final avatar = avatars != null
          ? avatars![index]
          : YoAvatar.image(
              imageUrl: imageUrls[index],
              size: size,
              variant: variant,
              borderWidth: 2,
            );

      return Positioned(left: index * (avatarSize - offset), child: avatar);
    });
  }

  Widget _buildMoreAvatar(int count, BuildContext context) {
    final widget = moreBuilder ??
        YoAvatar.text(
          text: '+$count',
          size: size,
          backgroundColor: context.gray200,
          textColor: context.gray700,
          variant: variant,
          borderWidth: 2,
        );

    if (onTapMore != null) {
      return GestureDetector(onTap: onTapMore, child: widget);
    }
    return widget;
  }
}
