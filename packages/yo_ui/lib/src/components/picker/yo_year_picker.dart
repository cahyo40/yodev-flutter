// File: yo_year_picker.dart
import 'package:flutter/material.dart';
import 'package:yo_ui/yo_ui.dart';

class YoYearPicker extends StatelessWidget {
  final int? selectedYear;
  final ValueChanged<int> onYearChanged;
  final int? firstYear;
  final int? lastYear;
  final String? labelText;
  final String? hintText;
  final IconData? icon;
  final bool enabled;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  final Color? borderColor;
  final Color? backgroundColor;

  const YoYearPicker({
    super.key,
    this.selectedYear,
    required this.onYearChanged,
    this.firstYear,
    this.lastYear,
    this.labelText,
    this.hintText,
    this.icon,
    this.enabled = true,
    this.padding,
    this.borderRadius = 8.0,
    this.borderColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _selectYear(context),
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
              icon ?? Icons.calendar_today_outlined,
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
                    selectedYear != null
                        ? selectedYear.toString()
                        : hintText ?? 'Select year',
                    style: context.yoBodyMedium.copyWith(
                      color: selectedYear != null
                          ? context.textColor
                          : context.gray400,
                      fontWeight: selectedYear != null
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

  Future<void> _selectYear(BuildContext context) async {
    if (!enabled) return;

    final int? picked = await YoDialogPicker.year(
      context: context,
      initialYear: selectedYear,
      firstYear: firstYear,
      lastYear: lastYear,
    );

    if (picked != null && picked != selectedYear) {
      onYearChanged(picked);
    }
  }
}
