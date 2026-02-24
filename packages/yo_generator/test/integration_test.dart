import 'dart:io';

import 'package:test/test.dart';

import '../src/config.dart';
import '../src/generators/generators.dart';

/// Integration tests for yo.dart generators
///
/// These tests create actual files in temporary directories and verify
/// the generator outputs are correct.
void main() {
  late Directory tempDir;
  late YoConfig config;

  setUp(() {
    tempDir = Directory.systemTemp.createTempSync('yo_integration_');

    // Create required directories
    Directory('${tempDir.path}/lib').createSync(recursive: true);

    // Create a minimal pubspec.yaml
    File('${tempDir.path}/pubspec.yaml').writeAsStringSync('''
name: test_app
description: Test app for integration tests

environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter

dev_dependencies:
  flutter_test:
    sdk: flutter
''');

    config = YoConfig(
      stateManagement: StateManagement.riverpod,
      packageName: 'com.test.app',
      appName: 'Test App',
      features: [],
      projectPath: tempDir.path,
    );
  });

  tearDown(() {
    tempDir.deleteSync(recursive: true);
  });

  group('InitGenerator Integration', () {
    test('should create core structure on init', () {
      InitGenerator(config).generate(StateManagement.riverpod);

      // Verify core directories
      expect(
        Directory('${tempDir.path}/lib/core/themes').existsSync(),
        isTrue,
      );
      expect(
        Directory('${tempDir.path}/lib/core/config').existsSync(),
        isTrue,
      );

      // Verify theme file
      expect(
        File('${tempDir.path}/lib/core/themes/app_theme.dart').existsSync(),
        isTrue,
      );

      // Verify router file
      expect(
        File('${tempDir.path}/lib/core/config/app_router.dart').existsSync(),
        isTrue,
      );

      // Verify yo.yaml was created
      expect(
        File('${tempDir.path}/yo.yaml').existsSync(),
        isTrue,
      );
    });

    test('should create GetX routing structure', () {
      InitGenerator(config).generate(StateManagement.getx);

      // GetX uses app_pages.dart instead of app_router.dart
      expect(
        File('${tempDir.path}/lib/core/config/app_pages.dart').existsSync(),
        isTrue,
      );
    });
  });

  group('PageGenerator Integration', () {
    test('should create full page structure with Riverpod', () {
      // Initialize first
      InitGenerator(config).generate(StateManagement.riverpod);

      // Reload config to get updated state
      final updatedConfig = YoConfig.load(tempDir.path);
      PageGenerator(updatedConfig).generate('home');

      final featurePath = '${tempDir.path}/lib/features/home';

      // Verify presentation layer
      expect(
        File('$featurePath/presentation/pages/home_page.dart').existsSync(),
        isTrue,
      );
      expect(
        File('$featurePath/presentation/providers/home_provider.dart')
            .existsSync(),
        isTrue,
      );

      // Verify domain layer
      expect(
        File('$featurePath/domain/entities/home_entity.dart').existsSync(),
        isTrue,
      );
      expect(
        File('$featurePath/domain/repositories/home_repository.dart')
            .existsSync(),
        isTrue,
      );
      expect(
        File('$featurePath/domain/usecases/home_usecase.dart').existsSync(),
        isTrue,
      );

      // Verify data layer
      expect(
        File('$featurePath/data/models/home_model.dart').existsSync(),
        isTrue,
      );
      expect(
        File('$featurePath/data/repositories/home_repository_impl.dart')
            .existsSync(),
        isTrue,
      );
      expect(
        File('$featurePath/data/datasources/home_remote_datasource.dart')
            .existsSync(),
        isTrue,
      );
    });

    test('should create presentation-only page', () {
      InitGenerator(config).generate(StateManagement.riverpod);
      final updatedConfig = YoConfig.load(tempDir.path);

      // Create the feature first with a full page
      PageGenerator(updatedConfig).generate('home');
      // Then create a presentation-only page within the feature
      PageGenerator(updatedConfig).generate(
        'home.settings',
        presentationOnly: true,
      );

      final featurePath = '${tempDir.path}/lib/features/home';

      // Verify presentation layer exists
      expect(
        File('$featurePath/presentation/pages/home_settings_page.dart')
            .existsSync(),
        isTrue,
      );
    });

    test('should update yo.yaml with new feature', () {
      InitGenerator(config).generate(StateManagement.riverpod);
      final updatedConfig = YoConfig.load(tempDir.path);

      PageGenerator(updatedConfig).generate('profile');

      final reloadedConfig = YoConfig.load(tempDir.path);
      expect(reloadedConfig.features, contains('profile'));
    });

    test('should handle dot notation for nested pages', () {
      InitGenerator(config).generate(StateManagement.riverpod);
      final updatedConfig = YoConfig.load(tempDir.path);

      PageGenerator(updatedConfig).generate('setting.profile');

      final featurePath = '${tempDir.path}/lib/features/setting';

      // Verify the page was created with the correct file name
      expect(
        File('$featurePath/presentation/pages/setting_profile_page.dart')
            .existsSync(),
        isTrue,
      );
    });

    test('should not overwrite existing page without --force', () {
      InitGenerator(config).generate(StateManagement.riverpod);
      final updatedConfig = YoConfig.load(tempDir.path);

      PageGenerator(updatedConfig).generate('home');

      // Get the original content
      final pagePath =
          '${tempDir.path}/lib/features/home/presentation/pages/home_page.dart';
      final originalContent = File(pagePath).readAsStringSync();

      // Try to generate again without force - should skip
      PageGenerator(updatedConfig).generate('home');

      // Content should remain the same
      final currentContent = File(pagePath).readAsStringSync();
      expect(currentContent, equals(originalContent));
    });

    test('should overwrite existing page with --force', () {
      InitGenerator(config).generate(StateManagement.riverpod);
      final updatedConfig = YoConfig.load(tempDir.path);

      PageGenerator(updatedConfig).generate('home');

      // Modify the page file
      final pagePath =
          '${tempDir.path}/lib/features/home/presentation/pages/home_page.dart';
      File(pagePath).writeAsStringSync('// modified content');

      // Regenerate with force
      PageGenerator(updatedConfig).generate('home', force: true);

      // Content should be regenerated (not the modified content)
      final currentContent = File(pagePath).readAsStringSync();
      expect(currentContent, isNot(equals('// modified content')));
      expect(currentContent, contains('HomePage'));
    });
  });

  group('ModelGenerator Integration', () {
    test('should create model and entity files', () {
      InitGenerator(config).generate(StateManagement.riverpod);
      final updatedConfig = YoConfig.load(tempDir.path);
      PageGenerator(updatedConfig).generate('auth');

      ModelGenerator(updatedConfig).generate('user', feature: 'auth');

      expect(
        File('${tempDir.path}/lib/features/auth/data/models/user_model.dart')
            .existsSync(),
        isTrue,
      );
      expect(
        File('${tempDir.path}/lib/features/auth/domain/entities/user_entity.dart')
            .existsSync(),
        isTrue,
      );
    });

    test('should create model content with correct class name', () {
      InitGenerator(config).generate(StateManagement.riverpod);
      final updatedConfig = YoConfig.load(tempDir.path);
      PageGenerator(updatedConfig).generate('auth');

      ModelGenerator(updatedConfig).generate('user', feature: 'auth');

      final content =
          File('${tempDir.path}/lib/features/auth/data/models/user_model.dart')
              .readAsStringSync();
      expect(content, contains('class UserModel'));
      expect(content, contains('fromJson'));
      expect(content, contains('toJson'));
      expect(content, contains('copyWith'));
    });
  });

  group('ControllerGenerator Integration', () {
    test('should create Riverpod provider file', () {
      InitGenerator(config).generate(StateManagement.riverpod);
      final updatedConfig = YoConfig.load(tempDir.path);
      PageGenerator(updatedConfig).generate('home');

      ControllerGenerator(updatedConfig).generate('dashboard', feature: 'home');

      expect(
        File('${tempDir.path}/lib/features/home/presentation/providers/dashboard_provider.dart')
            .existsSync(),
        isTrue,
      );
    });
  });

  group('DatasourceGenerator Integration', () {
    test('should create remote datasource', () {
      InitGenerator(config).generate(StateManagement.riverpod);
      final updatedConfig = YoConfig.load(tempDir.path);
      PageGenerator(updatedConfig).generate('auth');

      DatasourceGenerator(updatedConfig).generate('user', feature: 'auth');

      expect(
        File('${tempDir.path}/lib/features/auth/data/datasources/user_remote_datasource.dart')
            .existsSync(),
        isTrue,
      );
    });

    test('should create both remote and local datasources', () {
      InitGenerator(config).generate(StateManagement.riverpod);
      final updatedConfig = YoConfig.load(tempDir.path);
      PageGenerator(updatedConfig).generate('auth');

      DatasourceGenerator(updatedConfig).generate(
        'user',
        feature: 'auth',
        local: true,
      );

      expect(
        File('${tempDir.path}/lib/features/auth/data/datasources/user_remote_datasource.dart')
            .existsSync(),
        isTrue,
      );
      expect(
        File('${tempDir.path}/lib/features/auth/data/datasources/user_local_datasource.dart')
            .existsSync(),
        isTrue,
      );
    });
  });

  group('RepositoryGenerator Integration', () {
    test('should create repository interface and implementation', () {
      InitGenerator(config).generate(StateManagement.riverpod);
      final updatedConfig = YoConfig.load(tempDir.path);
      PageGenerator(updatedConfig).generate('auth');

      RepositoryGenerator(updatedConfig).generate('user', feature: 'auth');

      expect(
        File('${tempDir.path}/lib/features/auth/domain/repositories/user_repository.dart')
            .existsSync(),
        isTrue,
      );
      expect(
        File('${tempDir.path}/lib/features/auth/data/repositories/user_repository_impl.dart')
            .existsSync(),
        isTrue,
      );
    });
  });

  group('UsecaseGenerator Integration', () {
    test('should create usecase file', () {
      InitGenerator(config).generate(StateManagement.riverpod);
      final updatedConfig = YoConfig.load(tempDir.path);
      PageGenerator(updatedConfig).generate('auth');

      UsecaseGenerator(updatedConfig).generate('login', feature: 'auth');

      final usecasePath =
          '${tempDir.path}/lib/features/auth/domain/usecases/login_usecase.dart';
      expect(File(usecasePath).existsSync(), isTrue);

      final content = File(usecasePath).readAsStringSync();
      expect(content, contains('class LoginUseCase'));
      expect(content, contains('execute'));
    });
  });

  group('ServiceGenerator Integration', () {
    test('should create service in core directory', () {
      InitGenerator(config).generate(StateManagement.riverpod);
      final updatedConfig = YoConfig.load(tempDir.path);

      ServiceGenerator(updatedConfig).generate('analytics');

      final servicePath =
          '${tempDir.path}/lib/core/services/analytics_service.dart';
      expect(File(servicePath).existsSync(), isTrue);

      final content = File(servicePath).readAsStringSync();
      expect(content, contains('class AnalyticsService'));
    });
  });

  group('WidgetGenerator Integration', () {
    test('should create global widget in core', () {
      InitGenerator(config).generate(StateManagement.riverpod);
      final updatedConfig = YoConfig.load(tempDir.path);

      WidgetGenerator(updatedConfig).generate('custom_button', global: true);

      expect(
        File('${tempDir.path}/lib/core/widgets/custom_button_widget.dart')
            .existsSync(),
        isTrue,
      );
    });

    test('should create feature-specific widget', () {
      InitGenerator(config).generate(StateManagement.riverpod);
      final updatedConfig = YoConfig.load(tempDir.path);
      PageGenerator(updatedConfig).generate('home');

      WidgetGenerator(updatedConfig).generate('stat_card', feature: 'home');

      expect(
        File('${tempDir.path}/lib/features/home/presentation/widgets/stat_card_widget.dart')
            .existsSync(),
        isTrue,
      );
    });
  });

  group('ScreenGenerator Integration', () {
    test('should create screen with correct state management pattern', () {
      InitGenerator(config).generate(StateManagement.riverpod);
      final updatedConfig = YoConfig.load(tempDir.path);
      PageGenerator(updatedConfig).generate('home');

      ScreenGenerator(updatedConfig).generate('summary', feature: 'home');

      final screenPath =
          '${tempDir.path}/lib/features/home/presentation/screens/summary_screen.dart';
      expect(File(screenPath).existsSync(), isTrue);

      final content = File(screenPath).readAsStringSync();
      expect(content, contains('ConsumerWidget')); // Riverpod
    });
  });

  group('DialogGenerator Integration', () {
    test('should create dialog with correct state management pattern', () {
      InitGenerator(config).generate(StateManagement.riverpod);
      final updatedConfig = YoConfig.load(tempDir.path);
      PageGenerator(updatedConfig).generate('home');

      DialogGenerator(updatedConfig).generate('confirm', feature: 'home');

      final dialogPath =
          '${tempDir.path}/lib/features/home/presentation/dialogs/confirm_dialog.dart';
      expect(File(dialogPath).existsSync(), isTrue);

      final content = File(dialogPath).readAsStringSync();
      expect(content, contains('ConsumerWidget')); // Riverpod
      expect(content, contains('ConfirmDialog'));
    });
  });

  group('DeleteGenerator Integration', () {
    test('should delete page files', () {
      InitGenerator(config).generate(StateManagement.riverpod);
      final updatedConfig = YoConfig.load(tempDir.path);
      PageGenerator(updatedConfig).generate('home');

      // Verify files exist
      expect(
        File('${tempDir.path}/lib/features/home/presentation/pages/home_page.dart')
            .existsSync(),
        isTrue,
      );

      // Delete the page
      DeleteGenerator(updatedConfig).deletePage('home');

      // Verify page-specific files are deleted
      expect(
        File('${tempDir.path}/lib/features/home/presentation/pages/home_page.dart')
            .existsSync(),
        isFalse,
      );
    });

    test('should delete entire feature folder', () {
      InitGenerator(config).generate(StateManagement.riverpod);
      final updatedConfig = YoConfig.load(tempDir.path);
      PageGenerator(updatedConfig).generate('profile');

      // Verify feature exists
      expect(
        Directory('${tempDir.path}/lib/features/profile').existsSync(),
        isTrue,
      );

      // Delete entire feature
      DeleteGenerator(updatedConfig).deletePage(
        'profile',
        deleteFeature: true,
      );

      // Verify feature folder is deleted
      expect(
        Directory('${tempDir.path}/lib/features/profile').existsSync(),
        isFalse,
      );
    });
  });

  group('NetworkGenerator Integration', () {
    test('should create network layer files', () {
      InitGenerator(config).generate(StateManagement.riverpod);
      final updatedConfig = YoConfig.load(tempDir.path);

      NetworkGenerator(updatedConfig).generate();

      final networkPath = '${tempDir.path}/lib/core/network';
      expect(File('$networkPath/api_client.dart').existsSync(), isTrue);
      expect(File('$networkPath/dio_client.dart').existsSync(), isTrue);
      expect(
        File('$networkPath/interceptors/auth_interceptor.dart').existsSync(),
        isTrue,
      );
      expect(
        File('$networkPath/interceptors/logging_interceptor.dart').existsSync(),
        isTrue,
      );
      expect(
        File('$networkPath/interceptors/error_interceptor.dart').existsSync(),
        isTrue,
      );
    });
  });

  group('DIGenerator Integration', () {
    test('should create DI setup for Riverpod', () {
      InitGenerator(config).generate(StateManagement.riverpod);
      final updatedConfig = YoConfig.load(tempDir.path);

      DIGenerator(updatedConfig).generate();

      expect(
        File('${tempDir.path}/lib/core/di/providers.dart').existsSync(),
        isTrue,
      );

      final content =
          File('${tempDir.path}/lib/core/di/providers.dart').readAsStringSync();
      expect(content, contains('Provider'));
    });
  });

  group('Cross-State Management Tests', () {
    test('should generate GetX page structure', () {
      final getxConfig = config.copyWith(stateManagement: StateManagement.getx);
      InitGenerator(getxConfig).generate(StateManagement.getx);

      final updatedConfig = YoConfig.load(tempDir.path);
      PageGenerator(updatedConfig).generate('home');

      final featurePath = '${tempDir.path}/lib/features/home';
      expect(
        File('$featurePath/presentation/controllers/home_controller.dart')
            .existsSync(),
        isTrue,
      );
      expect(
        File('$featurePath/presentation/bindings/home_binding.dart')
            .existsSync(),
        isTrue,
      );
    });

    test('should generate Bloc page structure', () {
      final blocConfig = config.copyWith(stateManagement: StateManagement.bloc);
      InitGenerator(blocConfig).generate(StateManagement.bloc);

      final updatedConfig = YoConfig.load(tempDir.path);
      PageGenerator(updatedConfig).generate('home');

      final featurePath = '${tempDir.path}/lib/features/home';
      expect(
        File('$featurePath/presentation/bloc/home_bloc.dart').existsSync(),
        isTrue,
      );
      expect(
        File('$featurePath/presentation/bloc/home_event.dart').existsSync(),
        isTrue,
      );
      expect(
        File('$featurePath/presentation/bloc/home_state.dart').existsSync(),
        isTrue,
      );
    });
  });
}
