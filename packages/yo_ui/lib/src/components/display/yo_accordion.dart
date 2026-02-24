// File: yo_accordion.dart
import 'package:flutter/material.dart';
import 'package:yo_ui/yo_ui.dart';

class YoAccordion extends StatefulWidget {
  final String title;
  final Widget content;
  final bool initiallyExpanded;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderRadius;

  const YoAccordion({
    super.key,
    required this.title,
    required this.content,
    this.initiallyExpanded = false,
    this.padding,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius = 8.0,
  });

  @override
  State<YoAccordion> createState() => _YoAccordionState();
}

class _YoAccordionState extends State<YoAccordion> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? context.backgroundColor,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        border: Border.all(color: widget.borderColor ?? context.gray200),
      ),
      child: ExpansionTile(
        title: YoText.bodyLarge(widget.title, fontWeight: FontWeight.w600),
        initiallyExpanded: _isExpanded,
        onExpansionChanged: (expanded) {
          setState(() {
            _isExpanded = expanded;
          });
        },
        trailing: Icon(
          _isExpanded ? Icons.expand_less : Icons.expand_more,
          color: context.primaryColor,
        ),
        tilePadding: EdgeInsets.symmetric(horizontal: context.yoSpacingMd),
        children: [
          Padding(
            padding: widget.padding ?? EdgeInsets.all(context.yoSpacingMd),
            child: widget.content,
          ),
        ],
      ),
    );
  }
}
