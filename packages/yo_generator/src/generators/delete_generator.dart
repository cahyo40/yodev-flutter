import 'dart:io';

import 'package:path/path.dart' as path;

import '../config.dart';
import '../utils.dart';

/// Generator for deleting pages and their related files
class DeleteGenerator {
  DeleteGenerator(this.config);
  final YoConfig config;

  /// Delete a page and all its related files
  void deletePage(String name, {bool deleteFeature = false}) {
    final featureName = YoUtils.getFeatureName(name);
    final fileName = YoUtils.toFileName(name);
    final className = YoUtils.toClassName(name);
    final featurePath = config.featurePath(featureName);

    // Validate feature exists
    if (!YoUtils.featureExists(config.featuresPath, featureName)) {
      Console.error('Feature "$featureName" does not exist.');
      return;
    }

    Console.header('Deleting Page: $className');

    if (deleteFeature) {
      // Delete entire feature folder
      _deleteDirectory(featurePath);
      Console.success('Feature "$featureName" deleted completely!');

      // Update config
      _removeFeatureFromConfig(featureName);

      // Update routes
      _removeFromRoutes(name, featureName);
    } else {
      // Delete only page-related files
      _deletePageFiles(name, featurePath, fileName);
      Console.success('Page "$className" deleted!');

      // Update routes
      _removeFromRoutes(name, featureName);
    }
  }

  void _cleanupEmptyDirs(String featurePath) {
    final dirsToCheck = [
      path.join(featurePath, 'presentation', 'pages'),
      path.join(featurePath, 'presentation', 'providers'),
      path.join(featurePath, 'presentation', 'controllers'),
      path.join(featurePath, 'presentation', 'bindings'),
      path.join(featurePath, 'presentation', 'bloc'),
      path.join(featurePath, 'presentation', 'screens'),
      path.join(featurePath, 'presentation', 'dialogs'),
      path.join(featurePath, 'presentation', 'widgets'),
      path.join(featurePath, 'data', 'models'),
      path.join(featurePath, 'data', 'datasources'),
      path.join(featurePath, 'data', 'repositories'),
      path.join(featurePath, 'domain', 'entities'),
      path.join(featurePath, 'domain', 'repositories'),
      path.join(featurePath, 'domain', 'usecases'),
      path.join(featurePath, 'presentation'),
      path.join(featurePath, 'data'),
      path.join(featurePath, 'domain'),
      featurePath,
    ];

    for (final dirPath in dirsToCheck) {
      final dir = Directory(dirPath);
      if (dir.existsSync()) {
        final contents = dir.listSync();
        if (contents.isEmpty) {
          dir.deleteSync();
          Console.info('Removed empty directory: $dirPath');
        }
      }
    }
  }

  void _deleteDirectory(String dirPath) {
    final dir = Directory(dirPath);
    if (dir.existsSync()) {
      dir.deleteSync(recursive: true);
      Console.info('Deleted directory: $dirPath');
    }
  }

  void _deleteFile(String filePath) {
    final file = File(filePath);
    if (file.existsSync()) {
      file.deleteSync();
      Console.info('Deleted: $filePath');
    }
  }

