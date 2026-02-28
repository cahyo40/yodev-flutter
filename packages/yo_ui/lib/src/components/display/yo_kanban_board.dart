import 'package:flutter/material.dart';
import 'package:yo_ui/yo_ui.dart';

/// Kanban item model
class YoKanbanItem {
  final String id;
  final String title;
  final String? description;
  final Color? color;
  final Widget? leading;
  final List<String> tags;
  final DateTime? dueDate;
  final int priority;
  final List<Widget> customWidgets;

  const YoKanbanItem({
    required this.id,
    required this.title,
    this.description,
    this.color,
    this.leading,
    this.tags = const [],
    this.dueDate,
    this.priority = 0,
    this.customWidgets = const [],
  });

  YoKanbanItem copyWith({
    String? id,
    String? title,
    String? description,
    Color? color,
    Widget? leading,
    List<String>? tags,
    DateTime? dueDate,
    int? priority,
    List<Widget>? customWidgets,
  }) {
    return YoKanbanItem(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      color: color ?? this.color,
      leading: leading ?? this.leading,
      tags: tags ?? this.tags,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      customWidgets: customWidgets ?? this.customWidgets,
    );
  }
}

/// Kanban column model
class YoKanbanColumn {
  final String id;
  final String title;
  final Color? color;
  final IconData? icon;
  final List<YoKanbanItem> items;
  final int maxItems;

  const YoKanbanColumn({
    required this.id,
    required this.title,
    this.color,
    this.icon,
    required this.items,
    this.maxItems = 10,
  });

  YoKanbanColumn copyWith({
    String? id,
    String? title,
    Color? color,
    IconData? icon,
    List<YoKanbanItem>? items,
    int? maxItems,
  }) {
    return YoKanbanColumn(
      id: id ?? this.id,
      title: title ?? this.title,
      color: color ?? this.color,
      icon: icon ?? this.icon,
      items: items ?? this.items,
      maxItems: maxItems ?? this.maxItems,
    );
  }
}

/// Kanban board widget with drag-and-drop support
class YoKanbanBoard extends StatefulWidget {
  final List<YoKanbanColumn> columns;
  final Function(YoKanbanItem, String fromColumnId, String toColumnId)?
      onItemMoved;
  final Function(YoKanbanItem, String columnId)? onItemTap;
  final Function(YoKanbanColumn)? onColumnTap;
  final double columnWidth;
  final double columnSpacing;
  final bool scrollable;
  final double height;
  final bool dragEnabled;

  const YoKanbanBoard({
    super.key,
    required this.columns,
    this.onItemMoved,
    this.onItemTap,
    this.onColumnTap,
    this.columnWidth = 280,
    this.columnSpacing = 16,
    this.scrollable = true,
    this.height = 400,
    this.dragEnabled = true,
  });

  @override
  State<YoKanbanBoard> createState() => _YoKanbanBoardState();
}

class _YoKanbanBoardState extends State<YoKanbanBoard> {
  late List<YoKanbanColumn> _columns;
  String? _draggedItemId;
  String? _draggedFromColumnId;

  @override
  void initState() {
    super.initState();
    _columns = List.from(widget.columns);
  }

  @override
  void didUpdateWidget(YoKanbanBoard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Sync columns if widget.columns changed externally
    if (widget.columns != oldWidget.columns) {
      _columns = List.from(widget.columns);
    }
  }

  void _handleItemMove(
    YoKanbanItem item,
    String fromColumnId,
    String toColumnId,
  ) {
    if (fromColumnId == toColumnId || !widget.dragEnabled) return;

    setState(() {
      // Remove from source
      final fromIdx = _columns.indexWhere((c) => c.id == fromColumnId);
      if (fromIdx != -1) {
        final fromCol = _columns[fromIdx];
        _columns[fromIdx] = fromCol.copyWith(
          items: fromCol.items.where((i) => i.id != item.id).toList(),
        );
      }

      // Add to target
      final toIdx = _columns.indexWhere((c) => c.id == toColumnId);
      if (toIdx != -1) {
        final toCol = _columns[toIdx];
        _columns[toIdx] = toCol.copyWith(items: [...toCol.items, item]);
      }
    });

    widget.onItemMoved?.call(item, fromColumnId, toColumnId);
  }

