// File: yo_file_picker.dart
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:yo_ui/yo_ui.dart';

/// Drag and drop file zone
class YoFileDropZone extends StatefulWidget {
  /// Callback when files are dropped/selected
  final ValueChanged<List<YoFilePickerResult>> onFilesSelected;

  /// File type filter
  final YoFileType fileType;

  /// Custom allowed extensions
  final List<String>? allowedExtensions;

  /// Allow multiple files
  final bool multiple;

  /// Zone height
  final double height;

  /// Border radius
  final double borderRadius;

  /// Icon
  final IconData icon;

  /// Title text
  final String title;

  /// Subtitle text
  final String subtitle;

  /// Load file data
  final bool withData;

  const YoFileDropZone({
    super.key,
    required this.onFilesSelected,
    this.fileType = YoFileType.any,
    this.allowedExtensions,
    this.multiple = false,
    this.height = 150,
    this.borderRadius = 12,
    this.icon = Icons.cloud_upload_outlined,
    this.title = 'Drop files here',
    this.subtitle = 'or click to browse',
    this.withData = false,
  });

  @override
  State<YoFileDropZone> createState() => _YoFileDropZoneState();
}

/// File helper utilities
class YoFileHelper {
  YoFileHelper._();

  /// Format file size to human readable string
  static String formatFileSize(int bytes, {int decimals = 1}) {
    if (bytes <= 0) return '0 B';

    const suffixes = ['B', 'KB', 'MB', 'GB', 'TB'];
    var i = 0;
    double size = bytes.toDouble();

    while (size >= 1024 && i < suffixes.length - 1) {
      size /= 1024;
      i++;
    }

    return '${size.toStringAsFixed(decimals)} ${suffixes[i]}';
  }

  /// Get color for file type
  static Color getFileColor(String? extension, BuildContext context) {
    final ext = extension?.toLowerCase();

    // Images
    if (['jpg', 'jpeg', 'png', 'gif', 'webp', 'bmp', 'svg'].contains(ext)) {
      return Colors.blue;
    }

    // Videos
    if (['mp4', 'mov', 'avi', 'mkv', 'wmv', 'flv', 'webm'].contains(ext)) {
      return Colors.purple;
    }

    // Audio
    if (['mp3', 'wav', 'aac', 'flac', 'ogg', 'm4a', 'wma'].contains(ext)) {
      return Colors.orange;
    }

    // PDF
    if (ext == 'pdf') return Colors.red;

    // Documents
    if (['doc', 'docx'].contains(ext)) return Colors.blue;
    if (['xls', 'xlsx'].contains(ext)) return Colors.green;
    if (['ppt', 'pptx'].contains(ext)) return Colors.deepOrange;

    // Archives
    if (['zip', 'rar', '7z', 'tar', 'gz'].contains(ext)) return Colors.brown;

    return context.gray600;
  }

  /// Get icon for file extension
  static IconData getFileIcon(String? extension) {
    final ext = extension?.toLowerCase();

    // Images
    if (['jpg', 'jpeg', 'png', 'gif', 'webp', 'bmp', 'svg'].contains(ext)) {
      return Icons.image;
    }

    // Videos
    if (['mp4', 'mov', 'avi', 'mkv', 'wmv', 'flv', 'webm'].contains(ext)) {
      return Icons.video_file;
    }

    // Audio
    if (['mp3', 'wav', 'aac', 'flac', 'ogg', 'm4a', 'wma'].contains(ext)) {
      return Icons.audio_file;
    }

    // PDF
    if (ext == 'pdf') return Icons.picture_as_pdf;

    // Documents
    if (['doc', 'docx'].contains(ext)) return Icons.description;
    if (['xls', 'xlsx'].contains(ext)) return Icons.table_chart;
    if (['ppt', 'pptx'].contains(ext)) return Icons.slideshow;
    if (['txt', 'rtf'].contains(ext)) return Icons.text_snippet;

    // Archives
    if (['zip', 'rar', '7z', 'tar', 'gz'].contains(ext)) {
      return Icons.folder_zip;
    }

    // Code
    if ([
      'html',
      'css',
      'js',
      'json',
      'xml',
      'dart',
      'py',
      'java',
      'kt',
      'swift'
    ].contains(ext)) {
      return Icons.code;
    }

    return Icons.insert_drive_file;
  }
}

