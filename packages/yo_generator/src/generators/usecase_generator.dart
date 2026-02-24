import 'package:path/path.dart' as path;

import '../config.dart';
import '../templates/common_templates.dart';
import '../utils.dart';

/// Generator for creating usecases
class UsecaseGenerator {
  UsecaseGenerator(this.config) : _common = CommonTemplates(config);
  final YoConfig config;
  final CommonTemplates _common;

  /// Generate usecase file
  /// Validates that the feature exists first
  /// If [force] is true, overwrites existing files
  void generate(String name, {String? feature, bool force = false}) {
    final fileName = YoUtils.toFileName(name);
    final className = YoUtils.toClassName(name);
    final featureName = feature ?? YoUtils.getFeatureName(name);
    final featurePath = config.featurePath(featureName);
    final usecasesPath = path.join(featurePath, 'domain', 'usecases');
    final usecaseFile = path.join(usecasesPath, '${fileName}_usecase.dart');

    // Validate feature exists
    if (!YoUtils.validateFeatureExists(config.featuresPath, featureName)) {
      return;
    }

    // Check if file exists
    if (YoUtils.fileExists(usecaseFile) && !force) {
      Console.error('UseCase "$className" already exists!');
      Console.info('Location: $usecaseFile');
      Console.info('Use --force to overwrite existing files.');
      return;
    }

    if (YoUtils.fileExists(usecaseFile) && force) {
      Console.warning('Overwriting existing usecase: $className');
    }

    Console.header('Generating UseCase: $className');

    YoUtils.ensureDirectory(usecasesPath);

    YoUtils.writeFile(usecaseFile, _common.usecase(name));

    Console.success('UseCase $className generated successfully!');
  }
}
