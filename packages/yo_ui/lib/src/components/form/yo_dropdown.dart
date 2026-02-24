import 'package:flutter/material.dart';
import 'package:yo_ui/yo_ui.dart';

/// Dropdown widget with label and validation
class YoDropDown<T> extends StatelessWidget {
  final T? value;
  final ValueChanged<T?>? onChanged;
  final List<YoDropDownItem<T>> items;
  final String? labelText;
  final String? hintText;
  final String? errorText;
  final String? helperText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool enabled;
  final bool isRequired;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  final Color? borderColor;
  final Color? backgroundColor;
  final Color? focusedBorderColor;
  final bool isDense;

  const YoDropDown({
    super.key,
    required this.value,
    required this.onChanged,
    required this.items,
    this.labelText,
    this.hintText,
    this.errorText,
    this.helperText,
    this.prefixIcon,
    this.suffixIcon,
    this.enabled = true,
    this.isRequired = false,
    this.padding,
    this.borderRadius = 8.0,
    this.borderColor,
    this.backgroundColor,
    this.focusedBorderColor,
    this.isDense = false,
  });

  /// Outlined variant
  const YoDropDown.outlined({
    super.key,
    required this.value,
    required this.onChanged,
    required this.items,
    this.labelText,
    this.hintText,
    this.errorText,
    this.helperText,
    this.prefixIcon,
    this.suffixIcon,
    this.enabled = true,
    this.isRequired = false,
    this.padding,
    this.borderRadius = 8.0,
    this.borderColor,
    this.backgroundColor,
    this.focusedBorderColor,
    this.isDense = false,
  });

  /// Filled variant
  factory YoDropDown.filled({
    Key? key,
    required T? value,
    required ValueChanged<T?>? onChanged,
    required List<YoDropDownItem<T>> items,
    String? labelText,
    String? hintText,
    String? errorText,
    Widget? prefixIcon,
    bool enabled = true,
    bool isRequired = false,
  }) {
    return _YoDropDownFilled<T>(
      key: key,
      value: value,
      onChanged: onChanged,
      items: items,
      labelText: labelText,
      hintText: hintText,
      errorText: errorText,
      prefixIcon: prefixIcon,
      enabled: enabled,
      isRequired: isRequired,
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasError = errorText != null && errorText!.isNotEmpty;
    final effectiveBorderColor = hasError
        ? context.errorColor
        : borderColor ?? context.gray300;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Label
        if (labelText != null) ...[
          Row(
            children: [
              Text(
                labelText!,
                style: context.yoBodyMedium.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (isRequired)
                Text(
                  ' *',
                  style: context.yoBodyMedium.copyWith(
                    color: context.errorColor,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
        ],

        // Dropdown
        Container(
          padding:
              padding ??
              const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: enabled
                ? (backgroundColor ?? context.backgroundColor)
                : context.gray100,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: effectiveBorderColor,
              width: hasError ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              if (prefixIcon != null) ...[
                prefixIcon!,
                const SizedBox(width: 8),
              ],
              Expanded(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<T>(
                    value: value,
                    onChanged: enabled ? onChanged : null,
                    items: items
                        .map((item) => item._toMenuItem(context))
                        .toList(),
                    isExpanded: true,
                    isDense: isDense,
                    icon:
                        suffixIcon ??
                        Icon(
                          Icons.arrow_drop_down,
                          color: enabled ? context.gray500 : context.gray300,
                        ),
                    hint: hintText != null
                        ? Text(
                            hintText!,
                            style: context.yoBodyMedium.copyWith(
                              color: context.gray400,
                            ),
                          )
                        : null,
                    dropdownColor: context.backgroundColor,
                    style: context.yoBodyMedium.copyWith(
                      color: context.textColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Helper/Error text
        if (errorText != null || helperText != null) ...[
          const SizedBox(height: 4),
          Text(
            errorText ?? helperText!,
            style: context.yoBodySmall.copyWith(
              color: hasError ? context.errorColor : context.gray500,
            ),
          ),
        ],
      ],
    );
  }
}

/// Filled variant implementation
class _YoDropDownFilled<T> extends YoDropDown<T> {
  const _YoDropDownFilled({
    super.key,
    required super.value,
    required super.onChanged,
    required super.items,
    super.labelText,
    super.hintText,
    super.errorText,
    super.prefixIcon,
    super.enabled,
    super.isRequired,
  });

  @override
  Widget build(BuildContext context) {
    final hasError = errorText != null && errorText!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Label
        if (labelText != null) ...[
          Row(
            children: [
              Text(
                labelText!,
                style: context.yoBodyMedium.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (isRequired)
                Text(
                  ' *',
                  style: context.yoBodyMedium.copyWith(
                    color: context.errorColor,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
        ],

        // Dropdown with filled style
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: enabled ? context.gray100 : context.gray200,
            borderRadius: BorderRadius.circular(8),
            border: hasError
                ? Border.all(color: context.errorColor, width: 1.5)
                : null,
          ),
          child: Row(
            children: [
              if (prefixIcon != null) ...[
                prefixIcon!,
                const SizedBox(width: 8),
              ],
              Expanded(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<T>(
                    value: value,
                    onChanged: enabled ? onChanged : null,
                    items: items
                        .map((item) => item._toMenuItem(context))
                        .toList(),
                    isExpanded: true,
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: enabled ? context.gray500 : context.gray300,
                    ),
                    hint: hintText != null
                        ? Text(
                            hintText!,
                            style: context.yoBodyMedium.copyWith(
                              color: context.gray400,
                            ),
                          )
                        : null,
                    dropdownColor: context.backgroundColor,
                    style: context.yoBodyMedium.copyWith(
                      color: context.textColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Error text
        if (errorText != null) ...[
          const SizedBox(height: 4),
          Text(
            errorText!,
            style: context.yoBodySmall.copyWith(color: context.errorColor),
          ),
        ],
      ],
    );
  }
}

/// Dropdown item model
class YoDropDownItem<T> {
  final T value;
  final String label;
  final Widget? leading;
  final Widget? trailing;
  final bool enabled;

  const YoDropDownItem({
    required this.value,
    required this.label,
    this.leading,
    this.trailing,
    this.enabled = true,
  });

  DropdownMenuItem<T> _toMenuItem(BuildContext context) {
    return DropdownMenuItem<T>(
      value: value,
      enabled: enabled,
      child: Opacity(
        opacity: enabled ? 1.0 : 0.5,
        child: Row(
          children: [
            if (leading != null) ...[leading!, const SizedBox(width: 8)],
            Expanded(child: Text(label, style: context.yoBodyMedium)),
            if (trailing != null) ...[const SizedBox(width: 8), trailing!],
          ],
        ),
      ),
    );
  }
}
