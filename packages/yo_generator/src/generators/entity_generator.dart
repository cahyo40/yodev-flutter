import 'package:path/path.dart' as path;

import '../config.dart';
import '../templates/common_templates.dart';
import '../utils.dart';

/// Generator for entity files
class EntityGenerator {
  EntityGenerator(this.config) : _templates = CommonTemplates(config);
  final YoConfig config;
  final CommonTemplates _templates;

  /// Generate entity file
  void generate(String name, {String? feature, bool force = false}) {
    final featureName = feature ?? YoUtils.getFeatureName(name);
    final fileName = YoUtils.toFileName(name);
    final className = YoUtils.toClassName(name);

    final featurePath = path.join(config.featuresPath, featureName);

    // Validate feature exists
    if (!YoUtils.validateFeatureExists(config.featuresPath, featureName)) {
      return;
    }

    final entityPath = path.join(featurePath, 'domain', 'entities');
    YoUtils.ensureDirectory(entityPath);

    final entityFile = path.join(entityPath, '${fileName}_entity.dart');

    // Check if file exists
    if (!force && YoUtils.fileExists(entityFile)) {
      Console.warning('Entity already exists: ${fileName}_entity.dart');
      Console.info('Use --force to overwrite');
      return;
    }

    // Generate entity
    YoUtils.writeFile(entityFile, _templates.entity(name));

    Console.success('Created entity: ${className}Entity');
    Console.info('  → $entityFile');
  }
}
