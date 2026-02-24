import 'dart:io';

import 'config.dart';
import 'utils.dart';

/// Interactive mode for yo.dart CLI
///
/// Provides wizard-style prompts for users who prefer guided
/// configuration over memorizing CLI flags.

// ignore_for_file: avoid_classes_with_only_static_members

class Interactive {
  /// Run the interactive init wizard
  static InteractiveResult? runInitWizard() {
    Console.header('yo.dart - Interactive Setup Wizard');
    print('');

    // Step 1: State Management
    print('Which state management would you like to use?');
    print('  [1] Riverpod (recommended)');
    print('  [2] GetX');
    print('  [3] Bloc');
    print('');
    stdout.write('Select [1-3] (default: 1): ');
    final stateInput = stdin.readLineSync()?.trim() ?? '1';
    final stateManagement = switch (stateInput) {
      '2' => 'getx',
      '3' => 'bloc',
      _ => 'riverpod',
    };
    print('');

    // Step 2: Package Name
    stdout.write('Enter package name (e.g., com.example.myapp): ');
    final packageName = stdin.readLineSync()?.trim() ?? '';
    if (packageName.isEmpty) {
      Console.warning('Using default: com.example.app');
    }
    print('');

    // Step 3: App Name
    stdout.write('Enter app display name: ');
    final appName = stdin.readLineSync()?.trim() ?? '';
    if (appName.isEmpty) {
      Console.warning('Using default: My App');
    }
    print('');

    // Step 4: Initial Features
    print(
      'Enter initial feature names (comma-separated, or press Enter to skip):',
    );
    stdout.write('Features: ');
    final featuresInput = stdin.readLineSync()?.trim() ?? '';
    final features = featuresInput.isEmpty
        ? <String>[]
        : featuresInput.split(',').map((f) => f.trim().toLowerCase()).toList();
    print('');

    // Confirm
    Console.header('Configuration Summary');
    print('  State Management: ${stateManagement.toUpperCase()}');
    print(
      '  Package Name:     ${packageName.isEmpty ? 'com.example.app' : packageName}',
    );
    print('  App Name:         ${appName.isEmpty ? 'My App' : appName}');
    print(
      '  Features:         ${features.isEmpty ? '(none)' : features.join(', ')}',
    );
    print('');
    stdout.write('Proceed with this configuration? [Y/n]: ');
    final confirm = stdin.readLineSync()?.trim().toLowerCase() ?? 'y';

    if (confirm == 'n' || confirm == 'no') {
      Console.info('Setup cancelled.');
      return null;
    }

    return InteractiveResult(
      stateManagement: stateManagement,
      packageName: packageName.isEmpty ? 'com.example.app' : packageName,
      appName: appName.isEmpty ? 'My App' : appName,
      features: features,
    );
  }

  /// Run the interactive page creation wizard
  static InteractivePageResult? runPageWizard(YoConfig config) {
    Console.header('yo.dart - Page Creation Wizard');
    print('');

    // Step 1: Page Name
    stdout.write('Enter page name (e.g., home, setting.profile): ');
    final name = stdin.readLineSync()?.trim() ?? '';
    if (name.isEmpty) {
      Console.error('Page name is required.');
      return null;
    }
    print('');

    // Step 2: Presentation Only?
    stdout.write('Presentation layer only? [y/N]: ');
    final presOnly = stdin.readLineSync()?.trim().toLowerCase() ?? 'n';
    final presentationOnly = presOnly == 'y' || presOnly == 'yes';
    print('');

    // Step 3: Force overwrite?
    stdout.write('Force overwrite existing files? [y/N]: ');
    final forceInput = stdin.readLineSync()?.trim().toLowerCase() ?? 'n';
    final force = forceInput == 'y' || forceInput == 'yes';
    print('');

    // Confirm
    Console.header('Page Configuration');
    print('  Name:              $name');
    print('  Presentation Only: $presentationOnly');
    print('  Force Overwrite:   $force');
    print('');
    stdout.write('Create this page? [Y/n]: ');
    final confirm = stdin.readLineSync()?.trim().toLowerCase() ?? 'y';

    if (confirm == 'n' || confirm == 'no') {
      Console.info('Page creation cancelled.');
      return null;
    }

    return InteractivePageResult(
      name: name,
      presentationOnly: presentationOnly,
      force: force,
    );
  }

  /// Prompt user to select a command
  static String? runCommandSelector() {
    Console.header('yo.dart - Command Selector');
    print('');
    print('What would you like to generate?');
    print('');
    print('  [1]  page          - Full page with clean architecture');
    print('  [2]  model         - Model class');
    print('  [3]  entity        - Entity class');
    print('  [4]  controller    - Controller/Provider/Bloc');
    print('  [5]  datasource    - Datasource (remote/local)');
    print('  [6]  usecase       - Use case');
    print('  [7]  repository    - Repository');
    print('  [8]  screen        - Screen widget');
    print('  [9]  dialog        - Dialog widget');
    print('  [10] widget        - Reusable widget');
    print('  [11] service       - Service');
    print('  [12] test          - Test files');
    print('  [13] network       - Network layer');
    print('  [14] di            - Dependency injection');
    print('  [15] init          - Initialize project');
    print('  [16] translation   - Update translations');
    print('  [17] barrel        - Generate barrel (export) files');
    print('');
    stdout.write('Select [1-17]: ');
    final input = stdin.readLineSync()?.trim() ?? '';

    return switch (input) {
      '1' => 'page',
      '2' => 'model',
      '3' => 'entity',
      '4' => 'controller',
      '5' => 'datasource',
      '6' => 'usecase',
      '7' => 'repository',
      '8' => 'screen',
      '9' => 'dialog',
      '10' => 'widget',
      '11' => 'service',
      '12' => 'test',
      '13' => 'network',
      '14' => 'di',
      '15' => 'init',
      '16' => 'translation',
      '17' => 'barrel',
      _ => null,
    };
  }
}

/// Result from the interactive init wizard
class InteractiveResult {
  InteractiveResult({
    required this.stateManagement,
    required this.packageName,
    required this.appName,
    required this.features,
  });
  final String stateManagement;
  final String packageName;
  final String appName;
  final List<String> features;
}

/// Result from the interactive page wizard
class InteractivePageResult {
  InteractivePageResult({
    required this.name,
    required this.presentationOnly,
    required this.force,
  });
  final String name;
  final bool presentationOnly;
  final bool force;
}
