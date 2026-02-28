import 'package:flutter/material.dart';
import 'package:yo_ui/yo_ui.dart';

/// Data model untuk comment
class YoComment {
  final String id;
  final String userAvatar;
  final String userName;
  final String text;
  final DateTime timestamp;
  final int likes;
  final bool isLiked;
  final List<YoComment> replies;
  final bool isEdited;
  final String? userRole;

  const YoComment({
    required this.id,
    required this.userAvatar,
    required this.userName,
    required this.text,
    required this.timestamp,
    this.likes = 0,
    this.isLiked = false,
    this.replies = const [],
    this.isEdited = false,
    this.userRole,
  });
}

/// Widget untuk menampilkan komentar
class YoCommentWidget extends StatelessWidget {
  final YoComment comment;
  final bool compact;
  final Function(YoComment)? onLike;
  final Function(YoComment)? onReply;
  final Function(YoComment)? onEdit;
  final Function(YoComment)? onDelete;
  final bool showReplies;
  final int maxReplyDepth;
  final int _currentDepth;

  const YoCommentWidget({
    super.key,
    required this.comment,
    this.compact = false,
    this.onLike,
    this.onReply,
    this.onEdit,
    this.onDelete,
    this.showReplies = true,
    this.maxReplyDepth = 3,
  }) : _currentDepth = 0;

  const YoCommentWidget._reply({
    required this.comment,
    required this.compact,
    required this.onLike,
    required this.onReply,
    required this.onEdit,
    required this.onDelete,
    required this.showReplies,
    required this.maxReplyDepth,
    required int currentDepth,
  }) : _currentDepth = currentDepth;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildComment(context),
        if (showReplies &&
            comment.replies.isNotEmpty &&
            _currentDepth < maxReplyDepth)
          Padding(
            padding: EdgeInsets.only(left: compact ? 24 : 32, top: 8),
            child: Column(
              children: comment.replies
                  .map(
                    (reply) => YoCommentWidget._reply(
                      comment: reply,
                      compact: compact,
                      onLike: onLike,
                      onReply: onReply,
                      onEdit: onEdit,
                      onDelete: onDelete,
                      showReplies: showReplies,
                      maxReplyDepth: maxReplyDepth,
                      currentDepth: _currentDepth + 1,
                    ),
                  )
                  .toList(),
            ),
          ),
      ],
    );
  }

  Widget _buildComment(BuildContext context) {
    if (compact) return _buildCompact(context);
    return _buildNormal(context);
  }

  Widget _buildNormal(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.gray50,
        borderRadius: BorderRadius.circular(context.yoRadiusLg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              YoAvatar.image(
                imageUrl: comment.userAvatar,
                size: YoAvatarSize.sm,
              ),
              const YoSpace.width(8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        YoText.bodyMedium(
                          comment.userName,
                          fontWeight: FontWeight.w600,
                        ),
                        if (comment.userRole != null) ...[
                          const YoSpace.width(4),
                          _buildRoleBadge(context),
                        ],
                      ],
                    ),
                    YoText.bodySmall(
                      _formatTime(comment.timestamp),
                      color: context.gray500,
                    ),
                  ],
                ),
              ),
              if (onEdit != null || onDelete != null) _buildMenu(context),
            ],
          ),

          const YoSpace.height(8),
          YoText.bodyMedium(comment.text),
          const YoSpace.height(8),

          // Actions
          Row(
            children: [
              _buildAction(
                context,
                icon: comment.isLiked ? Icons.favorite : Icons.favorite_border,
                label: comment.likes.toString(),
                color: comment.isLiked ? context.errorColor : context.gray500,
                onTap: () => onLike?.call(comment),
              ),
              const YoSpace.width(16),
              _buildAction(
                context,
                icon: Icons.reply,
                label: 'Reply',
                onTap: () => onReply?.call(comment),
              ),
              const Spacer(),
              if (comment.isEdited)
                YoText.bodySmall(
                  'edited',
                  color: context.gray400,
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCompact(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          YoAvatar.image(imageUrl: comment.userAvatar, size: YoAvatarSize.xs),
          const YoSpace.width(8),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: context.gray100,
                borderRadius: BorderRadius.circular(context.yoRadiusLg),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      YoText.bodySmall(
                        comment.userName,
                        fontWeight: FontWeight.w600,
                      ),
                      const YoSpace.width(4),
                      YoText.bodySmall(
                        _formatTime(comment.timestamp),
                        color: context.gray500,
                      ),
                    ],
                  ),
                  const YoSpace.height(4),
                  YoText.bodySmall(comment.text),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleBadge(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: context.primaryColor.withAlpha(26),
        borderRadius: BorderRadius.circular(context.yoRadiusSm),
      ),
      child: YoText.bodySmall(
        comment.userRole!,
        color: context.primaryColor,
      ),
    );
  }

  Widget _buildAction(
    BuildContext context, {
    required IconData icon,
    required String label,
    Color? color,
    VoidCallback? onTap,
  }) {
    final effectiveColor = color ?? context.gray500;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          children: [
            Icon(icon, size: 16, color: effectiveColor),
            const YoSpace.width(4),
            YoText.bodySmall(
              label,
              color: effectiveColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenu(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(Icons.more_horiz, size: 16, color: context.gray500),
      onSelected: (value) {
        if (value == 'edit') onEdit?.call(comment);
        if (value == 'delete') onDelete?.call(comment);
      },
      itemBuilder: (context) => [
        if (onEdit != null)
          PopupMenuItem(
            value: 'edit',
            child: Row(
              children: [
                Icon(Icons.edit, size: 16, color: context.gray600),
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
                Icon(Icons.delete, size: 16, color: context.errorColor),
                const YoSpace.width(8),
                YoText.bodyMedium('Delete', color: context.errorColor),
              ],
            ),
          ),
      ],
    );
  }

  String _formatTime(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inHours < 1) return '${diff.inMinutes}m';
    if (diff.inDays < 1) return '${diff.inHours}h';
    if (diff.inDays < 7) return '${diff.inDays}d';
    return '${time.day}/${time.month}/${time.year}';
  }
}

/// List of comments dengan empty state
class YoCommentList extends StatelessWidget {
  final List<YoComment> comments;
  final bool compact;
  final Function(YoComment)? onLike;
  final Function(YoComment)? onReply;
  final Function(YoComment)? onEdit;
  final Function(YoComment)? onDelete;
  final Widget? emptyState;
  final ScrollPhysics? physics;
  final bool shrinkWrap;

  const YoCommentList({
    super.key,
    required this.comments,
    this.compact = false,
    this.onLike,
    this.onReply,
    this.onEdit,
    this.onDelete,
    this.emptyState,
    this.physics,
    this.shrinkWrap = false,
  });

  @override
  Widget build(BuildContext context) {
    if (comments.isEmpty) {
      return emptyState ?? _buildEmpty(context);
    }

    return ListView.builder(
      physics: physics,
      shrinkWrap: shrinkWrap,
      itemCount: comments.length,
      itemBuilder: (_, index) => YoCommentWidget(
        comment: comments[index],
        compact: compact,
        onLike: onLike,
        onReply: onReply,
        onEdit: onEdit,
        onDelete: onDelete,
      ),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.chat_bubble_outline, size: 64, color: context.gray300),
          const YoSpace.height(16),
          YoText.titleMedium(
            'No comments yet',
            color: context.gray500,
          ),
          const YoSpace.height(8),
          YoText.bodyMedium(
            'Be the first to share your thoughts!',
            color: context.gray400,
          ),
        ],
      ),
    );
  }
}
