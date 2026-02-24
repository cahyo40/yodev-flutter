import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yo_ui/yo_ui.dart';

enum YoInputStyle { outlined, filled, underline, floating, modern, none }

/* ---------------------------------------------------------- */
/*  1.  ENUMS (tetap)                                        */
/* ---------------------------------------------------------- */
enum YoInputType {
  text,
  email,
  password,
  phone,
  number,
  url,
  search,
  multiline,
  currency,
}

/* ---------------------------------------------------------- */
/*  2.  MAIN WIDGET – now 100 % YoUI color system             */
/* ---------------------------------------------------------- */
class YoTextFormField extends StatefulWidget {
  final String? labelText;
  final String? hintText;
  final String? initialValue;
  final TextEditingController? controller;
  final YoInputType inputType;
  final YoInputStyle inputStyle;
  final bool enabled;
  final bool readOnly;
  final bool obscureText;
  final bool autofocus;
  final bool enableSuggestions;
  final bool autocorrect;
  final int? maxLines;
  final int? maxLength;
  final double borderRadius;
  final Color? fillColor; // manual override tetap boleh
  final Color? borderColor;
  final Color? focusedBorderColor;
  final Color? errorBorderColor;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final void Function()? onTap;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final bool showClearButton;
  final bool showVisibilityToggle;
  final bool showCharacterCounter;
  final bool showLabelAlways;
  final TextStyle? textStyle;
  final TextStyle? labelStyle;
  final TextStyle? hintStyle;
  final EdgeInsetsGeometry? contentPadding;
  final InputDecoration? decoration;
  final List<TextInputFormatter>? inputFormatters;
  final bool isRequired;
  final String? helperText;
  final String? errorText;
  final bool showHelperText;
  final double focusedBorderWidth;
  final double enabledBorderWidth;
  final Duration animationDuration;
  final Curve animationCurve;
  final bool enableInteractiveSelection;
  final TextAlign textAlign;
  final bool expands;
  final int? minLines;

  const YoTextFormField({
    super.key,
    this.labelText,
    this.hintText,
    this.initialValue,
    this.controller,
    this.inputType = YoInputType.text,
    this.inputStyle = YoInputStyle.outlined,
    this.enabled = true,
    this.readOnly = false,
    this.obscureText = false,
    this.autofocus = false,
    this.enableSuggestions = true,
    this.autocorrect = true,
    this.maxLines = 1,
    this.maxLength,
    this.borderRadius = 12.0,
    this.fillColor,
    this.borderColor,
    this.focusedBorderColor,
    this.errorBorderColor,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.textInputAction,
    this.focusNode,
    this.showClearButton = false,
    this.showVisibilityToggle = false,
    this.showCharacterCounter = false,
    this.showLabelAlways = false,
    this.textStyle,
    this.labelStyle,
    this.hintStyle,
    this.contentPadding,
    this.decoration,
    this.inputFormatters,
    this.isRequired = false,
    this.helperText,
    this.errorText,
    this.showHelperText = true,
    this.focusedBorderWidth = 2.0,
    this.enabledBorderWidth = 1.0,
    this.animationDuration = const Duration(milliseconds: 200),
    this.animationCurve = Curves.easeInOut,
    this.enableInteractiveSelection = true,
    this.textAlign = TextAlign.start,
    this.expands = false,
    this.minLines,
  });

  @override
  State<YoTextFormField> createState() => _YoTextFormFieldState();
}

