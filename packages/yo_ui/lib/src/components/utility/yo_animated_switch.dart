// File: yo_animated_switch.dart
import 'package:flutter/material.dart';

class YoAnimatedSwitch extends StatelessWidget {
  final bool condition;
  final Widget trueChild;
  final Widget falseChild;
  final Duration duration;
  final Curve curve;

  const YoAnimatedSwitch({
    super.key,
    required this.condition,
    required this.trueChild,
    required this.falseChild,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeInOut,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: duration,
      switchInCurve: curve,
      switchOutCurve: curve,
      child: condition ? trueChild : falseChild,
    );
  }
}

class YoAnimatedCrossSwitch extends StatelessWidget {
  final bool condition;
  final Widget firstChild;
  final Widget secondChild;
  final Duration duration;
  final Curve curve;
  final CrossFadeState crossFadeState;

  const YoAnimatedCrossSwitch({
    super.key,
    required this.condition,
    required this.firstChild,
    required this.secondChild,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeInOut,
    this.crossFadeState = CrossFadeState.showFirst,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      firstChild: firstChild,
      secondChild: secondChild,
      crossFadeState: condition
          ? CrossFadeState.showFirst
          : CrossFadeState.showSecond,
      duration: duration,
      firstCurve: curve,
      secondCurve: curve,
    );
  }
}
