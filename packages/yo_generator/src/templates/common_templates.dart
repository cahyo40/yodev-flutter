import '../config.dart';
import '../utils.dart';

/// Common templates shared across all state management solutions
class CommonTemplates {
  CommonTemplates(this.config);
  final YoConfig config;

  /// Generate router file for GoRouter
  String appRouter() => r'''
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/home/presentation/pages/home_page.dart';

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),
      // Add more routes here
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page not found: ${state.error}'),
      ),
    ),
  );
}
''';

  /// Generate app theme file (using YoTheme from yo_ui)
  String appTheme() => '''
import 'package:flutter/material.dart';
import 'package:yo_ui/yo_ui.dart';

/// App theme configuration using YoTheme from yo_ui.
/// Customize the color scheme and font to match your brand.
class AppTheme {
  // Light theme - using YoTheme from yo_ui
  static ThemeData get light {
    return YoTheme.light(
      colorScheme: YoColorScheme.blue,
      fontFamily: YoFonts.inter,
    );
  }

  // Dark theme - using YoTheme from yo_ui
  static ThemeData get dark {
    return YoTheme.dark(
      colorScheme: YoColorScheme.blue,
      fontFamily: YoFonts.inter,
    );
  }
}
''';

  /// Generate translation ARB file
  String arbFile(String locale, Map<String, String> translations) {
    final buffer = StringBuffer()
      ..writeln('{')
      ..writeln('  "@@locale": "$locale",');

    final entries = translations.entries.toList();
    for (var i = 0; i < entries.length; i++) {
      final entry = entries[i];
      final comma = i < entries.length - 1 ? ',' : '';
      buffer.writeln('  "${entry.key}": "${entry.value}"$comma');
    }

    buffer.writeln('}');
    return buffer.toString();
  }

  /// Generate entity file
  String entity(String name) {
    final className = YoUtils.toClassName(name);

    return '''
import 'package:equatable/equatable.dart';

class ${className}Entity extends Equatable {
  final String id;
  // TODO: Add more fields

  const ${className}Entity({
    required this.id,
  });

  @override
  List<Object?> get props => [id];
}
''';
  }

  /// Generate l10n.yaml configuration
  String l10nYaml() => '''
arb-dir: lib/l10n
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart
''';

  /// Generate local datasource file
  String localDatasource(String name) {
    final className = YoUtils.toClassName(name);
    final fileName = YoUtils.toFileName(name);

    return '''
import '../models/${fileName}_model.dart';

abstract class ${className}LocalDataSource {
  Future<${className}Model?> getCached$className(String id);
  Future<List<${className}Model>> getAllCached$className();
  Future<void> cache$className(${className}Model data);
  Future<void> cacheAll$className(List<${className}Model> data);
  Future<void> clearCache();
}

class ${className}LocalDataSourceImpl implements ${className}LocalDataSource {
  // final SharedPreferences _prefs;
  // final Box<${className}Model> _box;

  ${className}LocalDataSourceImpl();

  static const String _cacheKey = '${fileName}_cache';

  @override
  Future<${className}Model?> getCached$className(String id) async {
    // TODO: Implement local storage retrieval
    throw UnimplementedError();
  }

  @override
  Future<List<${className}Model>> getAllCached$className() async {
    // TODO: Implement local storage retrieval
    throw UnimplementedError();
  }

  @override
  Future<void> cache$className(${className}Model data) async {
    // TODO: Implement local storage caching
    throw UnimplementedError();
  }

  @override
  Future<void> cacheAll$className(List<${className}Model> data) async {
    // TODO: Implement local storage caching
    throw UnimplementedError();
  }

  @override
  Future<void> clearCache() async {
    // TODO: Implement cache clearing
    throw UnimplementedError();
  }
}
''';
  }

  /// Generate main.dart with Bloc
  String mainBloc(String appName) => '''
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:yo_ui/yo_ui.dart';
import 'core/themes/app_theme.dart';
import 'core/config/app_router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Add your global BlocProviders here
      ],
      child: MaterialApp.router(
        title: '$appName',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.system,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
''';

