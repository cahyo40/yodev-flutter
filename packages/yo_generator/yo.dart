#!/usr/bin/env dart

/// yo.dart - Flutter Code Generator CLI
///
/// A comprehensive code generator for Flutter projects with support for
/// Riverpod, GetX, and Bloc state management using Clean Architecture.
///
/// Usage:
///   dart run yo.dart <command>:<name> [options]
///
/// Examples:
///   dart run yo.dart page:home
///   dart run yo.dart page:setting.profile --presentation-only
///   dart run yo.dart model:user --freezed
///   dart run yo.dart datasource:auth --remote
///   dart run yo.dart init --state=riverpod
///
/// For more information, run:
///   dart run yo.dart --help
library;

import 'dart:io';

import 'package:args/args.dart';

import 'src/config.dart';
import 'src/dry_run.dart';
import 'src/exceptions.dart';
import 'src/generators/generators.dart';
import 'src/interactive.dart';
import 'src/utils.dart';

void main(List<String> arguments) {
  final parser = ArgParser()
    ..addFlag(
      'help',
      abbr: 'h',
      negatable: false,
      help: 'Show help information',
    )
    ..addFlag('version', abbr: 'v', negatable: false, help: 'Show version')
    ..addOption(
      'state',
      abbr: 's',
      allowed: ['riverpod', 'getx', 'bloc'],
      help: 'State management to use',
    )
    ..addOption('feature', abbr: 'f', help: 'Feature name for the generator')
    ..addFlag(
      'presentation-only',
      negatable: false,
      help: 'Generate only presentation layer (for page command)',
    )
    ..addFlag(
      'freezed',
      negatable: false,
      help: 'Use freezed for model generation',
    )
    ..addFlag('remote', negatable: false, help: 'Generate remote datasource')
    ..addFlag('local', negatable: false, help: 'Generate local datasource')
    ..addFlag(
      'both',
      negatable: false,
      help: 'Generate both remote and local datasources',
    )
    ..addFlag(
      'global',
      abbr: 'g',
      negatable: false,
      help: 'Create global widget in core',
    )
    ..addFlag('cubit', negatable: false, help: 'Use Cubit instead of Bloc')
    ..addFlag('force', negatable: false, help: 'Force overwrite existing files')
    ..addFlag(
      'dry-run',
      negatable: false,
      help: 'Preview what files would be created without writing them',
    )
    ..addFlag(
      'interactive',
      abbr: 'i',
      negatable: false,
      help: 'Run in interactive mode with prompts',
    )
    ..addFlag(
      'delete-feature',
      negatable: false,
      help: 'Delete entire feature folder (for delete command)',
    )
    ..addFlag(
      'unit',
      negatable: false,
      help: 'Generate unit tests (for test command)',
    )
    ..addFlag(
      'widget',
      negatable: false,
      help: 'Generate widget tests (for test command)',
    )
    ..addFlag(
      'provider',
      negatable: false,
      help: 'Generate provider/controller tests (for test command)',
    )
    ..addFlag(
      'all',
      negatable: false,
      help: 'Generate all test types (for test command)',
    )
    ..addOption('key', help: 'Translation key')
    ..addOption('en', help: 'English translation')
    ..addOption('id', help: 'Indonesian translation');

  try {
    final results = parser.parse(arguments);

    if (results['help'] as bool) {
      _showHelp(parser);
      return;
    }

    if (results['version'] as bool) {
      print('yo.dart version $version');
      return;
    }

    // Get remaining arguments (command:name)
    final rest = results.rest;
    if (rest.isEmpty) {
      _showHelp(parser);
      return;
    }

    // Parse command
    final commandArg = rest.first;

    // Handle interactive mode
    if (results['interactive'] as bool) {
      _handleInteractiveMode(commandArg);
      return;
    }

    // Load configuration
    var config = YoConfig.load();

    // Override state management if provided
    if (results['state'] != null) {
      config = config.copyWith(
        stateManagement: StateManagement.fromString(results['state'] as String),
      );
    }

    // Enable dry-run mode if requested
    final isDryRun = results['dry-run'] as bool;
    if (isDryRun) {
      DryRun.enable();
      Console.header('DRY-RUN MODE');
      Console.info('No files will be created or modified.\n');
    }

    // Process command
    _processCommand(commandArg, results, config);

    // Print dry-run summary
    if (isDryRun) {
      DryRun.printSummary();
      DryRun.disable();
    }
  } on YoException catch (e) {
    Console.error(e.message);
    if (e.suggestion != null) {
      Console.info('💡 ${e.suggestion}');
    }
    exit(1);
  } on FormatException catch (e) {
    Console.error('Invalid arguments: ${e.message}');
    Console.info('Run "dart run yo.dart --help" for usage information.');
    exit(1);
  } catch (e) {
    Console.error('Unexpected error: $e');
    exit(2);
  }
}

