import 'package:flutter/material.dart';

import '../../../yo_ui_base.dart';

class YoExpandableText extends StatefulWidget {
  final String text;
  final int maxLines;
  final String expandText;
  final String collapseText;
  final TextStyle? textStyle;
  final TextStyle? linkStyle;
  final TextAlign textAlign;
  final bool expanded;

  const YoExpandableText({
    super.key,
    required this.text,
    this.maxLines = 3,
    this.expandText = 'Show more',
    this.collapseText = 'Show less',
    this.textStyle,
    this.linkStyle,
    this.textAlign = TextAlign.start,
    this.expanded = false,
  });

  @override
  State<YoExpandableText> createState() => _YoExpandableTextState();
}

class _YoExpandableTextState extends State<YoExpandableText> {
  bool _isExpanded = false;
  bool _needsExpansion = false;

  @override
  Widget build(BuildContext context) {
    final defaultTextStyle = widget.textStyle ?? context.yoBodyMedium;
    final defaultLinkStyle = widget.linkStyle ??
        defaultTextStyle.copyWith(
          color: context.primaryColor,
          fontWeight: FontWeight.w600,
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            return _buildTextContent(defaultTextStyle, defaultLinkStyle);
          },
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.expanded;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkIfTextOverflows();
    });
  }

  Widget _buildTextContent(TextStyle? textStyle, TextStyle? linkStyle) {
    if (!_needsExpansion && !_isExpanded) {
      return Text(widget.text, style: textStyle, textAlign: widget.textAlign);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.text,
          style: textStyle,
          textAlign: widget.textAlign,
          maxLines: _isExpanded ? null : widget.maxLines,
          overflow: _isExpanded ? null : TextOverflow.ellipsis,
        ),
        if (_needsExpansion || _isExpanded) ...[
          const SizedBox(height: 4),
          GestureDetector(
            onTap: _toggleExpansion,
            child: Text(
              _isExpanded ? widget.collapseText : widget.expandText,
              style: linkStyle,
            ),
          ),
        ],
      ],
    );
  }

  void _checkIfTextOverflows() {
    final textPainter = TextPainter(
      text: TextSpan(
        text: widget.text,
        style: widget.textStyle ?? context.yoBodyMedium,
      ),
      maxLines: widget.maxLines,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(maxWidth: MediaQuery.of(context).size.width - 32);
    setState(() {
      _needsExpansion = textPainter.didExceedMaxLines;
    });
  }

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }
}
