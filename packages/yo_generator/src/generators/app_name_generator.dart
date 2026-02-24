import 'package:path/path.dart' as path;

import '../config.dart';
import '../utils.dart';

/// Generator for updating app name
class AppNameGenerator {
  AppNameGenerator(this.config);
  final YoConfig config;

  /// Update app name in project
  void generate(String newAppName) {
    Console.header('Updating App Name');

    Console.info('Old app name: ${config.appName}');
    Console.info('New app name: $newAppName');

    // Update Android
    _updateAndroidAppName(newAppName);

    // Update iOS
    _updateiOSAppName(newAppName);

    // Update Web
    _updateWebAppName(newAppName);

    // Update translations
    _updateTranslations(newAppName);

    // Update config
    config.copyWith(appName: newAppName).save();

    Console.success('App name updated to: $newAppName');
  }

  void _updateAndroidAppName(String newName) {
    Console.info('Updating Android app name...');

    final stringsPath = path.join(
      config.projectPath,
      'android',
      'app',
      'src',
      'main',
      'res',
      'values',
      'strings.xml',
    );

    if (YoUtils.fileExists(stringsPath)) {
      var content = YoUtils.readFile(stringsPath);
      content = content.replaceFirst(
        RegExp('<string name="app_name">[^<]*</string>'),
        '<string name="app_name">$newName</string>',
      );
      YoUtils.writeFile(stringsPath, content);
    } else {
      // Create strings.xml if it doesn't exist
      final valuesDir = path.dirname(stringsPath);
      YoUtils.ensureDirectory(valuesDir);
      YoUtils.writeFile(stringsPath, '''
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <string name="app_name">$newName</string>
</resources>
''');
    }

    // Also update AndroidManifest.xml label
    final manifestPath = path.join(
      config.projectPath,
      'android',
      'app',
      'src',
      'main',
      'AndroidManifest.xml',
    );

    if (YoUtils.fileExists(manifestPath)) {
      var content = YoUtils.readFile(manifestPath);
      content = content.replaceFirst(
        RegExp('android:label="[^"]*"'),
        'android:label="$newName"',
      );
      YoUtils.writeFile(manifestPath, content);
    }
  }

  void _updateiOSAppName(String newName) {
    Console.info('Updating iOS app name...');

    final infoPlistPath = path.join(
      config.projectPath,
      'ios',
      'Runner',
      'Info.plist',
    );

    if (YoUtils.fileExists(infoPlistPath)) {
      var content = YoUtils.readFile(infoPlistPath);

      // Update CFBundleDisplayName
      content = content.replaceFirst(
        RegExp(r'<key>CFBundleDisplayName</key>\s*<string>[^<]*</string>'),
        '<key>CFBundleDisplayName</key>\n\t<string>$newName</string>',
      );

      // Update CFBundleName
      content = content.replaceFirst(
        RegExp(r'<key>CFBundleName</key>\s*<string>[^<]*</string>'),
        '<key>CFBundleName</key>\n\t<string>$newName</string>',
      );

      YoUtils.writeFile(infoPlistPath, content);
    }
  }

  void _updateTranslations(String newName) {
    Console.info('Updating translations...');

    final l10nPath = config.l10nPath;
    final arbFiles = ['app_en.arb', 'app_id.arb'];

    for (final arbFile in arbFiles) {
      final filePath = path.join(l10nPath, arbFile);
      if (YoUtils.fileExists(filePath)) {
        var content = YoUtils.readFile(filePath);
        content = content.replaceFirst(
          RegExp(r'"appTitle":\s*"[^"]*"'),
          '"appTitle": "$newName"',
        );
        YoUtils.writeFile(filePath, content);
      }
    }
  }

  void _updateWebAppName(String newName) {
    Console.info('Updating Web app name...');

    final indexPath = path.join(config.projectPath, 'web', 'index.html');

    if (YoUtils.fileExists(indexPath)) {
      var content = YoUtils.readFile(indexPath);
      content = content.replaceFirst(
        RegExp('<title>[^<]*</title>'),
        '<title>$newName</title>',
      );
      YoUtils.writeFile(indexPath, content);
    }

    final manifestPath = path.join(config.projectPath, 'web', 'manifest.json');

    if (YoUtils.fileExists(manifestPath)) {
      var content = YoUtils.readFile(manifestPath);
      content = content.replaceFirst(
        RegExp(r'"name":\s*"[^"]*"'),
        '"name": "$newName"',
      );
      content = content.replaceFirst(
        RegExp(r'"short_name":\s*"[^"]*"'),
        '"short_name": "$newName"',
      );
      YoUtils.writeFile(manifestPath, content);
    }
  }
}
