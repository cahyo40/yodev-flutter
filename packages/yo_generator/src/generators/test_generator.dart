import 'package:path/path.dart' as path;

import '../config.dart';
import '../templates/test_templates.dart';
import '../utils.dart';

/// Generator for creating test files
class TestGenerator {
  TestGenerator(this.config) : _templates = TestTemplates(config);
  final YoConfig config;
  final TestTemplates _templates;

  /// Generate test files for a feature/component
  /// Options:
  /// - [unit]: Generate unit tests (usecase, repository)
  /// - [widget]: Generate widget tests (page, screen)
  /// - [provider]: Generate provider/controller/bloc tests
  /// - [all]: Generate all test types (default)
  /// - [force]: Overwrite existing test files
  void generate(
    String name, {
    String? feature,
    bool unit = false,
    bool widget = false,
    bool provider = false,
    bool all = false,
    bool force = false,
  }) {
    final fileName = YoUtils.toFileName(name);
    final className = YoUtils.toClassName(name);
    final featureName = feature ?? YoUtils.getFeatureName(name);

    // If no specific flag is set, generate all tests
    final generateAll = all || (!unit && !widget && !provider);

    Console.header('Generating Tests: $className');

    // Validate feature exists
    if (!YoUtils.validateFeatureExists(config.featuresPath, featureName)) {
      return;
    }

    // Create test directory structure
    final testFeaturePath =
        path.join(config.projectPath, 'test', 'features', featureName);

    if (generateAll || unit) {
      _generateUnitTests(name, testFeaturePath, fileName, className, force);
    }

    if (generateAll || widget) {
      _generateWidgetTests(name, testFeaturePath, fileName, className, force);
    }

    if (generateAll || provider) {
      _generateProviderTests(name, testFeaturePath, fileName, className, force);
    }

    Console.success('Tests for $className generated successfully!');
    Console.info('');
    Console.info('Next steps:');
    Console.info(
      '  1. Run: dart run build_runner build --delete-conflicting-outputs',
    );
    Console.info('  2. Run: flutter test');
  }

  void _generateUnitTests(
    String name,
    String testFeaturePath,
    String fileName,
    String className,
    bool force,
  ) {
    Console.info('Generating unit tests...');

    // Usecase test
    final usecaseTestPath = path.join(testFeaturePath, 'domain', 'usecases');
    final usecaseTestFile =
        path.join(usecaseTestPath, '${fileName}_usecase_test.dart');

    if (YoUtils.fileExists(usecaseTestFile) && !force) {
      Console.warning('Usecase test already exists. Use --force to overwrite.');
    } else {
      YoUtils.ensureDirectory(usecaseTestPath);
      YoUtils.writeFile(usecaseTestFile, _templates.usecaseTest(name));
      Console.info('  ✓ Created ${fileName}_usecase_test.dart');
    }

    // Repository test
    final repoTestPath = path.join(testFeaturePath, 'data', 'repositories');
    final repoTestFile =
        path.join(repoTestPath, '${fileName}_repository_impl_test.dart');

    if (YoUtils.fileExists(repoTestFile) && !force) {
      Console.warning(
        'Repository test already exists. Use --force to overwrite.',
      );
    } else {
      YoUtils.ensureDirectory(repoTestPath);
      YoUtils.writeFile(repoTestFile, _templates.repositoryTest(name));
      Console.info('  ✓ Created ${fileName}_repository_impl_test.dart');
    }
  }

  void _generateWidgetTests(
    String name,
    String testFeaturePath,
    String fileName,
    String className,
    bool force,
  ) {
    Console.info('Generating widget tests...');

    // Page test
    final pageTestPath = path.join(testFeaturePath, 'presentation', 'pages');
    final pageTestFile = path.join(pageTestPath, '${fileName}_page_test.dart');

    if (YoUtils.fileExists(pageTestFile) && !force) {
      Console.warning('Page test already exists. Use --force to overwrite.');
    } else {
      YoUtils.ensureDirectory(pageTestPath);
      YoUtils.writeFile(pageTestFile, _templates.pageTest(name));
      Console.info('  ✓ Created ${fileName}_page_test.dart');
    }
  }

  void _generateProviderTests(
    String name,
    String testFeaturePath,
    String fileName,
    String className,
    bool force,
  ) {
    Console.info('Generating provider/controller tests...');

    String testPath;
    String testFileName;

    switch (config.stateManagement) {
      case StateManagement.riverpod:
        testPath = path.join(testFeaturePath, 'presentation', 'providers');
        testFileName = '${fileName}_provider_test.dart';
      case StateManagement.getx:
        testPath = path.join(testFeaturePath, 'presentation', 'controllers');
        testFileName = '${fileName}_controller_test.dart';
      case StateManagement.bloc:
        testPath = path.join(testFeaturePath, 'presentation', 'bloc');
        testFileName = '${fileName}_bloc_test.dart';
    }

    final testFile = path.join(testPath, testFileName);

    if (YoUtils.fileExists(testFile) && !force) {
      Console.warning(
        'Provider/Controller test already exists. Use --force to overwrite.',
      );
    } else {
      YoUtils.ensureDirectory(testPath);
      YoUtils.writeFile(testFile, _templates.providerTest(name));
      Console.info('  ✓ Created $testFileName');
    }
  }
}