/// File list tile widget for displaying selected files
class YoFileListTile extends StatelessWidget {
  /// File result
  final YoFilePickerResult file;

  /// On remove callback
  final VoidCallback? onRemove;

  /// On tap callback
  final VoidCallback? onTap;

  /// Show remove button
  final bool showRemove;

  const YoFileListTile({
    super.key,
    required this.file,
    this.onRemove,
    this.onTap,
    this.showRemove = true,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color:
              YoFileHelper.getFileColor(file.extension, context).withAlpha(30),
          borderRadius: BorderRadius.circular(context.yoRadiusMd),
        ),
        child: Icon(
          YoFileHelper.getFileIcon(file.extension),
          color: YoFileHelper.getFileColor(file.extension, context),
          size: 20,
        ),
      ),
      title: YoText.bodyMedium(
        file.name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: YoText.bodySmall(file.formattedSize),
      trailing: showRemove && onRemove != null
          ? IconButton(
              onPressed: onRemove,
              icon: Icon(Icons.close, color: context.gray500),
            )
          : null,
    );
  }
}

/// File picker utility class
class YoFilePicker {
  YoFilePicker._();

  /// Clear file picker cache
  static Future<bool?> clearCache() {
    return FilePicker.platform.clearTemporaryFiles();
  }

  // ==================== PICK SINGLE FILE ====================

  /// Pick any file
  static Future<YoFilePickerResult?> pickAny({bool withData = false}) {
    return pickFile(type: YoFileType.any, withData: withData);
  }

  /// Pick audio file
  static Future<YoFilePickerResult?> pickAudio({bool withData = false}) {
    return pickFile(type: YoFileType.audio, withData: withData);
  }

  /// Pick file with custom extensions
  static Future<YoFilePickerResult?> pickCustom({
    required List<String> extensions,
    bool withData = false,
  }) {
    return pickFile(
      type: YoFileType.custom,
      allowedExtensions: extensions,
      withData: withData,
    );
  }

  /// Pick a directory (not supported on web)
  static Future<String?> pickDirectory() async {
    if (kIsWeb) return null;
    return await FilePicker.platform.getDirectoryPath();
  }

  /// Pick document file
  static Future<YoFilePickerResult?> pickDocument({bool withData = false}) {
    return pickFile(
      type: YoFileType.custom,
      allowedExtensions: [
        'pdf',
        'doc',
        'docx',
        'xls',
        'xlsx',
        'ppt',
        'pptx',
        'txt'
      ],
      withData: withData,
    );
  }

  /// Pick a single file
  static Future<YoFilePickerResult?> pickFile({
    YoFileType type = YoFileType.any,
    List<String>? allowedExtensions,
    bool withData = false,
    bool withReadStream = false,
  }) async {
    final result = await FilePicker.platform.pickFiles(
      type: _mapFileType(type),
      allowedExtensions: type == YoFileType.custom ? allowedExtensions : null,
      withData: withData,
      withReadStream: withReadStream,
      allowMultiple: false,
    );

    if (result == null || result.files.isEmpty) return null;
    return YoFilePickerResult(file: result.files.first);
  }

  /// Pick image file
  static Future<YoFilePickerResult?> pickImage({bool withData = false}) {
    return pickFile(type: YoFileType.image, withData: withData);
  }

  /// Pick multiple files
  static Future<YoMultiFilePickerResult?> pickMultiple({
    YoFileType type = YoFileType.any,
    List<String>? allowedExtensions,
    bool withData = false,
    bool withReadStream = false,
  }) async {
    final result = await FilePicker.platform.pickFiles(
      type: _mapFileType(type),
      allowedExtensions: type == YoFileType.custom ? allowedExtensions : null,
      withData: withData,
      withReadStream: withReadStream,
      allowMultiple: true,
    );

    if (result == null || result.files.isEmpty) return null;
    return YoMultiFilePickerResult(files: result.files);
  }

