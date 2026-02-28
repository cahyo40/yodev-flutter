import 'package:flutter/material.dart';
import 'package:yo_ui/yo_ui.dart';

class YoSlider extends StatelessWidget {
  final double value;
  final ValueChanged<double> onChanged;
  final ValueChanged<double>? onChangeEnd;
  final double min;
  final double max;
  final int? divisions;
  final String? label;
  final Color? activeColor;
  final Color? inactiveColor;
  final bool enabled;

  const YoSlider({
    super.key,
    required this.value,
    required this.onChanged,
    this.onChangeEnd,
    this.min = 0.0,
    this.max = 1.0,
    this.divisions,
    this.label,
    this.activeColor,
    this.inactiveColor,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveActiveColor = activeColor ?? context.primaryColor;
    final effectiveInactiveColor = inactiveColor ?? context.gray300;

    return Slider(
      value: value,
      onChanged: enabled ? onChanged : null,
      onChangeEnd: enabled ? onChangeEnd : null,
      min: min,
      max: max,
      divisions: divisions,
      label: label,
      activeColor: effectiveActiveColor,
      inactiveColor: effectiveInactiveColor,
    );
  }
}

class YoSliderWithValue extends StatelessWidget {
  final double value;
  final ValueChanged<double> onChanged;
  final double min;
  final double max;
  final int? divisions;
  final String? prefix;
  final String? suffix;

  const YoSliderWithValue({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 0.0,
    this.max = 100.0,
    this.divisions,
    this.prefix,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: YoSlider(
                value: value,
                onChanged: onChanged,
                min: min,
                max: max,
                divisions: divisions,
              ),
            ),
            const YoSpace.width(16),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: context.yoSpacingSm,
                vertical: context.yoSpacingXs,
              ),
              decoration: BoxDecoration(
                color: context.primaryColor.withAlpha(26),
                borderRadius: BorderRadius.circular(6),
              ),
              child: YoText.bodyMedium(
                '${prefix ?? ''}${value.toInt()}${suffix ?? ''}',
                color: context.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
