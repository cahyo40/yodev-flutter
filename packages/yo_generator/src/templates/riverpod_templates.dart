import '../config.dart';
import '../utils.dart';

/// Template generator for Riverpod state management
class RiverpodTemplates {
  RiverpodTemplates(this.config);
  final YoConfig config;

  /// Generate dialog file
  String dialog(String name) {
    final className = YoUtils.toClassName(name);

    return '''
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yo_ui/yo_ui.dart';

class ${className}Dialog extends ConsumerWidget {
  const ${className}Dialog({super.key});

  static Future<T?> show<T>(BuildContext context) {
    return YoConfirmDialog.show<T>(
      context: context,
      title: '$className',
      content: const YoText('Dialog content goes here'),
      confirmText: 'Confirm',
      cancelText: 'Cancel',
      onConfirm: () => Navigator.of(context).pop(true),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return YoConfirmDialog(
      title: '$className',
      content: const YoText('Dialog content goes here'),
      confirmText: 'Confirm',
      cancelText: 'Cancel',
      onConfirm: () => Navigator.of(context).pop(true),
      onCancel: () => Navigator.of(context).pop(),
    );
  }
}
''';
  }

  /// Generate page file with provider
  String page(String name) {
    final className = YoUtils.toClassName(name);
    final fileName = YoUtils.toFileName(name);

    return '''
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yo_ui/yo_ui.dart';
import '../providers/${fileName}_provider.dart';

class ${className}Page extends ConsumerStatefulWidget {
  const ${className}Page({super.key});

  static const String routeName = '/${fileName.replaceAll('_', '-')}';

  @override
  ConsumerState<${className}Page> createState() => _${className}PageState();
}

class _${className}PageState extends ConsumerState<${className}Page> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(${YoUtils.toCamelCase(className)}Provider.notifier).init();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(${YoUtils.toCamelCase(className)}Provider);

    return YoScaffold(
      appBar: AppBar(
        title: YoText.heading('$className'),
      ),
      body: _buildBody(state),
    );
  }

  Widget _buildBody(${className}State state) {
    if (state.isLoading) {
      return const Center(child: YoLoading());
    }

    if (state.error != null) {
      return YoErrorState(
        message: state.error!,
        onRetry: () {
          ref.read(${YoUtils.toCamelCase(className)}Provider.notifier).fetchData();
        },
      );
    }

    return Center(
      child: YoText('$className Page'),
    );
  }
}
''';
  }

  /// Generate provider file
  String provider(String name) {
    final className = YoUtils.toClassName(name);
    final fileName = YoUtils.toFileName(name);

    return '''
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/usecases/${fileName}_usecase.dart';

/// State class for $className
class ${className}State {
  final bool isLoading;
  final String? error;
  final dynamic data;

  const ${className}State({
    this.isLoading = false,
    this.error,
    this.data,
  });

  ${className}State copyWith({
    bool? isLoading,
    String? error,
    dynamic data,
  }) {
    return ${className}State(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      data: data ?? this.data,
    );
  }
}

/// Notifier class for $className using modern Riverpod 2.x Notifier pattern
class ${className}Notifier extends Notifier<${className}State> {
  @override
  ${className}State build() {
    return const ${className}State();
  }

  /// Get the usecase from provider
  ${className}UseCase get _useCase => ref.read(${YoUtils.toCamelCase(className)}UseCaseProvider);

  /// Initialize data
  Future<void> init() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      // TODO: Implement initialization logic
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Fetch data
  Future<void> fetchData() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final result = await _useCase.execute();
      state = state.copyWith(isLoading: false, data: result);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Refresh data
  Future<void> refresh() async {
    await fetchData();
  }
}

/// Provider for $className
final ${YoUtils.toCamelCase(className)}Provider =
    NotifierProvider<${className}Notifier, ${className}State>(
  ${className}Notifier.new,
);

/// Provider for ${className}UseCase
final ${YoUtils.toCamelCase(className)}UseCaseProvider = Provider<${className}UseCase>((ref) {
  // TODO: Inject repository
  throw UnimplementedError('Provide ${className}UseCase implementation');
});
''';
  }

  /// Generate screen file
  String screen(String name) {
    final className = YoUtils.toClassName(name);
    final fileName = YoUtils.toFileName(name);

    return '''
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yo_ui/yo_ui.dart';
import '../providers/${fileName}_provider.dart';

class ${className}Screen extends ConsumerWidget {
  const ${className}Screen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(${YoUtils.toCamelCase(className)}Provider);

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          YoText.heading('$className Screen'),
          const SizedBox(height: 16),
          if (state.isLoading)
            const YoLoading()
          else if (state.error != null)
            YoErrorState(message: state.error!)
          else
            const YoText('Content goes here'),
        ],
      ),
    );
  }
}
''';
  }
}
