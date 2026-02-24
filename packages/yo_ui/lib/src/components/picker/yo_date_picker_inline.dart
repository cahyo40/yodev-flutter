// File: yo_inline_date_picker.dart
import 'package:flutter/material.dart';
import 'package:yo_ui/yo_ui.dart';

class YoInlineDatePicker extends StatefulWidget {
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onDateChanged;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final double itemExtent;
  final double diameterRatio;
  final double magnification;

  const YoInlineDatePicker({
    super.key,
    this.selectedDate,
    required this.onDateChanged,
    this.firstDate,
    this.lastDate,
    this.itemExtent = 50.0,
    this.diameterRatio = 1.1,
    this.magnification = 1.2,
  });

  @override
  State<YoInlineDatePicker> createState() => _YoInlineDatePickerState();
}

class _YoInlineDatePickerState extends State<YoInlineDatePicker> {
  late FixedExtentScrollController _controller;
  late List<DateTime> _dates;

  @override
  void initState() {
    super.initState();
    _initializeDates();
    _initializeController();
  }

  void _initializeDates() {
    final startDate =
        widget.firstDate ?? DateTime.now().subtract(const Duration(days: 365));
    final endDate =
        widget.lastDate ?? DateTime.now().add(const Duration(days: 365));

    _dates = [];
    DateTime currentDate = startDate;
    while (currentDate.isBefore(endDate) ||
        currentDate.isAtSameMomentAs(endDate)) {
      _dates.add(currentDate);
      currentDate = currentDate.add(const Duration(days: 1));
    }
  }

  void _initializeController() {
    final initialDate = widget.selectedDate ?? DateTime.now();
    final initialIndex = _dates.indexWhere(
      (date) =>
          date.year == initialDate.year &&
          date.month == initialDate.month &&
          date.day == initialDate.day,
    );

    _controller = FixedExtentScrollController(
      initialItem: initialIndex >= 0 ? initialIndex : _dates.length ~/ 2,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.itemExtent * 3,
      decoration: BoxDecoration(
        color: context.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.gray200),
      ),
      child: ListWheelScrollView(
        controller: _controller,
        itemExtent: widget.itemExtent,
        diameterRatio: widget.diameterRatio,
        magnification: widget.magnification,
        onSelectedItemChanged: (index) {
          if (index >= 0 && index < _dates.length) {
            widget.onDateChanged(_dates[index]);
          }
        },
        children: _dates.map((date) {
          final isSelected = _isSelectedDate(date);
          return Container(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                YoText(
                  YoDateFormatter.getRelativeDay(date),
                  style: context.yoBodyMedium.copyWith(
                    color: isSelected ? context.primaryColor : context.gray600,
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                    fontSize: isSelected ? 16 : 14,
                  ),
                ),
                if (isSelected) ...[
                  const SizedBox(height: 4),
                  Container(
                    width: 4,
                    height: 4,
                    decoration: BoxDecoration(
                      color: context.primaryColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  bool _isSelectedDate(DateTime date) {
    final selected = widget.selectedDate;
    return selected != null &&
        date.year == selected.year &&
        date.month == selected.month &&
        date.day == selected.day;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