  /// Generate main.dart with GetX
  String mainGetX(String appName) => '''
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:yo_ui/yo_ui.dart';
import 'core/themes/app_theme.dart';
import 'core/config/app_pages.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: '$appName',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
    );
  }
}
''';

  /// Generate main.dart with Riverpod
  String mainRiverpod(String appName) => '''
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:yo_ui/yo_ui.dart';
import 'core/themes/app_theme.dart';
import 'core/config/app_router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: '$appName',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: AppRouter.router,
    );
  }
}
''';

  /// Generate model file (manual)
  String model(String name) {
    final className = YoUtils.toClassName(name);

    return '''
import 'package:equatable/equatable.dart';

class $className extends Equatable {
  final String id;
  // TODO: Add more fields

  const $className({
    required this.id,
  });

  factory $className.fromJson(Map<String, dynamic> json) {
    return $className(
      id: json['id'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
    };
  }

  $className copyWith({
    String? id,
  }) {
    return $className(
      id: id ?? this.id,
    );
  }

  @override
  List<Object?> get props => [id];
}
''';
  }

  /// Generate model file with freezed
  String modelFreezed(String name) {
    final className = YoUtils.toClassName(name);
    final fileName = YoUtils.toFileName(name);

    return '''
import 'package:freezed_annotation/freezed_annotation.dart';

part '$fileName.freezed.dart';
part '$fileName.g.dart';

@freezed
class $className with _\$$className {
  const factory $className({
    required String id,
    // TODO: Add more fields
  }) = _$className;

  factory $className.fromJson(Map<String, dynamic> json) =>
      _\$${className}FromJson(json);
}
''';
  }

  /// Generate model with entity converter methods
  String modelWithEntity(String name) {
    final className = YoUtils.toClassName(name);
    final fileName = YoUtils.toFileName(name);

    return '''
import 'package:equatable/equatable.dart';
import '../../domain/entities/${fileName}_entity.dart';

class ${className}Model extends Equatable {
  final String id;
  // TODO: Add more fields

  const ${className}Model({
    required this.id,
  });

  factory ${className}Model.fromJson(Map<String, dynamic> json) {
    return ${className}Model(
      id: json['id'] as String,
    );
  }

  factory ${className}Model.fromEntity(${className}Entity entity) {
    return ${className}Model(
      id: entity.id,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
    };
  }

  ${className}Entity toEntity() {
    return ${className}Entity(
      id: id,
    );
  }

  ${className}Model copyWith({
    String? id,
  }) {
    return ${className}Model(
      id: id ?? this.id,
    );
  }

  @override
  List<Object?> get props => [id];
}
''';
  }

  /// Generate remote datasource file
  String remoteDatasource(String name) {
    final className = YoUtils.toClassName(name);
    final fileName = YoUtils.toFileName(name);

    return '''
import '../models/${fileName}_model.dart';

abstract class ${className}RemoteDataSource {
  Future<${className}Model> get$className(String id);
  Future<List<${className}Model>> getAll$className();
  Future<${className}Model> create$className(${className}Model data);
  Future<${className}Model> update$className(${className}Model data);
  Future<bool> delete$className(String id);
}

class ${className}RemoteDataSourceImpl implements ${className}RemoteDataSource {
  // final Dio _dio;
  // final ApiClient _apiClient;

  ${className}RemoteDataSourceImpl();

  @override
  Future<${className}Model> get$className(String id) async {
    // TODO: Implement API call
    throw UnimplementedError();
  }

  @override
  Future<List<${className}Model>> getAll$className() async {
    // TODO: Implement API call
    throw UnimplementedError();
  }

  @override
  Future<${className}Model> create$className(${className}Model data) async {
    // TODO: Implement API call
    throw UnimplementedError();
  }

  @override
  Future<${className}Model> update$className(${className}Model data) async {
    // TODO: Implement API call
    throw UnimplementedError();
  }

  @override
  Future<bool> delete$className(String id) async {
    // TODO: Implement API call
    throw UnimplementedError();
  }
}
''';
  }

