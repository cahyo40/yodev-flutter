import 'package:path/path.dart' as path;

import '../config.dart';
import '../templates/bloc_templates.dart';
import '../templates/getx_templates.dart';
import '../templates/riverpod_templates.dart';
import '../utils.dart';

/// Generator for creating controllers/providers/blocs
class ControllerGenerator {
  ControllerGenerator(this.config)
      : _riverpod = RiverpodTemplates(config),
        _getx = GetXTemplates(config),
        _bloc = BlocTemplates(config);
  final YoConfig config;
  final RiverpodTemplates _riverpod;
  final GetXTemplates _getx;
  final BlocTemplates _bloc;

  /// Generate controller/provider/bloc file
  /// Validates that the feature exists first
  void generate(
    String name, {
    String? feature,
    bool useCubit = false,
    bool force = false,
  }) {
    final fileName = YoUtils.toFileName(name);
    final className = YoUtils.toClassName(name);
    final featureName = feature ?? YoUtils.getFeatureName(name);
    final featurePath = config.featurePath(featureName);
    final presentationPath = path.join(featurePath, 'presentation');

    // Validate feature exists
    if (!YoUtils.validateFeatureExists(config.featuresPath, featureName)) {
      return;
    }

    Console.header('Generating Controller: $className');

    switch (config.stateManagement) {
      case StateManagement.riverpod:
        final providersPath = path.join(presentationPath, 'providers');
        final providerFile =
            path.join(providersPath, '${fileName}_provider.dart');
        if (!force && YoUtils.fileExists(providerFile)) {
          Console.warning('Provider already exists: ${fileName}_provider.dart');
          Console.info('Use --force to overwrite');
          return;
        }
        YoUtils.ensureDirectory(providersPath);
        YoUtils.writeFile(providerFile, _riverpod.provider(name));
      case StateManagement.getx:
        final controllersPath = path.join(presentationPath, 'controllers');
        final controllerFile =
            path.join(controllersPath, '${fileName}_controller.dart');
        if (!force && YoUtils.fileExists(controllerFile)) {
          Console.warning(
            'Controller already exists: ${fileName}_controller.dart',
          );
          Console.info('Use --force to overwrite');
          return;
        }
        final bindingsPath = path.join(presentationPath, 'bindings');
        YoUtils.ensureDirectory(controllersPath);
        YoUtils.ensureDirectory(bindingsPath);
        YoUtils.writeFile(controllerFile, _getx.controller(name));
        YoUtils.writeFile(
          path.join(bindingsPath, '${fileName}_binding.dart'),
          _getx.binding(name),
        );
      case StateManagement.bloc:
        final blocPath = path.join(presentationPath, 'bloc');
        final blocFile = useCubit
            ? path.join(blocPath, '${fileName}_cubit.dart')
            : path.join(blocPath, '${fileName}_bloc.dart');
        if (!force && YoUtils.fileExists(blocFile)) {
          Console.warning(
            'Bloc already exists: ${useCubit ? "${fileName}_cubit.dart" : "${fileName}_bloc.dart"}',
          );
          Console.info('Use --force to overwrite');
          return;
        }
        YoUtils.ensureDirectory(blocPath);
        if (useCubit) {
          YoUtils.writeFile(
            path.join(blocPath, '${fileName}_cubit.dart'),
            _bloc.cubit(name),
          );
          YoUtils.writeFile(
            path.join(blocPath, '${fileName}_state.dart'),
            _bloc.cubitState(name),
          );
        } else {
          YoUtils.writeFile(
            path.join(blocPath, '${fileName}_bloc.dart'),
            _bloc.bloc(name),
          );
          YoUtils.writeFile(
            path.join(blocPath, '${fileName}_event.dart'),
            _bloc.event(name),
          );
          YoUtils.writeFile(
            path.join(blocPath, '${fileName}_state.dart'),
            _bloc.state(name),
          );
        }
    }

    Console.success('Controller $className generated successfully!');
  }
}
