import 'dart:async';

import 'package:flutter/material.dart';
import 'package:yo_ui/yo_ui.dart';

/// Autocomplete input wrapper with async network search support, debouncer, and generic typing.
class YoAsyncAutocomplete<T> extends StatefulWidget {
  final Future<List<YoDropDownItem<T>>> Function(String search) dataSource;
  final void Function(T? value) onSelected;
  final String? labelText;
  final String? hintText;
  final String? errorText;
  final bool isRequired;
  final bool enabled;
  final int debounceMs;
  final String Function(T value)? displayStringForOption;
  final YoDropDownItem<T>? initialSelection;

  const YoAsyncAutocomplete({
    super.key,
    required this.dataSource,
    required this.onSelected,
    this.labelText,
    this.hintText,
    this.errorText,
    this.isRequired = false,
    this.enabled = true,
    this.debounceMs = 500,
    this.displayStringForOption,
    this.initialSelection,
  });

  @override
  State<YoAsyncAutocomplete<T>> createState() => _YoAsyncAutocompleteState<T>();
}

class _YoAsyncAutocompleteState<T> extends State<YoAsyncAutocomplete<T>> {
  bool _isLoading = false;
  List<YoDropDownItem<T>> _options = [];
  Timer? _debounceTimer;

  // We map complex types back to dropdown labels for internal TypeAhead logic processing
  String _displayString(YoDropDownItem<T> option) {
    if (widget.displayStringForOption != null) {
      return widget.displayStringForOption!(option.value);
    }
    return option.label;
  }

  Future<void> _fetchData(String query) async {
    setState(() => _isLoading = true);
    try {
      final results = await widget.dataSource(query);
      if (mounted) {
        setState(() {
          _options = results;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _onSearch(String query) {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    _debounceTimer = Timer(Duration(milliseconds: widget.debounceMs), () {
      _fetchData(query);
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  Widget _buildFieldBuilder(
    BuildContext context,
    TextEditingController textEditingController,
    FocusNode focusNode,
    VoidCallback onFieldSubmitted,
  ) {
    final hasError = widget.errorText != null && widget.errorText!.isNotEmpty;
    final effectiveBorderColor =
        hasError ? context.errorColor : context.gray300;

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
                YoText.bodyMedium(' *', color: context.errorColor),
            ],
          ),
          const YoSpace.height(6),
        ],
        TextFormField(
          controller: textEditingController,
          focusNode: focusNode,
          enabled: widget.enabled,
          style: context.yoBodyMedium,
          onChanged: _onSearch,
          onFieldSubmitted: (String value) {
            onFieldSubmitted();
          },
          decoration: InputDecoration(
            hintText: widget.hintText ?? 'Cari...',
            hintStyle: context.yoBodyMedium.copyWith(color: context.gray400),
            filled: true,
            fillColor:
                widget.enabled ? context.backgroundColor : context.gray100,
            suffixIcon: _isLoading
                ? Container(
                    padding: const EdgeInsets.all(12),
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: context.primaryColor,
                    ),
                  )
                : const Icon(Icons.search),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: YoSpacing.borderRadiusMd,
              borderSide: BorderSide(
                  color: effectiveBorderColor, width: hasError ? 1.5 : 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: YoSpacing.borderRadiusMd,
              borderSide: BorderSide(
                  color: effectiveBorderColor, width: hasError ? 1.5 : 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: YoSpacing.borderRadiusMd,
              borderSide: BorderSide(color: context.primaryColor, width: 2),
            ),
          ),
        ),
        if (hasError) ...[
          const YoSpace.heightXs(),
          YoText.bodySmall(widget.errorText!, color: context.errorColor),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Autocomplete<YoDropDownItem<T>>(
      displayStringForOption: _displayString,
      initialValue: widget.initialSelection != null
          ? TextEditingValue(text: _displayString(widget.initialSelection!))
          : const TextEditingValue(),
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return Iterable<YoDropDownItem<T>>.empty();
        }
        return _options;
      },
      onSelected: (YoDropDownItem<T> selection) {
        widget.onSelected(selection.value);
      },
      fieldViewBuilder: _buildFieldBuilder,
      optionsViewBuilder: (context, onSelected, options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 4,
            shape: const RoundedRectangleBorder(
                borderRadius: YoSpacing.borderRadiusMd),
            color: context.backgroundColor,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: 250,
                maxWidth:
                    MediaQuery.of(context).size.width - 40, // General fallback
              ),
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                shrinkWrap: true,
                itemCount: options.length,
                itemBuilder: (BuildContext context, int index) {
                  final YoDropDownItem<T> option = options.elementAt(index);
                  return ListTile(
                    title: YoText.bodyMedium(
                      _displayString(option),
                    ),
                    onTap: () {
                      onSelected(option);
                    },
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
