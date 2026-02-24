import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:recase/recase.dart';

import 'dry_run.dart';

// ignore_for_file: avoid_classes_with_only_static_members

/// Console printing utilities
class Console {
  static void error(String message) {
    print('❌ $message');
  }

  static void header(String message) {
    print('\n${'=' * 50}');
    print('  $message');
    print('${'=' * 50}\n');
  }

  static void info(String message) {
    print('ℹ️  $message');
  }

  static void success(String message) {
    print('✅ $message');
  }

  static void warning(String message) {
    print('⚠️  $message');
  }
}

/// Utility class for name conversions and file operations
class YoUtils {
  /// Update pubspec.yaml with dependencies
  static void addDependency(
    String projectPath,
    String dependency,
    String version,
  ) {
    final pubspecPath = path.join(projectPath, 'pubspec.yaml');
    var content = readFile(pubspecPath);

    if (!content.contains('$dependency:')) {
      // Find dependencies section and add
      final dependenciesIndex = content.indexOf('dependencies:');
      if (dependenciesIndex != -1) {
        final insertIndex = content.indexOf('\n', dependenciesIndex) + 1;
        content =
            '${content.substring(0, insertIndex)}  $dependency: $version\n${content.substring(insertIndex)}';
        writeFile(pubspecPath, content);
        print('📦 Added dependency: $dependency: $version');
      }
    }
  }

  /// Update pubspec.yaml with dev dependencies
  static void addDevDependency(
    String projectPath,
    String dependency,
    String version,
  ) {
    final pubspecPath = path.join(projectPath, 'pubspec.yaml');
    var content = readFile(pubspecPath);

    if (!content.contains('$dependency:')) {
      final devDependenciesIndex = content.indexOf('dev_dependencies:');
      if (devDependenciesIndex != -1) {
        final insertIndex = content.indexOf('\n', devDependenciesIndex) + 1;
        content =
            '${content.substring(0, insertIndex)}  $dependency: $version\n${content.substring(insertIndex)}';
        writeFile(pubspecPath, content);
        print('📦 Added dev dependency: $dependency: $version');
      }
    }
  }

  /// Append content to file
  static void appendToFile(String filePath, String content) {
    final file = File(filePath);
    if (file.existsSync()) {
      final existingContent = file.readAsStringSync();
      if (!existingContent.contains(content.trim())) {
        file.writeAsStringSync('$existingContent\n$content');
        print('📝 Updated file: $filePath');
      }
    } else {
      writeFile(filePath, content);
    }
  }

  /// Create directory if not exists
  static void ensureDirectory(String dirPath) {
    if (DryRun.isEnabled) {
      DryRun.ensureDirectory(dirPath);
      return;
    }
    final dir = Directory(dirPath);
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
      print('📁 Created directory: $dirPath');
    }
  }

  /// Check if a feature directory exists
  static bool featureExists(String featuresPath, String featureName) {
    final featurePath = path.join(featuresPath, featureName.toLowerCase());
    return Directory(featurePath).existsSync();
  }

  /// Check if file exists
  static bool fileExists(String filePath) => File(filePath).existsSync();

  /// Get feature name from input
  /// Example: 'home' -> 'home', 'setting.profile' -> 'setting'
  static String getFeatureName(String input) {
    final parts = input.split('.');
    return parts.first.toLowerCase();
  }

  /// Get import path relative to lib
  static String getImportPath(String packageName, String relativePath) =>
      'package:$packageName/$relativePath';

  /// Get page name from input
  /// Example: 'home' -> 'home', 'setting.profile' -> 'profile'
  static String getPageName(String input) {
    final parts = input.split('.');
    return parts.length > 1 ? parts.sublist(1).join('_') : parts.first;
  }

  /// Check if a page exists in a feature
  static bool pageExists(String featurePath, String fileName) {
    final pagePath = path.join(
      featurePath,
      'presentation',
      'pages',
      '${fileName}_page.dart',
    );
    return File(pagePath).existsSync();
  }

  /// Parse command input like 'page:home' or 'model:user'
  static (String command, String name) parseCommand(String input) {
    final parts = input.split(':');
    if (parts.length != 2) {
      throw ArgumentError('Invalid command format. Use: command:name');
    }
    return (parts[0], parts[1]);
  }

  /// Read file content
  static String readFile(String filePath) {
    final file = File(filePath);
    if (file.existsSync()) {
      return file.readAsStringSync();
    }
    return '';
  }

  /// Convert to camelCase
  /// Example: 'setting_profile' -> 'settingProfile'
  static String toCamelCase(String input) => ReCase(input).camelCase;

  /// Convert dot notation to PascalCase class name
  /// Example: 'setting.profile' -> 'SettingProfile'
  static String toClassName(String input) =>
      input.split('.').map((part) => ReCase(part).pascalCase).join();

  /// Convert dot notation to snake_case file name
  /// Example: 'setting.profile' -> 'setting_profile'
  static String toFileName(String input) =>
      input.split('.').map((part) => ReCase(part).snakeCase).join('_');

  /// Convert to PascalCase
  /// Example: 'setting_profile' -> 'SettingProfile'
  static String toPascalCase(String input) => ReCase(input).pascalCase;

  /// Convert to snake_case
  /// Example: 'SettingProfile' -> 'setting_profile'
  static String toSnakeCase(String input) => ReCase(input).snakeCase;

  /// Validate that a feature exists before generating components
  static bool validateFeatureExists(String featuresPath, String featureName) {
    if (!featureExists(featuresPath, featureName)) {
      Console.error('Feature "$featureName" does not exist.');
      Console.info('Create it first with: dart run yo.dart page:$featureName');
      return false;
    }
    return true;
  }

  /// Validate that a page exists before generating related components
  static bool validatePageExists(
    String featurePath,
    String fileName,
    String pageName,
  ) {
    if (!pageExists(featurePath, fileName)) {
      Console.error('Page "$pageName" does not exist in this feature.');
      Console.info('Create it first with: dart run yo.dart page:$pageName');
      return false;
    }
    return true;
  }

  /// Write file with content
  static void writeFile(String filePath, String content) {
    if (DryRun.isEnabled) {
      DryRun.writeFile(filePath, content);
      return;
    }
    final file = File(filePath);
    ensureDirectory(path.dirname(filePath));
    file.writeAsStringSync(content);
    print('📄 Created file: $filePath');
  }

  /// Write file with content (with overwrite check)
  /// Returns true if file was written, false if skipped
  static bool writeFileIfNotExists(String filePath, String content) {
    if (fileExists(filePath)) {
      Console.warning('File already exists: $filePath');
      Console.info('Use --force to overwrite');
      return false;
    }
    writeFile(filePath, content);
    return true;
  }

  /// Write file with content (always overwrite, but warn if exists)
  static void writeFileWithWarning(String filePath, String content) {
    if (fileExists(filePath)) {
      Console.warning('Overwriting existing file: $filePath');
    }
    writeFile(filePath, content);
  }
}
