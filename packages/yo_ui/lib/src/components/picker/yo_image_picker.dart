// File: yo_image_picker.dart
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yo_ui/yo_ui.dart';

/// Circular avatar image picker
class YoAvatarPicker extends StatelessWidget {
  /// Current avatar image path
  final String? imagePath;

  /// Current avatar URL (network)
  final String? imageUrl;

  /// Callback when image is selected
  final ValueChanged<YoImagePickerResult> onImageSelected;

  /// Avatar size
  final double size;

  /// Placeholder icon
  final IconData placeholderIcon;

  /// Border color
  final Color? borderColor;

  /// Border width
  final double borderWidth;

  /// Edit icon
  final IconData editIcon;

  /// Show edit icon
  final bool showEditIcon;

  const YoAvatarPicker({
    super.key,
    this.imagePath,
    this.imageUrl,
    required this.onImageSelected,
    this.size = 100,
    this.placeholderIcon = Icons.person,
    this.borderColor,
    this.borderWidth = 3,
    this.editIcon = Icons.camera_alt,
    this.showEditIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _pickImage(context),
      child: Stack(
        children: [
          // Avatar
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: context.gray100,
              border: Border.all(
                color: borderColor ?? context.primaryColor,
                width: borderWidth,
              ),
              image: _getDecorationImage(),
            ),
            child: _hasImage()
                ? null
                : Icon(
                    placeholderIcon,
                    size: size * 0.4,
                    color: context.gray400,
                  ),
          ),
          // Edit icon
          if (showEditIcon)
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: context.primaryColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: context.backgroundColor, width: 2),
                ),
                child: Icon(
                  editIcon,
                  size: size * 0.2,
                  color: context.onPrimaryColor,
                ),
              ),
            ),
        ],
      ),
    );
  }

  DecorationImage? _getDecorationImage() {
    if (imagePath != null && !kIsWeb) {
      return DecorationImage(
        image: FileImage(File(imagePath!)),
        fit: BoxFit.cover,
      );
    } else if (imageUrl != null) {
      return DecorationImage(
        image: NetworkImage(imageUrl!),
        fit: BoxFit.cover,
      );
    }
    return null;
  }

  bool _hasImage() => imagePath != null || imageUrl != null;

  Future<void> _pickImage(BuildContext context) async {
    final result = await YoImagePicker.showSourcePicker(
      context: context,
      config: YoImagePickerConfig.avatar,
    );

    if (result != null) {
      onImageSelected(result);
    }
  }
}

/// Image picker utility class
class YoImagePicker {
  static final ImagePicker _picker = ImagePicker();

  YoImagePicker._();

  // ==================== PICK SINGLE IMAGE ====================

  /// Pick image from specified source
  static Future<YoImagePickerResult?> pick({
    required YoImageSource source,
    YoImagePickerConfig config = YoImagePickerConfig.defaultConfig,
  }) async {
    switch (source) {
      case YoImageSource.camera:
        return pickFromCamera(config: config);
      case YoImageSource.gallery:
        return pickFromGallery(config: config);
    }
  }

  /// Pick image from camera
  static Future<YoImagePickerResult?> pickFromCamera({
    YoImagePickerConfig config = YoImagePickerConfig.defaultConfig,
  }) async {
    final XFile? file = await _picker.pickImage(
      source: ImageSource.camera,
      maxWidth: config.maxWidth,
      maxHeight: config.maxHeight,
      imageQuality: config.imageQuality,
      preferredCameraDevice: config.preferredCameraDevice,
      requestFullMetadata: config.requestFullMetadata,
    );

    if (file == null) return null;
    return YoImagePickerResult(file: file);
  }

  /// Pick image from gallery
  static Future<YoImagePickerResult?> pickFromGallery({
    YoImagePickerConfig config = YoImagePickerConfig.defaultConfig,
  }) async {
    final XFile? file = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: config.maxWidth,
      maxHeight: config.maxHeight,
      imageQuality: config.imageQuality,
      requestFullMetadata: config.requestFullMetadata,
    );

