import 'package:flutter/material.dart';
import 'package:yo_ui/yo_ui.dart';

/// Loading indicator dengan berbagai tipe animasi
class YoLoading extends StatelessWidget {
  final double size;
  final Color? color;
  final double strokeWidth;
  final YoLoadingType type;

  const YoLoading({
    super.key,
    this.size = 24,
    this.color,
    this.strokeWidth = 2.5,
    this.type = YoLoadingType.spinner,
  });

  /// Circular spinner (default)
  const YoLoading.spinner({
    super.key,
    this.size = 24,
    this.color,
    this.strokeWidth = 2.5,
  }) : type = YoLoadingType.spinner;

  /// Bouncing dots animation
  const YoLoading.dots({super.key, this.size = 24, this.color})
    : type = YoLoadingType.dots,
      strokeWidth = 2.5;

  /// Pulsing circle animation
  const YoLoading.pulse({super.key, this.size = 24, this.color})
    : type = YoLoadingType.pulse,
      strokeWidth = 2.5;

  /// Fading circles animation
  const YoLoading.fade({super.key, this.size = 24, this.color})
    : type = YoLoadingType.fade,
      strokeWidth = 2.5;

  @override
  Widget build(BuildContext context) {
    final loadingColor = color ?? context.primaryColor;

    switch (type) {
      case YoLoadingType.spinner:
        return SizedBox(
          width: size,
          height: size,
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(loadingColor),
            strokeWidth: strokeWidth,
          ),
        );
      case YoLoadingType.dots:
        return _DotsLoading(size: size, color: loadingColor);
      case YoLoadingType.pulse:
        return _PulseLoading(size: size, color: loadingColor);
      case YoLoadingType.fade:
        return _FadeLoading(size: size, color: loadingColor);
    }
  }
}

/// Bouncing dots animation
class _DotsLoading extends StatefulWidget {
  final double size;
  final Color color;

  const _DotsLoading({required this.size, required this.color});

  @override
  State<_DotsLoading> createState() => _DotsLoadingState();
}

class _DotsLoadingState extends State<_DotsLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1400),
      vsync: this,
    )..repeat();

    _animations = List.generate(3, (index) {
      final start = index * 0.2;
      final end = start + 0.4;
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(start, end.clamp(0.0, 1.0), curve: Curves.easeInOut),
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dotSize = widget.size / 4;

    return SizedBox(
      width: widget.size * 1.5,
      height: widget.size,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(3, (index) {
          return AnimatedBuilder(
            animation: _animations[index],
            builder: (context, child) {
              final value = _animations[index].value;
              return Container(
                width: dotSize,
                height: dotSize,
                margin: EdgeInsets.symmetric(horizontal: dotSize / 4),
                decoration: BoxDecoration(
                  color: widget.color.withAlpha(
                    (255 * (0.4 + value * 0.6)).round(),
                  ),
                  shape: BoxShape.circle,
                ),
                transform: Matrix4.translationValues(0, -value * 8, 0),
              );
            },
          );
        }),
      ),
    );
  }
}

/// Pulsing circle animation
class _PulseLoading extends StatefulWidget {
  final double size;
  final Color color;

  const _PulseLoading({required this.size, required this.color});

  @override
  State<_PulseLoading> createState() => _PulseLoadingState();
}

class _PulseLoadingState extends State<_PulseLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat();

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _opacityAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              // Outer pulsing circle
              Transform.scale(
                scale: _scaleAnimation.value,
                child: Container(
                  width: widget.size,
                  height: widget.size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.color.withAlpha(
                      (255 * _opacityAnimation.value * 0.3).round(),
                    ),
                  ),
                ),
              ),
              // Inner solid circle
              Container(
                width: widget.size * 0.4,
                height: widget.size * 0.4,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.color,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Fading circles animation
class _FadeLoading extends StatefulWidget {
  final double size;
  final Color color;

  const _FadeLoading({required this.size, required this.color});

  @override
  State<_FadeLoading> createState() => _FadeLoadingState();
}

class _FadeLoadingState extends State<_FadeLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const dotCount = 8;
    final dotSize = widget.size / 5;

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Stack(
            alignment: Alignment.center,
            children: List.generate(dotCount, (index) {
              final angle = (index / dotCount) * 2 * 3.14159;
              final delay = index / dotCount;
              final opacity = (1.0 - ((_controller.value - delay) % 1.0)).clamp(
                0.2,
                1.0,
              );
              final radius = widget.size / 2 - dotSize / 2;

              return Transform.translate(
                offset: Offset(
                  radius * 0.8 * (angle.cos()),
                  radius * 0.8 * (angle.sin()),
                ),
                child: Container(
                  width: dotSize,
                  height: dotSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.color.withAlpha((255 * opacity).round()),
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}

extension on double {
  double cos() => _cos(this);
  double sin() => _sin(this);
}

double _cos(double x) =>
    (x - (x * x * x / 6) + (x * x * x * x * x / 120)).clamp(-1.0, 1.0);
double _sin(double x) {
  x = x - 1.5708; // shift by pi/2
  return _cos(x);
}

enum YoLoadingType { spinner, dots, pulse, fade }
