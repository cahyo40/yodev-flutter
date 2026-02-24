import 'package:path/path.dart' as path;

import '../config.dart';
import '../templates/common_templates.dart';
import '../utils.dart';

/// Generator for creating models
class ModelGenerator {
  ModelGenerator(this.config) : _common = CommonTemplates(config);
  final YoConfig config;
  final CommonTemplates _common;

  /// Generate a model file
  /// Validates that the feature exists first
  void generate(
    String name, {
    bool freezed = false,
    String? feature,
    bool force = false,
  }) {
    final fileName = YoUtils.toFileName(name);
    final className = YoUtils.toClassName(name);
    final featureName = feature ?? YoUtils.getFeatureName(name);
    final featurePath = config.featurePath(featureName);
    final modelsPath = path.join(featurePath, 'data', 'models');

    // Validate feature exists
    if (!YoUtils.validateFeatureExists(config.featuresPath, featureName)) {
      return;
    }

    Console.header('Generating Model: $className');

    YoUtils.ensureDirectory(modelsPath);

    final modelFile = path.join(modelsPath, '${fileName}_model.dart');

    // Check if file exists and force is not set
    if (!force && YoUtils.fileExists(modelFile)) {
      Console.warning('Model already exists: ${fileName}_model.dart');
      Console.info('Use --force to overwrite');
      return;
    }

    if (freezed) {
      YoUtils.writeFile(modelFile, _common.modelFreezed(name));
      Console.info(
        'Run: dart run build_runner build --delete-conflicting-outputs',
      );
    } else {
      YoUtils.writeFile(modelFile, _common.modelWithEntity(name));
    }

    // Also generate entity
    final entitiesPath = path.join(featurePath, 'domain', 'entities');
    YoUtils.ensureDirectory(entitiesPath);

    final entityFile = path.join(entitiesPath, '${fileName}_entity.dart');
    if (force || !YoUtils.fileExists(entityFile)) {
      YoUtils.writeFile(entityFile, _common.entity(name));
    }

    Console.success('Model $className generated successfully!');
  }
}
