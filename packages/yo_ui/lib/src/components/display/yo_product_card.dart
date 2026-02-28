import 'package:flutter/material.dart';
import 'package:yo_ui/yo_ui.dart';

/// Product card for e-commerce and POS apps
class YoProductCard extends StatelessWidget {
  final String? imageUrl;
  final String title;
  final String? subtitle;
  final double price;
  final double? originalPrice;
  final double? rating;
  final int? reviewCount;
  final int? stock;
  final String? badge;
  final Color? badgeColor;
  final bool isFavorite;
  final VoidCallback? onTap;
  final VoidCallback? onFavorite;
  final VoidCallback? onAddToCart;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final String currencySymbol;
  final bool showStock;

  const YoProductCard({
    super.key,
    this.imageUrl,
    required this.title,
    required this.price,
    this.subtitle,
    this.originalPrice,
    this.rating,
    this.reviewCount,
    this.stock,
    this.badge,
    this.badgeColor,
    this.isFavorite = false,
    this.onTap,
    this.onFavorite,
    this.onAddToCart,
    this.onEdit,
    this.onDelete,
    this.currencySymbol = '\$',
    this.showStock = false,
  });

  /// Grid variant - vertical card for GridView
  const YoProductCard.grid({
    super.key,
    this.imageUrl,
    required this.title,
    required this.price,
    this.subtitle,
    this.originalPrice,
    this.rating,
    this.reviewCount,
    this.stock,
    this.badge,
    this.badgeColor,
    this.isFavorite = false,
    this.onTap,
    this.onFavorite,
    this.onAddToCart,
    this.onEdit,
    this.onDelete,
    this.currencySymbol = '\$',
    this.showStock = false,
  });

  /// List variant - horizontal card for ListView
  factory YoProductCard.list({
    Key? key,
    String? imageUrl,
    required String title,
    required double price,
    String? subtitle,
    double? originalPrice,
    double? rating,
    int? reviewCount,
    int? stock,
    String? badge,
    Color? badgeColor,
    bool isFavorite = false,
    VoidCallback? onTap,
    VoidCallback? onFavorite,
    VoidCallback? onAddToCart,
    VoidCallback? onEdit,
    VoidCallback? onDelete,
    String currencySymbol = '\$',
    bool showStock = false,
  }) {
    return _YoProductCardList(
      key: key,
      imageUrl: imageUrl,
      title: title,
      price: price,
      subtitle: subtitle,
      originalPrice: originalPrice,
      rating: rating,
      reviewCount: reviewCount,
      stock: stock,
      badge: badge,
      badgeColor: badgeColor,
      isFavorite: isFavorite,
      onTap: onTap,
      onFavorite: onFavorite,
      onAddToCart: onAddToCart,
      onEdit: onEdit,
      onDelete: onDelete,
      currencySymbol: currencySymbol,
      showStock: showStock,
    );
  }

