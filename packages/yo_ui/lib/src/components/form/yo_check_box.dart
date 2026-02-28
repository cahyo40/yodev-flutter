import 'package:flutter/material.dart';
import 'package:yo_ui/yo_ui.dart';

class YoCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;
  final String? label;
  final Color? activeColor;
  final Color? checkColor;
  final bool tristate;
  final bool enabled;

  const YoCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
    this.activeColor,
    this.checkColor,
    this.tristate = false,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveActiveColor = activeColor ?? context.primaryColor;
    final effectiveCheckColor = checkColor ?? context.onPrimaryColor;

    Widget checkbox = Checkbox(
      value: value,
      onChanged: enabled ? onChanged : null,
      activeColor: effectiveActiveColor,
      checkColor: effectiveCheckColor,
      tristate: tristate,
    );

    if (label != null) {
      return InkWell(
        onTap: enabled ? () => onChanged(!value) : null,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            checkbox,
            const YoSpace.width(8),
            YoText.bodyMedium(
              label!,
              color: enabled ? context.textColor : context.gray400,
            ),
          ],
        ),
      );
    }

    return checkbox;
  }
}

class YoCheckboxListTile extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;
  final String title;
  final String? subtitle;
  final Widget? secondary;
  final Color? activeColor;
  final bool enabled;

  const YoCheckboxListTile({
    super.key,
    required this.value,
    required this.onChanged,
    required this.title,
    this.subtitle,
    this.secondary,
    this.activeColor,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      value: value,
      onChanged: enabled ? onChanged : null,
      title: YoText.bodyMedium(
        title,
        color: enabled ? context.textColor : context.gray400,
      ),
      subtitle: subtitle != null
          ? YoText.bodySmall(
              subtitle!,
              color: enabled ? context.gray600 : context.gray400,
            )
          : null,
      secondary: secondary,
      activeColor: activeColor ?? context.primaryColor,
      controlAffinity: ListTileControlAffinity.leading,
    );
  }
}