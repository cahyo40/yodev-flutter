import 'package:flutter/material.dart';

/// Form wrapper with validation and submission
class YoForm extends StatefulWidget {
  final GlobalKey<FormState>? formKey;
  final List<Widget> children;
  final Function(Map<String, dynamic> values)? onSubmit;
  final bool autoValidate;
  final EdgeInsetsGeometry? padding;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;
  final MainAxisSize mainAxisSize;

  const YoForm({
    super.key,
    this.formKey,
    required this.children,
    this.onSubmit,
    this.autoValidate = false,
    this.padding,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.max,
  });

  @override
  State<YoForm> createState() => _YoFormState();
}

/// Form controller for programmatic access
class YoFormController {
  final GlobalKey<FormState> formKey;

  YoFormController() : formKey = GlobalKey<FormState>();

  void reset() {
    formKey.currentState?.reset();
  }

  void save() {
    formKey.currentState?.save();
  }

  bool submit() {
    if (validate()) {
      save();
      return true;
    }
    return false;
  }

  bool validate() {
    return formKey.currentState?.validate() ?? false;
  }
}

class _YoFormState extends State<YoForm> {
  late GlobalKey<FormState> _formKey;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: widget.autoValidate
          ? AutovalidateMode.always
          : AutovalidateMode.disabled,
      child: Padding(
        padding: widget.padding ?? EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: widget.crossAxisAlignment,
          mainAxisAlignment: widget.mainAxisAlignment,
          mainAxisSize: widget.mainAxisSize,
          children: widget.children,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _formKey = widget.formKey ?? GlobalKey<FormState>();
  }

  void reset() {
    _formKey.currentState?.reset();
  }

  void submit() {
    if (validate()) {
      _formKey.currentState?.save();
      widget.onSubmit?.call({});
    }
  }

  bool validate() {
    return _formKey.currentState?.validate() ?? false;
  }
}
