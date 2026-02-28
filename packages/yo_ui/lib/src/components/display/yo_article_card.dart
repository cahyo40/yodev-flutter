import 'package:flutter/material.dart';
import 'package:yo_ui/yo_ui.dart';

/// Article/Blog/News card
class YoArticleCard extends StatelessWidget {
  final String? imageUrl;
  final String title;
  final String? excerpt;
  final String? category;
  final String? authorName;
  final String? authorAvatar;
  final DateTime? publishedAt;
  final int? readTime;
  final bool isBookmarked;
  final VoidCallback? onTap;
  final VoidCallback? onBookmark;
  final VoidCallback? onShare;

  const YoArticleCard({
    super.key,
    this.imageUrl,
    required this.title,
    this.excerpt,
    this.category,
    this.authorName,
    this.authorAvatar,
    this.publishedAt,
    this.readTime,
    this.isBookmarked = false,
    this.onTap,
    this.onBookmark,
    this.onShare,
  });

  /// Horizontal list variant
  factory YoArticleCard.horizontal({
    Key? key,
    String? imageUrl,
    required String title,
    String? excerpt,
    String? category,
    String? authorName,
    DateTime? publishedAt,
    int? readTime,
    bool isBookmarked = false,
    VoidCallback? onTap,
    VoidCallback? onBookmark,
  }) {
    return _YoArticleCardHorizontal(
      key: key,
      imageUrl: imageUrl,
      title: title,
      excerpt: excerpt,
      category: category,
      authorName: authorName,
      publishedAt: publishedAt,
      readTime: readTime,
      isBookmarked: isBookmarked,
      onTap: onTap,
      onBookmark: onBookmark,
    );
  }