  /// POS variant - compact card optimized for point of sale
  factory YoProductCard.pos({
    Key? key,
    String? imageUrl,
    required String title,
    required double price,
    int? stock,
    VoidCallback? onTap,
    VoidCallback? onEdit,
    VoidCallback? onDelete,
    String currencySymbol = '\$',
  }) {
    return _YoProductCardPOS(
      key: key,
      imageUrl: imageUrl,
      title: title,
      price: price,
      stock: stock,
      onTap: onTap,
      onEdit: onEdit,
      onDelete: onDelete,
      currencySymbol: currencySymbol,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(context.yoRadiusLg)),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image section
            AspectRatio(
              aspectRatio: 1,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  _buildImage(context),
                  if (badge != null) _buildBadge(context),
                  if (onFavorite != null) _buildFavoriteButton(context),
                  if (onEdit != null || onDelete != null)
                    _buildMenuButton(context),
                  if (stock != null && stock! <= 0) _buildOutOfStock(context),
                ],
              ),
            ),

            // Content section
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  YoText.bodyMedium(
                    title,
                    fontWeight: FontWeight.w600,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (subtitle != null) ...[
                    const YoSpace.height(2),
                    YoText.bodySmall(
                      subtitle!,
                      color: context.gray500,
                    ),
                  ],
                  const YoSpace.height(8),
                  _buildPriceRow(context),
                  if (rating != null) ...[
                    const YoSpace.height(6),
                    _buildRating(context),
                  ],
                  if (showStock && stock != null) ...[
                    const YoSpace.height(6),
                    _buildStockIndicator(context),
                  ],
                  if (onAddToCart != null) ...[
                    const YoSpace.height(8),
                    YoBox.expandWidth(
                      child: YoButton.primary(
                        text: stock != null && stock! <= 0
                            ? 'Out of Stock'
                            : 'Add to Cart',
                        onPressed:
                            stock != null && stock! <= 0 ? null : onAddToCart,
                        size: YoButtonSize.small,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(BuildContext context) {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return Container(
        color: context.gray100,
        child: Icon(
          Icons.inventory_2_outlined,
          size: 48,
          color: context.gray300,
        ),
      );
    }
    return Image.network(
      imageUrl!,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Container(
        color: context.gray100,
        child: Icon(Icons.broken_image, size: 48, color: context.gray300),
      ),
    );
  }

  Widget _buildBadge(BuildContext context) {
    return Positioned(
      top: 8,
      left: 8,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: badgeColor ?? context.errorColor,
          borderRadius: BorderRadius.circular(context.yoRadiusSm),
        ),
        child: YoText.bodySmall(
          badge!,
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildFavoriteButton(BuildContext context) {
    return Positioned(
      top: 8,
      right: 8,
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
              size: 20,
              color: isFavorite ? context.errorColor : context.gray500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context) {
    return Positioned(
      top: 8,
      right: onFavorite != null ? 48 : 8,
      child: Material(
        color: Colors.white.withAlpha(230),
        shape: const CircleBorder(),
        child: PopupMenuButton<String>(
          icon: Icon(Icons.more_vert, size: 20, color: context.gray600),
          padding: EdgeInsets.zero,
          iconSize: 20,
          onSelected: (value) {
            if (value == 'edit') onEdit?.call();
            if (value == 'delete') onDelete?.call();
          },
          itemBuilder: (_) => [
            if (onEdit != null)
              PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit, size: 18, color: context.gray600),
                    const YoSpace.width(8),
                    YoText.bodyMedium('Edit'),
                  ],
                ),
              ),
            if (onDelete != null)
              PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, size: 18, color: context.errorColor),
                    const YoSpace.width(8),
                    YoText.bodyMedium('Delete', color: context.errorColor),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildOutOfStock(BuildContext context) {
    return Positioned.fill(
      child: Container(
        color: Colors.black.withAlpha(128),
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: context.errorColor,
              borderRadius: BorderRadius.circular(context.yoRadiusSm),
            ),
            child: YoText.bodySmall(
              'OUT OF STOCK',
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPriceRow(BuildContext context) {
    final hasDiscount = originalPrice != null && originalPrice! > price;
    final discountPercent = hasDiscount
        ? ((originalPrice! - price) / originalPrice! * 100).round()
        : 0;

    return Row(
      children: [
        YoText.bodyLarge(
          '$currencySymbol${price.toStringAsFixed(2)}',
          fontWeight: FontWeight.bold,
          color: context.primaryColor,
        ),
        if (hasDiscount) ...[
          const YoSpace.width(6),
          YoText(
            '$currencySymbol${originalPrice!.toStringAsFixed(2)}',
            style: context.yoBodySmall.copyWith(
              color: context.gray400,
              decoration: TextDecoration.lineThrough,
            ),
          ),
          const YoSpace.width(4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            decoration: BoxDecoration(
              color: context.errorColor.withAlpha(26),
              borderRadius: BorderRadius.circular(context.yoRadiusSm),
            ),
            child: YoText.bodySmall(
              '-$discountPercent%',
              color: context.errorColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildRating(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.star, size: 14, color: Colors.amber),
        const YoSpace.width(4),
        YoText.bodySmall(
          rating!.toStringAsFixed(1),
          fontWeight: FontWeight.w600,
        ),
        if (reviewCount != null) ...[
          const YoSpace.width(4),
          YoText.bodySmall(
            '($reviewCount)',
            color: context.gray500,
          ),
        ],
      ],
    );
  }

  Widget _buildStockIndicator(BuildContext context) {
    final stockColor = stock! <= 0
        ? context.errorColor
        : stock! <= 10
            ? context.warningColor
            : context.successColor;

    final stockText = stock! <= 0 ? 'Out of stock' : '$stock in stock';

    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: stockColor, shape: BoxShape.circle),
        ),
        const YoSpace.width(6),
        YoText.bodySmall(
          stockText,
          color: stockColor,
          fontWeight: FontWeight.w500,
        ),
      ],
    );
  }
}

/// List variant implementation
class _YoProductCardList extends YoProductCard {
  const _YoProductCardList({
    super.key,
    super.imageUrl,
    required super.title,
    required super.price,
    super.subtitle,
    super.originalPrice,
    super.rating,
    super.reviewCount,
    super.stock,
    super.badge,
    super.badgeColor,
    super.isFavorite,
    super.onTap,
    super.onFavorite,
    super.onAddToCart,
    super.onEdit,
    super.onDelete,
    super.currencySymbol,
    super.showStock,
  });

  @override
  Widget build(BuildContext context) {
    final isOutOfStock = stock != null && stock! <= 0;

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(context.yoRadiusLg)),
      child: InkWell(
        onTap: onTap,
        child: YoBox(
          height: 140,
          child: Row(
            children: [
              // Image section
              YoBox(
                width: 140,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    _buildImage(context),
                    if (badge != null) _buildBadge(context),
                    if (isOutOfStock) _buildOutOfStock(context),
                  ],
                ),
              ),

              // Content section
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            YoText.bodyMedium(
                              title,
                              fontWeight: FontWeight.w600,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (subtitle != null) ...[
                              const YoSpace.height(2),
                              YoText.bodySmall(
                                subtitle!,
                                color: context.gray500,
                              ),
                            ],
                            const YoSpace.height(4),
                            if (rating != null) _buildRating(context),
                            if (showStock && stock != null) ...[
                              const YoSpace.height(4),
                              _buildStockIndicator(context),
                            ],
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(child: _buildPriceRow(context)),
                          if (onEdit != null)
                            IconButton(
                              onPressed: onEdit,
                              icon: Icon(Icons.edit, color: context.gray500),
                              iconSize: 20,
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(
                                minWidth: 32,
                                minHeight: 32,
                              ),
                            ),
                          if (onDelete != null)
                            IconButton(
                              onPressed: onDelete,
                              icon: Icon(
                                Icons.delete,
                                color: context.errorColor,
                              ),
                              iconSize: 20,
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(
                                minWidth: 32,
                                minHeight: 32,
                              ),
                            ),
                          if (onFavorite != null)
                            IconButton(
                              onPressed: onFavorite,
                              icon: Icon(
                                isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: isFavorite
                                    ? context.errorColor
                                    : context.gray400,
                              ),
                              iconSize: 20,
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(
                                minWidth: 32,
                                minHeight: 32,
                              ),
                            ),
                          if (onAddToCart != null)
                            IconButton(
                              onPressed: isOutOfStock ? null : onAddToCart,
                              icon: Icon(
                                Icons.add_shopping_cart,
                                color: isOutOfStock
                                    ? context.gray300
                                    : context.primaryColor,
                              ),
                              iconSize: 20,
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(
                                minWidth: 32,
                                minHeight: 32,
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

/// POS variant - optimized for point of sale systems
class _YoProductCardPOS extends YoProductCard {
  const _YoProductCardPOS({
    super.key,
    super.imageUrl,
    required super.title,
    required super.price,
    super.stock,
    super.onTap,
    super.onEdit,
    super.onDelete,
    super.currencySymbol,
  });

  @override
  Widget build(BuildContext context) {
    final isOutOfStock = stock != null && stock! <= 0;
    final isLowStock = stock != null && stock! > 0 && stock! <= 10;

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(context.yoRadiusMd),
        side: BorderSide(
          color: isOutOfStock
              ? context.errorColor.withAlpha(128)
              : isLowStock
                  ? context.warningColor.withAlpha(128)
                  : context.gray200,
        ),
      ),
      child: InkWell(
        onTap: isOutOfStock ? null : onTap,
        child: Opacity(
          opacity: isOutOfStock ? 0.6 : 1.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image section (smaller for POS)
              AspectRatio(
                aspectRatio: 1.2,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    _buildImage(context),
                    if (onEdit != null || onDelete != null)
                      Positioned(
                        top: 4,
                        right: 4,
                        child: Material(
                          color: Colors.white.withAlpha(204),
                          borderRadius: BorderRadius.circular(context.yoRadiusSm),
                          child: PopupMenuButton<String>(
                            icon: Icon(
                              Icons.more_horiz,
                              size: 16,
                              color: context.gray600,
                            ),
                            padding: EdgeInsets.zero,
                            iconSize: 16,
                            onSelected: (value) {
                              if (value == 'edit') onEdit?.call();
                              if (value == 'delete') onDelete?.call();
                            },
                            itemBuilder: (_) => [
                              if (onEdit != null)
                                PopupMenuItem(
                                  value: 'edit',
                                  height: 36,
                                  child: YoText.bodyMedium(
                                    'Edit',
                                    fontSize: 13,
                                  ),
                                ),
                              if (onDelete != null)
                                PopupMenuItem(
                                  value: 'delete',
                                  height: 36,
                                  child: YoText.bodyMedium(
                                    'Delete',
                                    fontSize: 13,
                                    color: context.errorColor,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // Content section (compact)
              Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    YoText.bodySmall(
                      title,
                      fontWeight: FontWeight.w600,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const YoSpace.height(4),
                    YoText.bodyMedium(
                      '$currencySymbol${price.toStringAsFixed(2)}',
                      fontWeight: FontWeight.bold,
                      color: context.primaryColor,
                    ),
                    if (stock != null) ...[
                      const YoSpace.height(4),
                      Row(
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: isOutOfStock
                                  ? context.errorColor
                                  : isLowStock
                                      ? context.warningColor
                                      : context.successColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const YoSpace.width(4),
                          Expanded(
                            child: YoText.bodySmall(
                              isOutOfStock ? 'Out' : '$stock pcs',
                              color: isOutOfStock
                                  ? context.errorColor
                                  : isLowStock
                                      ? context.warningColor
                                      : context.gray500,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