    if (file == null) return null;
    return YoImagePickerResult(file: file);
  }

  // ==================== PICK MULTIPLE IMAGES ====================

  /// Pick any media (image or video) from gallery
  static Future<YoImagePickerResult?> pickMedia({
    YoImagePickerConfig config = YoImagePickerConfig.defaultConfig,
  }) async {
    final XFile? file = await _picker.pickMedia(
      maxWidth: config.maxWidth,
      maxHeight: config.maxHeight,
      imageQuality: config.imageQuality,
      requestFullMetadata: config.requestFullMetadata,
    );

    if (file == null) return null;
    return YoImagePickerResult(file: file);
  }

  // ==================== SHOW SOURCE PICKER DIALOG ====================

  /// Pick multiple images from gallery
  static Future<YoMultiImagePickerResult?> pickMultiple({
    YoImagePickerConfig config = YoImagePickerConfig.defaultConfig,
    int? limit,
  }) async {
    final List<XFile> files = await _picker.pickMultiImage(
      maxWidth: config.maxWidth,
      maxHeight: config.maxHeight,
      imageQuality: config.imageQuality,
      requestFullMetadata: config.requestFullMetadata,
      limit: limit,
    );

    if (files.isEmpty) return null;
    return YoMultiImagePickerResult(files: files);
  }

  /// Pick multiple media from gallery
  static Future<YoMultiImagePickerResult?> pickMultipleMedia({
    YoImagePickerConfig config = YoImagePickerConfig.defaultConfig,
    int? limit,
  }) async {
    final List<XFile> files = await _picker.pickMultipleMedia(
      maxWidth: config.maxWidth,
      maxHeight: config.maxHeight,
      imageQuality: config.imageQuality,
      requestFullMetadata: config.requestFullMetadata,
      limit: limit,
    );

    if (files.isEmpty) return null;
    return YoMultiImagePickerResult(files: files);
  }

  // ==================== VIDEO PICKING ====================

  /// Pick video from camera
  static Future<YoImagePickerResult?> pickVideoFromCamera({
    Duration? maxDuration,
  }) async {
    final XFile? file = await _picker.pickVideo(
      source: ImageSource.camera,
      maxDuration: maxDuration,
    );

    if (file == null) return null;
    return YoImagePickerResult(file: file);
  }

  /// Pick video from gallery
  static Future<YoImagePickerResult?> pickVideoFromGallery({
    Duration? maxDuration,
  }) async {
    final XFile? file = await _picker.pickVideo(
      source: ImageSource.gallery,
      maxDuration: maxDuration,
    );

    if (file == null) return null;
    return YoImagePickerResult(file: file);
  }

  /// Show dialog to select image source
  static Future<YoImagePickerResult?> showSourceDialog({
    required BuildContext context,
    YoImagePickerConfig config = YoImagePickerConfig.defaultConfig,
    String title = 'Select Image Source',
  }) async {
    final source = await showDialog<YoImageSource>(
      context: context,
      builder: (context) => _YoImageSourceDialog(title: title),
    );

    if (source == null) return null;
    return pick(source: source, config: config);
  }

  /// Show bottom sheet to select image source
  static Future<YoImagePickerResult?> showSourcePicker({
    required BuildContext context,
    YoImagePickerConfig config = YoImagePickerConfig.defaultConfig,
    String title = 'Select Image Source',
    String cameraLabel = 'Camera',
    String galleryLabel = 'Gallery',
    String cancelLabel = 'Cancel',
    bool showCancel = true,
  }) async {
    final source = await showModalBottomSheet<YoImageSource>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _YoImageSourcePicker(
        title: title,
        cameraLabel: cameraLabel,
        galleryLabel: galleryLabel,
        cancelLabel: cancelLabel,
        showCancel: showCancel,
      ),
    );

    if (source == null) return null;
    return pick(source: source, config: config);
  }
}

/// Image picker button widget
class YoImagePickerButton extends StatelessWidget {
  /// Currently selected image path
  final String? imagePath;

  /// Callback when image is selected
  final ValueChanged<YoImagePickerResult> onImageSelected;

  /// Picker configuration
  final YoImagePickerConfig config;

  /// Label text
  final String? labelText;

  /// Hint text
  final String hintText;

  /// Placeholder icon
  final IconData placeholderIcon;

  /// Preview size
  final double previewSize;

  /// Border radius
  final double borderRadius;

  /// Allow multiple images
  final bool multiple;

  /// Show source picker
  final bool showSourcePicker;

