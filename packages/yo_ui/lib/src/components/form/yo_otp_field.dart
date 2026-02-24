import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yo_ui/yo_ui.dart';

/// OTP/PIN input field widget
class YoOtpField extends StatefulWidget {
  final int length;
  final ValueChanged<String>? onCompleted;
  final ValueChanged<String>? onChanged;
  final bool obscureText;
  final bool autofocus;
  final double fieldWidth;
  final double fieldHeight;
  final double spacing;
  final TextInputType keyboardType;
  final Color? fillColor;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final TextStyle? textStyle;
  final bool enabled;

  const YoOtpField({
    super.key,
    this.length = 6,
    this.onCompleted,
    this.onChanged,
    this.obscureText = false,
    this.autofocus = true,
    this.fieldWidth = 45,
    this.fieldHeight = 55,
    this.spacing = 8,
    this.keyboardType = TextInputType.number,
    this.fillColor,
    this.borderColor,
    this.focusedBorderColor,
    this.textStyle,
    this.enabled = true,
  }) : assert(length > 0 && length <= 10, 'Length must be between 1 and 10');

  @override
  State<YoOtpField> createState() => _YoOtpFieldState();
}

class _YoOtpFieldState extends State<YoOtpField> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;
  String _otpValue = '';

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        widget.length,
        (index) => Padding(
          padding: EdgeInsets.only(
            right: index < widget.length - 1 ? widget.spacing : 0,
          ),
          child: SizedBox(
            width: widget.fieldWidth,
            height: widget.fieldHeight,
            child: KeyboardListener(
              focusNode: FocusNode(),
              onKeyEvent: (event) => _onKeyEvent(index, event),
              child: TextField(
                controller: _controllers[index],
                focusNode: _focusNodes[index],
                enabled: widget.enabled,
                textAlign: TextAlign.center,
                keyboardType: widget.keyboardType,
                maxLength: 1,
                obscureText: widget.obscureText,
                style: widget.textStyle ?? context.yoHeadlineSmall,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                    widget.keyboardType == TextInputType.number
                        ? RegExp(r'[0-9]')
                        : RegExp(r'[a-zA-Z0-9]'),
                  ),
                ],
                decoration: InputDecoration(
                  counterText: '',
                  filled: true,
                  fillColor: widget.fillColor ?? context.gray50,
                  contentPadding: EdgeInsets.zero,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: widget.borderColor ?? context.gray300,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: widget.borderColor ?? context.gray300,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: widget.focusedBorderColor ?? context.primaryColor,
                      width: 2,
                    ),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: context.gray200,
                    ),
                  ),
                ),
                onChanged: (value) => _onChanged(index, value),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      widget.length,
      (_) => TextEditingController(),
    );
    _focusNodes = List.generate(
      widget.length,
      (_) => FocusNode(),
    );

    if (widget.autofocus && widget.enabled) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _focusNodes[0].requestFocus();
      });
    }
  }

  void _handlePaste(String value, int startIndex) {
    final cleanValue = value.replaceAll(RegExp(r'\s'), '');

    for (int i = 0;
        i < cleanValue.length && (startIndex + i) < widget.length;
        i++) {
      _controllers[startIndex + i].text = cleanValue[i];
    }

    final lastFilledIndex =
        (startIndex + cleanValue.length - 1).clamp(0, widget.length - 1);
    if (lastFilledIndex < widget.length - 1) {
      _focusNodes[lastFilledIndex + 1].requestFocus();
    } else {
      _focusNodes[lastFilledIndex].unfocus();
    }

    _updateOtpValue();
  }

  void _onChanged(int index, String value) {
    if (value.length > 1) {
      // Handle paste
      _handlePaste(value, index);
      return;
    }

    if (value.isNotEmpty) {
      // Move to next field
      if (index < widget.length - 1) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
      }
    }

    _updateOtpValue();
  }

  void _onKeyEvent(int index, KeyEvent event) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace) {
      if (_controllers[index].text.isEmpty && index > 0) {
        _focusNodes[index - 1].requestFocus();
      }
    }
  }

  void _updateOtpValue() {
    _otpValue = _controllers.map((c) => c.text).join();
    widget.onChanged?.call(_otpValue);

    if (_otpValue.length == widget.length) {
      widget.onCompleted?.call(_otpValue);
    }
  }
}