  // ==================== PICK MULTIPLE FILES ====================

  /// Pick multiple images
  static Future<YoMultiFilePickerResult?> pickMultipleImages({
    bool withData = false,
  }) {
    return pickMultiple(type: YoFileType.image, withData: withData);
  }

  /// Pick PDF file
  static Future<YoFilePickerResult?> pickPdf({bool withData = false}) {
    return pickFile(
      type: YoFileType.custom,
      allowedExtensions: ['pdf'],
      withData: withData,
    );
  }

  // ==================== DIRECTORY PICKING ====================

  /// Pick video file
  static Future<YoFilePickerResult?> pickVideo({bool withData = false}) {
    return pickFile(type: YoFileType.video, withData: withData);
  }

  // ==================== SAVE FILE ====================

  /// Save file dialog (not supported on web)
  static Future<String?> saveFile({
    String? dialogTitle,
    String? fileName,
    List<String>? allowedExtensions,
    Uint8List? bytes,
  }) async {
    return await FilePicker.platform.saveFile(
      dialogTitle: dialogTitle,
      fileName: fileName,
      allowedExtensions: allowedExtensions,
      bytes: bytes,
    );
  }

  // ==================== CLEAR CACHE ====================

  static FileType _mapFileType(YoFileType type) {
    switch (type) {
      case YoFileType.any:
        return FileType.any;
      case YoFileType.media:
        return FileType.media;
      case YoFileType.image:
        return FileType.image;
      case YoFileType.video:
        return FileType.video;
      case YoFileType.audio:
        return FileType.audio;
      case YoFileType.custom:
        return FileType.custom;
    }
  }
}

/// File picker button widget
class YoFilePickerButton extends StatelessWidget {
  /// Currently selected file
  final YoFilePickerResult? selectedFile;

  /// Callback when file is selected
  final ValueChanged<YoFilePickerResult> onFileSelected;

  /// File type filter
  final YoFileType fileType;

  /// Custom allowed extensions (when fileType is custom)
  final List<String>? allowedExtensions;

  /// Label text
  final String? labelText;

  /// Hint text
  final String hintText;

  /// Show file preview/icon
  final bool showPreview;

  /// Border radius
  final double borderRadius;

  /// Load file data
  final bool withData;

