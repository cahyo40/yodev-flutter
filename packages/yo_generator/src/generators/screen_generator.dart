import 'package:path/path.dart' as path;

import '../config.dart';
import '../templates/bloc_templates.dart';
import '../templates/getx_templates.dart';
import '../templates/riverpod_templates.dart';
import '../utils.dart';

/// Generator for creating screens
class ScreenGenerator {
  ScreenGenerator(this.config)
      : _riverpod = RiverpodTemplates(config),
        _getx = GetXTemplates(config),
        _bloc = BlocTemplates(config);
  final YoConfig config;
  final RiverpodTemplates _riverpod;
  final GetXTemplates _getx;
  final BlocTemplates _bloc;

  /// Generate screen file
  /// Validates that the feature exists first
  /// If [force] is true, overwrites existing files
  void generate(String name, {String? feature, bool force = false}) {
    final fileName = YoUtils.toFileName(name);
    final className = YoUtils.toClassName(name);
    final featureName = feature ?? YoUtils.getFeatureName(name);
    final featurePath = config.featurePath(featureName);
    final screensPath = path.join(featurePath, 'presentation', 'screens');
    final screenFile = path.join(screensPath, '${fileName}_screen.dart');

    // Validate feature exists
    if (!YoUtils.validateFeatureExists(config.featuresPath, featureName)) {
      return;
    }

    // Check if file exists
    if (YoUtils.fileExists(screenFile) && !force) {
      Console.error('Screen "$className" already exists!');
      Console.info('Location: $screenFile');
      Console.info('Use --force to overwrite existing files.');
      return;
    }

    if (YoUtils.fileExists(screenFile) && force) {
      Console.warning('Overwriting existing screen: $className');
    }

    Console.header('Generating Screen: $className');

    YoUtils.ensureDirectory(screensPath);

    String content;
    switch (config.stateManagement) {
      case StateManagement.riverpod:
        content = _riverpod.screen(name);
      case StateManagement.getx:
        content = _getx.screen(name);
      case StateManagement.bloc:
        content = _bloc.screen(name);
    }

    YoUtils.writeFile(screenFile, content);

    Console.success('Screen $className generated successfully!');
  }
}
