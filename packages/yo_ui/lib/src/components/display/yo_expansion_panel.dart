import 'package:flutter/material.dart';
import 'package:yo_ui/yo_ui.dart';

/// Simple expansion panel
class YoExpansionPanel extends StatefulWidget {
  final Widget header;
  final Widget body;
  final bool initiallyExpanded;
  final Function(bool isExpanded)? onExpansionChanged;
  final Duration animationDuration;
  final EdgeInsetsGeometry? contentPadding;
  final Color? backgroundColor;
  final Color? expandedBackgroundColor;

  const YoExpansionPanel({
    super.key,
    required this.header,
    required this.body,
    this.initiallyExpanded = false,
    this.onExpansionChanged,
    this.animationDuration = const Duration(milliseconds: 200),
    this.contentPadding,
    this.backgroundColor,
    this.expandedBackgroundColor,
  });

  @override
  State<YoExpansionPanel> createState() => _YoExpansionPanelState();
}

/// Expansion panel item
class YoExpansionPanelItem {
  final Widget header;
  final Widget body;
  final bool isExpanded;
  final bool canToggle;

  const YoExpansionPanelItem({
    required this.header,
    required this.body,
    this.isExpanded = false,
    this.canToggle = true,
  });
}

/// Accordion-style expansion panel list
class YoExpansionPanelList extends StatefulWidget {
  final List<YoExpansionPanelItem> children;
  final Function(int index, bool isExpanded)? onExpansionChanged;
  final bool expandOnlyOne;
  final Duration animationDuration;
  final Color? dividerColor;
  final double elevation;
  final EdgeInsetsGeometry? contentPadding;

  const YoExpansionPanelList({
    super.key,
    required this.children,
    this.onExpansionChanged,
    this.expandOnlyOne = false,
    this.animationDuration = const Duration(milliseconds: 200),
    this.dividerColor,
    this.elevation = 0,
    this.contentPadding,
  });

  @override
  State<YoExpansionPanelList> createState() => _YoExpansionPanelListState();
}

class _YoExpansionPanelListState extends State<YoExpansionPanelList> {
  late List<bool> _expansionStates;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        widget.children.length,
        (index) {
          final item = widget.children[index];
          final isExpanded = _expansionStates[index];

          return Column(
            children: [
              Material(
                elevation: widget.elevation,
                child: InkWell(
                  onTap: () => _handleTap(index),
                  child: Container(
                    padding: widget.contentPadding ??
                        const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                    child: Row(
                      children: [
                        Expanded(child: item.header),
                        AnimatedRotation(
                          turns: isExpanded ? 0.5 : 0,
                          duration: widget.animationDuration,
                          child: Icon(
                            Icons.expand_more,
                            color: context.gray600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              AnimatedSize(
                duration: widget.animationDuration,
                curve: Curves.easeInOut,
                child: isExpanded
                    ? Container(
                        width: double.infinity,
                        padding:
                            widget.contentPadding ?? const EdgeInsets.all(16),
                        child: item.body,
                      )
                    : const YoBox(),
              ),
              if (index < widget.children.length - 1)
                Divider(
                  height: 1,
                  color: widget.dividerColor ?? context.gray200,
                ),
            ],
          );
        },
      ),
    );
  }

  @override
  void didUpdateWidget(YoExpansionPanelList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.children.length != oldWidget.children.length) {
      _expansionStates =
          widget.children.map((item) => item.isExpanded).toList();
    }
  }

  @override
  void initState() {
    super.initState();
    _expansionStates = widget.children.map((item) => item.isExpanded).toList();
  }

  void _handleTap(int index) {
    if (!widget.children[index].canToggle) return;

    setState(() {
      if (widget.expandOnlyOne) {
        // Collapse all others
        for (int i = 0; i < _expansionStates.length; i++) {
          if (i != index) {
            _expansionStates[i] = false;
          }
        }
      }
      _expansionStates[index] = !_expansionStates[index];
    });

    widget.onExpansionChanged?.call(index, _expansionStates[index]);
  }
}

class _YoExpansionPanelState extends State<YoExpansionPanel> {
  late bool _isExpanded;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _isExpanded
            ? (widget.expandedBackgroundColor ?? context.gray50)
            : (widget.backgroundColor ?? Colors.transparent),
        borderRadius: BorderRadius.circular(context.yoRadiusLg),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: _toggle,
            borderRadius: BorderRadius.circular(context.yoRadiusLg),
            child: Container(
              padding: widget.contentPadding ??
                  const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
              child: Row(
                children: [
                  Expanded(child: widget.header),
                  AnimatedRotation(
                    turns: _isExpanded ? 0.5 : 0,
                    duration: widget.animationDuration,
                    child: Icon(
                      Icons.expand_more,
                      color: context.gray600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedSize(
            duration: widget.animationDuration,
            curve: Curves.easeInOut,
            child: _isExpanded
                ? Container(
                    width: double.infinity,
                    padding: widget.contentPadding ?? const EdgeInsets.all(16),
                    child: widget.body,
                  )
                : const YoBox(),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
  }

  void _toggle() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
    widget.onExpansionChanged?.call(_isExpanded);
  }
}
