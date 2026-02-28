// File: yo_date_time_picker.dart
// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:yo_ui/yo_ui.dart';

class YoDateTimePicker extends StatelessWidget {
  final DateTime? selectedDateTime;
  final ValueChanged<DateTime> onDateTimeChanged;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final String? labelText;
  final String? hintText;
  final bool enabled;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  final Color? borderColor;
  final Color? backgroundColor;

  const YoDateTimePicker({
    super.key,
    this.selectedDateTime,
    required this.onDateTimeChanged,
    this.firstDate,
    this.lastDate,
    this.labelText,
    this.hintText,
    this.enabled = true,
    this.padding,
    this.borderRadius = 8.0,
    this.borderColor,
    this.backgroundColor,
  });

  Future<void> _selectDateTime(BuildContext context) async {
    if (!enabled) return;

    final DateTime? picked = await YoDialogPicker.dateTime(
      context: context,
      initialDateTime: selectedDateTime,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (picked != null && picked != selectedDateTime) {
      onDateTimeChanged(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _selectDateTime(context),
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
              Icons.calendar_today,
              color: enabled ? context.primaryColor : context.gray400,
              size: 20,
            ),
            const YoSpace.width(12),
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
                    const YoSpace.height(2),
                  ],
                  YoText(
                    selectedDateTime != null
                        ? YoDateFormatter.formatDateTime(selectedDateTime!)
                        : hintText ?? 'Select date & time',
                    style: context.yoBodyMedium.copyWith(
                      color: selectedDateTime != null
                          ? context.textColor
                          : context.gray400,
                      fontWeight: selectedDateTime != null
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
}