const String version = '1.1.0';

void _handleInteractiveMode(String commandArg) {
  switch (commandArg) {
    case 'init':
      final result = Interactive.runInitWizard();
      if (result != null) {
        final config = YoConfig(
          stateManagement: StateManagement.fromString(result.stateManagement),
          packageName: result.packageName,
          appName: result.appName,
          features: result.features,
          projectPath: Directory.current.path,
        );
        InitGenerator(config).generate(
          StateManagement.fromString(result.stateManagement),
        );

        // Generate initial feature pages
        for (final feature in result.features) {
          PageGenerator(config).generate(feature);
        }
      }

    case 'page':
      final config = YoConfig.load();
      final result = Interactive.runPageWizard(config);
      if (result != null) {
        PageGenerator(config).generate(
          result.name,
          presentationOnly: result.presentationOnly,
          force: result.force,
        );
      }

    default:
      // Fallback: show command selector
      final selectedCommand = Interactive.runCommandSelector();
      if (selectedCommand != null) {
        Console.info('Selected: $selectedCommand');
        Console.info(
          'Run: dart run yo.dart $selectedCommand:<name> for generation.',
        );
      }
  }
}

void _processCommand(String commandArg, ArgResults results, YoConfig config) {
  // Handle special commands without colon
  if (commandArg == 'init') {
    final stateManagement = results['state'] != null
        ? StateManagement.fromString(results['state'] as String)
        : StateManagement.riverpod;
    final force = results['force'] as bool;
    InitGenerator(config).generate(stateManagement, force: force);
    return;
  }

  if (commandArg == 'translation') {
    final key = results['key'] as String?;
    final en = results['en'] as String?;
    final id = results['id'] as String?;

    if (key == null) {
      Console.error('Translation key is required. Use --key=<key>');
      exit(1);
    }

    TranslationGenerator(config).generate(key: key, en: en, id: id);
    return;
  }

  // Handle network command
  if (commandArg == 'network') {
    final force = results['force'] as bool;
    NetworkGenerator(config).generate(force: force);
    return;
  }

  // Handle di command
  if (commandArg == 'di') {
    final force = results['force'] as bool;
    DIGenerator(config).generate(force: force);
    return;
  }

  // Handle barrel command
  if (commandArg == 'barrel') {
    final feature = results['feature'] as String?;
    final force = results['force'] as bool;
    BarrelGenerator(config).generate(feature: feature, force: force);
    return;
  }

  // Handle test command
  if (commandArg.startsWith('test:')) {
    final name = commandArg.substring(5);
    final feature = results['feature'] as String?;
    final unit = results['unit'] as bool;
    final widget = results['widget'] as bool;
    final provider = results['provider'] as bool;
    final all = results['all'] as bool;
    final force = results['force'] as bool;
    TestGenerator(config).generate(
      name,
      feature: feature,
      unit: unit,
      widget: widget,
      provider: provider,
      all: all,
      force: force,
    );
    return;
  }

  // Parse command:name format
  final (command, name) = YoUtils.parseCommand(commandArg);
  final feature = results['feature'] as String?;

  switch (command) {
    case 'page':
      final presentationOnly = results['presentation-only'] as bool;
      final force = results['force'] as bool;
      PageGenerator(config)
          .generate(name, presentationOnly: presentationOnly, force: force);

    case 'controller':
    case 'provider':
    case 'bloc':
      final useCubit = results['cubit'] as bool;
      final forceCtrl = results['force'] as bool;
      ControllerGenerator(config).generate(
        name,
        feature: feature,
        useCubit: useCubit,
        force: forceCtrl,
      );

    case 'model':
      final freezed = results['freezed'] as bool;
      final force = results['force'] as bool;
      ModelGenerator(config)
          .generate(name, freezed: freezed, feature: feature, force: force);

    case 'entity':
      final force = results['force'] as bool;
      EntityGenerator(config).generate(name, feature: feature, force: force);

    case 'datasource':
      final remote = results['remote'] as bool;
      final local = results['local'] as bool;
      final both = results['both'] as bool;
      final forceDs = results['force'] as bool;

      if (both) {
        DatasourceGenerator(config).generate(
          name,
          local: true,
          feature: feature,
          force: forceDs,
        );
      } else if (!remote && !local) {
        // Default to remote
        DatasourceGenerator(config).generate(
          name,
          feature: feature,
          force: forceDs,
        );
      } else {
        DatasourceGenerator(config).generate(
          name,
          remote: remote,
          local: local,
          feature: feature,
          force: forceDs,
        );
      }

    case 'usecase':
      final forceUsecase = results['force'] as bool;
      UsecaseGenerator(config)
          .generate(name, feature: feature, force: forceUsecase);

    case 'repository':
      final forceRepo = results['force'] as bool;
      RepositoryGenerator(config)
          .generate(name, feature: feature, force: forceRepo);

    case 'screen':
      final forceScreen = results['force'] as bool;
      ScreenGenerator(config)
          .generate(name, feature: feature, force: forceScreen);

    case 'dialog':
      final forceDialog = results['force'] as bool;
      DialogGenerator(config)
          .generate(name, feature: feature, force: forceDialog);

    case 'widget':
      final global = results['global'] as bool;
      final forceWidget = results['force'] as bool;
      WidgetGenerator(config)
          .generate(name, feature: feature, global: global, force: forceWidget);

    case 'service':
      final forceService = results['force'] as bool;
      ServiceGenerator(config).generate(name, force: forceService);

    case 'package-name':
      PackageNameGenerator(config).generate(name);

    case 'app-name':
      AppNameGenerator(config).generate(name);

    case 'delete':
      final deleteFeature = results['delete-feature'] as bool;
      DeleteGenerator(config).deletePage(name, deleteFeature: deleteFeature);

    default:
      Console.error('Unknown command: $command');
      Console.info('Run "dart run yo.dart --help" for available commands.');
      exit(1);
  }
}

