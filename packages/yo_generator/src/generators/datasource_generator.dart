import 'package:path/path.dart' as path;

import '../config.dart';
import '../templates/common_templates.dart';
import '../utils.dart';

/// Generator for creating datasources
class DatasourceGenerator {
  DatasourceGenerator(this.config) : _common = CommonTemplates(config);
  final YoConfig config;
  final CommonTemplates _common;

  /// Generate datasource files
  /// Validates that the feature exists first
  void generate(
    String name, {
    bool remote = true,
    bool local = false,
    String? feature,
    bool force = false,
  }) {
    final fileName = YoUtils.toFileName(name);
    final className = YoUtils.toClassName(name);
    final featureName = feature ?? YoUtils.getFeatureName(name);
    final featurePath = config.featurePath(featureName);
    final datasourcesPath = path.join(featurePath, 'data', 'datasources');

    // Validate feature exists
    if (!YoUtils.validateFeatureExists(config.featuresPath, featureName)) {
      return;
    }

    Console.header('Generating Datasource: $className');

    YoUtils.ensureDirectory(datasourcesPath);

    if (remote) {
      final remoteFile =
          path.join(datasourcesPath, '${fileName}_remote_datasource.dart');
      if (!force && YoUtils.fileExists(remoteFile)) {
        Console.warning(
          'Remote datasource already exists: ${fileName}_remote_datasource.dart',
        );
        Console.info('Use --force to overwrite');
      } else {
        YoUtils.writeFile(remoteFile, _common.remoteDatasource(name));
      }
    }

    if (local) {
      final localFile =
          path.join(datasourcesPath, '${fileName}_local_datasource.dart');
      if (!force && YoUtils.fileExists(localFile)) {
        Console.warning(
          'Local datasource already exists: ${fileName}_local_datasource.dart',
        );
        Console.info('Use --force to overwrite');
      } else {
        YoUtils.writeFile(localFile, _common.localDatasource(name));
      }
    }

    Console.success('Datasource $className generated successfully!');
  }
}
