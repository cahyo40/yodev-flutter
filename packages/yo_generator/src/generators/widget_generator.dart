import 'package:path/path.dart' as path;

import '../config.dart';
import '../templates/common_templates.dart';
import '../utils.dart';

/// Generator for creating widgets
class WidgetGenerator {
  WidgetGenerator(this.config) : _common = CommonTemplates(config);
  final YoConfig config;
  final CommonTemplates _common;

  /// Generate widget file
  /// For feature widgets, validates that the feature exists first
  /// If [force] is true, overwrites existing files
  void generate(
    String name, {
    String? feature,
    bool global = false,
    bool force = false,
  }) {
    final fileName = YoUtils.toFileName(name);
    final className = YoUtils.toClassName(name);

    String widgetsPath;
    if (global || feature == null) {
      widgetsPath = path.join(config.corePath, 'widgets');
    } else {
      // Validate feature exists for non-global widgets
      if (!YoUtils.validateFeatureExists(config.featuresPath, feature)) {
        return;
      }
      final featurePath = config.featurePath(feature);
      widgetsPath = path.join(featurePath, 'presentation', 'widgets');
    }

    final widgetFile = path.join(widgetsPath, '${fileName}_widget.dart');

    // Check if file exists
    if (YoUtils.fileExists(widgetFile) && !force) {
      Console.error('Widget "$className" already exists!');
      Console.info('Location: $widgetFile');
      Console.info('Use --force to overwrite existing files.');
      return;
    }

    if (YoUtils.fileExists(widgetFile) && force) {
      Console.warning('Overwriting existing widget: $className');
    }

    Console.header('Generating Widget: $className');

    YoUtils.ensureDirectory(widgetsPath);

    YoUtils.writeFile(widgetFile, _common.widget(name));

    Console.success('Widget $className generated successfully!');
  }
}
