import 'package:flutter/material.dart';
import 'package:yo_ui/yo_ui.dart';

/// Dialog picker untuk tanggal dan waktu
abstract final class YoDialogPicker {
  /// Show date picker dialog
  static Future<DateTime?> date({
    required BuildContext context,
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
    String? helpText,
    String? cancelText,
    String? confirmText,
  }) async {
    return showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: firstDate ?? DateTime(1900),
      lastDate: lastDate ?? DateTime(2100),
      helpText: helpText,
      cancelText: cancelText,
      confirmText: confirmText,
      builder: (context, child) => _themedDialog(context, child),
    );
  }

  /// Show date range picker
  static Future<DateTimeRange?> dateRange({
    required BuildContext context,
    DateTimeRange? initialDateRange,
    DateTime? firstDate,
    DateTime? lastDate,
    String? helpText,
    String? cancelText,
    String? confirmText,
    String? saveText,
  }) async {
    return showDateRangePicker(
      context: context,
      initialDateRange: initialDateRange,
      firstDate: firstDate ?? DateTime(1900),
      lastDate: lastDate ?? DateTime(2100),
      helpText: helpText,
      cancelText: cancelText,
      confirmText: confirmText,
      saveText: saveText,
      builder: (context, child) => _themedDialog(context, child),
    );
  }

  /// Show date and time picker (date first, then time)
  static Future<DateTime?> dateTime({
    required BuildContext context,
    DateTime? initialDateTime,
    DateTime? firstDate,
    DateTime? lastDate,
  }) async {
    final pickedDate = await date(
      context: context,
      initialDate: initialDateTime,
      firstDate: firstDate,
      lastDate: lastDate,
    );
    if (pickedDate == null) return null;

    if (!context.mounted) return null;

    final pickedTime = await time(
      context: context,
      initialTime: initialDateTime != null
          ? TimeOfDay.fromDateTime(initialDateTime)
          : null,
    );
    if (pickedTime == null) return null;

    return DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );
  }

  /// Show month range picker dialog (returns DateTimeRange for entire month)
  static Future<DateTimeRange?> month({
    required BuildContext context,
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
    String? helpText,
    String? cancelText,
    String? confirmText,
  }) async {
    return showDialog<DateTimeRange>(
      context: context,
      builder: (context) => _YoMonthRangePickerDialog(
        initialDate: initialDate ?? DateTime.now(),
        firstDate: firstDate ?? DateTime(1900),
        lastDate: lastDate ?? DateTime(2100),
        helpText: helpText ?? 'Select Month',
        cancelText: cancelText ?? 'Cancel',
        confirmText: confirmText ?? 'OK',
      ),
    );
  }

  /// Show time picker dialog
  static Future<TimeOfDay?> time({
    required BuildContext context,
    TimeOfDay? initialTime,
    String? helpText,
    String? cancelText,
    String? confirmText,
  }) async {
    return showTimePicker(
      context: context,
      initialTime: initialTime ?? TimeOfDay.now(),
      helpText: helpText,
      cancelText: cancelText,
      confirmText: confirmText,
      builder: (context, child) => _themedDialog(context, child),
    );
  }

  /// Show year picker dialog
  static Future<int?> year({
    required BuildContext context,
    int? initialYear,
    int? firstYear,
    int? lastYear,
    String? helpText,
    String? cancelText,
    String? confirmText,
  }) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(initialYear ?? DateTime.now().year),
      firstDate: DateTime(firstYear ?? 1900),
      lastDate: DateTime(lastYear ?? 2100),
      helpText: helpText ?? 'Select Year',
      cancelText: cancelText,
      confirmText: confirmText,
      initialDatePickerMode: DatePickerMode.year,
      builder: (context, child) => _themedDialog(context, child),
    );

    return selectedDate?.year;
  }

  /// Apply theme to picker dialogs
  static Widget _themedDialog(BuildContext context, Widget? child) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: isDark
            ? ColorScheme.dark(
                primary: context.primaryColor,
                onPrimary: context.onPrimaryColor,
                surface: context.backgroundColor,
                onSurface: context.textColor,
              )
            : ColorScheme.light(
                primary: context.primaryColor,
                onPrimary: context.onPrimaryColor,
                surface: context.backgroundColor,
                onSurface: context.textColor,
              ),
      ),
      child: child!,
    );
  }
}