  /// Featured large card
  factory YoArticleCard.featured({
    Key? key,
    String? imageUrl,
    required String title,
    String? excerpt,
    String? category,
    String? authorName,
    String? authorAvatar,
    DateTime? publishedAt,
    int? readTime,
    bool isBookmarked = false,
    VoidCallback? onTap,
    VoidCallback? onBookmark,
    VoidCallback? onShare,
  }) {
    return _YoArticleCardFeatured(
      key: key,
      imageUrl: imageUrl,
      title: title,
      excerpt: excerpt,
      category: category,
      authorName: authorName,
      authorAvatar: authorAvatar,
      publishedAt: publishedAt,
      readTime: readTime,
      isBookmarked: isBookmarked,
      onTap: onTap,
      onBookmark: onBookmark,
      onShare: onShare,
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
            // Image
            if (imageUrl != null)
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    _buildImage(context),
                    if (category != null) _buildCategory(context),
                  ],
                ),
              ),

            // Content
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (imageUrl == null && category != null) ...[
                    _buildCategoryChip(context),
                    const YoSpace.height(8),
                  ],
                  YoText.titleSmall(
                    title,
                    fontWeight: FontWeight.bold,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (excerpt != null) ...[
                    const YoSpace.height(6),
                    YoText.bodySmall(
                      excerpt!,
                      color: context.gray600,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const YoSpace.height(12),
                  _buildFooter(context),
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
      imageUrl!,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Container(
        color: context.gray100,
        child: Icon(Icons.article, size: 48, color: context.gray300),
      ),
    );
  }

  Widget _buildCategory(BuildContext context) {
    return Positioned(top: 10, left: 10, child: _buildCategoryChip(context));
  }

  Widget _buildCategoryChip(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: context.primaryColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: YoText.bodySmall(
        category!,
        color: Colors.white,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Row(
      children: [
        // Author
        if (authorName != null) ...[
          if (authorAvatar != null) ...[
            YoAvatar.image(imageUrl: authorAvatar!, size: YoAvatarSize.xs),
            const YoSpace.width(6),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                YoText.bodySmall(
                  authorName!,
                  fontWeight: FontWeight.w500,
                ),
                Row(
                  children: [
                    if (publishedAt != null)
                      YoText.bodySmall(
                        _formatDate(publishedAt!),
                        color: context.gray500,
                        fontSize: 11,
                      ),
                    if (readTime != null) ...[
                      YoText.bodySmall(
                        ' • ',
                        color: context.gray400,
                      ),
                      YoText.bodySmall(
                        '$readTime min read',
                        color: context.gray500,
                        fontSize: 11,
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ] else ...[
          if (publishedAt != null)
            YoText.bodySmall(
              _formatDate(publishedAt!),
              color: context.gray500,
            ),
          if (readTime != null) ...[
            const YoSpace.width(8),
            Icon(Icons.access_time, size: 12, color: context.gray500),
            const YoSpace.width(2),
            YoText.bodySmall(
              '$readTime min',
              color: context.gray500,
            ),
          ],
          const Spacer(),
        ],

        // Actions
        if (onBookmark != null)
          IconButton(
            onPressed: onBookmark,
            icon: Icon(
              isBookmarked ? Icons.bookmark : Icons.bookmark_border,
              color: isBookmarked ? context.primaryColor : context.gray500,
            ),
            iconSize: 20,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          ),
        if (onShare != null)
          IconButton(
            onPressed: onShare,
            icon: Icon(Icons.share, color: context.gray500),
            iconSize: 20,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${date.day}/${date.month}/${date.year}';
  }
}

/// Horizontal variant
class _YoArticleCardHorizontal extends YoArticleCard {
  const _YoArticleCardHorizontal({
    super.key,
    super.imageUrl,
    required super.title,
    super.excerpt,
    super.category,
    super.authorName,
    super.publishedAt,
    super.readTime,
    super.isBookmarked,
    super.onTap,
    super.onBookmark,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(context.yoRadiusLg)),
      child: InkWell(
        onTap: onTap,
        child: YoBox(
          height: 120,
          child: Row(
            children: [
              // Image
              if (imageUrl != null)
                YoBox(width: 120, child: _buildImage(context)),

              // Content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (category != null)
                        YoText.bodySmall(
                          category!,
                          color: context.primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      const YoSpace.height(2),
                      Expanded(
                        child: YoText.bodyMedium(
                          title,
                          fontWeight: FontWeight.w600,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Row(
                        children: [
                          if (publishedAt != null)
                            YoText.bodySmall(
                              _formatDate(publishedAt!),
                              color: context.gray500,
                              fontSize: 11,
                            ),
                          if (readTime != null) ...[
                            YoText.bodySmall(
                              ' • ',
                              color: context.gray400,
                            ),
                            YoText.bodySmall(
                              '$readTime min',
                              color: context.gray500,
                              fontSize: 11,
                            ),
                          ],
                          const Spacer(),
                          if (onBookmark != null)
                            GestureDetector(
                              onTap: onBookmark,
                              child: Icon(
                                isBookmarked
                                    ? Icons.bookmark
                                    : Icons.bookmark_border,
                                size: 18,
                                color: isBookmarked
                                    ? context.primaryColor
                                    : context.gray400,
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

/// Featured variant
class _YoArticleCardFeatured extends YoArticleCard {
  const _YoArticleCardFeatured({
    super.key,
    super.imageUrl,
    required super.title,
    super.excerpt,
    super.category,
    super.authorName,
    super.authorAvatar,
    super.publishedAt,
    super.readTime,
    super.isBookmarked,
    super.onTap,
    super.onBookmark,
    super.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(context.yoRadiusXl)),
      child: InkWell(
        onTap: onTap,
        child: Stack(
          children: [
            // Full image
            if (imageUrl != null)
              AspectRatio(
                aspectRatio: 4 / 3,
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
                            Colors.black.withAlpha(204),
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
                    if (category != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: context.primaryColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: YoText.bodySmall(
                          category!,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    YoText.titleMedium(
                      title,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (excerpt != null) ...[
                      const YoSpace.height(6),
                      YoText.bodySmall(
                        excerpt!,
                        color: Colors.white70,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    const YoSpace.height(12),
                    Row(
                      children: [
                        if (authorAvatar != null) ...[
                          YoAvatar.image(
                            imageUrl: authorAvatar!,
                            size: YoAvatarSize.xs,
                          ),
                          const YoSpace.width(8),
                        ],
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (authorName != null)
                                YoText.bodySmall(
                                  authorName!,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              Row(
                                children: [
                                  if (publishedAt != null)
                                    YoText.bodySmall(
                                      _formatDate(publishedAt!),
                                      color: Colors.white70,
                                      fontSize: 11,
                                    ),
                                  if (readTime != null)
                                    YoText.bodySmall(
                                      ' • $readTime min read',
                                      color: Colors.white70,
                                      fontSize: 11,
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        if (onBookmark != null)
                          IconButton(
                            onPressed: onBookmark,
                            icon: Icon(
                              isBookmarked
                                  ? Icons.bookmark
                                  : Icons.bookmark_border,
                              color: Colors.white,
                            ),
                            iconSize: 22,
                          ),
                        if (onShare != null)
                          IconButton(
                            onPressed: onShare,
                            icon: const Icon(Icons.share, color: Colors.white),
                            iconSize: 22,
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
    );
  }
}
