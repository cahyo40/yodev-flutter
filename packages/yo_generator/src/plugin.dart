import 'dart:io';

import 'package:path/path.dart' as path;

import 'config.dart';
import 'utils.dart';

/// Plugin system for extending yo.dart with custom generators
///
/// Allows loading and running custom generator plugins from a
/// `yo_plugins/` directory in the project root.

/// Base class for all generator plugins
abstract class GeneratorPlugin {
  GeneratorPlugin(this.config);
  final YoConfig config;

  /// Unique name of this plugin (used as command name)
  String get name;

  /// Short description shown in help
  String get description;

  /// Execute the plugin with the given arguments
  void execute(String? name, Map<String, dynamic> options);
}

/// Plugin registry and loader

// ignore_for_file: avoid_classes_with_only_static_members

class PluginRegistry {
  static final Map<String, GeneratorPlugin> _plugins = {};

  /// Register a plugin
  static void register(GeneratorPlugin plugin) {
    _plugins[plugin.name] = plugin;
  }

  /// Get a registered plugin by name
  static GeneratorPlugin? get(String name) => _plugins[name];

  /// Check if a plugin is registered
  static bool has(String name) => _plugins.containsKey(name);

  /// Get all registered plugin names
  static List<String> get pluginNames => _plugins.keys.toList();

  /// Get all registered plugins
  static Map<String, GeneratorPlugin> get all => Map.unmodifiable(_plugins);

  /// Clear all registered plugins
  static void clear() => _plugins.clear();

  /// Load plugins from the yo_plugins directory
  static void loadPlugins(YoConfig config) {
    final pluginsDir = path.join(config.projectPath, 'yo_plugins');
    final dir = Directory(pluginsDir);

    if (!dir.existsSync()) return;

    final pluginFiles =
        dir.listSync().whereType<File>().where((f) => f.path.endsWith('.dart'));

    if (pluginFiles.isNotEmpty) {
      Console.info(
        'Found ${pluginFiles.length} plugin(s) in yo_plugins/',
      );
      Console.info(
        'Note: Dynamic plugin loading requires Dart scripting. '
        'Register plugins manually in yo.dart for now.',
      );
    }
  }

  /// Print help for all registered plugins
  static void printHelp() {
    if (_plugins.isEmpty) return;

    print('\nPLUGINS:');
    for (final plugin in _plugins.values) {
      print('  ${plugin.name.padRight(22)} ${plugin.description}');
    }
  }
}

/// Example plugin implementation — can be used as a reference
///
/// To create a custom plugin:
/// 1. Extend [GeneratorPlugin]
/// 2. Implement [name], [description], and [execute]
/// 3. Register it in yo.dart: `PluginRegistry.register(MyPlugin(config))`
///
/// Example:
/// ```dart
/// class FeatureScaffoldPlugin extends GeneratorPlugin {
///   FeatureScaffoldPlugin(super.config);
///
///   @override
///   String get name => 'scaffold';
///
///   @override
///   String get description => 'Generate a full feature scaffold';
///
///   @override
///   void execute(String? name, Map<String, dynamic> options) {
///     if (name == null) {
///       Console.error('Name is required for scaffold command');
///       return;
///     }
///     // Generate full feature with all layers...
///   }
/// }
/// ```