  /// Generate repository implementation file
  String repositoryImpl(String name) {
    final className = YoUtils.toClassName(name);
    final fileName = YoUtils.toFileName(name);

    return '''
import '../../domain/entities/${fileName}_entity.dart';
import '../../domain/repositories/${fileName}_repository.dart';
import '../datasources/${fileName}_remote_datasource.dart';
import '../datasources/${fileName}_local_datasource.dart';
import '../models/${fileName}_model.dart';

class ${className}RepositoryImpl implements ${className}Repository {
  final ${className}RemoteDataSource _remoteDataSource;
  final ${className}LocalDataSource? _localDataSource;

  ${className}RepositoryImpl({
    required ${className}RemoteDataSource remoteDataSource,
    ${className}LocalDataSource? localDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;

  @override
  Future<${className}Entity> get$className(String id) async {
    try {
      // Try to get from cache first
      if (_localDataSource != null) {
        final cached = await _localDataSource!.getCached$className(id);
        if (cached != null) {
          return cached.toEntity();
        }
      }

      // Fetch from remote
      final result = await _remoteDataSource.get$className(id);
      
      // Cache the result
      if (_localDataSource != null) {
        await _localDataSource!.cache$className(result);
      }

      return result.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<${className}Entity>> getAll$className() async {
    try {
      final result = await _remoteDataSource.getAll$className();
      
      if (_localDataSource != null) {
        await _localDataSource!.cacheAll$className(result);
      }

      return result.map((e) => e.toEntity()).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<${className}Entity> create$className(${className}Entity data) async {
    try {
      final model = ${className}Model.fromEntity(data);
      final result = await _remoteDataSource.create$className(model);
      return result.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<${className}Entity> update$className(${className}Entity data) async {
    try {
      final model = ${className}Model.fromEntity(data);
      final result = await _remoteDataSource.update$className(model);

      if (_localDataSource != null) {
        await _localDataSource!.cache$className(result);
      }

      return result.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> delete$className(String id) async {
    try {
      final result = await _remoteDataSource.delete$className(id);

      if (_localDataSource != null) {
        await _localDataSource!.clearCache();
      }

      return result;
    } catch (e) {
      rethrow;
    }
  }
}

// Extension to convert between Model and Entity
extension ${className}ModelExtension on ${className}Model {
  ${className}Entity toEntity() {
    return ${className}Entity(
      id: id,
    );
  }
}

extension ${className}EntityExtension on ${className}Entity {
  ${className}Model toModel() {
    return ${className}Model(
      id: id,
    );
  }
}
''';
  }

  /// Generate repository interface file
  String repositoryInterface(String name) {
    final className = YoUtils.toClassName(name);
    final fileName = YoUtils.toFileName(name);

    return '''
import '../entities/${fileName}_entity.dart';

abstract class ${className}Repository {
  Future<${className}Entity> get$className(String id);
  Future<List<${className}Entity>> getAll$className();
  Future<${className}Entity> create$className(${className}Entity data);
  Future<${className}Entity> update$className(${className}Entity data);
  Future<bool> delete$className(String id);
}
''';
  }

  /// Generate service file
  String service(String name) {
    final className = YoUtils.toClassName(name);

    return '''
/// ${className}Service
/// 
/// A service class that provides functionality for $className operations.
class ${className}Service {
  // Singleton pattern
  static final ${className}Service _instance = ${className}Service._internal();
  factory ${className}Service() => _instance;
  ${className}Service._internal();

  /// Initialize the service
  Future<void> init() async {
    // TODO: Implement initialization
  }

  /// Dispose the service
  void dispose() {
    // TODO: Implement disposal
  }

  // TODO: Add service methods
}
''';
  }

