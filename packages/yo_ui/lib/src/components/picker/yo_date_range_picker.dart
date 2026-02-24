// File: yo_date_range_picker.dart
import 'package:flutter/material.dart';
import 'package:yo_ui/yo_ui.dart';

/// A date range picker widget that allows users to select a start and end date.
class YoDateRangePicker extends StatelessWidget {
  /// The currently selected date range.
  final DateTimeRange? selectedRange;

  /// Callback when the date range changes.
  final ValueChanged<DateTimeRange> onRangeChanged;

  /// The earliest date that can be selected.
  final DateTime? firstDate;

  /// The latest date that can be selected.
  final DateTime? lastDate;

  /// Label text displayed above the picker.
  final String? labelText;

  /// Hint text displayed when no range is selected.
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

  /// Text for the start date label in compact mode.
  final String startLabel;

  /// Text for the end date label in compact mode.
  final String endLabel;

  /// Use compact layout with two separate date fields.
  final bool compactLayout;

  const YoDateRangePicker({
    super.key,
    this.selectedRange,
    required this.onRangeChanged,
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
    this.startLabel = 'Start',
    this.endLabel = 'End',
    this.compactLayout = false,
  });

  /// Create a compact version with separate start/end fields.
  const YoDateRangePicker.compact({
    super.key,
    this.selectedRange,
    required this.onRangeChanged,
    this.firstDate,
    this.lastDate,
    this.labelText,
    this.icon,
    this.enabled = true,
    this.padding,
    this.borderRadius = 8.0,
    this.borderColor,
    this.backgroundColor,
    this.startLabel = 'Start Date',
    this.endLabel = 'End Date',
  })  : hintText = null,
        compactLayout = true;

  Future<void> _selectDateRange(BuildContext context) async {
    if (!enabled) return;

    final DateTimeRange? picked = await YoDialogPicker.dateRange(
      context: context,
      initialDateRange: selectedRange,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (picked != null) {
      onRangeChanged(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (compactLayout) {
      return _buildCompactLayout(context);
    }
    return _buildDefaultLayout(context);
  }

  Widget _buildDefaultLayout(BuildContext context) {
    return GestureDetector(
      onTap: () => _selectDateRange(context),
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
              icon ?? Icons.date_range,
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
                    _getDisplayText(),
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

  Widget _buildCompactLayout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelText != null) ...[
          YoText(
            labelText!,
            style: context.yoLabelMedium.copyWith(
              color: context.gray600,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
        ],
        Row(
          children: [
            Expanded(
              child: _buildDateField(
                context: context,
                label: startLabel,
                date: selectedRange?.start,
                icon: Icons.calendar_today,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Icon(
                Icons.arrow_forward,
                size: 16,
                color: context.gray400,
              ),
            ),
            Expanded(
              child: _buildDateField(
                context: context,
                label: endLabel,
                date: selectedRange?.end,
                icon: Icons.event,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDateField({
    required BuildContext context,
    required String label,
    required DateTime? date,
    required IconData icon,
  }) {
    return GestureDetector(
      onTap: () => _selectDateRange(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: backgroundColor ?? context.backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(color: borderColor ?? context.gray300, width: 1),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: enabled ? context.primaryColor : context.gray400,
              size: 18,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  YoText(
                    label,
                    style: context.yoLabelSmall.copyWith(
                      color: context.gray500,
                      fontSize: 10,
                    ),
                  ),
                  const SizedBox(height: 2),
                  YoText(
                    date != null
                        ? YoDateFormatter.formatDate(date, format: 'dd MMM yy')
                        : 'Select',
                    style: context.yoBodySmall.copyWith(
                      color: date != null ? context.textColor : context.gray400,
                      fontWeight:
                          date != null ? FontWeight.w500 : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getDisplayText() {
    if (selectedRange == null) {
      return hintText ?? 'Select date range';
    }
    return YoDateFormatter.formatDateRange(
      selectedRange!.start,
      selectedRange!.end,
    );
  }
}