  const YoFilePickerButton({
    super.key,
    this.selectedFile,
    required this.onFileSelected,
    this.fileType = YoFileType.any,
    this.allowedExtensions,
    this.labelText,
    this.hintText = 'Select file',
    this.showPreview = true,
    this.borderRadius = 12,
    this.withData = false,
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
          const YoSpace.height(8),
        ],
        GestureDetector(
          onTap: () => _pickFile(context),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: context.backgroundColor,
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(color: context.gray300),
            ),
            child: Row(
              children: [
                // Icon
                if (showPreview)
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: selectedFile != null
                          ? YoFileHelper.getFileColor(
                              selectedFile!.extension,
                              context,
                            ).withAlpha(30)
                          : context.gray100,
                      borderRadius: BorderRadius.circular(context.yoRadiusMd),
                    ),
                    child: Icon(
                      selectedFile != null
                          ? YoFileHelper.getFileIcon(selectedFile!.extension)
                          : Icons.upload_file,
                      size: 24,
                      color: selectedFile != null
                          ? YoFileHelper.getFileColor(
                              selectedFile!.extension,
                              context,
                            )
                          : context.gray400,
                    ),
                  ),
                if (showPreview) const YoSpace.width(16),
                // Text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      YoText(
                        selectedFile?.name ?? hintText,
                        style: context.yoBodyMedium.copyWith(
                          color: selectedFile != null
                              ? context.textColor
                              : context.gray400,
                          fontWeight: selectedFile != null
                              ? FontWeight.w500
                              : FontWeight.normal,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (selectedFile != null) ...[
                        const YoSpace.height(4),
                        YoText(
                          selectedFile!.formattedSize,
                          style: context.yoBodySmall.copyWith(
                            color: context.gray500,
                          ),
                        ),
                      ],
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

  Future<void> _pickFile(BuildContext context) async {
    final result = await YoFilePicker.pickFile(
      type: fileType,
      allowedExtensions: allowedExtensions,
      withData: withData,
    );

    if (result != null) {
      onFileSelected(result);
    }
  }
}

/// File picker result
class YoFilePickerResult {
  /// The picked file
  final PlatformFile file;

  const YoFilePickerResult({required this.file});

  /// File bytes (for web)
  Uint8List? get bytes => file.bytes;

  /// File extension
  String? get extension => file.extension;

  /// Get file size as formatted string
  String get formattedSize => YoFileHelper.formatFileSize(size);

  /// Check if file is audio
  bool get isAudio {
    final ext = extension?.toLowerCase();
    return ['mp3', 'wav', 'aac', 'flac', 'ogg', 'm4a', 'wma'].contains(ext);
  }

  /// Check if file is document
  bool get isDocument {
    final ext = extension?.toLowerCase();
    return ['pdf', 'doc', 'docx', 'xls', 'xlsx', 'ppt', 'pptx', 'txt', 'rtf']
        .contains(ext);
  }

  /// Check if file is image
  bool get isImage {
    final ext = extension?.toLowerCase();
    return ['jpg', 'jpeg', 'png', 'gif', 'webp', 'bmp', 'svg'].contains(ext);
  }

  /// Check if file is video
  bool get isVideo {
    final ext = extension?.toLowerCase();
    return ['mp4', 'mov', 'avi', 'mkv', 'wmv', 'flv', 'webm'].contains(ext);
  }

  /// File name
  String get name => file.name;

  /// File path (may be null on web)
  String? get path => file.path;

  /// File size in bytes
  int get size => file.size;
}

/// File type filter
enum YoFileType {
  /// Any file type
  any,

  /// Media files (images and videos)
  media,

  /// Image files only
  image,

  /// Video files only
  video,

  /// Audio files only
  audio,

  /// Custom extensions
  custom,
}

/// Multiple file picker result
class YoMultiFilePickerResult {
  /// List of picked files
  final List<PlatformFile> files;

  const YoMultiFilePickerResult({required this.files});

  /// Number of files
  int get count => files.length;

  /// Formatted total size
  String get formattedTotalSize => YoFileHelper.formatFileSize(totalSize);

  /// Get as single results
  List<YoFilePickerResult> get results =>
      files.map((f) => YoFilePickerResult(file: f)).toList();

  /// Total size in bytes
  int get totalSize => files.fold(0, (sum, f) => sum + f.size);
}

class _YoFileDropZoneState extends State<YoFileDropZone> {
  final bool _isDragging = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _pickFiles,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: widget.height,
        decoration: BoxDecoration(
          color:
              _isDragging ? context.primaryColor.withAlpha(20) : context.gray50,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          border: Border.all(
            color: _isDragging ? context.primaryColor : context.gray300,
            width: _isDragging ? 2 : 1,
            // Dashed effect simulation
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              widget.icon,
              size: 48,
              color: _isDragging ? context.primaryColor : context.gray400,
            ),
            const YoSpace.height(12),
            YoText(
              widget.title,
              style: context.yoBodyMedium.copyWith(
                fontWeight: FontWeight.w500,
                color: _isDragging ? context.primaryColor : context.textColor,
              ),
            ),
            const YoSpace.height(4),
            YoText(
              widget.subtitle,
              style: context.yoBodySmall.copyWith(
                color: context.gray500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickFiles() async {
    if (widget.multiple) {
      final result = await YoFilePicker.pickMultiple(
        type: widget.fileType,
        allowedExtensions: widget.allowedExtensions,
        withData: widget.withData,
      );
      if (result != null) {
        widget.onFilesSelected(result.results);
      }
    } else {
      final result = await YoFilePicker.pickFile(
        type: widget.fileType,
        allowedExtensions: widget.allowedExtensions,
        withData: widget.withData,
      );
      if (result != null) {
        widget.onFilesSelected([result]);
      }
    }
  }
}
