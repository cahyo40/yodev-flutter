import 'exceptions.dart';

/// Schema validator for yo.yaml configuration
///
/// Validates the configuration values to prevent corrupt configs
/// and provide clear error messages when configuration is invalid.

// ignore_for_file: avoid_classes_with_only_static_members

class ConfigValidator {
  /// Valid state management values
  static const validStateManagements = ['riverpod', 'getx', 'bloc'];

  /// Package name pattern: com.example.app (at least 2 segments)
  static final _packageNamePattern =
      RegExp(r'^[a-z][a-z0-9]*(\.[a-z][a-z0-9]*)+$');

  /// Feature name pattern: lowercase letters, numbers, underscores
  static final _featureNamePattern = RegExp(r'^[a-z][a-z0-9_]*$');

  /// Validate the complete configuration
  static List<String> validate({
    required String? stateManagement,
    required String? packageName,
    required String? appName,
    required List<String>? features,
  }) {
    final errors = <String>[];

    // Validate state management
    if (stateManagement != null &&
        !validStateManagements.contains(stateManagement.toLowerCase())) {
      errors.add(
        'Invalid state_management: "$stateManagement". '
        'Allowed values: ${validStateManagements.join(', ')}',
      );
    }

    // Validate package name
    if (packageName != null && packageName.isNotEmpty) {
      if (!_packageNamePattern.hasMatch(packageName)) {
        errors.add(
          'Invalid package_name: "$packageName". '
          'Must be in format: com.example.app (at least 2 segments, '
          'lowercase letters, numbers, dots only)',
        );
      }
    }

    // Validate app name
    if (appName != null && appName.trim().isEmpty) {
      errors.add('app_name cannot be empty.');
    }

    // Validate features
    if (features != null) {
      for (final feature in features) {
        if (!_featureNamePattern.hasMatch(feature)) {
          errors.add(
            'Invalid feature name: "$feature". '
            'Must start with a lowercase letter and contain only '
            'lowercase letters, numbers, and underscores.',
          );
        }
      }

      // Check for duplicates
      final uniqueFeatures = features.toSet();
      if (uniqueFeatures.length != features.length) {
        final duplicates =
            features.where((f) => features.where((x) => x == f).length > 1);
        errors.add(
          'Duplicate features found: ${duplicates.toSet().join(', ')}',
        );
      }
    }

    return errors;
  }

  /// Validate a single command name input (e.g., 'home', 'setting.profile')
  static void validateCommandName(String name) {
    if (name.isEmpty) {
      throw InvalidCommandException(
        'Command name cannot be empty.',
        suggestion: 'Provide a name like: page:home',
      );
    }

    final parts = name.split('.');
    for (final part in parts) {
      if (part.isEmpty) {
        throw InvalidCommandException(
          'Invalid name format: "$name". '
          'Each segment must not be empty.',
          suggestion: 'Use format: feature.page (e.g., setting.profile)',
        );
      }

      if (!RegExp(r'^[a-z][a-z0-9_]*$').hasMatch(part)) {
        throw InvalidCommandException(
          'Invalid name segment: "$part" in "$name". '
          'Must start with a lowercase letter and contain only '
          'lowercase letters, numbers, and underscores.',
          suggestion:
              'Use lowercase with underscores: ${part.toLowerCase().replaceAll(RegExp('[^a-z0-9_]'), '_')}',
        );
      }
    }
  }

  /// Validate configuration file content and throw if invalid
  static void validateOrThrow({
    required String? stateManagement,
    required String? packageName,
    required String? appName,
    required List<String>? features,
  }) {
    final errors = validate(
      stateManagement: stateManagement,
      packageName: packageName,
      appName: appName,
      features: features,
    );

    if (errors.isNotEmpty) {
      throw ConfigException(
        'Invalid yo.yaml configuration:\n${errors.map((e) => '  • $e').join('\n')}',
        suggestion: 'Fix the errors in yo.yaml and try again.',
      );
    }
  }

  /// Validate a new package name before applying
  static void validatePackageName(String packageName) {
    if (!_packageNamePattern.hasMatch(packageName)) {
      throw InvalidCommandException(
        'Invalid package name: "$packageName".',
        suggestion:
            'Use format: com.example.app (at least 2 segments, lowercase)',
      );
    }
  }
}
