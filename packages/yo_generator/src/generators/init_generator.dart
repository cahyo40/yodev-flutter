import 'package:path/path.dart' as path;

import '../config.dart';
import '../templates/common_templates.dart';
import '../utils.dart';
import 'page_generator.dart';
import 'translation_generator.dart';

/// Generator for initializing a new project
class InitGenerator {
  InitGenerator(this.config) : _common = CommonTemplates(config);
  final YoConfig config;
  final CommonTemplates _common;

  /// Initialize project with given state management
  void generate(StateManagement stateManagement, {bool force = false}) {
    Console.header(
      'Initializing Project with ${stateManagement.name.toUpperCase()}',
    );

    // Update config with state management
    config.copyWith(stateManagement: stateManagement).save();

    // Add dependencies to pubspec.yaml
    _addDependencies(stateManagement);

    // Create core structure
    _createCoreStructure();

    // Create theme
    _createTheme();

    // Create router
    _createRouter(stateManagement);

    // Initialize translations
    _initTranslations();

    // Create l10n.yaml
    _createL10nConfig();

    // Enable flutter generate in pubspec.yaml
    _enableFlutterGenerate();

    // Create default home page
    _createDefaultPage(stateManagement);

    // Create main.dart
    _createMain(stateManagement, force: force);

    // Create tasks.json
    _createTasksJson();

    Console.success('Project initialized successfully!');
    Console.info('');
    Console.info('Next steps:');
    Console.info('  1. Run: flutter pub get');
    Console.info('  2. Run: flutter gen-l10n');
    if (stateManagement == StateManagement.bloc) {
      Console.info(
        '  3. Run: dart run build_runner build --delete-conflicting-outputs',
      );
    }
    Console.info('');
  }

