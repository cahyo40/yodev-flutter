import 'package:flutter/material.dart';
import '../../../yo_ui_base.dart';


class YoSimpleImageViewer extends StatelessWidget {
  final String imageUrl;
  final String? heroTag;
  final bool enableClose;

  const YoSimpleImageViewer({
    super.key,
    required this.imageUrl,
    this.heroTag,
    this.enableClose = true,
  });

  static Future<void> show({
    required BuildContext context,
    required String imageUrl,
    String? heroTag,
  }) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => YoSimpleImageViewer(
          imageUrl: imageUrl,
          heroTag: heroTag,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Main image
          Center(
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Hero(
                tag: heroTag ?? imageUrl,
                child: YoImage.network(
                  url: imageUrl,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),

          // Close button
          if (enableClose)
            Positioned(
              top: MediaQuery.of(context).padding.top + 16,
              left: 16,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}