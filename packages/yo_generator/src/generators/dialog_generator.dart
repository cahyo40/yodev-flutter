import 'package:path/path.dart' as path;

import '../config.dart';
import '../templates/bloc_templates.dart';
import '../templates/getx_templates.dart';
import '../templates/riverpod_templates.dart';
import '../utils.dart';

/// Generator for creating dialogs
class DialogGenerator {
  DialogGenerator(this.config)
      : _riverpod = RiverpodTemplates(config),
        _getx = GetXTemplates(config),
        _bloc = BlocTemplates(config);
  final YoConfig config;
  final RiverpodTemplates _riverpod;
  final GetXTemplates _getx;
  final BlocTemplates _bloc;

  /// Generate dialog file
  /// Validates that the feature exists first
  /// If [force] is true, overwrites existing files
  void generate(String name, {String? feature, bool force = false}) {
    final fileName = YoUtils.toFileName(name);
    final className = YoUtils.toClassName(name);
    final featureName = feature ?? YoUtils.getFeatureName(name);
    final featurePath = config.featurePath(featureName);
    final dialogsPath = path.join(featurePath, 'presentation', 'dialogs');
    final dialogFile = path.join(dialogsPath, '${fileName}_dialog.dart');

    // Validate feature exists
    if (!YoUtils.validateFeatureExists(config.featuresPath, featureName)) {
      return;
    }

    // Check if file exists
    if (YoUtils.fileExists(dialogFile) && !force) {
      Console.error('Dialog "$className" already exists!');
      Console.info('Location: $dialogFile');
      Console.info('Use --force to overwrite existing files.');
      return;
    }

    if (YoUtils.fileExists(dialogFile) && force) {
      Console.warning('Overwriting existing dialog: $className');
    }

    Console.header('Generating Dialog: $className');

    YoUtils.ensureDirectory(dialogsPath);

    String content;
    switch (config.stateManagement) {
      case StateManagement.riverpod:
        content = _riverpod.dialog(name);
      case StateManagement.getx:
        content = _getx.dialog(name);
      case StateManagement.bloc:
        content = _bloc.dialog(name);
    }

    YoUtils.writeFile(dialogFile, content);

    Console.success('Dialog $className generated successfully!');
  }
}
