import 'dart:io';

import 'package:path/path.dart' as path;

import '../config.dart';
import '../utils.dart';

/// Generator for updating package name
class PackageNameGenerator {
  PackageNameGenerator(this.config);
  final YoConfig config;

  /// Update package name in project
  void generate(String newPackageName) {
    Console.header('Updating Package Name');

    final oldPackageName = config.packageName;

    Console.info('Old package name: $oldPackageName');
    Console.info('New package name: $newPackageName');

    // Update Android
    _updateAndroidPackageName(oldPackageName, newPackageName);

    // Update iOS
    _updateiOSBundleId(newPackageName);

    // Update pubspec.yaml
    _updatePubspec(newPackageName);

    // Update Dart imports
    _updateDartImports(oldPackageName, newPackageName);

    // Update config
    config.copyWith(packageName: newPackageName).save();

    Console.success('Package name updated to: $newPackageName');
    Console.info('');
    Console.info('Note: You may need to manually update some files.');
    Console.info('Run: flutter clean && flutter pub get');
  }

  void _updateAndroidPackageName(String oldPackage, String newPackage) {
    Console.info('Updating Android package name...');

    final androidPath = path.join(config.projectPath, 'android');
    final buildGradlePath = path.join(androidPath, 'app', 'build.gradle');
    final buildGradleKtsPath =
        path.join(androidPath, 'app', 'build.gradle.kts');

    // Update build.gradle or build.gradle.kts
    for (final gradlePath in [buildGradlePath, buildGradleKtsPath]) {
      if (YoUtils.fileExists(gradlePath)) {
        var content = YoUtils.readFile(gradlePath);
        content = content.replaceAll(oldPackage, newPackage);
        YoUtils.writeFile(gradlePath, content);
      }
    }

    // Update AndroidManifest.xml
    final manifestPath = path.join(
      androidPath,
      'app',
      'src',
      'main',
      'AndroidManifest.xml',
    );
    if (YoUtils.fileExists(manifestPath)) {
      var content = YoUtils.readFile(manifestPath);
      content = content.replaceAll(oldPackage, newPackage);
      YoUtils.writeFile(manifestPath, content);
    }

    // Update Kotlin/Java files
    _updateAndroidSourceFiles(oldPackage, newPackage);
  }

  void _updateAndroidSourceFiles(String oldPackage, String newPackage) {
    final oldPackagePath = oldPackage.replaceAll('.', '/');
    final newPackagePath = newPackage.replaceAll('.', '/');
    final androidPath = path.join(config.projectPath, 'android');

    final variants = ['main', 'debug', 'profile'];
    for (final variant in variants) {
      final oldDir = path.join(
        androidPath,
        'app',
        'src',
        variant,
        'kotlin',
        oldPackagePath,
      );
      final newDir = path.join(
        androidPath,
        'app',
        'src',
        variant,
        'kotlin',
        newPackagePath,
      );

      if (Directory(oldDir).existsSync()) {
        // Update files in the old directory
        final dir = Directory(oldDir);
        for (final file in dir.listSync(recursive: true)) {
          if (file is File && file.path.endsWith('.kt')) {
            var content = file.readAsStringSync();
            content = content.replaceAll(
              'package $oldPackage',
              'package $newPackage',
            );
            file.writeAsStringSync(content);
          }
        }

        // Try to move directory (may fail on some systems)
        try {
          YoUtils.ensureDirectory(path.dirname(newDir));
          Directory(oldDir).renameSync(newDir);
        } catch (e) {
          Console.warning('Could not move directory: $oldDir -> $newDir');
          Console.info('Please manually move the files.');
        }
      }
    }
  }

  void _updateDartImports(String oldPackage, String newPackage) {
    Console.info('Updating Dart imports...');

    final libDir = Directory(config.libPath);
    if (!libDir.existsSync()) return;

    final oldName = oldPackage.split('.').last;
    final newName = newPackage.split('.').last;

    for (final file in libDir.listSync(recursive: true)) {
      if (file is File && file.path.endsWith('.dart')) {
        var content = file.readAsStringSync();
        content = content.replaceAll('package:$oldName/', 'package:$newName/');
        file.writeAsStringSync(content);
      }
    }
  }

  void _updateiOSBundleId(String newPackage) {
    Console.info('Updating iOS bundle identifier...');

    final iosPath = path.join(config.projectPath, 'ios');
    final pbxprojPath =
        path.join(iosPath, 'Runner.xcodeproj', 'project.pbxproj');

    if (YoUtils.fileExists(pbxprojPath)) {
      var content = YoUtils.readFile(pbxprojPath);

      // Replace bundle identifier
      content = content.replaceAllMapped(
        RegExp('PRODUCT_BUNDLE_IDENTIFIER = ([^;]+);'),
        (match) => 'PRODUCT_BUNDLE_IDENTIFIER = $newPackage;',
      );

      YoUtils.writeFile(pbxprojPath, content);
    }
  }

  void _updatePubspec(String newPackage) {
    Console.info('Updating pubspec.yaml...');

    final pubspecPath = path.join(config.projectPath, 'pubspec.yaml');
    if (YoUtils.fileExists(pubspecPath)) {
      var content = YoUtils.readFile(pubspecPath);

      // Extract name from package (last part)
      final projectName = newPackage.split('.').last;

      // Update name field
      content = content.replaceFirst(
        RegExp(r'name: \w+'),
        'name: $projectName',
      );

      YoUtils.writeFile(pubspecPath, content);
    }
  }
}
