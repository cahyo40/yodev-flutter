import 'package:path/path.dart' as path;

import '../config.dart';
import '../templates/common_templates.dart';
import '../utils.dart';

/// Generator for creating services
class ServiceGenerator {
  ServiceGenerator(this.config) : _common = CommonTemplates(config);
  final YoConfig config;
  final CommonTemplates _common;

  /// Generate service file
  /// If [force] is true, overwrites existing files
  void generate(String name, {bool force = false}) {
    final fileName = YoUtils.toFileName(name);
    final className = YoUtils.toClassName(name);
    final servicesPath = path.join(config.corePath, 'services');
    final serviceFile = path.join(servicesPath, '${fileName}_service.dart');

    // Check if file exists
    if (YoUtils.fileExists(serviceFile) && !force) {
      Console.error('Service "$className" already exists!');
      Console.info('Location: $serviceFile');
      Console.info('Use --force to overwrite existing files.');
      return;
    }

    if (YoUtils.fileExists(serviceFile) && force) {
      Console.warning('Overwriting existing service: $className');
    }

    Console.header('Generating Service: $className');

    YoUtils.ensureDirectory(servicesPath);

    YoUtils.writeFile(serviceFile, _common.service(name));

    Console.success('Service $className generated successfully!');
  }
}
