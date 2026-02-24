// File: yo_month_picker.dart
import 'package:flutter/material.dart';
import 'package:yo_ui/yo_ui.dart';

/// A month picker widget that shows a dialog with month/year selection only.
/// Returns a [DateTimeRange] representing the entire selected month.
class YoMonthPicker extends StatelessWidget {
  /// The currently selected date range (first to last day of month).
  final DateTimeRange? selectedRange;

  /// Callback when the month changes, returns the full month range.
  final ValueChanged<DateTimeRange> onMonthChanged;

  /// The earliest date that can be selected.
  final DateTime? firstDate;

  /// The latest date that can be selected.
  final DateTime? lastDate;

  /// Label text displayed above the picker.
  final String? labelText;

  /// Hint text displayed when no month is selected.
  final String? hintText;

  /// Icon displayed on the left side.
  final IconData? icon;

  /// Whether the picker is enabled.
  final bool enabled;

  /// Padding inside the picker container.
  final EdgeInsetsGeometry? padding;

  /// Border radius of the picker container.
  final double borderRadius;

  /// Border color of the picker container.
  final Color? borderColor;

  /// Background color of the picker container.
  final Color? backgroundColor;

  /// Whether to show the year in the display text.
  final bool showYear;

  const YoMonthPicker({
    super.key,
    this.selectedRange,
    required this.onMonthChanged,
    this.firstDate,
    this.lastDate,
    this.labelText,
    this.hintText,
    this.icon,
    this.enabled = true,
    this.padding,
    this.borderRadius = 8.0,
    this.borderColor,
    this.backgroundColor,
    this.showYear = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _selectMonth(context),
      child: Container(
        padding: padding ?? EdgeInsets.all(context.yoSpacingMd),
        decoration: BoxDecoration(
          color: backgroundColor ?? context.backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(color: borderColor ?? context.gray300, width: 1),
        ),
        child: Row(
          children: [
            Icon(
              icon ?? Icons.calendar_month,
              color: enabled ? context.primaryColor : context.gray400,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (labelText != null) ...[
                    YoText(
                      labelText!,
                      style: context.yoLabelSmall.copyWith(
                        color: context.gray500,
                      ),
                    ),
                    const SizedBox(height: 2),
                  ],
                  YoText(
                    selectedRange != null
                        ? _formatMonth(selectedRange!.start)
                        : hintText ?? 'Select month',
                    style: context.yoBodyMedium.copyWith(
                      color: selectedRange != null
                          ? context.textColor
                          : context.gray400,
                      fontWeight: selectedRange != null
                          ? FontWeight.w500
                          : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_drop_down, color: context.gray500),
          ],
        ),
      ),
    );
  }

  String _formatMonth(DateTime date) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];

    final monthName = months[date.month - 1];
    return showYear ? '$monthName ${date.year}' : monthName;
  }

  Future<void> _selectMonth(BuildContext context) async {
    if (!enabled) return;

    final DateTimeRange? picked = await YoDialogPicker.month(
      context: context,
      initialDate: selectedRange?.start,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (picked != null) {
      onMonthChanged(picked);
    }
  }
}
