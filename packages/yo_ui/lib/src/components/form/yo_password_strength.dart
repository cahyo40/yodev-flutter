import 'package:flutter/material.dart';
import 'package:yo_ui/yo_ui.dart';

/// Password field wrapper that visualizes the strength of the entered password.
class YoPasswordStrengthField extends StatefulWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final String? labelText;
  final String? hintText;
  final String? errorText;
  final String? helperText;
  final bool isRequired;
  final bool enabled;

  const YoPasswordStrengthField({
    super.key,
    this.controller,
    this.onChanged,
    this.labelText,
    this.hintText,
    this.errorText,
    this.helperText,
    this.isRequired = false,
    this.enabled = true,
  });

  @override
  State<YoPasswordStrengthField> createState() =>
      _YoPasswordStrengthFieldState();
}

class _YoPasswordStrengthFieldState extends State<YoPasswordStrengthField> {
  late TextEditingController _controller;
  int _strengthScore = 0; // 0 to 4

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _controller.addListener(_evaluateStrength);
  }

  @override
  void dispose() {
    _controller.removeListener(_evaluateStrength);
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _evaluateStrength() {
    final password = _controller.text;
    int score = 0;

    if (password.length > 7) {
      score += 1;
    } // Minimum 8 chars
    if (RegExp(r'[A-Z]').hasMatch(password)) {
      score += 1;
    } // Has uppercase
    if (RegExp(r'[0-9]').hasMatch(password)) {
      score += 1;
    } // Has number
    if (RegExp(r'[!@#\$&*~%]').hasMatch(password)) {
      score += 1;
    } // Has special char

    if (password.isEmpty) {
      score = 0;
    }

    if (_strengthScore != score) {
      setState(() {
        _strengthScore = score;
      });
    }
  }

  Color _getStrengthColor() {
    if (_strengthScore == 0) return context.gray300;
    if (_strengthScore == 1) return context.errorColor; // Very Weak
    if (_strengthScore == 2) return Colors.orange; // Weak
    if (_strengthScore == 3) return Colors.yellow.shade700; // Good
    return Colors.green; // Strong
  }

  String _getStrengthLabel() {
    if (_controller.text.isEmpty) return 'Masukkan password';
    if (_strengthScore == 1) return 'Sangat Lemah';
    if (_strengthScore == 2) return 'Lemah';
    if (_strengthScore == 3) return 'Cukup Kuat';
    return 'Gagah Berani';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        YoTextFormField(
          controller: _controller,
          labelText: widget.labelText ?? 'Password',
          hintText: widget.hintText ?? '********',
          inputType: YoInputType.password,
          obscureText: true,
          showVisibilityToggle: true,
          isRequired: widget.isRequired,
          enabled: widget.enabled,
          errorText: widget.errorText,
          helperText: widget.helperText,
          onChanged: widget.onChanged,
        ),

        const YoSpace.heightSm(),

        // Dynamic multi-segment strength bar
        Row(
          children: List.generate(4, (index) {
            final active = index < _strengthScore;
            return Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: 4,
                margin: EdgeInsets.only(right: index == 3 ? 0 : 4),
                decoration: BoxDecoration(
                  color: active ? _getStrengthColor() : context.gray200,
                  borderRadius: BorderRadius.circular(YoSpacing.xs),
                ),
              ),
            );
          }),
        ),

        const YoSpace.heightXs(),

        // Strength status label
        YoText.bodySmall(
          _getStrengthLabel(),
          color:
              _controller.text.isEmpty ? context.gray400 : _getStrengthColor(),
          fontWeight: FontWeight.w500,
        ),
      ],
    );
  }
}
