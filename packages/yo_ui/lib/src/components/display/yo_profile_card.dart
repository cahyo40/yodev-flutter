import 'package:flutter/material.dart';
import 'package:yo_ui/yo_ui.dart';

/// Profile/User card for social apps
class YoProfileCard extends StatelessWidget {
  final String? avatarUrl;
  final String name;
  final String? subtitle;
  final String? bio;
  final List<YoProfileStat> stats;
  final bool isVerified;
  final bool isFollowing;
  final VoidCallback? onTap;
  final VoidCallback? onFollow;
  final VoidCallback? onMessage;
  final Widget? trailing;

  const YoProfileCard({
    super.key,
    this.avatarUrl,
    required this.name,
    this.subtitle,
    this.bio,
    this.stats = const [],
    this.isVerified = false,
    this.isFollowing = false,
    this.onTap,
    this.onFollow,
    this.onMessage,
    this.trailing,
  });

  /// Compact horizontal card for lists
  factory YoProfileCard.compact({
    Key? key,
    String? avatarUrl,
    required String name,
    String? subtitle,
    bool isVerified = false,
    bool isFollowing = false,
    VoidCallback? onTap,
    VoidCallback? onFollow,
    Widget? trailing,
  }) {
    return _YoProfileCardCompact(
      key: key,
      avatarUrl: avatarUrl,
      name: name,
      subtitle: subtitle,
      isVerified: isVerified,
      isFollowing: isFollowing,
      onTap: onTap,
      onFollow: onFollow,
      trailing: trailing,
    );
  }

