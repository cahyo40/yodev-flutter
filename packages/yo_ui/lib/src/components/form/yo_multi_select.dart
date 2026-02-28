import 'package:flutter/material.dart';
import 'package:yo_ui/yo_ui.dart';

/// Form component for selecting multiple items from a list
class YoMultiSelect<T> extends StatefulWidget {
  final List<YoDropDownItem<T>> items;
  final List<T> initialSelectedValues;
  final ValueChanged<List<T>> onChanged;
  final String? labelText;
  final String? hintText;
  final String? errorText;
  final bool isRequired;
  final bool enabled;
  final Widget? prefixIcon;
  final bool searchable;
  final String searchHintText;

  const YoMultiSelect({
    super.key,
    required this.items,
    required this.onChanged,
    this.initialSelectedValues = const [],
    this.labelText,
    this.hintText,
    this.errorText,
    this.isRequired = false,
    this.enabled = true,
    this.prefixIcon,
    this.searchable = true,
    this.searchHintText = 'Cari...',
  });

  @override
  State<YoMultiSelect<T>> createState() => _YoMultiSelectState<T>();
}

class _YoMultiSelectState<T> extends State<YoMultiSelect<T>> {
  late List<T> _selectedValues;

  @override
  void initState() {
    super.initState();
    _selectedValues = List.from(widget.initialSelectedValues);
  }

  void _showMultiSelectSheet() {
    FocusScope.of(context).unfocus();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return _MultiSelectSheet<T>(
          items: widget.items,
          initialSelectedValues: _selectedValues,
          searchable: widget.searchable,
          searchHintText: widget.searchHintText,
          title: widget.labelText ?? 'Pilih Item',
          onApplied: (values) {
            setState(() {
              _selectedValues = values;
            });
            widget.onChanged(_selectedValues);
          },
        );
      },
    );
  }

  void _removeItem(T value) {
    if (!widget.enabled) return;
    setState(() {
      _selectedValues.remove(value);
    });
    widget.onChanged(_selectedValues);
  }

  @override
  Widget build(BuildContext context) {
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
                YoText.bodyMedium(
                  ' *',
                  color: context.errorColor,
                ),
            ],
          ),
          const YoSpace.height(6),
        ],
        InkWell(
          onTap: widget.enabled ? _showMultiSelectSheet : null,
          borderRadius: YoSpacing.borderRadiusMd,
          child: Container(
            constraints: const BoxConstraints(minHeight: 48),
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: widget.enabled ? context.backgroundColor : context.gray100,
              borderRadius: YoSpacing.borderRadiusMd,
              border: Border.all(
                color: effectiveBorderColor,
                width: hasError ? 1.5 : 1,
              ),
            ),
            child: Row(
              children: [
                if (widget.prefixIcon != null) ...[
                  widget.prefixIcon!,
                  const YoSpace.widthSm(),
                ],
                Expanded(
                  child: _selectedValues.isEmpty
                      ? YoText.bodyMedium(
                          widget.hintText ?? 'Pilih item...',
                          color: context.gray400,
                        )
                      : Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _selectedValues.map((val) {
                            final item = widget.items.firstWhere(
                              (it) => it.value == val,
                              orElse: () => YoDropDownItem<T>(
                                  value: val, label: val.toString()),
                            );
                            return YoChip(
                              label: item.label,
                              size: YoChipSize.small,
                              onDeleted: widget.enabled
                                  ? () => _removeItem(val)
                                  : null,
                              variant: YoChipVariant.tonal,
                            );
                          }).toList(),
                        ),
                ),
                const YoSpace.widthSm(),
                Icon(
                  Icons.arrow_drop_down,
                  color: widget.enabled ? context.gray500 : context.gray300,
                ),
              ],
            ),
          ),
        ),
        if (widget.errorText != null) ...[
          const YoSpace.heightXs(),
          YoText.bodySmall(
            widget.errorText!,
            color: context.errorColor,
          ),
        ],
      ],
    );
  }
}

class _MultiSelectSheet<T> extends StatefulWidget {
  final List<YoDropDownItem<T>> items;
  final List<T> initialSelectedValues;
  final bool searchable;
  final String searchHintText;
  final String title;
  final ValueChanged<List<T>> onApplied;

  const _MultiSelectSheet({
    required this.items,
    required this.initialSelectedValues,
    required this.searchable,
    required this.searchHintText,
    required this.title,
    required this.onApplied,
  });

  @override
  State<_MultiSelectSheet<T>> createState() => _MultiSelectSheetState<T>();
}

class _MultiSelectSheetState<T> extends State<_MultiSelectSheet<T>> {
  late List<T> _tempSelectedValues;
  late List<YoDropDownItem<T>> _filteredItems;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tempSelectedValues = List.from(widget.initialSelectedValues);
    _filteredItems = List.from(widget.items);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterItems(String query) {
    if (query.isEmpty) {
      setState(() => _filteredItems = widget.items);
      return;
    }
    setState(() {
      _filteredItems = widget.items
          .where(
              (item) => item.label.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _toggleItem(T value) {
    setState(() {
      if (_tempSelectedValues.contains(value)) {
        _tempSelectedValues.remove(value);
      } else {
        _tempSelectedValues.add(value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      decoration: BoxDecoration(
        color: context.backgroundColor,
        borderRadius:
            const BorderRadius.vertical(top: Radius.circular(YoSpacing.md)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 8, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: YoText.titleMedium(
                    widget.title,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                YoButtonIcon.ghost(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                )
              ],
            ),
          ),

          if (widget.searchable)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: YoSearchField(
                controller: _searchController,
                hintText: widget.searchHintText,
                onSearch: _filterItems,
                showClearButton: true,
              ),
            ),

          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _filteredItems.length,
              itemBuilder: (context, index) {
                final item = _filteredItems[index];
                final isSelected = _tempSelectedValues.contains(item.value);
                return YoCheckboxListTile(
                  value: isSelected,
                  enabled: item.enabled,
                  onChanged: (val) {
                    if (val != null) _toggleItem(item.value);
                  },
                  title: item.label,
                );
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: YoButton.primary(
              text: 'Terapkan (${_tempSelectedValues.length})',
              expanded: true,
              onPressed: () {
                widget.onApplied(_tempSelectedValues);
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
