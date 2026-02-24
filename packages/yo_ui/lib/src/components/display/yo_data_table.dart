import 'package:flutter/material.dart';
import 'package:yo_ui/yo_ui.dart';

/// Data table with sorting and horizontal scroll
class YoDataTable extends StatefulWidget {
  final List<YoTableColumn> columns;
  final List<YoTableRow> rows;
  final Function(int columnIndex, bool ascending)? onSort;
  final bool selectable;
  final Function(List<int> selectedIndices)? onSelectionChanged;
  final double rowHeight;
  final bool showHeader;
  final Color? headerColor;
  final Color? rowColor;
  final Color? alternateRowColor;
  final EdgeInsetsGeometry? cellPadding;

  const YoDataTable({
    super.key,
    required this.columns,
    required this.rows,
    this.onSort,
    this.selectable = false,
    this.onSelectionChanged,
    this.rowHeight = 52,
    this.showHeader = true,
    this.headerColor,
    this.rowColor,
    this.alternateRowColor,
    this.cellPadding,
  });

  @override
  State<YoDataTable> createState() => _YoDataTableState();
}

/// Table column definition
class YoTableColumn {
  final String label;
  final double? width;
  final bool sortable;
  final bool numeric;
  final TextAlign textAlign;

  const YoTableColumn({
    required this.label,
    this.width,
    this.sortable = false,
    this.numeric = false,
    this.textAlign = TextAlign.left,
  });
}

/// Table row data
class YoTableRow {
  final List<dynamic> cells;
  final bool selected;
  final VoidCallback? onTap;

  const YoTableRow({
    required this.cells,
    this.selected = false,
    this.onTap,
  });
}

class _YoDataTableState extends State<YoDataTable> {
  int? _sortColumnIndex;
  bool _sortAscending = true;
  late List<int> _selectedIndices;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: MediaQuery.of(context).size.width,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.showHeader) _buildHeader(context),
            ..._buildRows(context),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _selectedIndices = [];
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      height: widget.rowHeight,
      decoration: BoxDecoration(
        color: widget.headerColor ?? context.gray100,
        border: Border(bottom: BorderSide(color: context.gray300)),
      ),
      child: Row(
        children: [
          if (widget.selectable)
            SizedBox(
              width: 56,
              child: Checkbox(
                value: _selectedIndices.length == widget.rows.length &&
                    widget.rows.isNotEmpty,
                onChanged: (_) => _toggleSelectAll(),
                tristate: true,
              ),
            ),
          ...widget.columns.asMap().entries.map((entry) {
            final index = entry.key;
            final column = entry.value;
            return InkWell(
              onTap: column.sortable ? () => _handleSort(index) : null,
              child: Container(
                width: column.width ?? 150,
                padding: widget.cellPadding ??
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: column.numeric
                      ? MainAxisAlignment.end
                      : MainAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Text(
                        column.label,
                        style: context.yoBodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: column.textAlign,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (column.sortable) ...[
                      const SizedBox(width: 4),
                      Icon(
                        _sortColumnIndex == index
                            ? (_sortAscending
                                ? Icons.arrow_upward
                                : Icons.arrow_downward)
                            : Icons.unfold_more,
                        size: 16,
                        color: _sortColumnIndex == index
                            ? context.primaryColor
                            : context.gray400,
                      ),
                    ],
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  List<Widget> _buildRows(BuildContext context) {
    return widget.rows.asMap().entries.map((entry) {
      final index = entry.key;
      final row = entry.value;
      final isSelected = _selectedIndices.contains(index);
      final isEven = index.isEven;

      return InkWell(
        onTap: row.onTap,
        child: Container(
          height: widget.rowHeight,
          decoration: BoxDecoration(
            color: isSelected
                ? context.primaryColor.withAlpha(26)
                : (widget.alternateRowColor != null && !isEven)
                    ? widget.alternateRowColor
                    : widget.rowColor ?? Colors.transparent,
            border: Border(bottom: BorderSide(color: context.gray200)),
          ),
          child: Row(
            children: [
              if (widget.selectable)
                SizedBox(
                  width: 56,
                  child: Checkbox(
                    value: isSelected,
                    onChanged: (_) => _toggleSelection(index),
                  ),
                ),
              ...widget.columns.asMap().entries.map((entry) {
                final columnIndex = entry.key;
                final column = entry.value;
                final cellData = row.cells[columnIndex];

                return Container(
                  width: column.width ?? 150,
                  padding: widget.cellPadding ??
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    cellData.toString(),
                    style: context.yoBodyMedium,
                    textAlign: column.textAlign,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }),
            ],
          ),
        ),
      );
    }).toList();
  }

  void _handleSort(int columnIndex) {
    if (!widget.columns[columnIndex].sortable) return;

    setState(() {
      if (_sortColumnIndex == columnIndex) {
        _sortAscending = !_sortAscending;
      } else {
        _sortColumnIndex = columnIndex;
        _sortAscending = true;
      }
    });

    widget.onSort?.call(columnIndex, _sortAscending);
  }

  void _toggleSelectAll() {
    setState(() {
      if (_selectedIndices.length == widget.rows.length) {
        _selectedIndices.clear();
      } else {
        _selectedIndices = List.generate(widget.rows.length, (i) => i);
      }
    });
    widget.onSelectionChanged?.call(_selectedIndices);
  }

  void _toggleSelection(int index) {
    setState(() {
      if (_selectedIndices.contains(index)) {
        _selectedIndices.remove(index);
      } else {
        _selectedIndices.add(index);
      }
    });
    widget.onSelectionChanged?.call(_selectedIndices);
  }
}