  /// Large card with cover image
  factory YoProfileCard.cover({
    Key? key,
    String? avatarUrl,
    String? coverUrl,
    required String name,
    String? subtitle,
    String? bio,
    List<YoProfileStat> stats = const [],
    bool isVerified = false,
    bool isFollowing = false,
    VoidCallback? onTap,
    VoidCallback? onFollow,
    VoidCallback? onMessage,
  }) {
    return _YoProfileCardCover(
      key: key,
      avatarUrl: avatarUrl,
      coverUrl: coverUrl,
      name: name,
      subtitle: subtitle,
      bio: bio,
      stats: stats,
      isVerified: isVerified,
      isFollowing: isFollowing,
      onTap: onTap,
      onFollow: onFollow,
      onMessage: onMessage,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(context.yoRadiusXl)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(context.yoRadiusXl),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Avatar and info
              Row(
                children: [
                  _buildAvatar(context, size: 60),
                  const YoSpace.width(16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildName(context),
                        if (subtitle != null) ...[
                          const YoSpace.height(2),
                          YoText.bodySmall(
                            subtitle!,
                            color: context.gray500,
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (trailing != null) trailing!,
                ],
              ),

              // Bio
              if (bio != null) ...[
                const YoSpace.height(12),
                YoText.bodyMedium(
                  bio!,
                  color: context.gray600,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],

              // Stats
              if (stats.isNotEmpty) ...[
                const YoSpace.height(16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: stats.map((s) => _buildStat(context, s)).toList(),
                ),
              ],

              // Actions
              if (onFollow != null || onMessage != null) ...[
                const YoSpace.height(16),
                Row(
                  children: [
                    if (onFollow != null)
                      Expanded(
                        child: isFollowing
                            ? YoButton.outline(
                                text: 'Following',
                                onPressed: onFollow,
                              )
                            : YoButton.primary(
                                text: 'Follow',
                                onPressed: onFollow,
                              ),
                      ),
                    if (onFollow != null && onMessage != null)
                      const YoSpace.width(12),
                    if (onMessage != null)
                      Expanded(
                        child: YoButton.outline(
                          text: 'Message',
                          onPressed: onMessage,
                        ),
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(BuildContext context, {double size = 48}) {
    if (avatarUrl != null) {
      return YoAvatar.image(
        imageUrl: avatarUrl!,
        size: size == 60 ? YoAvatarSize.lg : YoAvatarSize.md,
      );
    }
    return YoAvatar.text(
      text: name,
      size: size == 60 ? YoAvatarSize.lg : YoAvatarSize.md,
    );
  }

  Widget _buildName(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: YoText.titleSmall(
            name,
            fontWeight: FontWeight.bold,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (isVerified) ...[
          const YoSpace.width(4),
          Icon(Icons.verified, size: 16, color: context.primaryColor),
        ],
      ],
    );
  }

  Widget _buildStat(BuildContext context, YoProfileStat stat) {
    return Column(
      children: [
        YoText.titleSmall(
          stat.value,
          fontWeight: FontWeight.bold,
        ),
        const YoSpace.height(2),
        YoText.bodySmall(
          stat.label,
          color: context.gray500,
        ),
      ],
    );
  }
}

/// Profile stat model
class YoProfileStat {
  final String value;
  final String label;

  const YoProfileStat({required this.value, required this.label});
}

/// Compact variant
class _YoProfileCardCompact extends YoProfileCard {
  const _YoProfileCardCompact({
    super.key,
    super.avatarUrl,
    required super.name,
    super.subtitle,
    super.isVerified,
    super.isFollowing,
    super.onTap,
    super.onFollow,
    super.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(context.yoRadiusLg)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(context.yoRadiusLg),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              _buildAvatar(context),
              const YoSpace.width(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildName(context),
                    if (subtitle != null)
                      YoText.bodySmall(
                        subtitle!,
                        color: context.gray500,
                      ),
                  ],
                ),
              ),
              if (trailing != null)
                trailing!
              else if (onFollow != null)
                isFollowing
                    ? YoButton.outline(
                        text: 'Following',
                        onPressed: onFollow,
                        size: YoButtonSize.small,
                      )
                    : YoButton.primary(
                        text: 'Follow',
                        onPressed: onFollow,
                        size: YoButtonSize.small,
                      ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Cover variant with header image
class _YoProfileCardCover extends YoProfileCard {
  final String? coverUrl;

  const _YoProfileCardCover({
    super.key,
    super.avatarUrl,
    this.coverUrl,
    required super.name,
    super.subtitle,
    super.bio,
    super.stats,
    super.isVerified,
    super.isFollowing,
    super.onTap,
    super.onFollow,
    super.onMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(context.yoRadiusXl)),
      child: InkWell(
        onTap: onTap,
        child: Column(
          children: [
            // Cover image
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 100,
                  width: double.infinity,
                  color: context.primaryColor.withAlpha(77),
                  child: coverUrl != null
                      ? Image.network(
                          coverUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const YoBox(),
                        )
                      : null,
                ),
                // Avatar positioned at bottom center
                Positioned(
                  bottom: -40,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: context.backgroundColor,
                        shape: BoxShape.circle,
                      ),
                      child: YoAvatar.image(
                        imageUrl: avatarUrl ?? '',
                        size: YoAvatarSize.xl,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Content
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
              child: Column(
                children: [
                  _buildName(context),
                  if (subtitle != null) ...[
                    const YoSpace.height(2),
                    YoText.bodySmall(
                      subtitle!,
                      color: context.gray500,
                    ),
                  ],
                  if (bio != null) ...[
                    const YoSpace.height(8),
                    YoText.bodyMedium(
                      bio!,
                      color: context.gray600,
                      align: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  if (stats.isNotEmpty) ...[
                    const YoSpace.height(16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children:
                          stats.map((s) => _buildStat(context, s)).toList(),
                    ),
                  ],
                  if (onFollow != null || onMessage != null) ...[
                    const YoSpace.height(16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (onFollow != null)
                          isFollowing
                              ? YoButton.outline(
                                  text: 'Following',
                                  onPressed: onFollow,
                                )
                              : YoButton.primary(
                                  text: 'Follow',
                                  onPressed: onFollow,
                                ),
                        if (onFollow != null && onMessage != null)
                          const YoSpace.width(12),
                        if (onMessage != null)
                          YoButton.outline(
                            text: 'Message',
                            onPressed: onMessage,
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
    );
  }

  @override
  Widget _buildName(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        YoText.titleMedium(
          name,
          fontWeight: FontWeight.bold,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        if (isVerified) ...[
          const YoSpace.width(4),
          Icon(Icons.verified, size: 18, color: context.primaryColor),
        ],
      ],
    );
  }
}
