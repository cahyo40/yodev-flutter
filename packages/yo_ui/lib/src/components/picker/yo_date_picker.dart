// File: yo_date_picker.dart
import 'package:flutter/material.dart';
import 'package:yo_ui/yo_ui.dart';

class YoDatePicker extends StatelessWidget {
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onDateChanged;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final String? labelText;
  final String? hintText;
  final IconData? icon;
  final bool enabled;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  final Color? borderColor;
  final Color? backgroundColor;

  const YoDatePicker({
    super.key,
    this.selectedDate,
    required this.onDateChanged,
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
  });

  Future<void> _selectDate(BuildContext context) async {
    if (!enabled) return;

    final DateTime? picked = await YoDialogPicker.date(
      context: context,
      initialDate: selectedDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (picked != null && picked != selectedDate) {
      onDateChanged(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _selectDate(context),
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
              icon ?? Icons.calendar_today,
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
                    selectedDate != null
                        ? YoDateFormatter.formatDate(selectedDate!)
                        : hintText ?? 'Select date',
                    style: context.yoBodyMedium.copyWith(
                      color: selectedDate != null
                          ? context.textColor
                          : context.gray400,
                      fontWeight: selectedDate != null
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
