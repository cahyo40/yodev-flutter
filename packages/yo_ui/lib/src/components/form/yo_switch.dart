import 'package:flutter/material.dart';
import 'package:yo_ui/yo_ui.dart';

class YoSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final String? label;
  final Color? activeColor;
  final Color? inactiveColor;
  final bool enabled;

  const YoSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
    this.activeColor,
    this.inactiveColor,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveActiveColor = activeColor ?? context.primaryColor;

    Widget switchWidget = Switch(
      value: value,
      onChanged: enabled ? onChanged : null,
      activeThumbColor: effectiveActiveColor,
      inactiveTrackColor: inactiveColor ?? context.gray400,
    );

    if (label != null) {
      return InkWell(
        onTap: enabled ? () => onChanged(!value) : null,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            switchWidget,
            const SizedBox(width: 8),
            YoText.bodyMedium(
              label!,
              color: enabled ? context.textColor : context.gray400,
            ),
          ],
        ),
      );
    }

    return switchWidget;
  }
}

class YoSwitchListTile extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final String title;
  final String? subtitle;
  final Widget? secondary;
  final Color? activeColor;
  final bool enabled;

  const YoSwitchListTile({
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
    return SwitchListTile(
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
      activeThumbColor: activeColor ?? context.primaryColor,
      controlAffinity: ListTileControlAffinity.leading,
    );
  }
}
