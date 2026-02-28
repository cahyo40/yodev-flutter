import 'package:flutter/material.dart';
import 'package:yo_ui/yo_ui.dart';

/// Data model untuk chat message
class YoChatMessage {
  final String id;
  final String text;
  final DateTime timestamp;
  final bool isSentByMe;
  final String? senderAvatar;
  final String? senderName;
  final YoMessageStatus status;
  final YoMessageType type;
  final String? attachmentUrl;
  final String? attachmentName;

  const YoChatMessage({
    required this.id,
    required this.text,
    required this.timestamp,
    required this.isSentByMe,
    this.senderAvatar,
    this.senderName,
    this.status = YoMessageStatus.sent,
    this.type = YoMessageType.text,
    this.attachmentUrl,
    this.attachmentName,
  });
}

enum YoMessageStatus { sending, sent, delivered, read, failed }

enum YoMessageType { text, image, file, system }

/// Chat bubble widget
class YoChatBubble extends StatelessWidget {
  final YoChatMessage message;
  final Function(YoChatMessage)? onTap;
  final Function(YoChatMessage)? onLongPress;
  final bool showAvatar;
  final bool showTimestamp;
  final bool showStatus;
  final Color? sentColor;
  final Color? receivedColor;

  const YoChatBubble({
    super.key,
    required this.message,
    this.onTap,
    this.onLongPress,
    this.showAvatar = true,
    this.showTimestamp = true,
    this.showStatus = true,
    this.sentColor,
    this.receivedColor,
  });

  @override
  Widget build(BuildContext context) {
    if (message.type == YoMessageType.system) {
      return _buildSystemMessage(context);
    }

    final isSent = message.isSentByMe;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment:
            isSent ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          // Left avatar (received messages)
          if (!isSent && showAvatar && message.senderAvatar != null)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: YoAvatar.image(
                imageUrl: message.senderAvatar!,
                size: YoAvatarSize.sm,
              ),
            ),

          // Message content
          Flexible(
            child: Column(
              crossAxisAlignment:
                  isSent ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                // Sender name (group chat)
                if (!isSent && message.senderName != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 8, bottom: 2),
                    child: YoText.bodySmall(
                      message.senderName!,
                      color: context.gray500,
                    ),
                  ),

                // Bubble
                GestureDetector(
                  onTap: () => onTap?.call(message),
                  onLongPress: () => onLongPress?.call(message),
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.75,
                    ),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSent
                          ? (sentColor ?? context.primaryColor)
                          : (receivedColor ?? context.gray100),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(context.yoRadiusXl),
                        topRight: Radius.circular(context.yoRadiusXl),
                        bottomLeft: Radius.circular(isSent ? 16 : 4),
                        bottomRight: Radius.circular(isSent ? 4 : 16),
                      ),
                    ),
                    child: _buildContent(context),
                  ),
                ),

                // Timestamp & status
                if (showTimestamp || (showStatus && isSent))
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (showTimestamp)
                          YoText.bodySmall(
                            _formatTime(message.timestamp),
                            color: context.gray400,
                          ),
                        if (showStatus && isSent) ...[
                          const YoSpace.width(4),
                          _buildStatusIcon(context),
                        ],
                      ],
                    ),
                  ),
              ],
            ),
          ),

          // Right avatar (sent messages)
          if (isSent && showAvatar && message.senderAvatar != null)
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: YoAvatar.image(
                imageUrl: message.senderAvatar!,
                size: YoAvatarSize.sm,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final textColor =
        message.isSentByMe ? context.onPrimaryColor : context.textColor;

    switch (message.type) {
      case YoMessageType.text:
        return YoText.bodyMedium(
          message.text,
          color: textColor,
        );

      case YoMessageType.image:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(context.yoRadiusMd),
              child: Image.network(
                message.attachmentUrl!,
                width: 200,
                height: 150,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 200,
                  height: 150,
                  color: context.gray200,
                  child: Icon(Icons.broken_image, color: context.gray400),
                ),
              ),
            ),
            if (message.text.isNotEmpty) ...[
              const YoSpace.height(8),
              YoText.bodyMedium(
                message.text,
                color: textColor,
              ),
            ],
          ],
        );

      case YoMessageType.file:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _getFileIcon(),
              color: message.isSentByMe
                  ? context.onPrimaryColor
                  : context.primaryColor,
            ),
            const YoSpace.width(8),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  YoText.bodyMedium(
                    message.attachmentName ?? 'File',
                    color: textColor,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (message.text.isNotEmpty)
                    YoText.bodySmall(
                      message.text,
                      color: textColor.withAlpha(178),
                    ),
                ],
              ),
            ),
          ],
        );

      default:
        return YoText.bodyMedium(
          message.text,
          color: textColor,
        );
    }
  }

  Widget _buildSystemMessage(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: context.gray100,
            borderRadius: BorderRadius.circular(context.yoRadiusLg),
          ),
          child: YoText.bodySmall(
            message.text,
            color: context.gray600,
            align: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _buildStatusIcon(BuildContext context) {
    final (icon, color) = switch (message.status) {
      YoMessageStatus.sending => (Icons.access_time, context.gray400),
      YoMessageStatus.sent => (Icons.done, context.gray400),
      YoMessageStatus.delivered => (Icons.done_all, context.gray400),
      YoMessageStatus.read => (Icons.done_all, context.primaryColor),
      YoMessageStatus.failed => (Icons.error_outline, context.errorColor),
    };
    return Icon(icon, size: 12, color: color);
  }

  IconData _getFileIcon() {
    final ext = message.attachmentName?.split('.').lastOrNull?.toLowerCase();
    return switch (ext) {
      'pdf' => Icons.picture_as_pdf,
      'doc' || 'docx' => Icons.description,
      'xls' || 'xlsx' => Icons.table_chart,
      'zip' || 'rar' => Icons.folder_zip,
      _ => Icons.insert_drive_file,
    };
  }

  String _formatTime(DateTime t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
}

/// List of chat messages
class YoChatList extends StatelessWidget {
  final List<YoChatMessage> messages;
  final ScrollController? scrollController;
  final Function(YoChatMessage)? onMessageTap;
  final Function(YoChatMessage)? onMessageLongPress;
  final bool showAvatars;
  final bool showTimestamps;
  final bool showStatus;
  final Color? sentColor;
  final Color? receivedColor;
  final bool isLoading;

  const YoChatList({
    super.key,
    required this.messages,
    this.scrollController,
    this.onMessageTap,
    this.onMessageLongPress,
    this.showAvatars = true,
    this.showTimestamps = true,
    this.showStatus = true,
    this.sentColor,
    this.receivedColor,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      reverse: true,
      padding: const EdgeInsets.all(8),
      itemCount: messages.length + (isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (isLoading && index == 0) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: YoProgress.circular(size: YoProgressSize.small),
            ),
          );
        }

        final msg = messages[isLoading ? index - 1 : index];
        return YoChatBubble(
          message: msg,
          onTap: onMessageTap,
          onLongPress: onMessageLongPress,
          showAvatar: showAvatars,
          showTimestamp: showTimestamps,
          showStatus: showStatus,
          sentColor: sentColor,
          receivedColor: receivedColor,
        );
      },
    );
  }
}