  void _addDependencies(StateManagement stateManagement) {
    Console.info('Adding dependencies...');

    // ═══════════════════════════════════════════════════════════════════════
    // COMMON DEPENDENCIES (All State Managements)
    // ═══════════════════════════════════════════════════════════════════════
    final commonDeps = {
      // ─────────────────────────────────────────────────────────────────────
      // Core / Functional Programming
      // ─────────────────────────────────────────────────────────────────────
      'equatable': '^2.0.5',
      'dartz': '^0.10.1',
      'freezed_annotation': '^2.4.1',
      'json_annotation': '^4.8.1',
      'uuid': '^4.2.2',

      // ─────────────────────────────────────────────────────────────────────
      // Networking / API
      // ─────────────────────────────────────────────────────────────────────
      'connectivity_plus': '^7.0.0',
      'internet_connection_checker': '^1.0.0+1',

      // ─────────────────────────────────────────────────────────────────────
      // Local Storage / Database
      // ─────────────────────────────────────────────────────────────────────
      'shared_preferences': '^2.2.2',

      // ─────────────────────────────────────────────────────────────────────
      // Utils / Helpers
      // ─────────────────────────────────────────────────────────────────────
      'intl': '^0.20.2',

      'url_launcher': '^6.2.2',
      'package_info_plus': '^5.0.1',
      'device_info_plus': '^12.1.0',
      'permission_handler': '^11.1.0',
      'path': '^1.8.3',

      // ─────────────────────────────────────────────────────────────────────
      // UI / Widgets
      // ─────────────────────────────────────────────────────────────────────
      'flutter_svg': '^2.0.9',
      'cached_network_image': '^3.4.1',
      'flutter_spinkit': '^5.2.0',
      'flutter_staggered_grid_view': '^0.7.0',

      // ─────────────────────────────────────────────────────────────────────
      // Image / Media
      // ─────────────────────────────────────────────────────────────────────
      'image_picker': '^1.1.2',
      'photo_view': '^0.15.0',

      // ─────────────────────────────────────────────────────────────────────
      // Forms / Validation
      // ─────────────────────────────────────────────────────────────────────
      'formz': '^0.6.1',
      'email_validator': '^2.1.17',
    };

    // ═══════════════════════════════════════════════════════════════════════
    // STATE MANAGEMENT SPECIFIC DEPENDENCIES
    // ═══════════════════════════════════════════════════════════════════════
    final stateDeps = switch (stateManagement) {
      // ─────────────────────────────────────────────────────────────────────
      // RIVERPOD
      // ─────────────────────────────────────────────────────────────────────
      StateManagement.riverpod => {
          // Riverpod Core
          'flutter_riverpod': '^2.4.9',
          'riverpod_annotation': '^2.3.3',

          // Riverpod with Hooks
          'hooks_riverpod': '^2.4.9',
          'flutter_hooks': '^0.20.4',

          // Navigation
          'go_router': '^13.0.0',
        },

      // ─────────────────────────────────────────────────────────────────────
      // GETX
      // ─────────────────────────────────────────────────────────────────────
      StateManagement.getx => {
          // GetX Core (includes state, route, DI, internationalization)
          'get': '^4.6.6',

          // GetX Local Storage
          'get_storage': '^2.1.1',
        },

      // ─────────────────────────────────────────────────────────────────────
      // BLOC
      // ─────────────────────────────────────────────────────────────────────
      StateManagement.bloc => {
          // Bloc Core
          'flutter_bloc': '^8.1.3',
          'bloc': '^8.1.2',

          // Bloc Extensions
          'bloc_concurrency': '^0.2.2',
          'hydrated_bloc': '^9.1.3',
          'replay_bloc': '^0.2.6',

          // Navigation
          'go_router': '^13.0.0',

          // Bloc Extras
          'stream_transform': '^2.1.0',
        },
    };

    // ═══════════════════════════════════════════════════════════════════════
    // STATE MANAGEMENT SPECIFIC DEV DEPENDENCIES
    // ═══════════════════════════════════════════════════════════════════════
    final stateDevDeps = switch (stateManagement) {
      StateManagement.riverpod => {
          // Riverpod Code Generation
          'riverpod_generator': '^2.3.9',
          'riverpod_lint': '^2.3.7',
          'custom_lint': '^0.5.8',
        },
      StateManagement.getx => <String, String>{
          // GetX doesn't require additional dev dependencies
        },
      StateManagement.bloc => {
          // Bloc Testing
          'bloc_test': '^9.1.5',
          'mocktail': '^1.0.1',
        },
    };

    // ═══════════════════════════════════════════════════════════════════════
    // COMMON DEV DEPENDENCIES
    // ═══════════════════════════════════════════════════════════════════════
    final devDeps = {
      // Code Generation
      'build_runner': '^2.4.8',
      'freezed': '^2.4.6',
      'json_serializable': '^6.7.1',
      'retrofit_generator': '^8.0.6',

      // Hive Code Generation
      'hive_generator': '^2.0.1',

      // Linting
      'flutter_lints': '^3.0.1',
      'very_good_analysis': '^5.1.0',

      // Testing
      'mockito': '^5.4.4',
      'faker': '^2.1.0',

      // State management specific
      ...stateDevDeps,
    };

    // Add all dependencies
    Console.info(
      'Adding ${commonDeps.length + stateDeps.length} dependencies...',
    );
    for (final entry in {...commonDeps, ...stateDeps}.entries) {
      YoUtils.addDependency(config.projectPath, entry.key, entry.value);
    }

    Console.info('Adding ${devDeps.length} dev dependencies...');
    for (final entry in devDeps.entries) {
      YoUtils.addDevDependency(config.projectPath, entry.key, entry.value);
    }
  }

  /// Add `flutter: generate: true` to pubspec.yaml for l10n
  void _enableFlutterGenerate() {
    Console.info('Enabling flutter generate for l10n...');

    final pubspecPath = path.join(config.projectPath, 'pubspec.yaml');
    var content = YoUtils.readFile(pubspecPath);

    if (content.contains('generate: true')) {
      Console.info('flutter: generate already enabled.');
      return;
    }

    // Find `flutter:` section and add `generate: true` after it
    final flutterIndex =
        content.indexOf(RegExp(r'^flutter:\s*$', multiLine: true));
    if (flutterIndex != -1) {
      final insertIndex = content.indexOf('\n', flutterIndex) + 1;
      content =
          '${content.substring(0, insertIndex)}  generate: true\n${content.substring(insertIndex)}';
      YoUtils.writeFile(pubspecPath, content);
      Console.success('Added flutter: generate: true to pubspec.yaml');
    }
  }

