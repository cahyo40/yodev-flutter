import 'package:flutter/material.dart';
import 'package:yo_ui/yo_ui.dart';

/// Infinite scroll list with lazy loading
class YoInfiniteScroll extends StatefulWidget {
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final Future<void> Function() onLoadMore;
  final bool hasMore;
  final Widget? loadingWidget;
  final double threshold;
  final ScrollPhysics? physics;
  final EdgeInsetsGeometry? padding;
  final Widget? emptyWidget;
  final ScrollController? controller;

  const YoInfiniteScroll({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    required this.onLoadMore,
    this.hasMore = true,
    this.loadingWidget,
    this.threshold = 200,
    this.physics,
    this.padding,
    this.emptyWidget,
    this.controller,
  });

  @override
  State<YoInfiniteScroll> createState() => _YoInfiniteScrollState();
}

class _YoInfiniteScrollState extends State<YoInfiniteScroll> {
  late ScrollController _scrollController;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    if (widget.itemCount == 0 && widget.emptyWidget != null) {
      return widget.emptyWidget!;
    }

    return ListView.builder(
      controller: _scrollController,
      physics: widget.physics,
      padding: widget.padding,
      itemCount: widget.itemCount + (widget.hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == widget.itemCount) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: widget.loadingWidget ?? YoLoading.dots(),
            ),
          );
        }
        return widget.itemBuilder(context, index);
      },
    );
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _scrollController.dispose();
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _scrollController = widget.controller ?? ScrollController();
    _scrollController.addListener(_onScroll);
  }

  Future<void> _loadMore() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      await widget.onLoadMore();
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _onScroll() {
    if (_isLoading || !widget.hasMore) return;

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    final delta = maxScroll - currentScroll;

    if (delta < widget.threshold) {
      _loadMore();
    }
  }
}
