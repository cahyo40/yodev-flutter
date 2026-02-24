import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../yo_ui_base.dart';

class YoImage extends StatelessWidget {
  final String? url;
  final String? assetPath;
  final Widget? placeholder;
  final Widget? errorWidget;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final Alignment alignment;
  final Color? color;
  final BlendMode? colorBlendMode;
  final BorderRadiusGeometry? borderRadius;
  final BoxShape shape;
  final List<BoxShadow>? shadow;
  final VoidCallback? onTap;

  const YoImage.network({
    super.key,
    required this.url,
    this.placeholder,
    this.errorWidget,
    this.width,
    this.height,
    this.fit,
    this.alignment = Alignment.center,
    this.color,
    this.colorBlendMode,
    this.borderRadius,
    this.shape = BoxShape.rectangle,
    this.shadow,
    this.onTap,
  }) : assetPath = null;

  const YoImage.asset({
    super.key,
    required this.assetPath,
    this.placeholder,
    this.errorWidget,
    this.width,
    this.height,
    this.fit,
    this.alignment = Alignment.center,
    this.color,
    this.colorBlendMode,
    this.borderRadius,
    this.shape = BoxShape.rectangle,
    this.shadow,
    this.onTap,
  }) : url = null;

  @override
  Widget build(BuildContext context) {
    final imageWidget = _buildImageWidget(context);
    final container = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: shape == BoxShape.rectangle ? borderRadius : null,
        shape: shape,
        boxShadow: shadow,
      ),
      child: shape == BoxShape.rectangle
          ? ClipRRect(
              borderRadius: borderRadius ?? BorderRadius.zero,
              child: imageWidget,
            )
          : ClipOval(child: imageWidget),
    );

    return onTap != null
        ? GestureDetector(onTap: onTap, child: container)
        : container;
  }

  Widget _buildImageWidget(BuildContext context) {
    if (url != null) {
      return CachedNetworkImage(
        imageUrl: url!,
        width: width,
        height: height,
        fit: fit,
        alignment: alignment,
        color: color,
        colorBlendMode: colorBlendMode,
        placeholder: (context, url) =>
            placeholder ?? _defaultPlaceholder(context),
        errorWidget: (context, url, error) =>
            errorWidget ?? _defaultErrorWidget(context),
      );
    } else if (assetPath != null) {
      return Image.asset(
        assetPath!,
        width: width,
        height: height,
        fit: fit,
        alignment: alignment,
        color: color,
        colorBlendMode: colorBlendMode,

        errorBuilder: (context, error, stackTrace) =>
            errorWidget ?? _defaultErrorWidget(context),
      );
    } else {
      return errorWidget ?? _defaultErrorWidget(context);
    }
  }

  Widget _defaultPlaceholder(BuildContext context) {
    return Container(
      color: YoColors.gray200(context),
      child: const Center(child: YoLoading.spinner(size: 20)),
    );
  }

  Widget _defaultErrorWidget(BuildContext context) {
    return Container(
      color: YoColors.gray200(context),
      child: const Icon(Icons.error_outline, color: Colors.grey),
    );
  }

  // Preload image untuk caching
  static Future<void> preloadNetworkImage(String url, BuildContext context) {
    return precacheImage(CachedNetworkImageProvider(url), context);
  }

  // Preload multiple images
  static Future<void> preloadNetworkImages(
    List<String> urls,
    BuildContext context,
  ) {
    final futures = urls.map((url) => preloadNetworkImage(url, context));
    return Future.wait(futures);
  }
}
