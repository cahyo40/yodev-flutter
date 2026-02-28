// File: yo_icon_picker.dart
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:yo_ui/yo_ui.dart';

/// Icon category for organizing icons
enum YoIconCategory {
  all('All', Icons.apps),
  action('Action', Icons.touch_app),
  alert('Alert', Icons.warning),
  av('Audio/Video', Icons.play_circle),
  brand('Brand', Icons.branding_watermark),
  card('Card', Icons.credit_card),
  communication('Communication', Icons.chat),
  content('Content', Icons.edit),
  device('Device', Icons.devices),
  editor('Editor', Icons.format_paint),
  file('File', Icons.folder),
  hardware('Hardware', Icons.computer),
  home('Home', Icons.home),
  image('Image', Icons.image),
  maps('Maps', Icons.map),
  navigation('Navigation', Icons.navigation),
  notification('Notification', Icons.notifications),
  places('Places', Icons.place),
  social('Social', Icons.people),
  subscription('Subscription', Icons.subscriptions),
  toggle('Toggle', Icons.toggle_on);

  final String label;
  final IconData icon;

  const YoIconCategory(this.label, this.icon);
}

/// Icon data with metadata
class YoIconData {
  final IconData icon;
  final String name;
  final YoIconCategory category;

  const YoIconData({
    required this.icon,
    required this.name,
    required this.category,
  });
}

/// Icon picker widget
class YoIconPicker extends StatefulWidget {
  /// Currently selected icon
  final IconData? selectedIcon;

  /// Callback when an icon is selected
  final ValueChanged<IconData> onIconSelected;

  /// Initially selected category
  final YoIconCategory initialCategory;

  /// Icon size in the grid
  final double iconSize;

  /// Number of columns in the grid
  final int crossAxisCount;

  /// Whether to show the search bar
  final bool showSearch;

  /// Whether to show category tabs
  final bool showCategories;

  /// Label text
  final String? labelText;

  /// Hint text for search
  final String searchHint;

  /// Height of the picker
  final double height;

  /// Background color
  final Color? backgroundColor;

  /// Selected icon color
  final Color? selectedColor;

  const YoIconPicker({
    super.key,
    this.selectedIcon,
    required this.onIconSelected,
    this.initialCategory = YoIconCategory.all,
    this.iconSize = 24,
    this.crossAxisCount = 6,
    this.showSearch = true,
    this.showCategories = true,
    this.labelText,
    this.searchHint = 'Search icons...',
    this.height = 300,
    this.backgroundColor,
    this.selectedColor,
  });

  @override
  State<YoIconPicker> createState() => _YoIconPickerState();

  /// Show icon picker as a bottom sheet
  static Future<IconData?> showAsBottomSheet({
    required BuildContext context,
    IconData? selectedIcon,
    YoIconCategory initialCategory = YoIconCategory.all,
    String title = 'Select Icon',
  }) {
    return showModalBottomSheet<IconData>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _YoIconPickerBottomSheet(
        selectedIcon: selectedIcon,
        initialCategory: initialCategory,
        title: title,
      ),
    );
  }

  /// Show icon picker as a dialog
  static Future<IconData?> showAsDialog({
    required BuildContext context,
    IconData? selectedIcon,
    YoIconCategory initialCategory = YoIconCategory.all,
    String title = 'Select Icon',
  }) {
    return showDialog<IconData>(
      context: context,
      builder: (context) => _YoIconPickerDialog(
        selectedIcon: selectedIcon,
        initialCategory: initialCategory,
        title: title,
      ),
    );
  }
}

/// Icon picker button that shows picker on tap
class YoIconPickerButton extends StatelessWidget {
  /// Currently selected icon
  final IconData? selectedIcon;

  /// Callback when an icon is selected
  final ValueChanged<IconData> onIconSelected;

  /// Label text
  final String? labelText;

  /// Hint text when no icon is selected
  final String hintText;

  /// Border radius
  final double borderRadius;

  /// Border color
  final Color? borderColor;

  /// Background color
  final Color? backgroundColor;

  /// Picker type (bottom sheet or dialog)
  final bool useDialog;

  /// Picker title
  final String pickerTitle;

  const YoIconPickerButton({
    super.key,
    this.selectedIcon,
    required this.onIconSelected,
    this.labelText,
    this.hintText = 'Select icon',
    this.borderRadius = 8,
    this.borderColor,
    this.backgroundColor,
    this.useDialog = false,
    this.pickerTitle = 'Select Icon',
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showPicker(context),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: backgroundColor ?? context.backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(color: borderColor ?? context.gray300, width: 1),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: selectedIcon != null
                    ? context.primaryColor.withAlpha(30)
                    : context.gray100,
                borderRadius: BorderRadius.circular(context.yoRadiusMd),
                border: Border.all(
                  color: selectedIcon != null
                      ? context.primaryColor
                      : context.gray300,
                ),
              ),
              child: Icon(
                selectedIcon ?? Icons.add,
                color: selectedIcon != null
                    ? context.primaryColor
                    : context.gray400,
                size: 24,
              ),
            ),
            const YoSpace.width(12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (labelText != null) ...[
                    YoText(
                      labelText!,
                      style:
                          context.yoLabelSmall.copyWith(color: context.gray500),
                    ),
                    const YoSpace.height(2),
                  ],
                  YoText(
                    selectedIcon != null
                        ? _getIconName(selectedIcon!)
                        : hintText,
                    style: context.yoBodyMedium.copyWith(
                      color: selectedIcon != null
                          ? context.textColor
                          : context.gray400,
                      fontWeight: selectedIcon != null
                          ? FontWeight.w500
                          : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.keyboard_arrow_down, color: context.gray500),
          ],
        ),
      ),
    );
  }

  String _getIconName(IconData icon) {
    final found = YoIcons.all.where((i) => i.icon == icon).firstOrNull;
    return found?.name ?? 'Icon selected';
  }

  Future<void> _showPicker(BuildContext context) async {
    final IconData? result;
    if (useDialog) {
      result = await YoIconPicker.showAsDialog(
        context: context,
        selectedIcon: selectedIcon,
        title: pickerTitle,
      );
    } else {
      result = await YoIconPicker.showAsBottomSheet(
        context: context,
        selectedIcon: selectedIcon,
        title: pickerTitle,
      );
    }

    if (result != null) {
      onIconSelected(result);
    }
  }
}

