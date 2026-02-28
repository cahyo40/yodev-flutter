import 'package:flutter/material.dart';
import 'package:yo_ui/yo_ui.dart';

class YoTimePicker extends StatelessWidget {
  final TimeOfDay? selectedTime;
  final ValueChanged<TimeOfDay> onTimeChanged;
  final String? labelText;
  final String? hintText;
  final IconData? icon;
  final bool enabled;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  final Color? borderColor;
  final Color? backgroundColor;

  const YoTimePicker({
    super.key,
    this.selectedTime,
    required this.onTimeChanged,
    this.labelText,
    this.hintText,
    this.icon,
    this.enabled = true,
    this.padding,
    this.borderRadius = 8.0,
    this.borderColor,
    this.backgroundColor,
  });

  Future<void> _selectTime(BuildContext context) async {
    if (!enabled) return;

    final TimeOfDay? picked = await YoDialogPicker.time(
      context: context,
      initialTime: selectedTime,
    );

    if (picked != null && picked != selectedTime) {
      onTimeChanged(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _selectTime(context),
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
              icon ?? Icons.access_time,
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
                    selectedTime != null
                        ? _formatTime(selectedTime!)
                        : hintText ?? 'Select time',
                    style: context.yoBodyMedium.copyWith(
                      color: selectedTime != null
                          ? context.textColor
                          : context.gray400,
                      fontWeight: selectedTime != null
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

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }
}
