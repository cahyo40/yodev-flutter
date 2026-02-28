import 'package:flutter/material.dart';
import 'package:yo_ui/yo_ui.dart';

/// Pagination widget for navigating through pages
class YoPagination extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final ValueChanged<int> onPageChanged;
  final int maxButtons;
  final bool showFirstLast;
  final bool showPrevNext;
  final Color? activeColor;
  final Color? inactiveColor;
  final double buttonSize;
  final EdgeInsetsGeometry? padding;

  const YoPagination({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
    this.maxButtons = 5,
    this.showFirstLast = true,
    this.showPrevNext = true,
    this.activeColor,
    this.inactiveColor,
    this.buttonSize = 40,
    this.padding,
  }) : assert(currentPage >= 1 && currentPage <= totalPages,
            'currentPage must be between 1 and totalPages');

  @override
  Widget build(BuildContext context) {
    final activeClr = activeColor ?? context.primaryColor;
    final inactiveClr = inactiveColor ?? context.gray300;

    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(vertical: 16),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 8,
        runSpacing: 8,
        children: _buildButtons(context, activeClr, inactiveClr),
      ),
    );
  }

  Widget _buildButton(
    BuildContext context, {
    String? text,
    IconData? icon,
    required VoidCallback onTap,
    required bool isActive,
    required Color activeColor,
    required Color inactiveColor,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(context.yoRadiusMd),
      child: Container(
        width: buttonSize,
        height: buttonSize,
        decoration: BoxDecoration(
          color: isActive ? activeColor : Colors.transparent,
          border: Border.all(
            color: isActive ? activeColor : inactiveColor,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(context.yoRadiusMd),
        ),
        child: Center(
          child: icon != null
              ? Icon(
                  icon,
                  size: 20,
                  color: isActive ? context.onPrimaryColor : context.gray600,
                )
              : YoText(
                  text!,
                  style: TextStyle(
                    color: isActive ? context.onPrimaryColor : context.gray600,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                    fontSize: 14,
                  ),
                ),
        ),
      ),
    );
  }

  List<Widget> _buildButtons(
    BuildContext context,
    Color activeColor,
    Color inactiveColor,
  ) {
    final buttons = <Widget>[];

    // First button
    if (showFirstLast && currentPage > 1) {
      buttons.add(_buildButton(
        context,
        icon: Icons.first_page,
        onTap: () => onPageChanged(1),
        isActive: false,
        activeColor: activeColor,
        inactiveColor: inactiveColor,
      ));
    }

    // Previous button
    if (showPrevNext && currentPage > 1) {
      buttons.add(_buildButton(
        context,
        icon: Icons.chevron_left,
        onTap: () => onPageChanged(currentPage - 1),
        isActive: false,
        activeColor: activeColor,
        inactiveColor: inactiveColor,
      ));
    }

    // Page number buttons
    buttons.addAll(_buildPageButtons(context, activeColor, inactiveColor));

    // Next button
    if (showPrevNext && currentPage < totalPages) {
      buttons.add(_buildButton(
        context,
        icon: Icons.chevron_right,
        onTap: () => onPageChanged(currentPage + 1),
        isActive: false,
        activeColor: activeColor,
        inactiveColor: inactiveColor,
      ));
    }

    // Last button
    if (showFirstLast && currentPage < totalPages) {
      buttons.add(_buildButton(
        context,
        icon: Icons.last_page,
        onTap: () => onPageChanged(totalPages),
        isActive: false,
        activeColor: activeColor,
        inactiveColor: inactiveColor,
      ));
    }

    return buttons;
  }

  Widget _buildEllipsis(BuildContext context) {
    return YoBox(
      width: buttonSize,
      height: buttonSize,
      child: Center(
        child: YoText(
          '...',
          style: TextStyle(
            color: context.gray500,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  List<Widget> _buildPageButtons(
    BuildContext context,
    Color activeColor,
    Color inactiveColor,
  ) {
    final buttons = <Widget>[];
    final half = maxButtons ~/ 2;

    int start = currentPage - half;
    int end = currentPage + half;

    if (start < 1) {
      start = 1;
      end = maxButtons < totalPages ? maxButtons : totalPages;
    }

    if (end > totalPages) {
      end = totalPages;
      start = totalPages - maxButtons + 1;
      if (start < 1) start = 1;
    }

    // Add ellipsis at start if needed
    if (start > 1) {
      buttons.add(_buildButton(
        context,
        text: '1',
        onTap: () => onPageChanged(1),
        isActive: false,
        activeColor: activeColor,
        inactiveColor: inactiveColor,
      ));
      if (start > 2) {
        buttons.add(_buildEllipsis(context));
      }
    }

    // Add page buttons
    for (int i = start; i <= end; i++) {
      buttons.add(_buildButton(
        context,
        text: '$i',
        onTap: () => onPageChanged(i),
        isActive: i == currentPage,
        activeColor: activeColor,
        inactiveColor: inactiveColor,
      ));
    }

    // Add ellipsis at end if needed
    if (end < totalPages) {
      if (end < totalPages - 1) {
        buttons.add(_buildEllipsis(context));
      }
      buttons.add(_buildButton(
        context,
        text: '$totalPages',
        onTap: () => onPageChanged(totalPages),
        isActive: false,
        activeColor: activeColor,
        inactiveColor: inactiveColor,
      ));
    }

    return buttons;
  }
}
