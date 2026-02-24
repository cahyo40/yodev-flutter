import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:yaml/yaml.dart';

import 'validator.dart';

/// State management types supported by the generator
enum StateManagement {
  riverpod,
  getx,
  bloc;

  static StateManagement fromString(String value) =>
      StateManagement.values.firstWhere(
        (e) => e.name == value.toLowerCase(),
        orElse: () => StateManagement.riverpod,
      );
}

/// Configuration for the generator
class YoConfig {
  YoConfig({
    required this.stateManagement,
    required this.packageName,
    required this.appName,
    required this.features,
    required this.projectPath,
  });
  final StateManagement stateManagement;
  final String packageName;
  final String appName;
  final List<String> features;
  final String projectPath;

  /// Get the core path
  String get corePath => path.join(libPath, 'core');

  /// Get the features path
  String get featuresPath => path.join(libPath, 'features');

  /// Get the l10n path
  String get l10nPath => path.join(libPath, 'l10n');

  /// Get the lib path
  String get libPath => path.join(projectPath, 'lib');

  /// Create a copy with updated values
  YoConfig copyWith({
    StateManagement? stateManagement,
    String? packageName,
    String? appName,
    List<String>? features,
    String? projectPath,
  }) =>
      YoConfig(
        stateManagement: stateManagement ?? this.stateManagement,
        packageName: packageName ?? this.packageName,
        appName: appName ?? this.appName,
        features: features ?? this.features,
        projectPath: projectPath ?? this.projectPath,
      );

  /// Get feature path by name
  String featurePath(String featureName) =>
      path.join(featuresPath, featureName.toLowerCase());

  /// Save configuration to yo.yaml
  void save() {
    final configFile = File(path.join(projectPath, 'yo.yaml'));
    final content = '''
state_management: ${stateManagement.name}
package_name: $packageName
app_name: $appName
features:
${features.map((f) => '  - $f').join('\n')}
''';
    configFile.writeAsStringSync(content);
  }

  /// Load configuration from yo.yaml
  // ignore: prefer_constructors_over_static_methods
  static YoConfig load([String? projectPath]) {
    projectPath ??= Directory.current.path;
    final configFile = File(path.join(projectPath, 'yo.yaml'));

    if (!configFile.existsSync()) {
      return YoConfig(
        stateManagement: StateManagement.riverpod,
        packageName: 'com.example.app',
        appName: 'My App',
        features: [],
        projectPath: projectPath,
      );
    }

    final content = configFile.readAsStringSync();
    final yaml = loadYaml(content) as YamlMap;

    final stateManagementStr =
        yaml['state_management']?.toString() ?? 'riverpod';
    final packageNameStr =
        yaml['package_name']?.toString() ?? 'com.example.app';
    final appNameStr = yaml['app_name']?.toString() ?? 'My App';
    final featuresList =
        (yaml['features'] as YamlList?)?.map((e) => e.toString()).toList() ??
            [];

    // Validate config values
    ConfigValidator.validateOrThrow(
      stateManagement: stateManagementStr,
      packageName: packageNameStr,
      appName: appNameStr,
      features: featuresList,
    );

    return YoConfig(
      stateManagement: StateManagement.fromString(stateManagementStr),
      packageName: packageNameStr,
      appName: appNameStr,
      features: featuresList,
      projectPath: projectPath,
    );
  }
}
