import 'dart:io';

import 'package:test/test.dart';

import '../src/config.dart';
import '../src/dry_run.dart';
import '../src/exceptions.dart';
import '../src/plugin.dart';
import '../src/template_version.dart';
import '../src/validator.dart';

void main() {
  group('ConfigValidator', () {
    test('should validate correct config', () {
      final errors = ConfigValidator.validate(
        stateManagement: 'riverpod',
        packageName: 'com.example.app',
        appName: 'My App',
        features: ['home', 'profile'],
      );
      expect(errors, isEmpty);
    });

    test('should reject invalid state management', () {
      final errors = ConfigValidator.validate(
        stateManagement: 'invalid_sm',
        packageName: 'com.example.app',
        appName: 'My App',
        features: [],
      );
      expect(errors, isNotEmpty);
      expect(errors.first, contains('state_management'));
    });

    test('should reject invalid package name', () {
      final errors = ConfigValidator.validate(
        stateManagement: 'riverpod',
        packageName: 'InvalidPackage',
        appName: 'My App',
        features: [],
      );
      expect(errors, isNotEmpty);
      expect(errors.first, contains('package_name'));
    });

    test('should reject single-segment package name', () {
      final errors = ConfigValidator.validate(
        stateManagement: 'riverpod',
        packageName: 'myapp',
        appName: 'My App',
        features: [],
      );
      expect(errors, isNotEmpty);
    });

    test('should accept valid package names', () {
      final validNames = [
        'com.example.app',
        'id.co.company.myapp',
      ];
      for (final name in validNames) {
        final errors = ConfigValidator.validate(
          stateManagement: 'riverpod',
          packageName: name,
          appName: 'My App',
          features: [],
        );
        expect(errors, isEmpty, reason: 'Expected $name to be valid');
      }
    });

    test('should reject invalid feature names', () {
      final errors = ConfigValidator.validate(
        stateManagement: 'riverpod',
        packageName: 'com.example.app',
        appName: 'My App',
        features: ['Home', 'valid_feature', '123invalid'],
      );
      expect(errors.length, equals(2));
    });

    test('should detect duplicate features', () {
      final errors = ConfigValidator.validate(
        stateManagement: 'riverpod',
        packageName: 'com.example.app',
        appName: 'My App',
        features: ['home', 'profile', 'home'],
      );
      expect(errors, isNotEmpty);
      expect(errors.last, contains('Duplicate'));
    });

    test('should reject empty app name', () {
      final errors = ConfigValidator.validate(
        stateManagement: 'riverpod',
        packageName: 'com.example.app',
        appName: '   ',
        features: [],
      );
      expect(errors, isNotEmpty);
      expect(errors.first, contains('app_name'));
    });

    test('validateCommandName should accept valid names', () {
      expect(
        () => ConfigValidator.validateCommandName('home'),
        returnsNormally,
      );
      expect(
        () => ConfigValidator.validateCommandName('setting.profile'),
        returnsNormally,
      );
      expect(
        () => ConfigValidator.validateCommandName('user_auth'),
        returnsNormally,
      );
    });

    test('validateCommandName should reject invalid names', () {
      expect(
        () => ConfigValidator.validateCommandName(''),
        throwsA(isA<InvalidCommandException>()),
      );
      expect(
        () => ConfigValidator.validateCommandName('Home'),
        throwsA(isA<InvalidCommandException>()),
      );
      expect(
        () => ConfigValidator.validateCommandName('.profile'),
        throwsA(isA<InvalidCommandException>()),
      );
    });

    test('validateOrThrow should throw ConfigException on invalid config', () {
      expect(
        () => ConfigValidator.validateOrThrow(
          stateManagement: 'invalid',
          packageName: 'com.example.app',
          appName: 'My App',
          features: [],
        ),
        throwsA(isA<ConfigException>()),
      );
    });
  });

  group('YoException', () {
    test('should have message and suggestion', () {
      final ex = YoException('test error', suggestion: 'try this');
      expect(ex.message, equals('test error'));
      expect(ex.suggestion, equals('try this'));
      expect(ex.toString(), equals('test error'));
    });

    test('typed exceptions should extend YoException', () {
      expect(InvalidCommandException('test'), isA<YoException>());
      expect(ConfigException('test'), isA<YoException>());
      expect(FileNotFoundException('test'), isA<YoException>());
      expect(FileExistsException('test'), isA<YoException>());
      expect(FeatureNotFoundException('home'), isA<YoException>());
      expect(PageNotFoundException('home'), isA<YoException>());
      expect(TemplateException('test'), isA<YoException>());
      expect(DependencyException('test'), isA<YoException>());
    });

    test('FeatureNotFoundException should have suggestion', () {
      final ex = FeatureNotFoundException('auth');
      expect(ex.message, contains('auth'));
      expect(ex.suggestion, contains('dart run yo.dart page:auth'));
    });
  });

  group('TemplateVersion', () {
    test('should have current versions for all template types', () {
      expect(TemplateVersion.current, isNotEmpty);
      expect(TemplateVersion.current.containsKey('page'), isTrue);
      expect(TemplateVersion.current.containsKey('model'), isTrue);
      expect(TemplateVersion.current.containsKey('controller'), isTrue);
    });

    test('should generate valid header', () {
      final header = TemplateVersion.header('page');
      expect(header, contains('Generated by yo.dart'));
      expect(header, contains('Template: page@'));
    });

    test('should extract info from generated header', () {
      final header = TemplateVersion.header('page');
      final info = TemplateVersion.extractInfo(header);
      expect(info, isNotNull);
      expect(info!.templateType, equals('page'));
      expect(info.templateVersion, equals('1.0.0'));
    });

    test('should return null for non-generated content', () {
      final info = TemplateVersion.extractInfo('// just a regular file');
      expect(info, isNull);
    });

    test('should detect current version as not outdated', () {
      final header = TemplateVersion.header('page');
      expect(TemplateVersion.isOutdated(header), isFalse);
    });

    test('TemplateInfo.isUpToDate should work correctly', () {
      final info = TemplateInfo(
        generatorVersion: '1.0.0',
        templateType: 'page',
        templateVersion: '1.0.0',
      );
      expect(info.isUpToDate, isTrue);
    });
  });

  group('DryRun', () {
    setUp(DryRun.disable);

    tearDown(DryRun.disable);

    test('should start disabled', () {
      expect(DryRun.isEnabled, isFalse);
    });

    test('should enable and disable', () {
      DryRun.enable();
      expect(DryRun.isEnabled, isTrue);
      DryRun.disable();
      expect(DryRun.isEnabled, isFalse);
    });

    test('should record write actions when enabled', () {
      DryRun.enable();
      DryRun.writeFile('/fake/path/test.dart', 'content');
      expect(DryRun.actions, hasLength(1));
      expect(DryRun.actions.first.type, equals(DryRunActionType.createFile));
      expect(DryRun.actions.first.path, equals('/fake/path/test.dart'));
    });

    test('should record directory actions when enabled', () {
      DryRun.enable();
      DryRun.ensureDirectory('/fake/dir');
      expect(DryRun.actions, hasLength(1));
      expect(
        DryRun.actions.first.type,
        equals(DryRunActionType.createDirectory),
      );
    });

    test('should record delete actions when enabled', () {
      DryRun.enable();
      DryRun.deleteFile('/fake/file.dart');
      expect(DryRun.actions, hasLength(1));
      expect(DryRun.actions.first.type, equals(DryRunActionType.deleteFile));
    });

    test('should not create actual files when enabled', () {
      DryRun.enable();
      final tempPath =
          '${Directory.systemTemp.path}/yo_dryrun_test_${DateTime.now().millisecondsSinceEpoch}.dart';
      DryRun.writeFile(tempPath, 'test content');
      expect(File(tempPath).existsSync(), isFalse);
    });

    test('should clear actions on disable', () {
      DryRun.enable();
      DryRun.writeFile('/fake/path.dart', 'content');
      expect(DryRun.actions, isNotEmpty);
      DryRun.disable();
      expect(DryRun.actions, isEmpty);
    });

    test('DryRunAction toString should include type and path', () {
      final action = DryRunAction(
        type: DryRunActionType.createFile,
        path: '/test.dart',
        size: 100,
      );
      expect(action.toString(), contains('createFile'));
      expect(action.toString(), contains('/test.dart'));
      expect(action.toString(), contains('100'));
    });
  });

  group('PluginRegistry', () {
    setUp(PluginRegistry.clear);

    test('should start empty', () {
      expect(PluginRegistry.pluginNames, isEmpty);
    });

    test('should register and retrieve plugins', () {
      final config = YoConfig(
        stateManagement: StateManagement.riverpod,
        packageName: 'com.test.app',
        appName: 'Test',
        features: [],
        projectPath: '/tmp',
      );

      final plugin = _TestPlugin(config);
      PluginRegistry.register(plugin);

      expect(PluginRegistry.has('test'), isTrue);
      expect(PluginRegistry.get('test'), equals(plugin));
      expect(PluginRegistry.pluginNames, contains('test'));
    });

    test('should return null for unregistered plugins', () {
      expect(PluginRegistry.get('nonexistent'), isNull);
      expect(PluginRegistry.has('nonexistent'), isFalse);
    });

    test('should clear all plugins', () {
      final config = YoConfig(
        stateManagement: StateManagement.riverpod,
        packageName: 'com.test.app',
        appName: 'Test',
        features: [],
        projectPath: '/tmp',
      );

      PluginRegistry.register(_TestPlugin(config));
      expect(PluginRegistry.pluginNames, isNotEmpty);

      PluginRegistry.clear();
      expect(PluginRegistry.pluginNames, isEmpty);
    });
  });
}

/// Test plugin implementation for PluginRegistry tests
class _TestPlugin extends GeneratorPlugin {
  _TestPlugin(super.config);

  @override
  String get name => 'test';

  @override
  String get description => 'Test plugin';

  @override
  void execute(String? name, Map<String, dynamic> options) {
    // no-op for testing
  }
}
