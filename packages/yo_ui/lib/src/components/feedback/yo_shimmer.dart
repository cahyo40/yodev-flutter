import 'package:flutter/material.dart';

/// Shimmer direction enum
enum ShimmerDirection {
  leftToRight,
  rightToLeft,
  topToBottom,
  bottomToTop,
}

/// Shimmer loading effect widget
class YoShimmer extends StatefulWidget {
  final Widget child;
  final Color? baseColor;
  final Color? highlightColor;
  final Duration duration;
  final ShimmerDirection direction;
  final bool enabled;

  const YoShimmer({
    super.key,
    required this.child,
    this.baseColor,
    this.highlightColor,
    this.duration = const Duration(milliseconds: 1500),
    this.direction = ShimmerDirection.leftToRight,
    this.enabled = true,
  });

  @override
  State<YoShimmer> createState() => _YoShimmerState();

  /// Shimmer for card loading
  static Widget card({
    double height = 100,
    double? width,
    Color? baseColor,
    Color? highlightColor,
    BorderRadius? borderRadius,
  }) {
    return YoShimmer(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: borderRadius ?? BorderRadius.circular(12),
        ),
      ),
    );
  }

  /// Shimmer for image loading
  static Widget image({
    double height = 200,
    double? width,
    Color? baseColor,
    Color? highlightColor,
    BorderRadius? borderRadius,
  }) {
    return YoShimmer(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: borderRadius ?? BorderRadius.circular(12),
        ),
      ),
    );
  }

  /// Shimmer for list tile loading
  static Widget listTile({
    Color? baseColor,
    Color? highlightColor,
  }) {
    return YoShimmer(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 16,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 14,
                  width: 150,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _YoShimmerState extends State<YoShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) {
      return widget.child;
    }

    final baseColor = widget.baseColor ?? Colors.grey[300]!;
    final highlightColor = widget.highlightColor ?? Colors.grey[100]!;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            final gradientWidth = bounds.width;
            final gradientHeight = bounds.height;

            Alignment begin, end;
            switch (widget.direction) {
              case ShimmerDirection.leftToRight:
                begin = Alignment.centerLeft;
                end = Alignment.centerRight;
                break;
              case ShimmerDirection.rightToLeft:
                begin = Alignment.centerRight;
                end = Alignment.centerLeft;
                break;
              case ShimmerDirection.topToBottom:
                begin = Alignment.topCenter;
                end = Alignment.bottomCenter;
                break;
              case ShimmerDirection.bottomToTop:
                begin = Alignment.bottomCenter;
                end = Alignment.topCenter;
                break;
            }

            return LinearGradient(
              begin: begin,
              end: end,
              colors: [
                baseColor,
                highlightColor,
                baseColor,
              ],
              stops: [
                _animation.value - 1,
                _animation.value,
                _animation.value + 1,
              ].map((v) => v.clamp(0.0, 1.0)).toList(),
            ).createShader(
              Rect.fromLTWH(0, 0, gradientWidth, gradientHeight),
            );
          },
          child: child,
        );
      },
      child: widget.child,
    );
  }

  @override
  void didUpdateWidget(YoShimmer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enabled != oldWidget.enabled) {
      if (widget.enabled) {
        _controller.repeat();
      } else {
        _controller.stop();
      }
    }
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
      duration: widget.duration,
    );
    _animation = Tween<double>(begin: -2, end: 2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    if (widget.enabled) {
      _controller.repeat();
    }
  }
}