  /// Generate tasks.json for VSCode
  String tasksJson() => r'''
{
  "version": "2.0.0",
  "tasks": [
    {
      "label": "yo: Generate Page",
      "type": "shell",
      "command": "dart run yo.dart page:${input:pageName}",
      "group": "build",
      "problemMatcher": []
    },
    {
      "label": "yo: Generate Page (Presentation Only)",
      "type": "shell",
      "command": "dart run yo.dart page:${input:pageName} --presentation-only",
      "group": "build",
      "problemMatcher": []
    },
    {
      "label": "yo: Generate Model",
      "type": "shell",
      "command": "dart run yo.dart model:${input:modelName}",
      "group": "build",
      "problemMatcher": []
    },
    {
      "label": "yo: Generate Model (Freezed)",
      "type": "shell",
      "command": "dart run yo.dart model:${input:modelName} --freezed",
      "group": "build",
      "problemMatcher": []
    },
    {
      "label": "yo: Generate Datasource (Remote)",
      "type": "shell",
      "command": "dart run yo.dart datasource:${input:datasourceName} --remote",
      "group": "build",
      "problemMatcher": []
    },
    {
      "label": "yo: Generate Datasource (Local)",
      "type": "shell",
      "command": "dart run yo.dart datasource:${input:datasourceName} --local",
      "group": "build",
      "problemMatcher": []
    },
    {
      "label": "yo: Generate Datasource (Both)",
      "type": "shell",
      "command": "dart run yo.dart datasource:${input:datasourceName} --both",
      "group": "build",
      "problemMatcher": []
    },
    {
      "label": "yo: Generate UseCase",
      "type": "shell",
      "command": "dart run yo.dart usecase:${input:usecaseName}",
      "group": "build",
      "problemMatcher": []
    },
    {
      "label": "yo: Generate Repository",
      "type": "shell",
      "command": "dart run yo.dart repository:${input:repositoryName}",
      "group": "build",
      "problemMatcher": []
    },
    {
      "label": "yo: Generate Screen",
      "type": "shell",
      "command": "dart run yo.dart screen:${input:screenName}",
      "group": "build",
      "problemMatcher": []
    },
    {
      "label": "yo: Generate Dialog",
      "type": "shell",
      "command": "dart run yo.dart dialog:${input:dialogName}",
      "group": "build",
      "problemMatcher": []
    },
    {
      "label": "yo: Generate Widget",
      "type": "shell",
      "command": "dart run yo.dart widget:${input:widgetName}",
      "group": "build",
      "problemMatcher": []
    },
    {
      "label": "yo: Generate Service",
      "type": "shell",
      "command": "dart run yo.dart service:${input:serviceName}",
      "group": "build",
      "problemMatcher": []
    },
    {
      "label": "yo: Generate Controller",
      "type": "shell",
      "command": "dart run yo.dart controller:${input:controllerName}",
      "group": "build",
      "problemMatcher": []
    },
    {
      "label": "yo: Update Translation",
      "type": "shell",
      "command": "dart run yo.dart translation --key=${input:translationKey} --en=${input:translationEn} --id=${input:translationId}",
      "group": "build",
      "problemMatcher": []
    },
    {
      "label": "yo: Initialize Project (Riverpod)",
      "type": "shell",
      "command": "dart run yo.dart init --state=riverpod",
      "group": "build",
      "problemMatcher": []
    },
    {
      "label": "yo: Initialize Project (GetX)",
      "type": "shell",
      "command": "dart run yo.dart init --state=getx",
      "group": "build",
      "problemMatcher": []
    },
    {
      "label": "yo: Initialize Project (Bloc)",
      "type": "shell",
      "command": "dart run yo.dart init --state=bloc",
      "group": "build",
      "problemMatcher": []
    },
    {
      "label": "yo: Update Package Name",
      "type": "shell",
      "command": "dart run yo.dart package-name:${input:packageName}",
      "group": "build",
      "problemMatcher": []
    },
    {
      "label": "yo: Update App Name",
      "type": "shell",
      "command": "dart run yo.dart app-name:${input:appName}",
      "group": "build",
      "problemMatcher": []
    },
    {
      "label": "Flutter: Build Runner",
      "type": "shell",
      "command": "dart run build_runner build --delete-conflicting-outputs",
      "group": "build",
      "problemMatcher": []
    },
    {
      "label": "Flutter: Build Runner Watch",
      "type": "shell",
      "command": "dart run build_runner watch --delete-conflicting-outputs",
      "group": "build",
      "problemMatcher": [],
      "isBackground": true
    },
    {
      "label": "Flutter: Generate L10n",
      "type": "shell",
      "command": "flutter gen-l10n",
      "group": "build",
      "problemMatcher": []
    }
  ],
  "inputs": [
    {
      "id": "pageName",
      "description": "Page name (e.g., home or setting.profile)",
      "type": "promptString"
    },
    {
      "id": "modelName",
      "description": "Model name (e.g., user or product.item)",
      "type": "promptString"
    },
    {
      "id": "datasourceName",
      "description": "Datasource name (e.g., auth or user.profile)",
      "type": "promptString"
    },
    {
      "id": "usecaseName",
      "description": "UseCase name (e.g., login or get.user)",
      "type": "promptString"
    },
    {
      "id": "repositoryName",
      "description": "Repository name (e.g., user or product)",
      "type": "promptString"
    },
    {
      "id": "screenName",
      "description": "Screen name (e.g., profile or settings.general)",
      "type": "promptString"
    },
    {
      "id": "dialogName",
      "description": "Dialog name (e.g., confirm or login.error)",
      "type": "promptString"
    },
    {
      "id": "widgetName",
      "description": "Widget name (e.g., button or card.product)",
      "type": "promptString"
    },
    {
      "id": "serviceName",
      "description": "Service name (e.g., analytics or notification)",
      "type": "promptString"
    },
    {
      "id": "controllerName",
      "description": "Controller name (e.g., home or setting.profile)",
      "type": "promptString"
    },
    {
      "id": "translationKey",
      "description": "Translation key (e.g., appTitle)",
      "type": "promptString"
    },
    {
      "id": "translationEn",
      "description": "English translation",
      "type": "promptString"
    },
    {
      "id": "translationId",
      "description": "Indonesian translation",
      "type": "promptString"
    },
    {
      "id": "packageName",
      "description": "Package name (e.g., com.example.myapp)",
      "type": "promptString"
    },
    {
      "id": "appName",
      "description": "App display name",
      "type": "promptString"
    }
  ]
}
''';