void _showHelp(ArgParser parser) {
  print(r'''
╔═══════════════════════════════════════════════════════════════╗
║                    yo.dart - Flutter Generator                 ║
║         Clean Architecture Code Generator for Flutter          ║
╚═══════════════════════════════════════════════════════════════╝

USAGE:
  dart run yo.dart <command>:<name> [options]

COMMANDS:
  page:<name>           Generate a full page with clean architecture
  controller:<name>     Generate controller/provider/bloc
  model:<name>          Generate model class
  entity:<name>         Generate entity class only
  datasource:<name>     Generate datasource
  usecase:<name>        Generate usecase
  repository:<name>     Generate repository (interface + implementation)
  screen:<name>         Generate screen widget
  dialog:<name>         Generate dialog widget
  widget:<name>         Generate widget
  service:<name>        Generate service
  test:<name>           Generate test files for a feature
  translation           Update translations
  init                  Initialize project with state management
  network               Generate network layer (Dio client + interceptors)
  di                    Generate dependency injection setup
  barrel                Generate barrel (export) files for all features
  package-name:<name>   Update package name
  app-name:<name>       Update app display name
  delete:<name>         Delete a page and its related files

NAMING CONVENTION:
  Input              Class Name        File Name
  home               Home              home.dart
  setting.profile    SettingProfile    setting_profile.dart
  user.auth.login    UserAuthLogin     user_auth_login.dart

OPTIONS:
${parser.usage}

EXAMPLES:
  # Initialize project with Riverpod
  dart run yo.dart init --state=riverpod

  # Interactive mode (guided wizards)
  dart run yo.dart init --interactive
  dart run yo.dart page --interactive

  # Generate a full page
  dart run yo.dart page:home

  # Generate page with dot notation
  dart run yo.dart page:setting.profile

  # Generate presentation only
  dart run yo.dart page:auth.login --presentation-only

  # Force overwrite existing page
  dart run yo.dart page:home --force

  # Dry-run mode (preview without writing files)
  dart run yo.dart page:home --dry-run

  # Generate model with freezed
  dart run yo.dart model:user --freezed --feature=auth

  # Generate datasource (remote only)
  dart run yo.dart datasource:user --remote --feature=auth

  # Generate datasource (both remote and local)
  dart run yo.dart datasource:user --both --feature=auth

  # Generate global widget
  dart run yo.dart widget:custom.button --global

  # Generate all tests for a feature
  dart run yo.dart test:home

  # Generate only unit tests
  dart run yo.dart test:home --unit

  # Generate only widget tests
  dart run yo.dart test:home --widget

  # Generate provider/controller tests
  dart run yo.dart test:home --provider

  # Force overwrite existing tests
  dart run yo.dart test:home --force

  # Generate barrel (export) files
  dart run yo.dart barrel
  dart run yo.dart barrel --feature=home

  # Update translation
  dart run yo.dart translation --key=welcome --en="Welcome" --id="Selamat Datang"

  # Update package name
  dart run yo.dart package-name:com.company.myapp

  # Update app name
  dart run yo.dart app-name:"My Awesome App"

  # Delete a page (files only)
  dart run yo.dart delete:home

  # Delete entire feature folder
  dart run yo.dart delete:home --delete-feature
''');
}
