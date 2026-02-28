import 'package:flutter/material.dart';
import 'package:yo_ui/yo_ui.dart';

/// Chip input widget for tags
class YoChipInput extends StatefulWidget {
  final List<String> chips;
  final ValueChanged<List<String>>? onChanged;
  final List<String>? suggestions;
  final String? hintText;
  final int? maxChips;
  final Color? chipColor;
  final Color? chipTextColor;
  final bool enabled;

  const YoChipInput({
    super.key,
    this.chips = const [],
    this.onChanged,
    this.suggestions,
    this.hintText,
    this.maxChips,
    this.chipColor,
    this.chipTextColor,
    this.enabled = true,
  });

  @override
  State<YoChipInput> createState() => _YoChipInputState();
}

class _YoChipInputState extends State<YoChipInput> {
  late List<String> _chips;
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List<String> _filteredSuggestions = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(color: context.gray300),
            borderRadius: BorderRadius.circular(context.yoRadiusLg),
          ),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ..._chips.asMap().entries.map((entry) {
                return Chip(
                  label: YoText.bodyMedium(
                    entry.value,
                    color: widget.chipTextColor ?? Colors.white,
                  ),
                  backgroundColor: widget.chipColor ?? context.primaryColor,
                  deleteIcon: Icon(
                    Icons.close,
                    size: 16,
                    color: widget.chipTextColor ?? Colors.white,
                  ),
                  onDeleted:
                      widget.enabled ? () => _removeChip(entry.key) : null,
                );
              }),
              if (widget.maxChips == null || _chips.length < widget.maxChips!)
                YoBox(
                  width: 150,
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    enabled: widget.enabled,
                    decoration: InputDecoration(
                      hintText: widget.hintText ?? 'Add tag...',
                      border: InputBorder.none,
                      isDense: true,
                    ),
                    onChanged: _onTextChanged,
                    onSubmitted: _addChip,
                  ),
                ),
            ],
          ),
        ),
        if (_filteredSuggestions.isNotEmpty) ...[
          const YoSpace.height(8),
          Container(
            constraints: const BoxConstraints(maxHeight: 150),
            decoration: BoxDecoration(
              border: Border.all(color: context.gray300),
              borderRadius: BorderRadius.circular(context.yoRadiusMd),
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _filteredSuggestions.length,
              itemBuilder: (context, index) {
                return ListTile(
                  dense: true,
                  title: YoText.bodyMedium(_filteredSuggestions[index]),
                  onTap: () {
                    _addChip(_filteredSuggestions[index]);
                    _focusNode.requestFocus();
                  },
                );
              },
            ),
          ),
        ],
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _chips = List.from(widget.chips);
  }

  void _addChip(String value) {
    if (value.isEmpty) return;
    if (_chips.contains(value)) return;
    if (widget.maxChips != null && _chips.length >= widget.maxChips!) return;

    setState(() {
      _chips.add(value);
      _controller.clear();
      _filteredSuggestions.clear();
    });

    widget.onChanged?.call(_chips);
  }

  void _onTextChanged(String value) {
    if (widget.suggestions == null || widget.suggestions!.isEmpty) return;

    setState(() {
      _filteredSuggestions = widget.suggestions!
          .where((s) =>
              s.toLowerCase().contains(value.toLowerCase()) &&
              !_chips.contains(s))
          .toList();
    });
  }

  void _removeChip(int index) {
    setState(() {
      _chips.removeAt(index);
    });
    widget.onChanged?.call(_chips);
  }
}
