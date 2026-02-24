import 'dart:async';

import 'package:flutter/material.dart';
import 'package:yo_ui/yo_ui.dart';

/// Carousel/Slider widget with auto-play and indicators
class YoCarousel extends StatefulWidget {
  final List<Widget> items;
  final double height;
  final bool autoPlay;
  final Duration autoPlayInterval;
  final bool showIndicators;
  final bool infiniteScroll;
  final double viewportFraction;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final ValueChanged<int>? onPageChanged;

  const YoCarousel({
    super.key,
    required this.items,
    this.height = 200,
    this.autoPlay = false,
    this.autoPlayInterval = const Duration(seconds: 3),
    this.showIndicators = true,
    this.infiniteScroll = true,
    this.viewportFraction = 1.0,
    this.borderRadius,
    this.padding,
    this.onPageChanged,
  }) : assert(items.length > 0, 'items cannot be empty');

  @override
  State<YoCarousel> createState() => _YoCarouselState();
}

class _YoCarouselState extends State<YoCarousel> {
  late PageController _pageController;
  int _currentPage = 0;
  Timer? _autoPlayTimer;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: widget.height,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            itemCount: widget.infiniteScroll ? null : widget.items.length,
            itemBuilder: (context, index) {
              final itemIndex = index % widget.items.length;
              return Padding(
                padding:
                    widget.padding ?? const EdgeInsets.symmetric(horizontal: 8),
                child: ClipRRect(
                  borderRadius:
                      widget.borderRadius ?? BorderRadius.circular(12),
                  child: widget.items[itemIndex],
                ),
              );
            },
          ),
        ),
        if (widget.showIndicators) ...[
          const SizedBox(height: 12),
          _buildIndicators(context),
        ],
      ],
    );
  }

  @override
  void dispose() {
    _autoPlayTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: widget.viewportFraction,
      initialPage: widget.infiniteScroll ? 1000 * widget.items.length : 0,
    );
    _currentPage = widget.infiniteScroll ? 0 : 0;

    if (widget.autoPlay) {
      _startAutoPlay();
    }
  }

  Widget _buildIndicators(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        widget.items.length,
        (index) => Container(
          width: 8,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color:
                index == _currentPage ? context.primaryColor : context.gray300,
          ),
        ),
      ),
    );
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = widget.infiniteScroll ? page % widget.items.length : page;
    });
    widget.onPageChanged?.call(_currentPage);
  }

  void _startAutoPlay() {
    _autoPlayTimer = Timer.periodic(widget.autoPlayInterval, (_) {
      if (_pageController.hasClients) {
        final nextPage = _pageController.page?.toInt() ?? 0;
        _pageController.animateToPage(
          nextPage + 1,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }
}