/// Custom month range picker dialog widget
class _YoMonthRangePickerDialog extends StatefulWidget {
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final String helpText;
  final String cancelText;
  final String confirmText;

  const _YoMonthRangePickerDialog({
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
    required this.helpText,
    required this.cancelText,
    required this.confirmText,
  });

  @override
  State<_YoMonthRangePickerDialog> createState() =>
      _YoMonthRangePickerDialogState();
}

class _YoMonthRangePickerDialogState extends State<_YoMonthRangePickerDialog> {
  static const List<String> _monthNames = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];
  late int _selectedYear;

  late int _selectedMonth;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(context.yoRadiusXl)),
      backgroundColor: context.backgroundColor,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 320),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: context.primaryColor,
                borderRadius: BorderRadius.vertical(
                    top: Radius.circular(context.yoRadiusXl)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  YoText(
                    widget.helpText,
                    style: TextStyle(
                      color: context.onPrimaryColor.withAlpha(180),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const YoSpace.height(4),
                  YoText(
                    '${_monthNames[_selectedMonth - 1]} $_selectedYear',
                    style: TextStyle(
                      color: context.onPrimaryColor,
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            // Year navigation
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.chevron_left, color: context.textColor),
                    onPressed: _selectedYear > widget.firstDate.year
                        ? () => setState(() => _selectedYear--)
                        : null,
                  ),
                  GestureDetector(
                    onTap: () async {
                      final year = await YoDialogPicker.year(
                        context: context,
                        initialYear: _selectedYear,
                        firstYear: widget.firstDate.year,
                        lastYear: widget.lastDate.year,
                      );
                      if (year != null) {
                        setState(() => _selectedYear = year);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: context.backgroundColor,
                        borderRadius: BorderRadius.circular(context.yoRadiusMd),
                      ),
                      child: YoText(
                        _selectedYear.toString(),
                        style: context.yoTitleMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: context.textColor,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.chevron_right, color: context.textColor),
                    onPressed: _selectedYear < widget.lastDate.year
                        ? () => setState(() => _selectedYear++)
                        : null,
                  ),
                ],
              ),
            ),

            // Month grid (3x4)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1.5,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: 12,
                itemBuilder: (context, index) {
                  final month = index + 1;
                  final isSelected = month == _selectedMonth;
                  final isEnabled = _isMonthEnabled(_selectedYear, month);

                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(context.yoRadiusMd),
                      onTap: isEnabled
                          ? () => setState(() => _selectedMonth = month)
                          : null,
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected
                              ? context.primaryColor
                              : Colors.transparent,
                          borderRadius:
                              BorderRadius.circular(context.yoRadiusMd),
                          border: isSelected
                              ? null
                              : Border.all(
                                  color: isEnabled
                                      ? context.gray300
                                      : context.gray200,
                                ),
                        ),
                        alignment: Alignment.center,
                        child: YoText(
                          _monthNames[index],
                          style: TextStyle(
                            color: isSelected
                                ? context.onPrimaryColor
                                : isEnabled
                                    ? context.textColor
                                    : context.gray400,
                            fontWeight:
                                isSelected ? FontWeight.w600 : FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Actions
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: YoText(
                      widget.cancelText,
                      style: TextStyle(color: context.gray600),
                    ),
                  ),
                  const YoSpace.width(8),
                  ElevatedButton(
                    onPressed: () {
                      final range =
                          _getMonthRange(_selectedYear, _selectedMonth);
                      Navigator.of(context).pop(range);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.primaryColor,
                      foregroundColor: context.onPrimaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(context.yoRadiusMd),
                      ),
                    ),
                    child: YoText(widget.confirmText),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _selectedYear = widget.initialDate.year;
    _selectedMonth = widget.initialDate.month;
  }

  DateTimeRange _getMonthRange(int year, int month) {
    final start = DateTime(year, month, 1);
    final end = DateTime(year, month + 1, 0); // Last day of month
    return DateTimeRange(start: start, end: end);
  }

  bool _isMonthEnabled(int year, int month) {
    final date = DateTime(year, month);
    final firstMonth = DateTime(widget.firstDate.year, widget.firstDate.month);
    final lastMonth = DateTime(widget.lastDate.year, widget.lastDate.month);
    return !date.isBefore(firstMonth) && !date.isAfter(lastMonth);
  }
}