/// Predefined icons organized by category
class YoIcons {
  static const List<YoIconData> all = [
    // Action icons
    YoIconData(icon: Icons.add, name: 'add', category: YoIconCategory.action),
    YoIconData(
        icon: Icons.remove, name: 'remove', category: YoIconCategory.action),
    YoIconData(
        icon: Icons.close, name: 'close', category: YoIconCategory.action),
    YoIconData(
        icon: Icons.check, name: 'check', category: YoIconCategory.action),
    YoIconData(
        icon: Icons.delete, name: 'delete', category: YoIconCategory.action),
    YoIconData(icon: Icons.edit, name: 'edit', category: YoIconCategory.action),
    YoIconData(icon: Icons.save, name: 'save', category: YoIconCategory.action),
    YoIconData(
        icon: Icons.share, name: 'share', category: YoIconCategory.action),
    YoIconData(icon: Icons.copy, name: 'copy', category: YoIconCategory.action),
    YoIconData(
        icon: Icons.content_paste,
        name: 'paste',
        category: YoIconCategory.action),
    YoIconData(
        icon: Icons.search, name: 'search', category: YoIconCategory.action),
    YoIconData(
        icon: Icons.settings,
        name: 'settings',
        category: YoIconCategory.action),
    YoIconData(
        icon: Icons.more_vert,
        name: 'more_vert',
        category: YoIconCategory.action),
    YoIconData(
        icon: Icons.more_horiz,
        name: 'more_horiz',
        category: YoIconCategory.action),
    YoIconData(
        icon: Icons.refresh, name: 'refresh', category: YoIconCategory.action),
    YoIconData(icon: Icons.undo, name: 'undo', category: YoIconCategory.action),
    YoIconData(icon: Icons.redo, name: 'redo', category: YoIconCategory.action),
    YoIconData(
        icon: Icons.download,
        name: 'download',
        category: YoIconCategory.action),
    YoIconData(
        icon: Icons.upload, name: 'upload', category: YoIconCategory.action),
    YoIconData(
        icon: Icons.print, name: 'print', category: YoIconCategory.action),
    YoIconData(
        icon: Icons.bookmark,
        name: 'bookmark',
        category: YoIconCategory.action),
    YoIconData(
        icon: Icons.favorite,
        name: 'favorite',
        category: YoIconCategory.action),
    YoIconData(icon: Icons.star, name: 'star', category: YoIconCategory.action),
    YoIconData(
        icon: Icons.thumb_up,
        name: 'thumb_up',
        category: YoIconCategory.action),
    YoIconData(
        icon: Icons.thumb_down,
        name: 'thumb_down',
        category: YoIconCategory.action),
    YoIconData(icon: Icons.lock, name: 'lock', category: YoIconCategory.action),
    YoIconData(
        icon: Icons.lock_open,
        name: 'lock_open',
        category: YoIconCategory.action),
    YoIconData(
        icon: Icons.visibility,
        name: 'visibility',
        category: YoIconCategory.action),
    YoIconData(
        icon: Icons.visibility_off,
        name: 'visibility_off',
        category: YoIconCategory.action),
    YoIconData(
        icon: Icons.zoom_in, name: 'zoom_in', category: YoIconCategory.action),
    YoIconData(
        icon: Icons.zoom_out,
        name: 'zoom_out',
        category: YoIconCategory.action),

    // Alert icons
    YoIconData(
        icon: Icons.warning, name: 'warning', category: YoIconCategory.alert),
    YoIconData(
        icon: Icons.error, name: 'error', category: YoIconCategory.alert),
    YoIconData(icon: Icons.info, name: 'info', category: YoIconCategory.alert),
    YoIconData(icon: Icons.help, name: 'help', category: YoIconCategory.alert),
    YoIconData(
        icon: Icons.report, name: 'report', category: YoIconCategory.alert),
    YoIconData(
        icon: Icons.notification_important,
        name: 'notification_important',
        category: YoIconCategory.alert),

    // Audio/Video icons
    YoIconData(
        icon: Icons.play_arrow, name: 'play', category: YoIconCategory.av),
    YoIconData(icon: Icons.pause, name: 'pause', category: YoIconCategory.av),
    YoIconData(icon: Icons.stop, name: 'stop', category: YoIconCategory.av),
    YoIconData(
        icon: Icons.skip_next, name: 'skip_next', category: YoIconCategory.av),
    YoIconData(
        icon: Icons.skip_previous,
        name: 'skip_previous',
        category: YoIconCategory.av),
    YoIconData(
        icon: Icons.fast_forward,
        name: 'fast_forward',
        category: YoIconCategory.av),
    YoIconData(
        icon: Icons.fast_rewind,
        name: 'fast_rewind',
        category: YoIconCategory.av),
    YoIconData(
        icon: Icons.volume_up, name: 'volume_up', category: YoIconCategory.av),
    YoIconData(
        icon: Icons.volume_down,
        name: 'volume_down',
        category: YoIconCategory.av),
    YoIconData(
        icon: Icons.volume_off,
        name: 'volume_off',
        category: YoIconCategory.av),
    YoIconData(icon: Icons.mic, name: 'mic', category: YoIconCategory.av),
    YoIconData(
        icon: Icons.mic_off, name: 'mic_off', category: YoIconCategory.av),
    YoIconData(
        icon: Icons.videocam, name: 'videocam', category: YoIconCategory.av),
    YoIconData(icon: Icons.movie, name: 'movie', category: YoIconCategory.av),
    YoIconData(
        icon: Icons.music_note,
        name: 'music_note',
        category: YoIconCategory.av),
    YoIconData(
        icon: Icons.headphones,
        name: 'headphones',
        category: YoIconCategory.av),
    YoIconData(icon: Icons.radio, name: 'radio', category: YoIconCategory.av),
    YoIconData(icon: Icons.album, name: 'album', category: YoIconCategory.av),

    // Brand icons

    YoIconData(
        icon: FontAwesomeIcons.spotify,
        name: 'spotify',
        category: YoIconCategory.brand),
    YoIconData(
        icon: FontAwesomeIcons.amazon,
        name: 'amazon',
        category: YoIconCategory.brand),
    YoIconData(
        icon: FontAwesomeIcons.google,
        name: 'google',
        category: YoIconCategory.brand),
    YoIconData(
        icon: FontAwesomeIcons.apple,
        name: 'apple',
        category: YoIconCategory.brand),
    YoIconData(
        icon: FontAwesomeIcons.microsoft,
        name: 'microsoft',
        category: YoIconCategory.brand),
    YoIconData(
        icon: FontAwesomeIcons.facebook,
        name: 'facebook',
        category: YoIconCategory.brand),
    YoIconData(
        icon: FontAwesomeIcons.twitter,
        name: 'twitter',
        category: YoIconCategory.brand),
    YoIconData(
        icon: FontAwesomeIcons.instagram,
        name: 'instagram',
        category: YoIconCategory.brand),
    YoIconData(
        icon: FontAwesomeIcons.youtube,
        name: 'youtube',
        category: YoIconCategory.brand),
    YoIconData(
        icon: FontAwesomeIcons.linkedin,
        name: 'linkedin',
        category: YoIconCategory.brand),
    YoIconData(
        icon: FontAwesomeIcons.discord,
        name: 'discord',
        category: YoIconCategory.brand),
    YoIconData(
        icon: FontAwesomeIcons.slack,
        name: 'slack',
        category: YoIconCategory.brand),
    YoIconData(
        icon: FontAwesomeIcons.whatsapp,
        name: 'whatsapp',
        category: YoIconCategory.brand),
    YoIconData(
        icon: FontAwesomeIcons.telegram,
        name: 'telegram',
        category: YoIconCategory.brand),
    YoIconData(
        icon: FontAwesomeIcons.twitch,
        name: 'twitch',
        category: YoIconCategory.brand),
    YoIconData(
        icon: FontAwesomeIcons.steam,
        name: 'steam',
        category: YoIconCategory.brand),
    YoIconData(
        icon: FontAwesomeIcons.snapchat,
        name: 'snapchat',
        category: YoIconCategory.brand),
    YoIconData(
        icon: FontAwesomeIcons.tiktok,
        name: 'tiktok',
        category: YoIconCategory.brand),

    // Card icons
    YoIconData(
        icon: FontAwesomeIcons.ccVisa,
        name: 'visa',
        category: YoIconCategory.card),
    YoIconData(
        icon: FontAwesomeIcons.ccMastercard,
        name: 'mastercard',
        category: YoIconCategory.card),
    YoIconData(
        icon: FontAwesomeIcons.ccAmex,
        name: 'amex',
        category: YoIconCategory.card),
    YoIconData(
        icon: FontAwesomeIcons.ccDiscover,
        name: 'discover',
        category: YoIconCategory.card),
    YoIconData(
        icon: FontAwesomeIcons.ccDinersClub,
        name: 'diners_club',
        category: YoIconCategory.card),
    YoIconData(
        icon: FontAwesomeIcons.ccJcb,
        name: 'jcb',
        category: YoIconCategory.card),
    YoIconData(
        icon: FontAwesomeIcons.ccPaypal,
        name: 'paypal',
        category: YoIconCategory.card),
    YoIconData(
        icon: FontAwesomeIcons.ccStripe,
        name: 'stripe',
        category: YoIconCategory.card),
    YoIconData(
        icon: FontAwesomeIcons.creditCard,
        name: 'credit_card',
        category: YoIconCategory.card),
    YoIconData(
        icon: FontAwesomeIcons.wallet,
        name: 'wallet',
        category: YoIconCategory.card),
    YoIconData(
        icon: FontAwesomeIcons.moneyBill,
        name: 'cash',
        category: YoIconCategory.card),
    YoIconData(
        icon: FontAwesomeIcons.moneyBillWave,
        name: 'money',
        category: YoIconCategory.card),
    YoIconData(
        icon: FontAwesomeIcons.handHoldingDollar,
        name: 'donate',
        category: YoIconCategory.card),
    YoIconData(
        icon: FontAwesomeIcons.handHoldingDollar,
        name: 'payment',
        category: YoIconCategory.card),
    YoIconData(
        icon: FontAwesomeIcons.bitcoin,
        name: 'bitcoin',
        category: YoIconCategory.card),
    YoIconData(
        icon: FontAwesomeIcons.ethereum,
        name: 'ethereum',
        category: YoIconCategory.card),

    // Communication icons
    YoIconData(
        icon: Icons.call, name: 'call', category: YoIconCategory.communication),
    YoIconData(
        icon: Icons.call_end,
        name: 'call_end',
        category: YoIconCategory.communication),
    YoIconData(
        icon: Icons.chat, name: 'chat', category: YoIconCategory.communication),
    YoIconData(
        icon: Icons.message,
        name: 'message',
        category: YoIconCategory.communication),
    YoIconData(
        icon: Icons.email,
        name: 'email',
        category: YoIconCategory.communication),
    YoIconData(
        icon: Icons.inbox,
        name: 'inbox',
        category: YoIconCategory.communication),
    YoIconData(
        icon: Icons.send, name: 'send', category: YoIconCategory.communication),
    YoIconData(
        icon: Icons.forum,
        name: 'forum',
        category: YoIconCategory.communication),
    YoIconData(
        icon: Icons.comment,
        name: 'comment',
        category: YoIconCategory.communication),
    YoIconData(
        icon: Icons.contacts,
        name: 'contacts',
        category: YoIconCategory.communication),
    YoIconData(
        icon: Icons.contact_phone,
        name: 'contact_phone',
        category: YoIconCategory.communication),
    YoIconData(
        icon: Icons.contact_mail,
        name: 'contact_mail',
        category: YoIconCategory.communication),

    // Content icons
    YoIconData(
        icon: Icons.add_circle,
        name: 'add_circle',
        category: YoIconCategory.content),
    YoIconData(
        icon: Icons.remove_circle,
        name: 'remove_circle',
        category: YoIconCategory.content),
    YoIconData(
        icon: Icons.content_copy,
        name: 'content_copy',
        category: YoIconCategory.content),
    YoIconData(
        icon: Icons.create, name: 'create', category: YoIconCategory.content),
    YoIconData(
        icon: Icons.flag, name: 'flag', category: YoIconCategory.content),
    YoIconData(
        icon: Icons.link, name: 'link', category: YoIconCategory.content),
    YoIconData(
        icon: Icons.link_off,
        name: 'link_off',
        category: YoIconCategory.content),
    YoIconData(
        icon: Icons.archive, name: 'archive', category: YoIconCategory.content),
    YoIconData(
        icon: Icons.unarchive,
        name: 'unarchive',
        category: YoIconCategory.content),
    YoIconData(
        icon: Icons.filter_list,
        name: 'filter_list',
        category: YoIconCategory.content),
    YoIconData(
        icon: Icons.sort, name: 'sort', category: YoIconCategory.content),
    YoIconData(
        icon: Icons.text_format,
        name: 'text_format',
        category: YoIconCategory.content),

    // Device icons
    YoIconData(
        icon: Icons.smartphone,
        name: 'smartphone',
        category: YoIconCategory.device),
    YoIconData(
        icon: Icons.tablet, name: 'tablet', category: YoIconCategory.device),
    YoIconData(
        icon: Icons.laptop, name: 'laptop', category: YoIconCategory.device),
    YoIconData(
        icon: Icons.desktop_windows,
        name: 'desktop',
        category: YoIconCategory.device),
    YoIconData(icon: Icons.tv, name: 'tv', category: YoIconCategory.device),
    YoIconData(
        icon: Icons.watch, name: 'watch', category: YoIconCategory.device),
    YoIconData(
        icon: Icons.bluetooth,
        name: 'bluetooth',
        category: YoIconCategory.device),
    YoIconData(icon: Icons.wifi, name: 'wifi', category: YoIconCategory.device),
    YoIconData(
        icon: Icons.wifi_off,
        name: 'wifi_off',
        category: YoIconCategory.device),
    YoIconData(
        icon: Icons.battery_full,
        name: 'battery_full',
        category: YoIconCategory.device),
    YoIconData(
        icon: Icons.battery_charging_full,
        name: 'battery_charging',
        category: YoIconCategory.device),
    YoIconData(
        icon: Icons.signal_cellular_4_bar,
        name: 'signal',
        category: YoIconCategory.device),
    YoIconData(
        icon: Icons.gps_fixed, name: 'gps', category: YoIconCategory.device),
    YoIconData(
        icon: Icons.screen_rotation,
        name: 'screen_rotation',
        category: YoIconCategory.device),
    YoIconData(
        icon: Icons.brightness_high,
        name: 'brightness',
        category: YoIconCategory.device),
    YoIconData(
        icon: Icons.flashlight_on,
        name: 'flashlight',
        category: YoIconCategory.device),

    // Editor icons
    YoIconData(
        icon: Icons.format_bold, name: 'bold', category: YoIconCategory.editor),
    YoIconData(
        icon: Icons.format_italic,
        name: 'italic',
        category: YoIconCategory.editor),
    YoIconData(
        icon: Icons.format_underline,
        name: 'underline',
        category: YoIconCategory.editor),
    YoIconData(
        icon: Icons.format_strikethrough,
        name: 'strikethrough',
        category: YoIconCategory.editor),
    YoIconData(
        icon: Icons.format_align_left,
        name: 'align_left',
        category: YoIconCategory.editor),
    YoIconData(
        icon: Icons.format_align_center,
        name: 'align_center',
        category: YoIconCategory.editor),
    YoIconData(
        icon: Icons.format_align_right,
        name: 'align_right',
        category: YoIconCategory.editor),
    YoIconData(
        icon: Icons.format_list_bulleted,
        name: 'list_bulleted',
        category: YoIconCategory.editor),
    YoIconData(
        icon: Icons.format_list_numbered,
        name: 'list_numbered',
        category: YoIconCategory.editor),
    YoIconData(
        icon: Icons.format_quote,
        name: 'quote',
        category: YoIconCategory.editor),
    YoIconData(
        icon: Icons.format_color_text,
        name: 'text_color',
        category: YoIconCategory.editor),
    YoIconData(
        icon: Icons.format_color_fill,
        name: 'fill_color',
        category: YoIconCategory.editor),
    YoIconData(
        icon: Icons.format_size,
        name: 'font_size',
        category: YoIconCategory.editor),
    YoIconData(
        icon: Icons.title, name: 'title', category: YoIconCategory.editor),

    // File icons
    YoIconData(
        icon: Icons.folder, name: 'folder', category: YoIconCategory.file),
    YoIconData(
        icon: Icons.folder_open,
        name: 'folder_open',
        category: YoIconCategory.file),
    YoIconData(
        icon: Icons.create_new_folder,
        name: 'create_folder',
        category: YoIconCategory.file),
    YoIconData(
        icon: Icons.insert_drive_file,
        name: 'file',
        category: YoIconCategory.file),
    YoIconData(
        icon: Icons.attachment,
        name: 'attachment',
        category: YoIconCategory.file),
    YoIconData(icon: Icons.cloud, name: 'cloud', category: YoIconCategory.file),
    YoIconData(
        icon: Icons.cloud_upload,
        name: 'cloud_upload',
        category: YoIconCategory.file),
    YoIconData(
        icon: Icons.cloud_download,
        name: 'cloud_download',
        category: YoIconCategory.file),
    YoIconData(
        icon: Icons.cloud_done,
        name: 'cloud_done',
        category: YoIconCategory.file),
    YoIconData(
        icon: Icons.cloud_off,
        name: 'cloud_off',
        category: YoIconCategory.file),
    YoIconData(
        icon: Icons.description,
        name: 'document',
        category: YoIconCategory.file),
    YoIconData(
        icon: Icons.picture_as_pdf, name: 'pdf', category: YoIconCategory.file),

    // Hardware icons
    YoIconData(
        icon: Icons.computer,
        name: 'computer',
        category: YoIconCategory.hardware),
    YoIconData(
        icon: Icons.keyboard,
        name: 'keyboard',
        category: YoIconCategory.hardware),
    YoIconData(
        icon: Icons.mouse, name: 'mouse', category: YoIconCategory.hardware),
    YoIconData(
        icon: Icons.memory, name: 'memory', category: YoIconCategory.hardware),
    YoIconData(
        icon: Icons.storage,
        name: 'storage',
        category: YoIconCategory.hardware),
    YoIconData(icon: Icons.usb, name: 'usb', category: YoIconCategory.hardware),
    YoIconData(
        icon: Icons.router, name: 'router', category: YoIconCategory.hardware),
    YoIconData(
        icon: Icons.scanner,
        name: 'scanner',
        category: YoIconCategory.hardware),
    YoIconData(
        icon: Icons.print, name: 'printer', category: YoIconCategory.hardware),
    YoIconData(
        icon: Icons.camera, name: 'camera', category: YoIconCategory.hardware),
    YoIconData(
        icon: Icons.videocam,
        name: 'video_camera',
        category: YoIconCategory.hardware),
    YoIconData(
        icon: Icons.speaker,
        name: 'speaker',
        category: YoIconCategory.hardware),

    // Home icons
    YoIconData(icon: Icons.home, name: 'home', category: YoIconCategory.home),
    YoIconData(icon: Icons.house, name: 'house', category: YoIconCategory.home),
    YoIconData(
        icon: Icons.apartment,
        name: 'apartment',
        category: YoIconCategory.home),
    YoIconData(
        icon: Icons.business, name: 'business', category: YoIconCategory.home),
    YoIconData(icon: Icons.store, name: 'store', category: YoIconCategory.home),
    YoIconData(icon: Icons.hotel, name: 'hotel', category: YoIconCategory.home),
    YoIconData(
        icon: Icons.restaurant,
        name: 'restaurant',
        category: YoIconCategory.home),
    YoIconData(
        icon: Icons.local_cafe, name: 'cafe', category: YoIconCategory.home),
    YoIconData(
        icon: Icons.local_bar, name: 'bar', category: YoIconCategory.home),
    YoIconData(
        icon: Icons.local_hospital,
        name: 'hospital',
        category: YoIconCategory.home),
    YoIconData(
        icon: Icons.local_pharmacy,
        name: 'pharmacy',
        category: YoIconCategory.home),
    YoIconData(
        icon: Icons.local_gas_station,
        name: 'gas_station',
        category: YoIconCategory.home),
    YoIconData(
        icon: Icons.local_parking,
        name: 'parking',
        category: YoIconCategory.home),
    YoIconData(
        icon: Icons.local_atm, name: 'atm', category: YoIconCategory.home),

    // Image icons
    YoIconData(
        icon: Icons.image, name: 'image', category: YoIconCategory.image),
    YoIconData(
        icon: Icons.photo, name: 'photo', category: YoIconCategory.image),
    YoIconData(
        icon: Icons.photo_album,
        name: 'photo_album',
        category: YoIconCategory.image),
    YoIconData(
        icon: Icons.photo_camera,
        name: 'camera',
        category: YoIconCategory.image),
    YoIconData(
        icon: Icons.photo_library,
        name: 'photo_library',
        category: YoIconCategory.image),
    YoIconData(
        icon: Icons.add_a_photo,
        name: 'add_photo',
        category: YoIconCategory.image),
    YoIconData(
        icon: Icons.add_photo_alternate,
        name: 'add_photo_alt',
        category: YoIconCategory.image),
    YoIconData(icon: Icons.crop, name: 'crop', category: YoIconCategory.image),
    YoIconData(
        icon: Icons.rotate_left,
        name: 'rotate_left',
        category: YoIconCategory.image),
    YoIconData(
        icon: Icons.rotate_right,
        name: 'rotate_right',
        category: YoIconCategory.image),
    YoIconData(icon: Icons.flip, name: 'flip', category: YoIconCategory.image),
    YoIconData(
        icon: Icons.color_lens,
        name: 'color_lens',
        category: YoIconCategory.image),
    YoIconData(
        icon: Icons.brush, name: 'brush', category: YoIconCategory.image),
    YoIconData(
        icon: Icons.palette, name: 'palette', category: YoIconCategory.image),

    // Maps icons
    YoIconData(icon: Icons.map, name: 'map', category: YoIconCategory.maps),
    YoIconData(
        icon: Icons.location_on,
        name: 'location',
        category: YoIconCategory.maps),
    YoIconData(
        icon: Icons.location_off,
        name: 'location_off',
        category: YoIconCategory.maps),
    YoIconData(
        icon: Icons.my_location,
        name: 'my_location',
        category: YoIconCategory.maps),
    YoIconData(
        icon: Icons.near_me, name: 'near_me', category: YoIconCategory.maps),
    YoIconData(
        icon: Icons.directions,
        name: 'directions',
        category: YoIconCategory.maps),
    YoIconData(
        icon: Icons.directions_car, name: 'car', category: YoIconCategory.maps),
    YoIconData(
        icon: Icons.directions_bus, name: 'bus', category: YoIconCategory.maps),
    YoIconData(
        icon: Icons.directions_bike,
        name: 'bike',
        category: YoIconCategory.maps),
    YoIconData(
        icon: Icons.directions_walk,
        name: 'walk',
        category: YoIconCategory.maps),
    YoIconData(
        icon: Icons.flight, name: 'flight', category: YoIconCategory.maps),
    YoIconData(icon: Icons.train, name: 'train', category: YoIconCategory.maps),
    YoIconData(
        icon: Icons.subway, name: 'subway', category: YoIconCategory.maps),
    YoIconData(
        icon: Icons.local_taxi, name: 'taxi', category: YoIconCategory.maps),
    YoIconData(
        icon: Icons.traffic, name: 'traffic', category: YoIconCategory.maps),

    // Navigation icons
    YoIconData(
        icon: Icons.arrow_back,
        name: 'arrow_back',
        category: YoIconCategory.navigation),
    YoIconData(
        icon: Icons.arrow_forward,
        name: 'arrow_forward',
        category: YoIconCategory.navigation),
    YoIconData(
        icon: Icons.arrow_upward,
        name: 'arrow_up',
        category: YoIconCategory.navigation),
    YoIconData(
        icon: Icons.arrow_downward,
        name: 'arrow_down',
        category: YoIconCategory.navigation),
    YoIconData(
        icon: Icons.arrow_drop_down,
        name: 'drop_down',
        category: YoIconCategory.navigation),
    YoIconData(
        icon: Icons.arrow_drop_up,
        name: 'drop_up',
        category: YoIconCategory.navigation),
    YoIconData(
        icon: Icons.chevron_left,
        name: 'chevron_left',
        category: YoIconCategory.navigation),
    YoIconData(
        icon: Icons.chevron_right,
        name: 'chevron_right',
        category: YoIconCategory.navigation),
    YoIconData(
        icon: Icons.expand_less,
        name: 'expand_less',
        category: YoIconCategory.navigation),
    YoIconData(
        icon: Icons.expand_more,
        name: 'expand_more',
        category: YoIconCategory.navigation),
    YoIconData(
        icon: Icons.first_page,
        name: 'first_page',
        category: YoIconCategory.navigation),
    YoIconData(
        icon: Icons.last_page,
        name: 'last_page',
        category: YoIconCategory.navigation),
    YoIconData(
        icon: Icons.menu, name: 'menu', category: YoIconCategory.navigation),
    YoIconData(
        icon: Icons.apps, name: 'apps', category: YoIconCategory.navigation),
    YoIconData(
        icon: Icons.fullscreen,
        name: 'fullscreen',
        category: YoIconCategory.navigation),
    YoIconData(
        icon: Icons.fullscreen_exit,
        name: 'fullscreen_exit',
        category: YoIconCategory.navigation),

    // Notification icons
    YoIconData(
        icon: Icons.notifications,
        name: 'notifications',
        category: YoIconCategory.notification),
    YoIconData(
        icon: Icons.notifications_active,
        name: 'notifications_active',
        category: YoIconCategory.notification),
    YoIconData(
        icon: Icons.notifications_none,
        name: 'notifications_none',
        category: YoIconCategory.notification),
    YoIconData(
        icon: Icons.notifications_off,
        name: 'notifications_off',
        category: YoIconCategory.notification),
    YoIconData(
        icon: Icons.notifications_paused,
        name: 'notifications_paused',
        category: YoIconCategory.notification),
    YoIconData(
        icon: Icons.do_not_disturb,
        name: 'do_not_disturb',
        category: YoIconCategory.notification),
    YoIconData(
        icon: Icons.alarm,
        name: 'alarm',
        category: YoIconCategory.notification),
    YoIconData(
        icon: Icons.alarm_add,
        name: 'alarm_add',
        category: YoIconCategory.notification),
    YoIconData(
        icon: Icons.alarm_on,
        name: 'alarm_on',
        category: YoIconCategory.notification),
    YoIconData(
        icon: Icons.alarm_off,
        name: 'alarm_off',
        category: YoIconCategory.notification),

    // Places icons
    YoIconData(
        icon: Icons.place, name: 'place', category: YoIconCategory.places),
    YoIconData(
        icon: Icons.beach_access,
        name: 'beach',
        category: YoIconCategory.places),
    YoIconData(
        icon: Icons.casino, name: 'casino', category: YoIconCategory.places),
    YoIconData(
        icon: Icons.child_care,
        name: 'child_care',
        category: YoIconCategory.places),
    YoIconData(
        icon: Icons.fitness_center,
        name: 'fitness',
        category: YoIconCategory.places),
    YoIconData(
        icon: Icons.golf_course, name: 'golf', category: YoIconCategory.places),
    YoIconData(icon: Icons.pool, name: 'pool', category: YoIconCategory.places),
    YoIconData(icon: Icons.spa, name: 'spa', category: YoIconCategory.places),
    YoIconData(
        icon: Icons.kitchen, name: 'kitchen', category: YoIconCategory.places),
    YoIconData(
        icon: Icons.room_service,
        name: 'room_service',
        category: YoIconCategory.places),
    YoIconData(
        icon: Icons.smoking_rooms,
        name: 'smoking',
        category: YoIconCategory.places),
    YoIconData(
        icon: Icons.smoke_free,
        name: 'smoke_free',
        category: YoIconCategory.places),

    // Social icons
    YoIconData(
        icon: Icons.people, name: 'people', category: YoIconCategory.social),
    YoIconData(
        icon: Icons.person, name: 'person', category: YoIconCategory.social),
    YoIconData(
        icon: Icons.person_add,
        name: 'person_add',
        category: YoIconCategory.social),
    YoIconData(
        icon: Icons.person_remove,
        name: 'person_remove',
        category: YoIconCategory.social),
    YoIconData(
        icon: Icons.group, name: 'group', category: YoIconCategory.social),
    YoIconData(
        icon: Icons.group_add,
        name: 'group_add',
        category: YoIconCategory.social),
    YoIconData(
        icon: Icons.groups, name: 'groups', category: YoIconCategory.social),
    YoIconData(
        icon: Icons.public, name: 'public', category: YoIconCategory.social),
    YoIconData(
        icon: Icons.share, name: 'share', category: YoIconCategory.social),
    YoIconData(icon: Icons.mood, name: 'mood', category: YoIconCategory.social),
    YoIconData(
        icon: Icons.mood_bad,
        name: 'mood_bad',
        category: YoIconCategory.social),
    YoIconData(
        icon: Icons.sentiment_satisfied,
        name: 'satisfied',
        category: YoIconCategory.social),
    YoIconData(
        icon: Icons.sentiment_dissatisfied,
        name: 'dissatisfied',
        category: YoIconCategory.social),
    YoIconData(
        icon: Icons.sentiment_neutral,
        name: 'neutral',
        category: YoIconCategory.social),
    YoIconData(icon: Icons.cake, name: 'cake', category: YoIconCategory.social),
    YoIconData(
        icon: Icons.party_mode, name: 'party', category: YoIconCategory.social),

    // Subscription icons
    YoIconData(
        icon: FontAwesomeIcons.podcast,
        name: 'podcast',
        category: YoIconCategory.subscription),
    YoIconData(
        icon: FontAwesomeIcons.newspaper,
        name: 'news',
        category: YoIconCategory.subscription),
    YoIconData(
        icon: FontAwesomeIcons.book,
        name: 'book',
        category: YoIconCategory.subscription),
    YoIconData(
        icon: FontAwesomeIcons.tv,
        name: 'streaming',
        category: YoIconCategory.subscription),
    YoIconData(
        icon: FontAwesomeIcons.gamepad,
        name: 'gaming',
        category: YoIconCategory.subscription),
    YoIconData(
        icon: FontAwesomeIcons.music,
        name: 'music',
        category: YoIconCategory.subscription),
    YoIconData(
        icon: FontAwesomeIcons.film,
        name: 'movie',
        category: YoIconCategory.subscription),
    YoIconData(
        icon: FontAwesomeIcons.cloud,
        name: 'cloud_service',
        category: YoIconCategory.subscription),
    YoIconData(
        icon: FontAwesomeIcons.server,
        name: 'hosting',
        category: YoIconCategory.subscription),
    YoIconData(
        icon: FontAwesomeIcons.database,
        name: 'storage',
        category: YoIconCategory.subscription),
    YoIconData(
        icon: FontAwesomeIcons.gears,
        name: 'software',
        category: YoIconCategory.subscription),
    YoIconData(
        icon: FontAwesomeIcons.mobileScreenButton,
        name: 'mobile_app',
        category: YoIconCategory.subscription),
    YoIconData(
        icon: FontAwesomeIcons.bell,
        name: 'notifications',
        category: YoIconCategory.subscription),
    YoIconData(
        icon: FontAwesomeIcons.envelope,
        name: 'email_service',
        category: YoIconCategory.subscription),
    YoIconData(
        icon: FontAwesomeIcons.calendarDays,
        name: 'calendar',
        category: YoIconCategory.subscription),
    YoIconData(
        icon: FontAwesomeIcons.photoFilm,
        name: 'media',
        category: YoIconCategory.subscription),
    YoIconData(
        icon: FontAwesomeIcons.graduationCap,
        name: 'education',
        category: YoIconCategory.subscription),
    YoIconData(
        icon: FontAwesomeIcons.dumbbell,
        name: 'fitness',
        category: YoIconCategory.subscription),
    YoIconData(
        icon: FontAwesomeIcons.utensils,
        name: 'food',
        category: YoIconCategory.subscription),
    YoIconData(
        icon: FontAwesomeIcons.bagShopping,
        name: 'shopping',
        category: YoIconCategory.subscription),

    // Toggle icons
    YoIconData(
        icon: Icons.toggle_on,
        name: 'toggle_on',
        category: YoIconCategory.toggle),
    YoIconData(
        icon: Icons.toggle_off,
        name: 'toggle_off',
        category: YoIconCategory.toggle),
    YoIconData(
        icon: Icons.check_box,
        name: 'checkbox',
        category: YoIconCategory.toggle),
    YoIconData(
        icon: Icons.check_box_outline_blank,
        name: 'checkbox_blank',
        category: YoIconCategory.toggle),
    YoIconData(
        icon: Icons.radio_button_checked,
        name: 'radio_checked',
        category: YoIconCategory.toggle),
    YoIconData(
        icon: Icons.radio_button_unchecked,
        name: 'radio_unchecked',
        category: YoIconCategory.toggle),
    YoIconData(
        icon: Icons.indeterminate_check_box,
        name: 'indeterminate',
        category: YoIconCategory.toggle),
    YoIconData(icon: Icons.star, name: 'star', category: YoIconCategory.toggle),
    YoIconData(
        icon: Icons.star_border,
        name: 'star_border',
        category: YoIconCategory.toggle),
    YoIconData(
        icon: Icons.star_half,
        name: 'star_half',
        category: YoIconCategory.toggle),
  ];