  /// Generate usecase file
  String usecase(String name) {
    final className = YoUtils.toClassName(name);
    final fileName = YoUtils.toFileName(name);

    return '''
import '../entities/${fileName}_entity.dart';
import '../repositories/${fileName}_repository.dart';

class ${className}UseCase {
  final ${className}Repository _repository;

  ${className}UseCase(this._repository);

  Future<${className}Entity?> execute({String? id}) async {
    if (id != null) {
      return await _repository.get$className(id);
    }
    return null;
  }

  Future<List<${className}Entity>> getAll() async {
    return await _repository.getAll$className();
  }

  Future<${className}Entity> create(${className}Entity data) async {
    return await _repository.create$className(data);
  }

  Future<${className}Entity> update(${className}Entity data) async {
    return await _repository.update$className(data);
  }

  Future<bool> delete(String id) async {
    return await _repository.delete$className(id);
  }
}
''';
  }

  /// Generate widget file
  String widget(String name) {
    final className = YoUtils.toClassName(name);

    return '''
import 'package:flutter/material.dart';
import 'package:yo_ui/yo_ui.dart';

class ${className}Widget extends StatelessWidget {
  const ${className}Widget({super.key});

  @override
  Widget build(BuildContext context) {
    return YoCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: YoText('$className Widget'),
      ),
    );
  }
}
''';
  }
}
