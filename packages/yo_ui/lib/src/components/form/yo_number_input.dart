import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yo_ui/yo_ui.dart';

/// Stepper input for numeric values. Good for quantity selectors, etc.
class YoNumberInput extends StatefulWidget {
  final int value;
  final ValueChanged<int> onChanged;
  final int step;
  final int min;
  final int max;
  final String? labelText;
  final String? helperText;
  final String? errorText;
  final bool isRequired;
  final bool enabled;

  const YoNumberInput({
    super.key,
    required this.value,
    required this.onChanged,
    this.step = 1,
    this.min = 0,
    this.max = 9999,
    this.labelText,
    this.helperText,
    this.errorText,
    this.isRequired = false,
    this.enabled = true,
  });

  @override
  State<YoNumberInput> createState() => _YoNumberInputState();
}

class _YoNumberInputState extends State<YoNumberInput> {
  late TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value.toString());
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void didUpdateWidget(YoNumberInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value &&
        int.tryParse(_controller.text) != widget.value) {
      _controller.text = widget.value.toString();
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus) {
      _validateAndSubmit();
    }
  }

  void _validateAndSubmit() {
    int? parsed = int.tryParse(_controller.text);
    if (parsed == null) {
      _updateValue(widget.min);
    } else if (parsed < widget.min) {
      _updateValue(widget.min);
    } else if (parsed > widget.max) {
      _updateValue(widget.max);
    } else {
      _updateValue(parsed);
    }
  }

  void _updateValue(int newValue) {
    if (!widget.enabled) return;
    int boundedValue = newValue.clamp(widget.min, widget.max);

    _controller.text = boundedValue.toString();
    if (boundedValue != widget.value) {
      widget.onChanged(boundedValue);
    }
  }

  void _increment() {
    _focusNode.unfocus();
    _updateValue(widget.value + widget.step);
  }

  void _decrement() {
    _focusNode.unfocus();
    _updateValue(widget.value - widget.step);
  }

  @override
  Widget build(BuildContext context) {
    final hasError = widget.errorText != null && widget.errorText!.isNotEmpty;
    final borderColor = hasError ? context.errorColor : context.gray300;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.labelText != null) ...[
          Row(
            children: [
              YoText.bodyMedium(
                widget.labelText!,
                fontWeight: FontWeight.w500,
              ),
              if (widget.isRequired)
                YoText.bodyMedium(
                  ' *',
                  color: context.errorColor,
                ),
            ],
          ),
          const YoSpace.height(6),
        ],
        Container(
          height: 48,
          decoration: BoxDecoration(
            color: widget.enabled ? context.backgroundColor : context.gray100,
            borderRadius: YoSpacing.borderRadiusMd,
            border: Border.all(
              color: borderColor,
              width: hasError ? 1.5 : 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildControlButton(
                icon: Icons.remove,
                onPressed: (widget.enabled && widget.value > widget.min)
                    ? _decrement
                    : null,
                isLeft: true,
              ),
              Container(
                width: 1,
                color: borderColor,
              ),
              Expanded(
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  enabled: widget.enabled,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  style: context.yoBodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                    color: widget.enabled ? context.textColor : context.gray500,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    isDense: true,
                  ),
                  onSubmitted: (_) => _validateAndSubmit(),
                ),
              ),
              Container(
                width: 1,
                color: borderColor,
              ),
              _buildControlButton(
                icon: Icons.add,
                onPressed: (widget.enabled && widget.value < widget.max)
                    ? _increment
                    : null,
                isLeft: false,
              ),
            ],
          ),
        ),
        if (widget.errorText != null || widget.helperText != null) ...[
          const YoSpace.heightXs(),
          YoText.bodySmall(
            widget.errorText ?? widget.helperText!,
            color: hasError ? context.errorColor : context.gray500,
          ),
        ],
      ],
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback? onPressed,
    required bool isLeft,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: isLeft
            ? const BorderRadius.horizontal(left: Radius.circular(YoSpacing.md))
            : const BorderRadius.horizontal(
                right: Radius.circular(YoSpacing.md)),
        child: Container(
          width: 48,
          alignment: Alignment.center,
          child: Icon(
            icon,
            size: 20,
            color: onPressed != null ? context.gray700 : context.gray300,
          ),
        ),
      ),
    );
  }
}
