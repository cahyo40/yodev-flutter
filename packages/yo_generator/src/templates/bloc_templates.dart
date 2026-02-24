import '../config.dart';
import '../utils.dart';

/// Template generator for Bloc state management
class BlocTemplates {
  BlocTemplates(this.config);
  final YoConfig config;

  /// Generate bloc file
  String bloc(String name) {
    final className = YoUtils.toClassName(name);
    final fileName = YoUtils.toFileName(name);

    return '''
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/${fileName}_usecase.dart';

part '${fileName}_event.dart';
part '${fileName}_state.dart';

class ${className}Bloc extends Bloc<${className}Event, ${className}State> {
  final ${className}UseCase _useCase;

  ${className}Bloc(this._useCase) : super(const ${className}Initial()) {
    on<${className}Started>(_onStarted);
    on<${className}Fetched>(_onFetched);
    on<${className}Refreshed>(_onRefreshed);
  }

  Future<void> _onStarted(
    ${className}Started event,
    Emitter<${className}State> emit,
  ) async {
    emit(const ${className}Loading());
    try {
      // TODO: Implement initialization logic
      emit(const ${className}Loaded(data: null));
    } catch (e) {
      emit(${className}Error(message: e.toString()));
    }
  }

  Future<void> _onFetched(
    ${className}Fetched event,
    Emitter<${className}State> emit,
  ) async {
    emit(const ${className}Loading());
    try {
      final result = await _useCase.execute();
      emit(${className}Loaded(data: result));
    } catch (e) {
      emit(${className}Error(message: e.toString()));
    }
  }

  Future<void> _onRefreshed(
    ${className}Refreshed event,
    Emitter<${className}State> emit,
  ) async {
    add(const ${className}Fetched());
  }
}
''';
  }

  /// Generate cubit file (simpler alternative to bloc)
  String cubit(String name) {
    final className = YoUtils.toClassName(name);
    final fileName = YoUtils.toFileName(name);

    return '''
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/${fileName}_usecase.dart';

part '${fileName}_state.dart';

class ${className}Cubit extends Cubit<${className}State> {
  final ${className}UseCase _useCase;

  ${className}Cubit(this._useCase) : super(const ${className}Initial());

  /// Initialize
  Future<void> init() async {
    emit(const ${className}Loading());
    try {
      // TODO: Implement initialization logic
      emit(const ${className}Loaded(data: null));
    } catch (e) {
      emit(${className}Error(message: e.toString()));
    }
  }

  /// Fetch data
  Future<void> fetchData() async {
    emit(const ${className}Loading());
    try {
      final result = await _useCase.execute();
      emit(${className}Loaded(data: result));
    } catch (e) {
      emit(${className}Error(message: e.toString()));
    }
  }

  /// Refresh data
  Future<void> refresh() async {
    await fetchData();
  }
}
''';
  }

  /// Generate cubit state file
  String cubitState(String name) {
    final className = YoUtils.toClassName(name);

    return '''
part of '${YoUtils.toFileName(name)}_cubit.dart';

abstract class ${className}State extends Equatable {
  const ${className}State();

  @override
  List<Object?> get props => [];
}

class ${className}Initial extends ${className}State {
  const ${className}Initial();
}

class ${className}Loading extends ${className}State {
  const ${className}Loading();
}

class ${className}Loaded extends ${className}State {
  final dynamic data;

  const ${className}Loaded({required this.data});

  @override
  List<Object?> get props => [data];
}

class ${className}Error extends ${className}State {
  final String message;

  const ${className}Error({required this.message});

  @override
  List<Object?> get props => [message];
}
''';
  }

  /// Generate dialog file
  String dialog(String name) {
    final className = YoUtils.toClassName(name);

    return '''
import 'package:flutter/material.dart';
import 'package:yo_ui/yo_ui.dart';

class ${className}Dialog extends StatelessWidget {
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
  Widget build(BuildContext context) {
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

  /// Generate event file
  String event(String name) {
    final className = YoUtils.toClassName(name);

    return '''
part of '${YoUtils.toFileName(name)}_bloc.dart';

abstract class ${className}Event extends Equatable {
  const ${className}Event();

  @override
  List<Object?> get props => [];
}

class ${className}Started extends ${className}Event {
  const ${className}Started();
}

class ${className}Fetched extends ${className}Event {
  const ${className}Fetched();
}

class ${className}Refreshed extends ${className}Event {
  const ${className}Refreshed();
}
''';
  }

  /// Generate page file with Bloc
  String page(String name) {
    final className = YoUtils.toClassName(name);
    final fileName = YoUtils.toFileName(name);

    return '''
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yo_ui/yo_ui.dart';
import '../bloc/${fileName}_bloc.dart';

class ${className}Page extends StatelessWidget {
  const ${className}Page({super.key});

  static const String routeName = '/${fileName.replaceAll('_', '-')}';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ${className}Bloc(
        context.read(),
      )..add(const ${className}Started()),
      child: const ${className}View(),
    );
  }
}

class ${className}View extends StatelessWidget {
  const ${className}View({super.key});

  @override
  Widget build(BuildContext context) {
    return YoScaffold(
      appBar: AppBar(
        title: YoText.heading('$className'),
      ),
      body: BlocBuilder<${className}Bloc, ${className}State>(
        builder: (context, state) => _buildBody(context, state),
      ),
    );
  }

  Widget _buildBody(BuildContext context, ${className}State state) {
    if (state is ${className}Loading) {
      return const Center(child: YoLoading());
    }

    if (state is ${className}Error) {
      return YoErrorState(
        message: state.message,
        onRetry: () {
          context.read<${className}Bloc>().add(const ${className}Refreshed());
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

  /// Generate screen file
  String screen(String name) {
    final className = YoUtils.toClassName(name);
    final fileName = YoUtils.toFileName(name);

    return '''
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yo_ui/yo_ui.dart';
import '../bloc/${fileName}_bloc.dart';

class ${className}Screen extends StatelessWidget {
  const ${className}Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<${className}Bloc, ${className}State>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              YoText.heading('$className Screen'),
              const SizedBox(height: 16),
              if (state is ${className}Loading)
                const YoLoading()
              else if (state is ${className}Error)
                YoErrorState(message: state.message)
              else
                const YoText('Content goes here'),
            ],
          ),
        );
      },
    );
  }
}
''';
  }

  /// Generate state file
  String state(String name) {
    final className = YoUtils.toClassName(name);

    return '''
part of '${YoUtils.toFileName(name)}_bloc.dart';

abstract class ${className}State extends Equatable {
  const ${className}State();

  @override
  List<Object?> get props => [];
}

class ${className}Initial extends ${className}State {
  const ${className}Initial();
}

class ${className}Loading extends ${className}State {
  const ${className}Loading();
}

class ${className}Loaded extends ${className}State {
  final dynamic data;

  const ${className}Loaded({required this.data});

  @override
  List<Object?> get props => [data];
}

class ${className}Error extends ${className}State {
  final String message;

  const ${className}Error({required this.message});

  @override
  List<Object?> get props => [message];
}
''';
  }
}
