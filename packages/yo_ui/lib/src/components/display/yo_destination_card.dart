import 'package:flutter/material.dart';
import 'package:yo_ui/yo_ui.dart';

/// Destination card for travel apps
class YoDestinationCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String location;
  final double? rating;
  final int? reviewCount;
  final double? price;
  final String? priceLabel;
  final String? duration;
  final List<String> tags;
  final bool isFavorite;
  final VoidCallback? onTap;
  final VoidCallback? onFavorite;
  final String currencySymbol;

  const YoDestinationCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.location,
    this.rating,
    this.reviewCount,
    this.price,
    this.priceLabel,
    this.duration,
    this.tags = const [],
    this.isFavorite = false,
    this.onTap,
    this.onFavorite,
    this.currencySymbol = '\$',
  });

  /// Large featured card for hero sections
  factory YoDestinationCard.featured({
    Key? key,
    required String imageUrl,
    required String title,
    required String location,
    double? rating,
    int? reviewCount,
    double? price,
    String? priceLabel,
    String? duration,
    List<String> tags = const [],
    bool isFavorite = false,
    VoidCallback? onTap,
    VoidCallback? onFavorite,
    String currencySymbol = '\$',
  }) {
    return _YoDestinationCardFeatured(
      key: key,
      imageUrl: imageUrl,
      title: title,
      location: location,
      rating: rating,
      reviewCount: reviewCount,
      price: price,
      priceLabel: priceLabel,
      duration: duration,
      tags: tags,
      isFavorite: isFavorite,
      onTap: onTap,
      onFavorite: onFavorite,
      currencySymbol: currencySymbol,
    );
  }

  /// Compact horizontal card for lists
  factory YoDestinationCard.compact({
    Key? key,
    required String imageUrl,
    required String title,
    required String location,
    double? rating,
    double? price,
    String? duration,
    bool isFavorite = false,
    VoidCallback? onTap,
    VoidCallback? onFavorite,
    String currencySymbol = '\$',
  }) {
    return _YoDestinationCardCompact(
      key: key,
      imageUrl: imageUrl,
      title: title,
      location: location,
      rating: rating,
      price: price,
      duration: duration,
      isFavorite: isFavorite,
      onTap: onTap,
      onFavorite: onFavorite,
      currencySymbol: currencySymbol,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image section
            AspectRatio(
              aspectRatio: 16 / 10,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  _buildImage(context),
                  _buildGradientOverlay(),
                  _buildFavoriteButton(context),
                  if (duration != null) _buildDuration(context),
                ],
              ),
            ),

            // Content section
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: context.yoTitleSmall.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  _buildLocation(context),
                  if (tags.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    _buildTags(context),
                  ],
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      if (rating != null)
                        Expanded(child: _buildRating(context)),
                      if (price != null) _buildPrice(context),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(BuildContext context) {
    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Container(
        color: context.gray100,
        child: Icon(Icons.landscape, size: 48, color: context.gray300),
      ),
    );
  }

  Widget _buildGradientOverlay() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.transparent, Colors.black.withAlpha(77)],
        ),
      ),
    );
  }

  Widget _buildFavoriteButton(BuildContext context) {
    return Positioned(
      top: 10,
      right: 10,
      child: Material(
        color: Colors.white.withAlpha(230),
        shape: const CircleBorder(),
        child: InkWell(
          onTap: onFavorite,
          customBorder: const CircleBorder(),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              size: 22,
              color: isFavorite ? context.errorColor : context.gray600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDuration(BuildContext context) {
    return Positioned(
      bottom: 10,
      left: 10,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.black.withAlpha(153),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.schedule, size: 14, color: Colors.white),
            const SizedBox(width: 4),
            Text(
              duration!,
              style: context.yoBodySmall.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocation(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.location_on, size: 14, color: context.gray500),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            location,
            style: context.yoBodySmall.copyWith(color: context.gray500),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildTags(BuildContext context) {
    return Wrap(
      spacing: 6,
      runSpacing: 4,
      children: tags
          .take(3)
          .map(
            (tag) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: context.primaryColor.withAlpha(26),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                tag,
                style: context.yoBodySmall.copyWith(
                  color: context.primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildRating(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.star, size: 16, color: Colors.amber),
        const SizedBox(width: 4),
        Text(
          rating!.toStringAsFixed(1),
          style: context.yoBodyMedium.copyWith(fontWeight: FontWeight.w600),
        ),
        if (reviewCount != null) ...[
          const SizedBox(width: 4),
          Text(
            '($reviewCount reviews)',
            style: context.yoBodySmall.copyWith(color: context.gray500),
          ),
        ],
      ],
    );
  }

  Widget _buildPrice(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          '$currencySymbol${price!.toStringAsFixed(0)}',
          style: context.yoTitleSmall.copyWith(
            fontWeight: FontWeight.bold,
            color: context.primaryColor,
          ),
        ),
        if (priceLabel != null)
          Text(
            priceLabel!,
            style: context.yoBodySmall.copyWith(color: context.gray500),
          ),
      ],
    );
  }
}

/// Featured variant
class _YoDestinationCardFeatured extends YoDestinationCard {
  const _YoDestinationCardFeatured({
    super.key,
    required super.imageUrl,
    required super.title,
    required super.location,
    super.rating,
    super.reviewCount,
    super.price,
    super.priceLabel,
    super.duration,
    super.tags,
    super.isFavorite,
    super.onTap,
    super.onFavorite,
    super.currencySymbol,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        onTap: onTap,
        child: Stack(
          children: [
            // Full image background
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  _buildImage(context),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withAlpha(178),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Content overlay
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (tags.isNotEmpty) ...[
                      Wrap(
                        spacing: 6,
                        children: tags
                            .take(2)
                            .map(
                              (t) => Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withAlpha(51),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  t,
                                  style: context.yoBodySmall.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                      const SizedBox(height: 8),
                    ],
                    Text(
                      title,
                      style: context.yoTitleMedium.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 14,
                          color: Colors.white70,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          location,
                          style: context.yoBodySmall.copyWith(
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        if (rating != null) ...[
                          const Icon(Icons.star, size: 16, color: Colors.amber),
                          const SizedBox(width: 4),
                          Text(
                            rating!.toStringAsFixed(1),
                            style: context.yoBodyMedium.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (reviewCount != null)
                            Text(
                              ' ($reviewCount)',
                              style: context.yoBodySmall.copyWith(
                                color: Colors.white70,
                              ),
                            ),
                        ],
                        const Spacer(),
                        if (price != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: context.primaryColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '$currencySymbol${price!.toStringAsFixed(0)} ${priceLabel ?? ''}',
                              style: context.yoBodyMedium.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Favorite button
            Positioned(
              top: 12,
              right: 12,
              child: Material(
                color: Colors.white.withAlpha(230),
                shape: const CircleBorder(),
                child: InkWell(
                  onTap: onFavorite,
                  customBorder: const CircleBorder(),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      size: 24,
                      color: isFavorite ? context.errorColor : context.gray600,
                    ),
                  ),
                ),
              ),
            ),

            // Duration badge
            if (duration != null)
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withAlpha(153),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.schedule, size: 14, color: Colors.white),
                      const SizedBox(width: 4),
                      Text(
                        duration!,
                        style: context.yoBodySmall.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Compact horizontal variant
class _YoDestinationCardCompact extends YoDestinationCard {
  const _YoDestinationCardCompact({
    super.key,
    required super.imageUrl,
    required super.title,
    required super.location,
    super.rating,
    super.price,
    super.duration,
    super.isFavorite,
    super.onTap,
    super.onFavorite,
    super.currencySymbol,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: 100,
          child: Row(
            children: [
              // Image
              SizedBox(
                width: 100,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    _buildImage(context),
                    if (duration != null)
                      Positioned(
                        bottom: 4,
                        left: 4,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withAlpha(153),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            duration!,
                            style: context.yoBodySmall.copyWith(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: context.yoBodyMedium.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (onFavorite != null)
                            GestureDetector(
                              onTap: onFavorite,
                              child: Icon(
                                isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                size: 18,
                                color: isFavorite
                                    ? context.errorColor
                                    : context.gray400,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 12,
                            color: context.gray500,
                          ),
                          const SizedBox(width: 2),
                          Expanded(
                            child: Text(
                              location,
                              style: context.yoBodySmall.copyWith(
                                color: context.gray500,
                                fontSize: 11,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          if (rating != null) ...[
                            const Icon(
                              Icons.star,
                              size: 14,
                              color: Colors.amber,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              rating!.toStringAsFixed(1),
                              style: context.yoBodySmall.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                          const Spacer(),
                          if (price != null)
                            Text(
                              '$currencySymbol${price!.toStringAsFixed(0)}',
                              style: context.yoBodyMedium.copyWith(
                                fontWeight: FontWeight.bold,
                                color: context.primaryColor,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