  @override
  Widget build(BuildContext context) {
    return YoBox(
      height: widget.height,
      child: widget.scrollable
          ? ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.all(widget.columnSpacing),
              itemCount: _columns.length,
              separatorBuilder: (_, __) => YoBox(width: widget.columnSpacing),
              itemBuilder: (_, i) => _buildColumn(context, _columns[i]),
            )
          : Padding(
              padding: EdgeInsets.all(widget.columnSpacing),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (int i = 0; i < _columns.length; i++) ...[
                    Expanded(child: _buildColumn(context, _columns[i])),
                    if (i < _columns.length - 1)
                      YoBox(width: widget.columnSpacing),
                  ],
                ],
              ),
            ),
    );
  }

  Widget _buildColumn(BuildContext context, YoKanbanColumn column) {
    Widget content(bool isActive) =>
        _buildColumnContent(context, column, isActive);

    if (!widget.dragEnabled) {
      return YoBox(width: widget.columnWidth, child: content(false));
    }

    return YoBox(
      width: widget.scrollable ? widget.columnWidth : null,
      child: DragTarget<Map<String, dynamic>>(
        onWillAcceptWithDetails: (data) {
          final fromColId = data.data['fromColumnId'] as String;
          return fromColId != column.id;
        },
        onAcceptWithDetails: (data) {
          final itemId = data.data['itemId'] as String;
          final fromColId = data.data['fromColumnId'] as String;
          final fromCol = _columns.firstWhere((c) => c.id == fromColId);
          final item = fromCol.items.firstWhere((i) => i.id == itemId);
          _handleItemMove(item, fromColId, column.id);
        },
        builder: (_, candidateData, __) => content(candidateData.isNotEmpty),
      ),
    );
  }

  Widget _buildColumnContent(
    BuildContext context,
    YoKanbanColumn column,
    bool isDragActive,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: context.backgroundColor,
        borderRadius: BorderRadius.circular(context.yoRadiusLg),
        border: Border.all(
          color: isDragActive
              ? context.primaryColor.withAlpha(128)
              : context.gray200,
          width: isDragActive ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Padding(
            padding: EdgeInsets.all(context.yoSpacingMd),
            child: GestureDetector(
              onTap: () => widget.onColumnTap?.call(column),
              child: Row(
                children: [
                  if (column.icon != null) ...[
                    Icon(
                      column.icon,
                      color: column.color ?? context.primaryColor,
                      size: 16,
                    ),
                    YoBox(width: context.yoSpacingSm),
                  ],
                  Expanded(
                    child: YoText.bodyLarge(
                      '${column.title} (${column.items.length})',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Items
          Expanded(
            child: column.items.isEmpty
                ? _buildEmpty(context, isDragActive)
                : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                      horizontal: context.yoSpacingSm,
                    ),
                    itemCount: column.items.length,
                    itemBuilder: (_, i) =>
                        _buildItem(context, column.items[i], column.id),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(BuildContext context, YoKanbanItem item, String columnId) {
    final card = _buildItemCard(context, item, columnId);

    if (!widget.dragEnabled) return card;

    return LongPressDraggable<Map<String, dynamic>>(
      data: {'itemId': item.id, 'fromColumnId': columnId},
      feedback: Material(
        type: MaterialType.transparency,
        child: YoBox(
          width: widget.columnWidth - 32,
          child: Card(
            elevation: 8,
            child: Padding(
              padding: EdgeInsets.all(context.yoSpacingMd),
              child: _buildItemContent(context, item),
            ),
          ),
        ),
      ),
      childWhenDragging: Opacity(opacity: 0.3, child: card),
      onDragStarted: () => setState(() {
        _draggedItemId = item.id;
        _draggedFromColumnId = columnId;
      }),
      onDragEnd: (_) => setState(() {
        _draggedItemId = null;
        _draggedFromColumnId = null;
      }),
      child: card,
    );
  }

  Widget _buildItemCard(
    BuildContext context,
    YoKanbanItem item,
    String columnId,
  ) {
    final isDragging =
        _draggedItemId == item.id && _draggedFromColumnId == columnId;

    return Container(
      margin: EdgeInsets.symmetric(vertical: context.yoSpacingXs),
      child: Card(
        elevation: isDragging ? 4 : 1,
        color: isDragging ? context.primaryColor.withAlpha(26) : null,
        child: InkWell(
          onTap: () => widget.onItemTap?.call(item, columnId),
          borderRadius: BorderRadius.circular(context.yoRadiusLg),
          child: Padding(
            padding: EdgeInsets.all(context.yoSpacingMd),
            child: _buildItemContent(context, item),
          ),
        ),
      ),
    );
  }

  Widget _buildItemContent(BuildContext context, YoKanbanItem item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Header
        Row(
          children: [
            if (widget.dragEnabled) ...[
              MouseRegion(
                cursor: SystemMouseCursors.grab,
                child: Icon(
                  Icons.drag_handle,
                  size: 16,
                  color: context.gray400,
                ),
              ),
              YoBox(width: context.yoSpacingSm),
            ],
            if (item.leading != null) ...[
              item.leading!,
              YoBox(width: context.yoSpacingSm),
            ],
            Expanded(
              child: YoText.bodyMedium(item.title, fontWeight: FontWeight.w500),
            ),
            if (item.priority > 0)
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: context.yoSpacingSm,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: _priorityColor(context, item.priority),
                  borderRadius: BorderRadius.circular(context.yoRadiusSm),
                ),
                child: YoText.bodySmall(
                  'P${item.priority}',
                  color: context.onPrimaryColor,
                ),
              ),
          ],
        ),

        // Description
        if (item.description != null) ...[
          YoBox(height: context.yoSpacingXs),
          YoText.bodySmall(
            item.description!,
            color: context.gray600,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],

        // Custom widgets
        if (item.customWidgets.isNotEmpty) ...[
          YoBox(height: context.yoSpacingSm),
          ...item.customWidgets.map(
            (w) => Padding(
              padding: EdgeInsets.only(bottom: context.yoSpacingXs),
              child: w,
            ),
          ),
        ],

        // Tags
        if (item.tags.isNotEmpty) ...[
          YoBox(height: context.yoSpacingSm),
          Wrap(
            spacing: 4,
            runSpacing: 4,
            children: item.tags
                .map(
                  (t) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: context.gray100,
                      borderRadius: BorderRadius.circular(context.yoRadiusSm),
                    ),
                    child: YoText.bodySmall(t, color: context.gray600),
                  ),
                )
                .toList(),
          ),
        ],

        // Due date
        if (item.dueDate != null) ...[
          YoBox(height: context.yoSpacingSm),
          Row(
            children: [
              Icon(Icons.access_time, size: 12, color: context.gray500),
              const YoSpace.width(4),
              YoText.bodySmall(
                YoDateFormatter.formatDate(item.dueDate!),
                color: context.gray600,
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildEmpty(BuildContext context, bool isDragActive) {
    return Container(
      margin: EdgeInsets.all(context.yoSpacingMd),
      padding: EdgeInsets.all(context.yoSpacingXl),
      decoration: BoxDecoration(
        border: Border.all(
          color: isDragActive ? context.primaryColor : context.gray300,
          width: isDragActive ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(context.yoRadiusMd),
        color:
            isDragActive ? context.primaryColor.withAlpha(26) : context.gray50,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.inbox,
            size: 40,
            color: isDragActive ? context.primaryColor : context.gray300,
          ),
          YoBox(height: context.yoSpacingSm),
          YoText.bodyMedium(
            isDragActive ? 'Drop here' : 'No items',
            color: isDragActive ? context.primaryColor : context.gray500,
            fontWeight: isDragActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ],
      ),
    );
  }

  Color _priorityColor(BuildContext context, int priority) {
    return switch (priority) {
      1 => context.successColor,
      2 => context.warningColor,
      3 => context.errorColor,
      _ => context.primaryColor,
    };
  }
}
