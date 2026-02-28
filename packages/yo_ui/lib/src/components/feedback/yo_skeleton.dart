import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:yo_ui/yo_ui.dart';

/// Skeleton loading placeholder dengan shimmer effect
class YoSkeleton extends StatefulWidget {
  final double? width;
  final double? height;
  final BorderRadius borderRadius;
  final YoSkeletonType type;
  final Color? baseColor;
  final Color? highlightColor;
  final bool enabled;

  const YoSkeleton({
    super.key,
    this.width,
    this.height = 20,
    this.borderRadius = YoSpacing.borderRadiusSm,
    this.type = YoSkeletonType.shimmer,
    this.baseColor,
    this.highlightColor,
    this.enabled = true,
  });

  /// Circle skeleton (avatar, profile picture)
  const YoSkeleton.circle({
    super.key,
    required double size,
    this.type = YoSkeletonType.shimmer,
    this.baseColor,
    this.highlightColor,
    this.enabled = true,
  })  : width = size,
        height = size,
        borderRadius = const BorderRadius.all(Radius.circular(100));

  /// Line skeleton (text line)
  const YoSkeleton.line({
    super.key,
    this.width,
    this.height = 16,
    this.type = YoSkeletonType.shimmer,
    this.baseColor,
    this.highlightColor,
    this.enabled = true,
  }) : borderRadius = YoSpacing.borderRadiusSm;

  /// Rounded skeleton (button, card)
  const YoSkeleton.rounded({
    super.key,
    this.width,
    this.height = 20,
    this.type = YoSkeletonType.shimmer,
    this.baseColor,
    this.highlightColor,
    this.enabled = true,
  }) : borderRadius = YoSpacing.borderRadiusMd;

  /// Square skeleton (thumbnail)
  const YoSkeleton.square({
    super.key,
    required double size,
    this.type = YoSkeletonType.shimmer,
    this.baseColor,
    this.highlightColor,
    this.enabled = true,
  })  : width = size,
        height = size,
        borderRadius = BorderRadius.zero;

  /// Paragraph skeleton (multiple lines)
  static Widget paragraph({
    Key? key,
    int lines = 3,
    double spacing = 8,
    double? width,
    YoSkeletonType type = YoSkeletonType.shimmer,
    Color? baseColor,
    Color? highlightColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(lines, (index) {
        // Last line is shorter
        final lineWidth =
            index == lines - 1 ? (width ?? double.infinity) * 0.7 : width;
        return Padding(
          padding: EdgeInsets.only(bottom: index < lines - 1 ? spacing : 0),
          child: YoSkeleton.line(
            width: lineWidth,
            type: type,
            baseColor: baseColor,
            highlightColor: highlightColor,
          ),
        );
      }),
    );
  }

  @override
  State<YoSkeleton> createState() => _YoSkeletonState();
}

class _YoSkeletonState extends State<YoSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _animation = Tween<double>(
      begin: -1.0,
      end: 2.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    if (widget.enabled && widget.type == YoSkeletonType.shimmer) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(YoSkeleton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enabled && widget.type == YoSkeletonType.shimmer) {
      if (!_controller.isAnimating) _controller.repeat();
    } else {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) {
      return const YoBox();
    }

    final baseColor = widget.baseColor ?? context.gray200;
    final highlightColor = widget.highlightColor ?? context.gray100;

    if (widget.type == YoSkeletonType.static) {
      return Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          borderRadius: widget.borderRadius,
          color: baseColor,
        ),
      );
    }

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius,
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [baseColor, highlightColor, baseColor],
              stops: [
                math.max(0.0, _animation.value - 0.3),
                _animation.value.clamp(0.0, 1.0),
                math.min(1.0, _animation.value + 0.3),
              ],
            ),
          ),
        );
      },
    );
  }
}

enum YoSkeletonType { static, shimmer }