  void _createCoreStructure() {
    Console.info('Creating core structure...');

    final dirs = [
      path.join(config.corePath, 'config'),
      path.join(config.corePath, 'constants'),
      path.join(config.corePath, 'extensions'),
      path.join(config.corePath, 'services'),
      path.join(config.corePath, 'themes'),
      path.join(config.corePath, 'utils'),
      path.join(config.corePath, 'widgets'),
    ];

    for (final dir in dirs) {
      YoUtils.ensureDirectory(dir);
    }
  }

  void _createDefaultPage(StateManagement stateManagement) {
    Console.info('Creating default home page...');

    PageGenerator(
      config.copyWith(stateManagement: stateManagement),
    ).generate('home');
  }

  void _createL10nConfig() {
    Console.info('Creating l10n configuration...');

    final l10nPath = path.join(config.projectPath, 'l10n.yaml');
    YoUtils.writeFile(l10nPath, _common.l10nYaml());
  }

  void _createMain(StateManagement stateManagement, {bool force = false}) {
    Console.info('Updating main.dart...');

    final mainPath = path.join(config.libPath, 'main.dart');

    // Check if main.dart exists
    if (YoUtils.fileExists(mainPath)) {
      if (force) {
        Console.info('Force overwriting main.dart...');
        _writeMainFile(mainPath, stateManagement);
        return;
      }

      final existingContent = YoUtils.readFile(mainPath);

      // Update if it's a default Flutter main.dart OR a previous yo init main.dart
      final isDefault = existingContent.contains('MyHomePage') ||
          existingContent.contains('flutter create') ||
          existingContent.contains('incrementCounter');

      final isYoGenerated = existingContent.contains('AppTheme') ||
          existingContent.contains('yo_ui') ||
          existingContent.contains('yo.dart');

      if (isDefault || isYoGenerated) {
        Console.info('Replacing main.dart with configured version...');
        _writeMainFile(mainPath, stateManagement);
      } else {
        Console.warning(
          'main.dart already customized. Use --force to overwrite.',
        );
      }
    } else {
      _writeMainFile(mainPath, stateManagement);
    }
  }

  void _createRouter(StateManagement stateManagement) {
    Console.info('Creating router...');

    final configPath = path.join(config.corePath, 'config');
    YoUtils.ensureDirectory(configPath);

    if (stateManagement == StateManagement.getx) {
      final pagesContent = '''
import 'package:get/get.dart';

class AppPages {
  static const initial = '/';

  static final routes = <GetPage>[
    // Add routes here
  ];
}
''';
      YoUtils.writeFile(path.join(configPath, 'app_pages.dart'), pagesContent);
    } else {
      YoUtils.writeFile(
        path.join(configPath, 'app_router.dart'),
        _common.appRouter(),
      );
    }
  }

  void _createTasksJson() {
    Console.info('Creating tasks.json...');

    final vscodePath = path.join(config.projectPath, '.vscode');
    YoUtils.ensureDirectory(vscodePath);

    final tasksPath = path.join(vscodePath, 'tasks.json');
    YoUtils.writeFile(tasksPath, _common.tasksJson());
  }

  void _createTheme() {
    Console.info('Creating theme...');

    final themePath = path.join(config.corePath, 'themes', 'app_theme.dart');
    YoUtils.writeFile(themePath, _common.appTheme());
  }

  void _initTranslations() {
    Console.info('Initializing translations...');

    TranslationGenerator(config).initTranslations();
  }

  void _writeMainFile(String mainPath, StateManagement stateManagement) {
    final content = switch (stateManagement) {
      StateManagement.riverpod => _common.mainRiverpod(config.appName),
      StateManagement.getx => _common.mainGetX(config.appName),
      StateManagement.bloc => _common.mainBloc(config.appName),
    };

    YoUtils.writeFile(mainPath, content);
  }
}
