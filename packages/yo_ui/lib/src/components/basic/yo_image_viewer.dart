import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

import '../../../yo_ui_base.dart';

class YoImageViewer extends StatefulWidget {
  final List<String> imageUrls;
  final int initialIndex;
  final String? heroTag;
  final bool enableDownload;
  final bool enableShare;
  final bool enableZoom;
  final BoxDecoration? backgroundDecoration;
  final double minScale;
  final double maxScale;

  const YoImageViewer({
    super.key,
    required this.imageUrls,
    this.initialIndex = 0,
    this.heroTag,
    this.enableDownload = true,
    this.enableShare = true,
    this.enableZoom = true,
    this.backgroundDecoration,
    this.minScale = 0.1,
    this.maxScale = 5.0,
  });

  static Future<void> show({
    required BuildContext context,
    required List<String> imageUrls,
    int initialIndex = 0,
    String? heroTag,
    bool enableDownload = true,
    bool enableShare = true,
    bool enableZoom = true,
  }) {
    return Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (context, animation, secondaryAnimation) {
          return YoImageViewer(
            imageUrls: imageUrls,
            initialIndex: initialIndex,
            heroTag: heroTag,
            enableDownload: enableDownload,
            enableShare: enableShare,
            enableZoom: enableZoom,
          );
        },
      ),
    );
  }

  static Future<void> showSingle({
    required BuildContext context,
    required String imageUrl,
    String? heroTag,
    bool enableDownload = true,
    bool enableShare = true,
  }) {
    return show(
      context: context,
      imageUrls: [imageUrl],
      heroTag: heroTag,
      enableDownload: enableDownload,
      enableShare: enableShare,
    );
  }

  @override
  State<YoImageViewer> createState() => _YoImageViewerState();
}

class _YoImageViewerState extends State<YoImageViewer> {
  late PageController _pageController;
  late int _currentIndex;
  bool _showAppBar = true;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  void _toggleAppBar() {
    setState(() {
      _showAppBar = !_showAppBar;
    });
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Main content
          _buildPhotoView(),

          // App Bar
          if (_showAppBar) _buildAppBar(),

          // Bottom indicators
          if (widget.imageUrls.length > 1 && _showAppBar)
            _buildBottomIndicator(),
        ],
      ),
    );
  }

  Widget _buildPhotoView() {
    return GestureDetector(
      onTap: _toggleAppBar,
      child: Container(
        color: Colors.black,
        child: PageView.builder(
          controller: _pageController,
          itemCount: widget.imageUrls.length,
          onPageChanged: _onPageChanged,
          itemBuilder: (context, index) {
            final imageUrl = widget.imageUrls[index];
            return widget.enableZoom
                ? _buildZoomableImage(imageUrl, index)
                : _buildSimpleImage(imageUrl, index);
          },
        ),
      ),
    );
  }

  Widget _buildZoomableImage(String imageUrl, int index) {
    return PhotoView(
      imageProvider: CachedNetworkImageProvider(imageUrl),
      backgroundDecoration:
          widget.backgroundDecoration ??
          const BoxDecoration(color: Colors.black),
      minScale: widget.minScale,
      maxScale: widget.maxScale,
      heroAttributes: widget.heroTag != null
          ? PhotoViewHeroAttributes(tag: '${widget.heroTag}_$index')
          : null,
      loadingBuilder: (context, event) =>
          const Center(child: CircularProgressIndicator(color: Colors.white)),
      errorBuilder: (context, error, stackTrace) => _buildErrorWidget(),
    );
  }

  Widget _buildSimpleImage(String imageUrl, int index) {
    return Hero(
      tag: widget.heroTag ?? 'image_$index',
      child: Center(
        child: YoImage.network(
          url: imageUrl,
          fit: BoxFit.contain,
          errorWidget: _buildErrorWidget(),
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.error_outline, color: Colors.white, size: 48),
        SizedBox(height: 8),
        Text('Failed to load image', style: TextStyle(color: Colors.white)),
      ],
    );
  }

  Widget _buildAppBar() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: AppBar(
        backgroundColor: Colors.black54,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: widget.imageUrls.length > 1
            ? Text(
                '${_currentIndex + 1} / ${widget.imageUrls.length}',
                style: const TextStyle(color: Colors.white),
              )
            : null,
      ),
    );
  }

  Widget _buildBottomIndicator() {
    return Positioned(
      bottom: 20,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(widget.imageUrls.length, (index) {
          return Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _currentIndex == index ? Colors.white : Colors.white54,
            ),
          );
        }),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
