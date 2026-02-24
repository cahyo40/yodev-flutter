import 'package:path/path.dart' as path;

import '../config.dart';
import '../templates/bloc_templates.dart';
import '../templates/common_templates.dart';
import '../templates/getx_templates.dart';
import '../templates/riverpod_templates.dart';
import '../utils.dart';

/// Generator for creating pages with clean architecture
class PageGenerator {
  PageGenerator(this.config)
      : _common = CommonTemplates(config),
        _riverpod = RiverpodTemplates(config),
        _getx = GetXTemplates(config),
        _bloc = BlocTemplates(config);
  final YoConfig config;
  final CommonTemplates _common;
  final RiverpodTemplates _riverpod;
  final GetXTemplates _getx;
  final BlocTemplates _bloc;

  /// Generate a full page with all layers
  /// If [force] is true, overwrites existing files
  void generate(
    String name, {
    bool presentationOnly = false,
    bool force = false,
  }) {
    final featureName = YoUtils.getFeatureName(name);
    final fileName = YoUtils.toFileName(name);
    final className = YoUtils.toClassName(name);
    final featurePath = config.featurePath(featureName);

    // Check if page already exists
    final pagesPath = path.join(featurePath, 'presentation', 'pages');
    final pageFile = path.join(pagesPath, '${fileName}_page.dart');

    if (YoUtils.fileExists(pageFile) && !force) {
      Console.error('Page "$className" already exists!');
      Console.info('Location: $pageFile');
      Console.info('Use --force to overwrite existing files.');
      return;
    }

    if (YoUtils.fileExists(pageFile) && force) {
      Console.warning('Overwriting existing page: $className');
    }

    Console.header('Generating Page: $className');

    // Create presentation layer
    _generatePresentation(name, featurePath);

    if (!presentationOnly) {
      // Create data layer
      _generateData(name, featurePath);

      // Create domain layer
      _generateDomain(name, featurePath);
    }

    // Update routes
    _updateRoutes(name, featurePath);

    // Update feature in config
    _updateConfig(featureName);

    Console.success('Page $className generated successfully!');
  }

  void _generateData(String name, String featurePath) {
    final fileName = YoUtils.toFileName(name);
    final dataPath = path.join(featurePath, 'data');

    // Create models
    final modelsPath = path.join(dataPath, 'models');
    YoUtils.ensureDirectory(modelsPath);
    YoUtils.writeFile(
      path.join(modelsPath, '${fileName}_model.dart'),
      _common.modelWithEntity(name),
    );

    // Create datasources
    final datasourcesPath = path.join(dataPath, 'datasources');
    YoUtils.ensureDirectory(datasourcesPath);
    YoUtils.writeFile(
      path.join(datasourcesPath, '${fileName}_remote_datasource.dart'),
      _common.remoteDatasource(name),
    );

    // Create repositories
    final repositoriesPath = path.join(dataPath, 'repositories');
    YoUtils.ensureDirectory(repositoriesPath);
    YoUtils.writeFile(
      path.join(repositoriesPath, '${fileName}_repository_impl.dart'),
      _common.repositoryImpl(name),
    );
  }

  void _generateDomain(String name, String featurePath) {
    final fileName = YoUtils.toFileName(name);
    final domainPath = path.join(featurePath, 'domain');

    // Create entities
    final entitiesPath = path.join(domainPath, 'entities');
    YoUtils.ensureDirectory(entitiesPath);
    YoUtils.writeFile(
      path.join(entitiesPath, '${fileName}_entity.dart'),
      _common.entity(name),
    );

    // Create repository interface
    final repositoriesPath = path.join(domainPath, 'repositories');
    YoUtils.ensureDirectory(repositoriesPath);
    YoUtils.writeFile(
      path.join(repositoriesPath, '${fileName}_repository.dart'),
      _common.repositoryInterface(name),
    );

    // Create usecases
    final usecasesPath = path.join(domainPath, 'usecases');
    YoUtils.ensureDirectory(usecasesPath);
    YoUtils.writeFile(
      path.join(usecasesPath, '${fileName}_usecase.dart'),
      _common.usecase(name),
    );
  }

