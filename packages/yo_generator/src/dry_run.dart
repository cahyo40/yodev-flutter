import 'dart:io';

import 'package:path/path.dart' as path;

import 'utils.dart';

/// Dry-run mode controller
///
/// When enabled, all file writes and directory creations are logged
/// but not actually executed. This allows users to preview what
/// changes a generator command would make.

// ignore_for_file: avoid_classes_with_only_static_members

class DryRun {
  static bool _enabled = false;
  static final List<DryRunAction> _actions = [];

  /// Whether dry-run mode is currently enabled
  static bool get isEnabled => _enabled;

  /// Get all recorded actions
  static List<DryRunAction> get actions => List.unmodifiable(_actions);

  /// Enable dry-run mode
  static void enable() {
    _enabled = true;
    _actions.clear();
  }

  /// Disable dry-run mode and clear actions
  static void disable() {
    _enabled = false;
    _actions.clear();
  }

  /// Create directory (or log if dry-run)
  static void ensureDirectory(String dirPath) {
    if (_enabled) {
      _actions.add(
        DryRunAction(
          type: DryRunActionType.createDirectory,
          path: dirPath,
        ),
      );
      Console.info('📁 [DRY-RUN] Would create directory: $dirPath');
      return;
    }
    final dir = Directory(dirPath);
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
      print('📁 Created directory: $dirPath');
    }
  }

  /// Write file (or log if dry-run)
  static void writeFile(String filePath, String content) {
    if (_enabled) {
      final exists = File(filePath).existsSync();
      _actions.add(
        DryRunAction(
          type: exists
              ? DryRunActionType.overwriteFile
              : DryRunActionType.createFile,
          path: filePath,
          size: content.length,
        ),
      );
      Console.info(
        '📄 [DRY-RUN] Would ${exists ? 'overwrite' : 'create'} file: $filePath '
        '(${_formatSize(content.length)})',
      );
      return;
    }
    final file = File(filePath);
    ensureDirectory(path.dirname(filePath));
    file.writeAsStringSync(content);
    print('📄 Created file: $filePath');
  }

  /// Delete file (or log if dry-run)
  static void deleteFile(String filePath) {
    if (_enabled) {
      _actions.add(
        DryRunAction(
          type: DryRunActionType.deleteFile,
          path: filePath,
        ),
      );
      Console.info('🗑️  [DRY-RUN] Would delete file: $filePath');
      return;
    }
    final file = File(filePath);
    if (file.existsSync()) {
      file.deleteSync();
      print('🗑️  Deleted file: $filePath');
    }
  }

  /// Print summary of all actions that would be taken
  static void printSummary() {
    if (!_enabled || _actions.isEmpty) return;

    final creates =
        _actions.where((a) => a.type == DryRunActionType.createFile).length;
    final overwrites =
        _actions.where((a) => a.type == DryRunActionType.overwriteFile).length;
    final dirs = _actions
        .where((a) => a.type == DryRunActionType.createDirectory)
        .length;
    final deletes =
        _actions.where((a) => a.type == DryRunActionType.deleteFile).length;

    Console.header('DRY-RUN SUMMARY');
    if (creates > 0) Console.info('  📄 New files:       $creates');
    if (overwrites > 0) Console.info('  📝 Overwrites:      $overwrites');
    if (dirs > 0) Console.info('  📁 New directories: $dirs');
    if (deletes > 0) Console.info('  🗑️  Deletions:      $deletes');
    Console.info('  ─────────────────────────');
    Console.info('  📊 Total actions:   ${_actions.length}');
    Console.info('');
    Console.info('Run without --dry-run to apply these changes.');
  }

  static String _formatSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}

/// Types of dry-run actions
enum DryRunActionType {
  createFile,
  overwriteFile,
  createDirectory,
  deleteFile,
}

/// A single dry-run action record
class DryRunAction {
  DryRunAction({
    required this.type,
    required this.path,
    this.size,
  });
  final DryRunActionType type;
  final String path;
  final int? size;

  @override
  String toString() =>
      '${type.name}: $path${size != null ? ' ($size bytes)' : ''}';
}