class _YoTextFormFieldState extends State<YoTextFormField>
    with SingleTickerProviderStateMixin {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  late bool _obscureText;
  late AnimationController _animationController;
  String? _errorText;
  bool _hasFocus = false;
  bool _hasText = false;

  @override
  Widget build(BuildContext context) {
    /* ------------------------------------------------------ */
    /*  NOW 100 % YoUI color system – no Theme.of()!        */
    /* ------------------------------------------------------ */
    final borderColor = widget.borderColor ?? context.gray300;
    final focusedBorderColor =
        widget.focusedBorderColor ?? context.primaryColor;
    final errorBorderColor = widget.errorBorderColor ?? context.errorColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.labelText != null && widget.showLabelAlways) ...[
          Row(
            children: [
              Text(
                widget.labelText!,
                style: widget.labelStyle ??
                    YoTextTheme.labelLarge(context).copyWith(
                      color: _hasFocus ? focusedBorderColor : context.gray600,
                    ),
              ),
              if (widget.isRequired) ...[
                const SizedBox(width: 4),
                Text('*', style: TextStyle(color: errorBorderColor)),
              ],
            ],
          ),
          const SizedBox(height: 8),
        ],
        TextFormField(
          controller: _controller,
          focusNode: _focusNode,
          enabled: widget.enabled,
          readOnly: widget.readOnly,
          obscureText: _obscureText,
          keyboardType: _getTextInputType(),
          textInputAction: widget.textInputAction,
          autofocus: widget.autofocus,
          enableSuggestions: widget.enableSuggestions,
          autocorrect: widget.autocorrect,
          maxLines: widget.obscureText ? 1 : widget.maxLines,
          minLines: widget.minLines,
          maxLength: widget.maxLength,
          validator: (value) {
            final error = _validateInput(value);
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted && _errorText != error) {
                setState(() => _errorText = error);
              }
            });
            return error;
          },
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onSubmitted,
          onTap: widget.onTap,
          style: widget.textStyle ?? YoTextTheme.bodyLarge(context),
          textAlign: widget.textAlign,
          expands: widget.expands,
          inputFormatters: _getInputFormatters(),
          enableInteractiveSelection: widget.enableInteractiveSelection,
          decoration: widget.decoration ??
              _buildInputDecoration(
                context,
                borderColor,
                focusedBorderColor,
                errorBorderColor,
              ),
        ),
        if (widget.showHelperText &&
            (widget.helperText != null || _errorText != null)) ...[
          const SizedBox(height: 4),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: _errorText != null
                ? Text(
                    _errorText!,
                    style: YoTextTheme.bodySmall(context)
                        .copyWith(color: errorBorderColor),
                  )
                : widget.helperText != null
                    ? Text(
                        widget.helperText!,
                        style: YoTextTheme.bodySmall(context)
                            .copyWith(color: context.gray500),
                      )
                    : const SizedBox.shrink(),
          ),
        ],
        if (widget.showCharacterCounter && widget.maxLength != null) ...[
          const SizedBox(height: 4),
          Text(
            '${_controller.text.length}/${widget.maxLength}',
            style: YoTextTheme.bodySmall(context).copyWith(
              color: _controller.text.length == widget.maxLength
                  ? errorBorderColor
                  : context.gray500,
            ),
          ),
        ],
      ],
    );
  }

  @override
  void dispose() {
    _controller.removeListener(_handleTextChange);
    _focusNode.removeListener(_handleFocusChange);
    if (widget.controller == null) _controller.dispose();
    if (widget.focusNode == null) _focusNode.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _focusNode = widget.focusNode ?? FocusNode();
    _obscureText = widget.obscureText;
    _hasText = _controller.text.isNotEmpty;

    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _controller.addListener(_handleTextChange);
    _focusNode.addListener(_handleFocusChange);

    if (widget.initialValue != null) {
      _controller.text = widget.initialValue!;
    }
  }

  InputDecoration _buildFilledDecoration(
    BuildContext context,
    Color borderColor,
    Color focusedBorderColor,
    Color errorBorderColor,
  ) {
    return InputDecoration(
      labelText: widget.showLabelAlways ? null : widget.labelText,
      hintText: widget.hintText,
      prefixIcon: widget.prefixIcon,
      suffixIcon: _buildSuffixIcon(),
      filled: true,
      fillColor: widget.fillColor ?? context.gray100,
      contentPadding: widget.contentPadding ??
          const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        borderSide: BorderSide(
          color: focusedBorderColor,
          width: widget.focusedBorderWidth,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        borderSide: BorderSide(
          color: errorBorderColor,
          width: widget.focusedBorderWidth,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        borderSide: BorderSide(
          color: errorBorderColor,
          width: widget.focusedBorderWidth,
        ),
      ),
      labelStyle: widget.labelStyle ??
          YoTextTheme.bodyMedium(context).copyWith(color: context.gray600),
      hintStyle: widget.hintStyle ??
          YoTextTheme.bodyMedium(context).copyWith(color: context.gray400),
      errorStyle: const TextStyle(height: 0, fontSize: 0),
    );
  }

  InputDecoration _buildFloatingDecoration(
    BuildContext context,
    Color borderColor,
    Color focusedBorderColor,
    Color errorBorderColor,
  ) {
    return _buildOutlinedDecoration(
      context,
      borderColor,
      focusedBorderColor,
      errorBorderColor,
    ).copyWith(
      floatingLabelBehavior: FloatingLabelBehavior.always,
      labelStyle: (_hasFocus || _hasText)
          ? YoTextTheme.bodySmall(context).copyWith(color: focusedBorderColor)
          : YoTextTheme.bodyLarge(context).copyWith(color: context.gray400),
    );
  }

  InputDecoration _buildInputDecoration(
    BuildContext context,
    Color borderColor,
    Color focusedBorderColor,
    Color errorBorderColor,
  ) {
    switch (widget.inputStyle) {
      case YoInputStyle.outlined:
        return _buildOutlinedDecoration(
          context,
          borderColor,
          focusedBorderColor,
          errorBorderColor,
        );
      case YoInputStyle.filled:
        return _buildFilledDecoration(
          context,
          borderColor,
          focusedBorderColor,
          errorBorderColor,
        );
      case YoInputStyle.underline:
        return _buildUnderlineDecoration(
          context,
          borderColor,
          focusedBorderColor,
          errorBorderColor,
        );
      case YoInputStyle.floating:
        return _buildFloatingDecoration(
          context,
          borderColor,
          focusedBorderColor,
          errorBorderColor,
        );
      case YoInputStyle.modern:
        return _buildModernDecoration(
          context,
          borderColor,
          focusedBorderColor,
          errorBorderColor,
        );
      case YoInputStyle.none:
        return _buildNoneDecoration(
          context,
          borderColor,
          focusedBorderColor,
          errorBorderColor,
        );
    }
  }

  InputDecoration _buildModernDecoration(
    BuildContext context,
    Color borderColor,
    Color focusedBorderColor,
    Color errorBorderColor,
  ) {
    return InputDecoration(
      labelText: widget.showLabelAlways ? null : widget.labelText,
      hintText: widget.hintText,
      prefixIcon: widget.prefixIcon,
      suffixIcon: _buildSuffixIcon(),
      filled: true,
      fillColor: widget.fillColor ??
          (_hasFocus ? focusedBorderColor.withAlpha(13) : context.gray100),
      contentPadding: widget.contentPadding ??
          const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(widget.borderRadius * 1.5),
        borderSide: BorderSide(
          color: borderColor,
          width: widget.enabledBorderWidth,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(widget.borderRadius * 1.5),
        borderSide: BorderSide(
          color: borderColor,
          width: widget.enabledBorderWidth,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(widget.borderRadius * 1.5),
        borderSide: BorderSide(
          color: focusedBorderColor,
          width: widget.focusedBorderWidth,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(widget.borderRadius * 1.5),
        borderSide: BorderSide(
          color: errorBorderColor,
          width: widget.focusedBorderWidth,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(widget.borderRadius * 1.5),
        borderSide: BorderSide(
          color: errorBorderColor,
          width: widget.focusedBorderWidth,
        ),
      ),
      labelStyle: widget.labelStyle ??
          YoTextTheme.bodyMedium(context).copyWith(color: context.gray600),
      hintStyle: widget.hintStyle ??
          YoTextTheme.bodyMedium(context).copyWith(color: context.gray400),
      errorStyle: const TextStyle(height: 0, fontSize: 0),
    );
  }

  InputDecoration _buildNoneDecoration(
    BuildContext context,
    Color borderColor,
    Color focusedBorderColor,
    Color errorBorderColor,
  ) {
    return InputDecoration(
      labelText: widget.showLabelAlways ? null : widget.labelText,
      hintText: widget.hintText,
      prefixIcon: widget.prefixIcon,
      suffixIcon: _buildSuffixIcon(),
      filled: false,
      contentPadding: widget.contentPadding ??
          const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
      border: InputBorder.none,
      enabledBorder: InputBorder.none,
      focusedBorder: InputBorder.none,
      errorBorder: InputBorder.none,
      focusedErrorBorder: InputBorder.none,
      disabledBorder: InputBorder.none,
      labelStyle: widget.labelStyle ??
          YoTextTheme.bodyMedium(context).copyWith(color: context.gray600),
      hintStyle: widget.hintStyle ??
          YoTextTheme.bodyMedium(context).copyWith(color: context.gray400),
      errorStyle: const TextStyle(height: 0, fontSize: 0),
    );
  }

  /* ------------------------------------------------------ */
  /*  Decoration helpers – now use YoUI colors              */
  /* ------------------------------------------------------ */
  InputDecoration _buildOutlinedDecoration(
    BuildContext context,
    Color borderColor,
    Color focusedBorderColor,
    Color errorBorderColor,
  ) {
    return InputDecoration(
      labelText: widget.showLabelAlways ? null : widget.labelText,
      hintText: widget.hintText,
      prefixIcon: widget.prefixIcon,
      suffixIcon: _buildSuffixIcon(),
      filled: false,
      contentPadding: widget.contentPadding ??
          const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        borderSide: BorderSide(
          color: borderColor,
          width: widget.enabledBorderWidth,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        borderSide: BorderSide(
          color: borderColor,
          width: widget.enabledBorderWidth,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        borderSide: BorderSide(
          color: focusedBorderColor,
          width: widget.focusedBorderWidth,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        borderSide: BorderSide(
          color: errorBorderColor,
          width: widget.focusedBorderWidth,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        borderSide: BorderSide(
          color: errorBorderColor,
          width: widget.focusedBorderWidth,
        ),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        borderSide: BorderSide(
          color: borderColor.withAlpha(77),
          width: widget.enabledBorderWidth,
        ),
      ),
      labelStyle: widget.labelStyle ??
          YoTextTheme.bodyMedium(context).copyWith(color: context.gray600),
      hintStyle: widget.hintStyle ??
          YoTextTheme.bodyMedium(context).copyWith(color: context.gray400),
      errorStyle: const TextStyle(height: 0, fontSize: 0),
    );
  }

  Widget? _buildSuffixIcon() {
    final icons = <Widget>[];
    if (widget.showClearButton && _controller.text.isNotEmpty) {
      icons.add(
        IconButton(
          icon: Icon(Icons.clear, size: 20, color: context.gray500),
          onPressed: () {
            _controller.clear();
            if (widget.onChanged != null) widget.onChanged!('');
          },
        ),
      );
    }
    if (widget.showVisibilityToggle &&
        widget.inputType == YoInputType.password) {
      icons.add(
        IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility : Icons.visibility_off,
            size: 20,
            color: context.gray500,
          ),
          onPressed: () => setState(() => _obscureText = !_obscureText),
        ),
      );
    }
    if (widget.suffixIcon != null) icons.add(widget.suffixIcon!);
    if (icons.isEmpty) return null;
    if (icons.length == 1) return icons.first;
    return Row(mainAxisSize: MainAxisSize.min, children: icons);
  }

  InputDecoration _buildUnderlineDecoration(
    BuildContext context,
    Color borderColor,
    Color focusedBorderColor,
    Color errorBorderColor,
  ) {
    return InputDecoration(
      labelText: widget.showLabelAlways ? null : widget.labelText,
      hintText: widget.hintText,
      prefixIcon: widget.prefixIcon,
      suffixIcon: _buildSuffixIcon(),
      filled: false,
      contentPadding: widget.contentPadding ??
          const EdgeInsets.symmetric(horizontal: 0, vertical: 16),
      border: UnderlineInputBorder(
        borderSide: BorderSide(
          color: borderColor,
          width: widget.enabledBorderWidth,
        ),
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: borderColor,
          width: widget.enabledBorderWidth,
        ),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: focusedBorderColor,
          width: widget.focusedBorderWidth,
        ),
      ),
      errorBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: errorBorderColor,
          width: widget.focusedBorderWidth,
        ),
      ),
      focusedErrorBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: errorBorderColor,
          width: widget.focusedBorderWidth,
        ),
      ),
      labelStyle: widget.labelStyle ??
          YoTextTheme.bodyMedium(context).copyWith(color: context.gray600),
      hintStyle: widget.hintStyle ??
          YoTextTheme.bodyMedium(context).copyWith(color: context.gray400),
      errorStyle: const TextStyle(height: 0, fontSize: 0),
    );
  }

  List<TextInputFormatter> _getInputFormatters() {
    final formatters = <TextInputFormatter>[];
    if (widget.inputFormatters != null) {
      formatters.addAll(widget.inputFormatters!);
    }
    switch (widget.inputType) {
      case YoInputType.number:
        formatters.add(FilteringTextInputFormatter.digitsOnly);
        break;
      case YoInputType.currency:
        formatters.add(CurrencyTextInputFormatter());
        break;
      case YoInputType.phone:
        formatters.add(PhoneNumberFormatter());
        break;
      default:
        break;
    }
    return formatters;
  }

  TextInputType _getTextInputType() {
    switch (widget.inputType) {
      case YoInputType.email:
        return TextInputType.emailAddress;
      case YoInputType.phone:
        return TextInputType.phone;
      case YoInputType.number:
      case YoInputType.currency:
        return TextInputType.number;
      case YoInputType.url:
        return TextInputType.url;
      case YoInputType.multiline:
        return TextInputType.multiline;
      case YoInputType.search:
        return TextInputType.text;
      default:
        return TextInputType.text;
    }
  }

  void _handleFocusChange() {
    setState(() {
      _hasFocus = _focusNode.hasFocus;
      if (_hasFocus || _hasText) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  void _handleTextChange() {
    setState(() {
      _hasText = _controller.text.isNotEmpty;
    });
  }

  String? _validateInput(String? value) {
    if (widget.validator != null) return widget.validator!(value);
    if (widget.isRequired && (value == null || value.isEmpty)) {
      return 'This field is required';
    }
    switch (widget.inputType) {
      case YoInputType.email:
        final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
        if (value != null && value.isNotEmpty && !emailRegex.hasMatch(value)) {
          return 'Please enter a valid email';
        }
        break;
      case YoInputType.phone:
        final phoneRegex = RegExp(r'^\+?[\d\s-]{10,}$');
        if (value != null && value.isNotEmpty && !phoneRegex.hasMatch(value)) {
          return 'Please enter a valid phone number';
        }
        break;
      case YoInputType.url:
        final urlRegex = RegExp(
          r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
        );
        if (value != null && value.isNotEmpty && !urlRegex.hasMatch(value)) {
          return 'Please enter a valid URL';
        }
        break;
      default:
        break;
    }
    return null;
  }
}
