import '../config.dart';
import '../utils.dart';

/// Template generator for GetX state management
class GetXTemplates {
  GetXTemplates(this.config);
  final YoConfig config;

  /// Generate binding file
  String binding(String name) {
    final className = YoUtils.toClassName(name);
    final fileName = YoUtils.toFileName(name);

    return '''
import 'package:get/get.dart';
import '../controllers/${fileName}_controller.dart';
import '../../domain/usecases/${fileName}_usecase.dart';
import '../../data/repositories/${fileName}_repository_impl.dart';

class ${className}Binding extends Bindings {
  @override
  void dependencies() {
    // Repository
    Get.lazyPut<${className}RepositoryImpl>(
      () => ${className}RepositoryImpl(),
    );

    // UseCase
    Get.lazyPut<${className}UseCase>(
      () => ${className}UseCase(Get.find()),
    );

    // Controller
    Get.lazyPut<${className}Controller>(
      () => ${className}Controller(Get.find()),
    );
  }
}
''';
  }

  /// Generate controller file
  String controller(String name) {
    final className = YoUtils.toClassName(name);
    final fileName = YoUtils.toFileName(name);

    return '''
import 'package:get/get.dart';
import '../../domain/usecases/${fileName}_usecase.dart';

class ${className}Controller extends GetxController {
  final ${className}UseCase _useCase;

  ${className}Controller(this._useCase);

  // Observable states
  final _isLoading = false.obs;
  final _error = Rxn<String>();
  final _data = Rxn<dynamic>();

  // Getters
  bool get isLoading => _isLoading.value;
  String? get error => _error.value;
  dynamic get data => _data.value;

  @override
  void onInit() {
    super.onInit();
    init();
  }

  /// Initialize controller
  Future<void> init() async {
    _isLoading.value = true;
    _error.value = null;
    try {
      // TODO: Implement initialization logic
      _isLoading.value = false;
    } catch (e) {
      _isLoading.value = false;
      _error.value = e.toString();
    }
  }

  /// Fetch data
  Future<void> fetchData() async {
    _isLoading.value = true;
    _error.value = null;
    try {
      final result = await _useCase.execute();
      _data.value = result;
      _isLoading.value = false;
    } catch (e) {
      _isLoading.value = false;
      _error.value = e.toString();
    }
  }

  /// Refresh data
  Future<void> refresh() async {
    await fetchData();
  }
}
''';
  }

  /// Generate dialog file
  String dialog(String name) {
    final className = YoUtils.toClassName(name);

    return '''
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yo_ui/yo_ui.dart';

class ${className}Dialog extends StatelessWidget {
  const ${className}Dialog({super.key});

  static Future<T?> show<T>() {
    return Get.dialog<T>(const ${className}Dialog());
  }

  @override
  Widget build(BuildContext context) {
    return YoConfirmDialog(
      title: '$className',
      content: const YoText('Dialog content goes here'),
      confirmText: 'Confirm',
      cancelText: 'Cancel',
      onConfirm: () => Get.back(result: true),
      onCancel: () => Get.back(),
    );
  }
}
''';
  }

  /// Generate page file with GetX
  String page(String name) {
    final className = YoUtils.toClassName(name);
    final fileName = YoUtils.toFileName(name);

    return '''
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yo_ui/yo_ui.dart';
import '../controllers/${fileName}_controller.dart';

class ${className}Page extends GetView<${className}Controller> {
  const ${className}Page({super.key});

  static const String routeName = '/${fileName.replaceAll('_', '-')}';

  @override
  Widget build(BuildContext context) {
    return YoScaffold(
      appBar: AppBar(
        title: YoText.heading('$className'),
      ),
      body: Obx(() => _buildBody()),
    );
  }

  Widget _buildBody() {
    if (controller.isLoading) {
      return const Center(child: YoLoading());
    }

    if (controller.error != null) {
      return YoErrorState(
        message: controller.error!,
        onRetry: controller.refresh,
      );
    }

    return Center(
      child: YoText('$className Page'),
    );
  }
}
''';
  }

  /// Generate route page for GetX
  String routePage(String name, List<String> pages) {
    final imports = pages.map((p) {
      final fileName = YoUtils.toFileName(p);
      final featureName = YoUtils.getFeatureName(p);
      return "import '../features/$featureName/presentation/pages/${fileName}_page.dart';";
    }).join('\n');

    final bindings = pages.map((p) {
      final fileName = YoUtils.toFileName(p);
      final featureName = YoUtils.getFeatureName(p);
      return "import '../features/$featureName/presentation/bindings/${fileName}_binding.dart';";
    }).join('\n');

    final routes = pages.map((p) {
      final className = YoUtils.toClassName(p);
      return '''
    GetPage(
      name: ${className}Page.routeName,
      page: () => const ${className}Page(),
      binding: ${className}Binding(),
    ),''';
    }).join('\n');

    return '''
import 'package:get/get.dart';
$imports
$bindings

class AppPages {
  static const initial = '/';

  static final routes = <GetPage>[
$routes
  ];
}
''';
  }

  /// Generate screen file
  String screen(String name) {
    final className = YoUtils.toClassName(name);
    final fileName = YoUtils.toFileName(name);

    return '''
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yo_ui/yo_ui.dart';
import '../controllers/${fileName}_controller.dart';

class ${className}Screen extends GetView<${className}Controller> {
  const ${className}Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          YoText.heading('$className Screen'),
          const SizedBox(height: 16),
          if (controller.isLoading)
            const YoLoading()
          else if (controller.error != null)
            YoErrorState(message: controller.error!)
          else
            const YoText('Content goes here'),
        ],
      ),
    ));
  }
}
''';
  }
}