  void _deletePageFiles(String name, String featurePath, String fileName) {
    final filesToDelete = [
      // Presentation
      path.join(featurePath, 'presentation', 'pages', '${fileName}_page.dart'),
      path.join(
        featurePath,
        'presentation',
        'providers',
        '${fileName}_provider.dart',
      ),
      path.join(
        featurePath,
        'presentation',
        'controllers',
        '${fileName}_controller.dart',
      ),
      path.join(
        featurePath,
        'presentation',
        'bindings',
        '${fileName}_binding.dart',
      ),
      path.join(featurePath, 'presentation', 'bloc', '${fileName}_bloc.dart'),
      path.join(featurePath, 'presentation', 'bloc', '${fileName}_event.dart'),
      path.join(featurePath, 'presentation', 'bloc', '${fileName}_state.dart'),
      path.join(featurePath, 'presentation', 'bloc', '${fileName}_cubit.dart'),
      path.join(
        featurePath,
        'presentation',
        'screens',
        '${fileName}_screen.dart',
      ),
      path.join(
        featurePath,
        'presentation',
        'dialogs',
        '${fileName}_dialog.dart',
      ),

      // Data
      path.join(featurePath, 'data', 'models', '${fileName}_model.dart'),
      path.join(
        featurePath,
        'data',
        'datasources',
        '${fileName}_remote_datasource.dart',
      ),
      path.join(
        featurePath,
        'data',
        'datasources',
        '${fileName}_local_datasource.dart',
      ),
      path.join(
        featurePath,
        'data',
        'repositories',
        '${fileName}_repository_impl.dart',
      ),

      // Domain
      path.join(featurePath, 'domain', 'entities', '${fileName}_entity.dart'),
      path.join(
        featurePath,
        'domain',
        'repositories',
        '${fileName}_repository.dart',
      ),
      path.join(featurePath, 'domain', 'usecases', '${fileName}_usecase.dart'),
    ];

    for (final filePath in filesToDelete) {
      _deleteFile(filePath);
    }

    // Clean up empty directories
    _cleanupEmptyDirs(featurePath);
  }

  void _removeFeatureFromConfig(String featureName) {
    if (config.features.contains(featureName)) {
      final updatedFeatures =
          config.features.where((f) => f != featureName).toList();
      config.copyWith(features: updatedFeatures).save();
    }
  }

  void _removeFromGetXPages(
    String className,
    String fileName,
    String featureName,
    String routerPath,
  ) {
    final pagesFile = path.join(routerPath, 'app_pages.dart');
    if (!YoUtils.fileExists(pagesFile)) return;

    var content = YoUtils.readFile(pagesFile);

    // Remove imports
    final pageImportPattern = RegExp(
      "import '../../features/$featureName/presentation/pages/${fileName}_page\\.dart';\n?",
    );
    final bindingImportPattern = RegExp(
      "import '../../features/$featureName/presentation/bindings/${fileName}_binding\\.dart';\n?",
    );
    content = content.replaceAll(pageImportPattern, '');
    content = content.replaceAll(bindingImportPattern, '');

    // Remove route
    final routePattern = RegExp(
      r'\s*GetPage\(\s*name:\s*' +
          className +
          r'Page\.routeName,[\s\S]*?\),?\n?',
    );
    content = content.replaceAll(routePattern, '');

    YoUtils.writeFile(pagesFile, content);
  }

  void _removeFromGoRouter(
    String className,
    String fileName,
    String featureName,
    String routerPath,
  ) {
    final routerFile = path.join(routerPath, 'app_router.dart');
    if (!YoUtils.fileExists(routerFile)) return;

    var content = YoUtils.readFile(routerFile);

    // Remove import
    final importPattern = RegExp(
      "import '../../features/$featureName/presentation/pages/${fileName}_page\\.dart';\n?",
    );
    content = content.replaceAll(importPattern, '');

    // Remove route
    final routePattern = RegExp(
      r'\s*GoRoute\(\s*path:\s*' +
          className +
          r'Page\.routeName,[\s\S]*?\),?\n?',
    );
    content = content.replaceAll(routePattern, '');

    YoUtils.writeFile(routerFile, content);
  }

  void _removeFromRoutes(String name, String featureName) {
    final fileName = YoUtils.toFileName(name);
    final className = YoUtils.toClassName(name);
    final routerPath = path.join(config.corePath, 'config');

    switch (config.stateManagement) {
      case StateManagement.riverpod:
      case StateManagement.bloc:
        _removeFromGoRouter(className, fileName, featureName, routerPath);
      case StateManagement.getx:
        _removeFromGetXPages(className, fileName, featureName, routerPath);
    }
  }
}