  const YoImagePickerButton({
    super.key,
    this.imagePath,
    required this.onImageSelected,
    this.config = YoImagePickerConfig.defaultConfig,
    this.labelText,
    this.hintText = 'Select image',
    this.placeholderIcon = Icons.add_a_photo,
    this.previewSize = 80,
    this.borderRadius = 12,
    this.multiple = false,
    this.showSourcePicker = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelText != null) ...[
          YoText(
            labelText!,
            style: context.yoLabelMedium.copyWith(
              fontWeight: FontWeight.w500,
              color: context.gray600,
            ),
          ),
          const SizedBox(height: 8),
        ],
        GestureDetector(
          onTap: () => _pickImage(context),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: context.backgroundColor,
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(color: context.gray300),
            ),
            child: Row(
              children: [
                // Preview
                Container(
                  width: previewSize,
                  height: previewSize,
                  decoration: BoxDecoration(
                    color: context.gray100,
                    borderRadius: BorderRadius.circular(borderRadius - 4),
                    border: Border.all(color: context.gray200),
                    image: imagePath != null && !kIsWeb
                        ? DecorationImage(
                            image: FileImage(File(imagePath!)),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: imagePath == null
                      ? Icon(placeholderIcon, size: 32, color: context.gray400)
                      : null,
                ),
                const SizedBox(width: 16),
                // Text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      YoText(
                        imagePath != null ? 'Image selected' : hintText,
                        style: context.yoBodyMedium.copyWith(
                          color: imagePath != null
                              ? context.textColor
                              : context.gray400,
                          fontWeight: imagePath != null
                              ? FontWeight.w500
                              : FontWeight.normal,
                        ),
                      ),
                      const SizedBox(height: 4),
                      YoText(
                        imagePath != null
                            ? 'Tap to change'
                            : 'Tap to select image',
                        style: context.yoBodySmall.copyWith(
                          color: context.gray500,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_drop_down, color: context.gray500),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _pickImage(BuildContext context) async {
    YoImagePickerResult? result;

    if (showSourcePicker) {
      result = await YoImagePicker.showSourcePicker(
        context: context,
        config: config,
      );
    } else {
      result = await YoImagePicker.pickFromGallery(config: config);
    }

    if (result != null) {
      onImageSelected(result);
    }
  }
}

/// Image picker configuration
class YoImagePickerConfig {
  /// Default configuration
  static const YoImagePickerConfig defaultConfig = YoImagePickerConfig();

  /// Compressed image for upload
  static const YoImagePickerConfig compressed = YoImagePickerConfig(
    maxWidth: 1024,
    maxHeight: 1024,
    imageQuality: 80,
  );

  /// High quality image
  static const YoImagePickerConfig highQuality = YoImagePickerConfig(
    imageQuality: 100,
    requestFullMetadata: true,
  );

  /// Thumbnail size
  static const YoImagePickerConfig thumbnail = YoImagePickerConfig(
    maxWidth: 256,
    maxHeight: 256,
    imageQuality: 70,
  );

  /// Avatar size
  static const YoImagePickerConfig avatar = YoImagePickerConfig(
    maxWidth: 512,
    maxHeight: 512,
    imageQuality: 85,
  );

  /// Maximum width of the image
  final double? maxWidth;

  /// Maximum height of the image
  final double? maxHeight;

  /// Image quality (0-100)
  final int? imageQuality;

  /// Preferred camera device
  final CameraDevice preferredCameraDevice;

  /// Request full metadata
  final bool requestFullMetadata;

  const YoImagePickerConfig({
    this.maxWidth,
    this.maxHeight,
    this.imageQuality,
    this.preferredCameraDevice = CameraDevice.rear,
    this.requestFullMetadata = true,
  });
}

/// Image picker result
class YoImagePickerResult {
  /// The picked file
  final XFile file;

  const YoImagePickerResult({required this.file});

  /// MIME type
  String? get mimeType => file.mimeType;

  /// File name
  String get name => file.name;

  /// File path
  String get path => file.path;

  /// Read file as bytes
  Future<Uint8List> readAsBytes() => file.readAsBytes();
}

/// Image source for picker
enum YoImageSource {
  camera,
  gallery,
}

/// Multiple image picker result
class YoMultiImagePickerResult {
  /// List of picked files
  final List<XFile> files;

  const YoMultiImagePickerResult({required this.files});

  /// Number of files
  int get count => files.length;

  /// File paths
  List<String> get paths => files.map((f) => f.path).toList();

  /// Get as single results
  List<YoImagePickerResult> get results =>
      files.map((f) => YoImagePickerResult(file: f)).toList();
}

/// Dialog source picker
class _YoImageSourceDialog extends StatelessWidget {
  final String title;

  const _YoImageSourceDialog({required this.title});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.camera_alt, color: context.primaryColor),
            title: const Text('Camera'),
            subtitle: const Text('Take a photo'),
            onTap: () => Navigator.pop(context, YoImageSource.camera),
          ),
          ListTile(
            leading: Icon(Icons.photo_library, color: context.primaryColor),
            title: const Text('Gallery'),
            subtitle: const Text('Choose from gallery'),
            onTap: () => Navigator.pop(context, YoImageSource.gallery),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}

/// Bottom sheet source picker
class _YoImageSourcePicker extends StatelessWidget {
  final String title;
  final String cameraLabel;
  final String galleryLabel;
  final String cancelLabel;
  final bool showCancel;

  const _YoImageSourcePicker({
    required this.title,
    required this.cameraLabel,
    required this.galleryLabel,
    required this.cancelLabel,
    required this.showCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.backgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: context.gray300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Title
              YoText(
                title,
                style:
                    context.yoTitleMedium.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 24),
              // Options
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildOption(
                    context,
                    icon: Icons.camera_alt,
                    label: cameraLabel,
                    onTap: () => Navigator.pop(context, YoImageSource.camera),
                  ),
                  _buildOption(
                    context,
                    icon: Icons.photo_library,
                    label: galleryLabel,
                    onTap: () => Navigator.pop(context, YoImageSource.gallery),
                  ),
                ],
              ),
              if (showCancel) ...[
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(cancelLabel),
                  ),
                ),
              ],
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOption(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: context.primaryColor.withAlpha(20),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: context.primaryColor.withAlpha(40)),
        ),
        child: Column(
          children: [
            Icon(icon, size: 48, color: context.primaryColor),
            const SizedBox(height: 8),
            YoText(
              label,
              style: context.yoBodyMedium.copyWith(
                fontWeight: FontWeight.w500,
                color: context.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
