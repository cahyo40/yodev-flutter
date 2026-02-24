import 'dart:io';

import 'package:test/test.dart';

import '../src/config.dart';
import '../src/utils.dart';

void main() {
  group('YoConfig', () {
    test('should parse state management from string', () {
      expect(
        StateManagement.fromString('riverpod'),
        equals(StateManagement.riverpod),
      );
      expect(
        StateManagement.fromString('getx'),
        equals(StateManagement.getx),
      );
      expect(
        StateManagement.fromString('bloc'),
        equals(StateManagement.bloc),
      );
    });

    test('should default to riverpod for unknown state', () {
      expect(
        StateManagement.fromString('unknown'),
        equals(StateManagement.riverpod),
      );
    });

    test('should create default config when yo.yaml not exists', () {
      final tempDir = Directory.systemTemp.createTempSync('yo_test_');
      try {
        final config = YoConfig.load(tempDir.path);
        expect(config.stateManagement, equals(StateManagement.riverpod));
        expect(config.packageName, equals('com.example.app'));
        expect(config.appName, equals('My App'));
        expect(config.features, isEmpty);
      } finally {
        tempDir.deleteSync(recursive: true);
      }
    });

    test('should save and load config correctly', () {
      final tempDir = Directory.systemTemp.createTempSync('yo_test_');
      try {
        YoConfig(
          stateManagement: StateManagement.bloc,
          packageName: 'com.test.app',
          appName: 'Test App',
          features: ['home', 'profile'],
          projectPath: tempDir.path,
        ).save();

        final loaded = YoConfig.load(tempDir.path);
        expect(loaded.stateManagement, equals(StateManagement.bloc));
        expect(loaded.packageName, equals('com.test.app'));
        expect(loaded.appName, equals('Test App'));
        expect(loaded.features, equals(['home', 'profile']));
      } finally {
        tempDir.deleteSync(recursive: true);
      }
    });
  });

  group('YoUtils', () {
    test('toClassName should convert dot notation to PascalCase', () {
      expect(YoUtils.toClassName('home'), equals('Home'));
      expect(YoUtils.toClassName('setting.profile'), equals('SettingProfile'));
      expect(
        YoUtils.toClassName('user.auth.login'),
        equals('UserAuthLogin'),
      );
    });

    test('toFileName should convert dot notation to snake_case', () {
      expect(YoUtils.toFileName('home'), equals('home'));
      expect(YoUtils.toFileName('setting.profile'), equals('setting_profile'));
      expect(
        YoUtils.toFileName('user.auth.login'),
        equals('user_auth_login'),
      );
    });

    test('getFeatureName should extract first part of dot notation', () {
      expect(YoUtils.getFeatureName('home'), equals('home'));
      expect(YoUtils.getFeatureName('setting.profile'), equals('setting'));
      expect(YoUtils.getFeatureName('user.auth.login'), equals('user'));
    });

    test('parseCommand should split command and name', () {
      final (cmd1, name1) = YoUtils.parseCommand('page:home');
      expect(cmd1, equals('page'));
      expect(name1, equals('home'));

      final (cmd2, name2) = YoUtils.parseCommand('model:user');
      expect(cmd2, equals('model'));
      expect(name2, equals('user'));
    });

    test('parseCommand should throw for invalid format', () {
      expect(
        () => YoUtils.parseCommand('invalid'),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('toCamelCase should convert to camelCase', () {
      expect(YoUtils.toCamelCase('home_page'), equals('homePage'));
      expect(YoUtils.toCamelCase('SettingProfile'), equals('settingProfile'));
    });

    test('toPascalCase should convert to PascalCase', () {
      expect(YoUtils.toPascalCase('home_page'), equals('HomePage'));
      expect(YoUtils.toPascalCase('setting_profile'), equals('SettingProfile'));
    });

    test('toSnakeCase should convert to snake_case', () {
      expect(YoUtils.toSnakeCase('HomePage'), equals('home_page'));
      expect(
        YoUtils.toSnakeCase('SettingProfile'),
        equals('setting_profile'),
      );
    });
  });
}
