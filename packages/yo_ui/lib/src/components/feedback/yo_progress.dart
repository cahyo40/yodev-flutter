// File: yo_progress.dart
import 'package:flutter/material.dart';
import 'package:yo_ui/yo_ui.dart' hide YoSpacing;

enum YoProgressType { linear, circular, circularWithValue }

enum YoProgressSize { small, medium, large }

class YoProgress extends StatelessWidget {
  final double? value;
  final YoProgressType type;
  final YoProgressSize size;
  final Color? color;
  final Color? backgroundColor;
  final double strokeWidth;
  final String? label;
  final TextStyle? labelStyle;

  const YoProgress({
    super.key,
    this.value,
    this.type = YoProgressType.circular,
    this.size = YoProgressSize.medium,
    this.color,
    this.backgroundColor,
    this.strokeWidth = 4.0,
    this.label,
    this.labelStyle,
  });

  YoProgress.linear({
    super.key,
    this.value,
    this.size = YoProgressSize.medium,
    this.color,
    this.backgroundColor,
    this.label,
    this.labelStyle,
  })  : type = YoProgressType.linear,
        strokeWidth = _getLinearHeight(size);

  YoProgress.circular({
    super.key,
    this.value,
    this.size = YoProgressSize.medium,
    this.color,
    this.backgroundColor,
    double? strokeWidth,
    this.label,
    this.labelStyle,
  })  : type = YoProgressType.circular,
        strokeWidth = strokeWidth ?? _getStrokeWidth(size);

  YoProgress.circularWithValue({
    super.key,
    required double this.value,
    this.size = YoProgressSize.medium,
    this.color,
    this.backgroundColor,
    double? strokeWidth,
    this.label,
    this.labelStyle,
  })  : type = YoProgressType.circularWithValue,
        strokeWidth = strokeWidth ?? _getStrokeWidth(size);

  static double _getStrokeWidth(YoProgressSize size) {
    switch (size) {
      case YoProgressSize.small:
        return 2.0;
      case YoProgressSize.medium:
        return 4.0;
      case YoProgressSize.large:
        return 6.0;
    }
  }

  static double _getLinearHeight(YoProgressSize size) {
    switch (size) {
      case YoProgressSize.small:
        return 4.0;
      case YoProgressSize.medium:
        return 6.0;
      case YoProgressSize.large:
        return 8.0;
    }
  }

  double _getCircularSize(YoProgressSize size) {
    switch (size) {
      case YoProgressSize.small:
        return 20.0;
      case YoProgressSize.medium:
        return 32.0;
      case YoProgressSize.large:
        return 48.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? context.primaryColor;
    final effectiveBackgroundColor = backgroundColor ?? context.gray200;
    final effectiveLabelStyle =
        labelStyle ?? Theme.of(context).textTheme.bodySmall;

    switch (type) {
      case YoProgressType.linear:
        return _buildLinearProgress(
          context,
          effectiveColor,
          effectiveBackgroundColor,
          effectiveLabelStyle!,
        );
      case YoProgressType.circular:
        return _buildCircularProgress(
          context,
          effectiveColor,
          effectiveBackgroundColor,
          effectiveLabelStyle!,
        );
      case YoProgressType.circularWithValue:
        return _buildCircularProgressWithValue(
          context,
          effectiveColor,
          effectiveBackgroundColor,
          effectiveLabelStyle!,
        );
    }
  }

  Widget _buildLinearProgress(
    BuildContext context,
    Color color,
    Color backgroundColor,
    TextStyle labelStyle,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(label!, style: labelStyle),
          const YoSpace.heightXs(),
        ],
        LinearProgressIndicator(
          value: value,
          backgroundColor: backgroundColor,
          color: color,
          minHeight: strokeWidth,
        ),
      ],
    );
  }

  Widget _buildCircularProgress(
    BuildContext context,
    Color color,
    Color backgroundColor,
    TextStyle labelStyle,
  ) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: _getCircularSize(size),
            height: _getCircularSize(size),
            child: CircularProgressIndicator(
              value: value,
              backgroundColor: backgroundColor,
              color: color,
              strokeWidth: strokeWidth,
            ),
          ),
          if (label != null) ...[
            const YoSpace.heightXs(),
            Text(label!, style: labelStyle),
          ],
        ],
      ),
    );
  }

  Widget _buildCircularProgressWithValue(
    BuildContext context,
    Color color,
    Color backgroundColor,
    TextStyle labelStyle,
  ) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: _getCircularSize(size),
                height: _getCircularSize(size),
                child: CircularProgressIndicator(
                  value: value,
                  backgroundColor: backgroundColor,
                  color: color,
                  strokeWidth: strokeWidth,
                ),
              ),
              Text(
                '${((value ?? 0) * 100).toInt()}%',
                style: labelStyle.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: size == YoProgressSize.small
                      ? 8
                      : size == YoProgressSize.medium
                          ? 10
                          : 12,
                ),
              ),
            ],
          ),
          if (label != null) ...[
            const YoSpace.heightXs(),
            Text(label!, style: labelStyle),
          ],
        ],
      ),
    );
  }
}
