import 'dart:async';

import 'package:flutter/material.dart';
import 'package:yo_ui/yo_ui.dart';

/// Search field with debounce, suggestions, and filters
class YoSearchField extends StatefulWidget {
  final String? hintText;
  final String? initialValue;
  final ValueChanged<String>? onSearch;
  final List<String>? suggestions;
  final int debounceMs;
  final bool showClearButton;
  final bool autofocus;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextEditingController? controller;
  final double borderRadius;
  final Color? fillColor;
  final Color? borderColor;
  final EdgeInsetsGeometry? contentPadding;

  const YoSearchField({
    super.key,
    this.hintText = 'Search...',
    this.initialValue,
    this.onSearch,
    this.suggestions,
    this.debounceMs = 300,
    this.showClearButton = true,
    this.autofocus = false,
    this.prefixIcon,
    this.suffixIcon,
    this.controller,
    this.borderRadius = 12.0,
    this.fillColor,
    this.borderColor,
    this.contentPadding,
  });

  @override
  State<YoSearchField> createState() => _YoSearchFieldState();
}

class _YoSearchFieldState extends State<YoSearchField> {
  late TextEditingController _controller;
  Timer? _debounceTimer;
  final FocusNode _focusNode = FocusNode();
  List<String> _filteredSuggestions = [];
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        autofocus: widget.autofocus,
        onChanged: _onSearchChanged,
        style: YoTextTheme.bodyMedium(context),
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: YoTextTheme.bodyMedium(context).copyWith(
            color: context.gray400,
          ),
          filled: true,
          fillColor: widget.fillColor ?? context.gray50,
          prefixIcon: widget.prefixIcon ??
              Icon(Icons.search, color: context.gray500, size: 20),
          suffixIcon: widget.showClearButton && _controller.text.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear, color: context.gray500, size: 20),
                  onPressed: _clearSearch,
                )
              : widget.suffixIcon,
          contentPadding: widget.contentPadding ??
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            borderSide: BorderSide(
              color: widget.borderColor ?? context.gray300,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            borderSide: BorderSide(
              color: widget.borderColor ?? context.gray300,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            borderSide: BorderSide(
              color: context.primaryColor,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
    if (widget.controller == null) {
      _controller.dispose();
    }
    _removeOverlay();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    if (widget.initialValue != null) {
      _controller.text = widget.initialValue!;
    }
    _focusNode.addListener(_handleFocusChange);
  }

  void _clearSearch() {
    _controller.clear();
    widget.onSearch?.call('');
    _removeOverlay();
  }

  void _filterSuggestions(String query) {
    if (widget.suggestions == null || widget.suggestions!.isEmpty) return;

    final filtered = widget.suggestions!
        .where((s) => s.toLowerCase().contains(query.toLowerCase()))
        .toList();

    if (filtered.isNotEmpty) {
      setState(() {
        _filteredSuggestions = filtered;
      });
      _showOverlay();
    } else {
      _removeOverlay();
    }
  }

  void _handleFocusChange() {
    if (_focusNode.hasFocus && _controller.text.isNotEmpty) {
      _filterSuggestions(_controller.text);
    } else {
      _removeOverlay();
    }
  }

  void _onSearchChanged(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(Duration(milliseconds: widget.debounceMs), () {
      widget.onSearch?.call(query);
    });

    if (query.isNotEmpty && widget.suggestions != null) {
      _filterSuggestions(query);
    } else {
      _removeOverlay();
    }
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _showOverlay() {
    _removeOverlay();

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: context.size?.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: const Offset(0, 60),
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(8),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 200),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: _filteredSuggestions.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    dense: true,
                    title: Text(
                      _filteredSuggestions[index],
                      style: YoTextTheme.bodyMedium(context),
                    ),
                    onTap: () {
                      _controller.text = _filteredSuggestions[index];
                      widget.onSearch?.call(_filteredSuggestions[index]);
                      _removeOverlay();
                      _focusNode.unfocus();
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }
}
