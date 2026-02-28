import 'package:flutter/material.dart';
import 'package:yo_ui/yo_ui.dart';

class YoRadio<T> extends StatelessWidget {
  final T value;
  final T? groupValue;
  final ValueChanged<T?> onChanged;
  final String? label;
  final Color? activeColor;
  final bool toggleable;
  final bool enabled;

  const YoRadio({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.label,
    this.activeColor,
    this.toggleable = false,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveActiveColor = activeColor ?? context.primaryColor;

    Widget radio = Radio<T>(
      value: value,
      groupValue: groupValue,
      onChanged: enabled ? onChanged : null,
      activeColor: effectiveActiveColor,
      toggleable: toggleable,
    );

    if (label != null) {
      return InkWell(
        onTap: enabled ? () => onChanged(value) : null,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            radio,
            const YoSpace.width(8),
            YoText.bodyMedium(
              label!,
              color: enabled ? context.textColor : context.gray400,
            ),
          ],
        ),
      );
    }

    return radio;
  }
}

class YoRadioListTile<T> extends StatelessWidget {
  final T value;
  final T? groupValue;
  final ValueChanged<T?> onChanged;
  final String title;
  final String? subtitle;
  final Widget? secondary;
  final Color? activeColor;
  final bool toggleable;
  final bool enabled;

  const YoRadioListTile({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.title,
    this.subtitle,
    this.secondary,
    this.activeColor,
    this.toggleable = false,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return RadioListTile<T>(
      value: value,
      groupValue: groupValue,
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
      toggleable: toggleable,
      controlAffinity: ListTileControlAffinity.leading,
    );
  }
}
