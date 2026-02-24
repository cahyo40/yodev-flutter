import 'package:flutter/material.dart';
import 'package:yo_ui/yo_ui.dart';

/// File upload widget with progress indicator
class YoFileUpload extends StatefulWidget {
  final Function(List<YoFilePickerResult>)? onFilesSelected;
  final bool multiple;
  final YoFileType fileType;
  final List<String>? allowedExtensions;
  final String? maxSize;
  final String? title;
  final String? subtitle;
  final double height;
  final Color? borderColor;
  final Color? backgroundColor;

  const YoFileUpload({
    super.key,
    this.onFilesSelected,
    this.multiple = false,
    this.fileType = YoFileType.any,
    this.allowedExtensions,
    this.maxSize,
    this.title,
    this.subtitle,
    this.height = 150,
    this.borderColor,
    this.backgroundColor,
  });

  @override
  State<YoFileUpload> createState() => _YoFileUploadState();
}

class _YoFileUploadState extends State<YoFileUpload> {
  List<YoFilePickerResult> _selectedFiles = [];
  final bool _isDragging = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: _pickFiles,
          child: Container(
            height: widget.height,
            decoration: BoxDecoration(
              color: _isDragging
                  ? context.primaryColor.withAlpha(26)
                  : widget.backgroundColor ?? context.gray50,
              border: Border.all(
                color: _isDragging
                    ? context.primaryColor
                    : widget.borderColor ?? context.gray300,
                width: 2,
                style: BorderStyle.solid,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.cloud_upload_outlined,
                    size: 48,
                    color: context.gray400,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.title ?? 'Click to upload files',
                    style: context.yoBodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (widget.subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      widget.subtitle!,
                      style: context.yoBodySmall.copyWith(
                        color: context.gray500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
        if (_selectedFiles.isNotEmpty) ...[
          const SizedBox(height: 16),
          ..._selectedFiles.asMap().entries.map((entry) {
            final index = entry.key;
            final file = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: YoFileListTile(
                file: file,
                onRemove: () => _removeFile(index),
              ),
            );
          }),
        ],
      ],
    );
  }

  Future<void> _pickFiles() async {
    try {
      if (widget.multiple) {
        final result = await YoFilePicker.pickMultiple(
          type: widget.fileType,
        );
        if (result != null) {
          // Convert PlatformFile list to YoFilePickerResult list
          final fileResults = result.files
              .map((pf) => YoFilePickerResult(
                    file: pf,
                  ))
              .toList();
          setState(() => _selectedFiles = fileResults);
          widget.onFilesSelected?.call(fileResults);
        }
      } else {
        final result = await YoFilePicker.pickFile(
          type: widget.fileType,
        );
        if (result != null) {
          setState(() => _selectedFiles = [result]);
          widget.onFilesSelected?.call([result]);
        }
      }
    } catch (e) {
      debugPrint('Error picking files: $e');
    }
  }

  void _removeFile(int index) {
    setState(() {
      _selectedFiles.removeAt(index);
    });
    widget.onFilesSelected?.call(_selectedFiles);
  }
}