  YoIcons._();

  /// Get icons by category
  static List<YoIconData> byCategory(YoIconCategory category) {
    if (category == YoIconCategory.all) return all;
    return all.where((icon) => icon.category == category).toList();
  }

  /// Search icons by name
  static List<YoIconData> search(String query) {
    if (query.isEmpty) return all;
    final lowerQuery = query.toLowerCase();
    return all
        .where((icon) => icon.name.toLowerCase().contains(lowerQuery))
        .toList();
  }
}

/// Bottom sheet variant
class _YoIconPickerBottomSheet extends StatefulWidget {
  final IconData? selectedIcon;
  final YoIconCategory initialCategory;
  final String title;

  const _YoIconPickerBottomSheet({
    this.selectedIcon,
    required this.initialCategory,
    required this.title,
  });

  @override
  State<_YoIconPickerBottomSheet> createState() =>
      _YoIconPickerBottomSheetState();
}

class _YoIconPickerBottomSheetState extends State<_YoIconPickerBottomSheet> {
  IconData? _selectedIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        color: context.backgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: context.gray300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                YoText(
                  widget.title,
                  style: context.yoTitleMedium
                      .copyWith(fontWeight: FontWeight.w600),
                ),
                Row(
                  children: [
                    if (_selectedIcon != null)
                      TextButton(
                        onPressed: () =>
                            Navigator.of(context).pop(_selectedIcon),
                        child: YoText.bodyMedium('Select'),
                      ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Picker
          Expanded(
            child: YoIconPicker(
              selectedIcon: _selectedIcon,
              initialCategory: widget.initialCategory,
              onIconSelected: (icon) {
                setState(() => _selectedIcon = icon);
              },
              height: double.infinity,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _selectedIcon = widget.selectedIcon;
  }
}

/// Dialog variant
class _YoIconPickerDialog extends StatefulWidget {
  final IconData? selectedIcon;
  final YoIconCategory initialCategory;
  final String title;

  const _YoIconPickerDialog({
    this.selectedIcon,
    required this.initialCategory,
    required this.title,
  });

  @override
  State<_YoIconPickerDialog> createState() => _YoIconPickerDialogState();
}

class _YoIconPickerDialogState extends State<_YoIconPickerDialog> {
  IconData? _selectedIcon;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(context.yoRadiusXl)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.6,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                YoText(
                  widget.title,
                  style: context.yoTitleMedium
                      .copyWith(fontWeight: FontWeight.w600),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const YoSpace.height(8),
            // Picker
            Expanded(
              child: YoIconPicker(
                selectedIcon: _selectedIcon,
                initialCategory: widget.initialCategory,
                onIconSelected: (icon) {
                  setState(() => _selectedIcon = icon);
                },
                height: double.infinity,
                crossAxisCount: 5,
              ),
            ),
            const YoSpace.height(16),
            // Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: YoText.bodyMedium('Cancel'),
                ),
                const YoSpace.width(8),
                ElevatedButton(
                  onPressed: _selectedIcon != null
                      ? () => Navigator.of(context).pop(_selectedIcon)
                      : null,
                  child: YoText.bodyMedium('Select'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _selectedIcon = widget.selectedIcon;
  }
}

class _YoIconPickerState extends State<YoIconPicker> {
  late YoIconCategory _selectedCategory;
  late TextEditingController _searchController;
  List<YoIconData> _filteredIcons = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? context.backgroundColor,
        borderRadius: BorderRadius.circular(context.yoRadiusLg),
        border: Border.all(color: context.gray200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.labelText != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
              child: YoText(
                widget.labelText!,
                style: context.yoLabelMedium.copyWith(
                  fontWeight: FontWeight.w500,
                  color: context.gray600,
                ),
              ),
            ),
          if (widget.showSearch)
            Padding(
              padding: const EdgeInsets.all(12),
              child: YoTextFormField(
                controller: _searchController,
                hintText: widget.searchHint,
                prefixIcon:
                    Icon(Icons.search, size: 20, color: context.gray400),
                inputStyle: YoInputStyle.filled,
                borderRadius: 8.0,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                onChanged: (value) {
                  setState(() => _updateFilteredIcons());
                },
              ),
            ),
          if (widget.showCategories && _searchController.text.isEmpty)
            YoBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: YoIconCategory.values.length,
                itemBuilder: (context, index) {
                  final category = YoIconCategory.values[index];
                  final isSelected = _selectedCategory == category;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      selected: isSelected,
                      label: YoText.bodyMedium(category.label),
                      avatar: Icon(category.icon, size: 16),
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _selectedCategory = category;
                            _updateFilteredIcons();
                          });
                        }
                      },
                      selectedColor:
                          (widget.selectedColor ?? context.primaryColor)
                              .withAlpha(40),
                      checkmarkColor:
                          widget.selectedColor ?? context.primaryColor,
                      labelStyle: TextStyle(
                        fontSize: 12,
                        color: isSelected
                            ? widget.selectedColor ?? context.primaryColor
                            : context.textColor,
                      ),
                    ),
                  );
                },
              ),
            ),
          const YoSpace.height(8),
          Expanded(
            child: _filteredIcons.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off,
                            size: 48, color: context.gray300),
                        const YoSpace.height(8),
                        YoText(
                          'No icons found',
                          style: context.yoBodyMedium
                              .copyWith(color: context.gray400),
                        ),
                      ],
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: widget.crossAxisCount,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: _filteredIcons.length,
                    itemBuilder: (context, index) {
                      final iconData = _filteredIcons[index];
                      final isSelected = widget.selectedIcon == iconData.icon;
                      return Tooltip(
                        message: iconData.name,
                        child: InkWell(
                          onTap: () => widget.onIconSelected(iconData.icon),
                          borderRadius: BorderRadius.circular(context.yoRadiusMd),
                          child: Container(
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? (widget.selectedColor ??
                                          context.primaryColor)
                                      .withAlpha(30)
                                  : context.gray50,
                              borderRadius: BorderRadius.circular(context.yoRadiusMd),
                              border: Border.all(
                                color: isSelected
                                    ? widget.selectedColor ??
                                        context.primaryColor
                                    : context.gray200,
                                width: isSelected ? 2 : 1,
                              ),
                            ),
                            child: Icon(
                              iconData.icon,
                              size: widget.iconSize,
                              color: isSelected
                                  ? widget.selectedColor ?? context.primaryColor
                                  : context.gray600,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory;
    _searchController = TextEditingController();
    _updateFilteredIcons();
  }

  void _updateFilteredIcons() {
    final query = _searchController.text;
    if (query.isNotEmpty) {
      _filteredIcons = YoIcons.search(query);
    } else {
      _filteredIcons = YoIcons.byCategory(_selectedCategory);
    }
  }
}
