import 'package:flutter/material.dart';
import 'package:yo_ui/yo_ui.dart';

/// Range slider with dual thumbs
class YoRangeSlider extends StatefulWidget {
  final RangeValues values;
  final double min;
  final double max;
  final int? divisions;
  final ValueChanged<RangeValues>? onChanged;
  final ValueChanged<RangeValues>? onChangeEnd;
  final RangeLabels? labels;
  final Color? activeColor;
  final Color? inactiveColor;
  final bool showLabels;

  const YoRangeSlider({
    super.key,
    required this.values,
    this.min = 0.0,
    this.max = 100.0,
    this.divisions,
    this.onChanged,
    this.onChangeEnd,
    this.labels,
    this.activeColor,
    this.inactiveColor,
    this.showLabels = true,
  });

  @override
  State<YoRangeSlider> createState() => _YoRangeSliderState();
}

class _YoRangeSliderState extends State<YoRangeSlider> {
  late RangeValues _values;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.showLabels)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              YoText.bodySmall(
                widget.labels?.start ?? _values.start.toStringAsFixed(0),
                color: context.gray600,
              ),
              YoText.bodySmall(
                widget.labels?.end ?? _values.end.toStringAsFixed(0),
                color: context.gray600,
              ),
            ],
          ),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: widget.activeColor ?? context.primaryColor,
            inactiveTrackColor: widget.inactiveColor ?? context.gray300,
            thumbColor: widget.activeColor ?? context.primaryColor,
            overlayColor:
                (widget.activeColor ?? context.primaryColor).withAlpha(51),
            trackHeight: 4,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
          ),
          child: RangeSlider(
            values: _values,
            min: widget.min,
            max: widget.max,
            divisions: widget.divisions,
            labels: widget.labels,
            onChanged: (values) {
              setState(() => _values = values);
              widget.onChanged?.call(values);
            },
            onChangeEnd: widget.onChangeEnd,
          ),
        ),
      ],
    );
  }

  @override
  void didUpdateWidget(YoRangeSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.values != oldWidget.values) {
      _values = widget.values;
    }
  }

  @override
  void initState() {
    super.initState();
    _values = widget.values;
  }
}