  void _generatePresentation(String name, String featurePath) {
    final fileName = YoUtils.toFileName(name);
    final presentationPath = path.join(featurePath, 'presentation');

    // Create pages directory
    final pagesPath = path.join(presentationPath, 'pages');
    YoUtils.ensureDirectory(pagesPath);

    // Generate page file based on state management
    String pageContent;
    switch (config.stateManagement) {
      case StateManagement.riverpod:
        pageContent = _riverpod.page(name);
        // Also generate provider
        final providersPath = path.join(presentationPath, 'providers');
        YoUtils.ensureDirectory(providersPath);
        YoUtils.writeFile(
          path.join(providersPath, '${fileName}_provider.dart'),
          _riverpod.provider(name),
        );
      case StateManagement.getx:
        pageContent = _getx.page(name);
        // Generate controller and binding
        final controllersPath = path.join(presentationPath, 'controllers');
        final bindingsPath = path.join(presentationPath, 'bindings');
        YoUtils.ensureDirectory(controllersPath);
        YoUtils.ensureDirectory(bindingsPath);
        YoUtils.writeFile(
          path.join(controllersPath, '${fileName}_controller.dart'),
          _getx.controller(name),
        );
        YoUtils.writeFile(
          path.join(bindingsPath, '${fileName}_binding.dart'),
          _getx.binding(name),
        );
      case StateManagement.bloc:
        pageContent = _bloc.page(name);
        // Generate bloc files
        final blocPath = path.join(presentationPath, 'bloc');
        YoUtils.ensureDirectory(blocPath);
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

    YoUtils.writeFile(
      path.join(pagesPath, '${fileName}_page.dart'),
      pageContent,
    );
  }

  void _updateConfig(String featureName) {
    if (!config.features.contains(featureName)) {
      config.copyWith(
        features: [...config.features, featureName],
      ).save();
    }
  }

  void _updateGetXPages(String name, String routerPath, String featureName) {
    final fileName = YoUtils.toFileName(name);
    final className = YoUtils.toClassName(name);
    final pagesFile = path.join(routerPath, 'app_pages.dart');

    if (!YoUtils.fileExists(pagesFile)) {
      // Create initial pages file
      final initialContent = '''
import 'package:get/get.dart';

class AppPages {
  static const initial = '/';

  static final routes = <GetPage>[
    // Add routes here
  ];
}
''';
      YoUtils.writeFile(pagesFile, initialContent);
    }

    var content = YoUtils.readFile(pagesFile);
    final pageImport =
        "import '../../features/$featureName/presentation/pages/${fileName}_page.dart';";
    final bindingImport =
        "import '../../features/$featureName/presentation/bindings/${fileName}_binding.dart';";
    final route = '''
    GetPage(
      name: ${className}Page.routeName,
      page: () => const ${className}Page(),
      binding: ${className}Binding(),
    ),''';

    if (!content.contains(pageImport)) {
      content = content.replaceFirst(
        "import 'package:get/get.dart';",
        "import 'package:get/get.dart';\n$pageImport\n$bindingImport",
      );
    }

    if (!content.contains('${className}Page.routeName')) {
      content = content.replaceFirst(
        '// Add routes here',
        '$route\n    // Add routes here',
      );
    }

    YoUtils.writeFile(pagesFile, content);
  }

  void _updateGoRouter(String name, String routerPath, String featureName) {
    final fileName = YoUtils.toFileName(name);
    final className = YoUtils.toClassName(name);
    final routerFile = path.join(routerPath, 'app_router.dart');

    if (!YoUtils.fileExists(routerFile)) {
      // Create initial router file
      YoUtils.writeFile(routerFile, _common.appRouter());
    }

    // Add import and route
    var content = YoUtils.readFile(routerFile);
    final import =
        "import '../../features/$featureName/presentation/pages/${fileName}_page.dart';";
    final route = '''
      GoRoute(
        path: ${className}Page.routeName,
        name: '${YoUtils.toCamelCase(className)}',
        builder: (context, state) => const ${className}Page(),
      ),''';

    if (!content.contains(import)) {
      content = content.replaceFirst(
        "import 'package:go_router/go_router.dart';",
        "import 'package:go_router/go_router.dart';\n$import",
      );
    }

    if (!content.contains('${className}Page.routeName')) {
      content = content.replaceFirst(
        '// Add more routes here',
        '$route\n      // Add more routes here',
      );
    }

    YoUtils.writeFile(routerFile, content);
  }

  void _updateRoutes(String name, String featurePath) {
    final featureName = YoUtils.getFeatureName(name);
    final routerPath = path.join(config.corePath, 'config');

    YoUtils.ensureDirectory(routerPath);

    switch (config.stateManagement) {
      case StateManagement.riverpod:
      case StateManagement.bloc:
        _updateGoRouter(name, routerPath, featureName);
      case StateManagement.getx:
        _updateGetXPages(name, routerPath, featureName);
    }
  }
}
