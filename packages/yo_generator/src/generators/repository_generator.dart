import 'package:path/path.dart' as path;

import '../config.dart';
import '../templates/common_templates.dart';
import '../utils.dart';

/// Generator for creating repositories
class RepositoryGenerator {
  RepositoryGenerator(this.config) : _common = CommonTemplates(config);
  final YoConfig config;
  final CommonTemplates _common;

  /// Generate repository files (interface and implementation)
  /// Validates that the feature exists first
  /// If [force] is true, overwrites existing files
  void generate(String name, {String? feature, bool force = false}) {
    final fileName = YoUtils.toFileName(name);
    final className = YoUtils.toClassName(name);
    final featureName = feature ?? YoUtils.getFeatureName(name);
    final featurePath = config.featurePath(featureName);

    final domainRepoPath = path.join(featurePath, 'domain', 'repositories');
    final dataRepoPath = path.join(featurePath, 'data', 'repositories');
    final interfaceFile =
        path.join(domainRepoPath, '${fileName}_repository.dart');
    final implFile =
        path.join(dataRepoPath, '${fileName}_repository_impl.dart');

    // Validate feature exists
    if (!YoUtils.validateFeatureExists(config.featuresPath, featureName)) {
      return;
    }

    // Check if files exist
    if ((YoUtils.fileExists(interfaceFile) || YoUtils.fileExists(implFile)) &&
        !force) {
      Console.error('Repository "$className" already exists!');
      Console.info('Use --force to overwrite existing files.');
      return;
    }

    if ((YoUtils.fileExists(interfaceFile) || YoUtils.fileExists(implFile)) &&
        force) {
      Console.warning('Overwriting existing repository: $className');
    }

    Console.header('Generating Repository: $className');

    // Generate interface in domain layer
    YoUtils.ensureDirectory(domainRepoPath);
    YoUtils.writeFile(interfaceFile, _common.repositoryInterface(name));

    // Generate implementation in data layer
    YoUtils.ensureDirectory(dataRepoPath);
    YoUtils.writeFile(implFile, _common.repositoryImpl(name));

    Console.success('Repository $className generated successfully!');
  }
}
