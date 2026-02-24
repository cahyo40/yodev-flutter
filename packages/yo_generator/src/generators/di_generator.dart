import 'package:path/path.dart' as path;

import '../config.dart';
import '../utils.dart';

/// Generator for Dependency Injection setup
class DIGenerator {
  DIGenerator(this.config);
  final YoConfig config;

  /// Generate DI setup based on state management
  void generate({bool force = false}) {
    switch (config.stateManagement) {
      case StateManagement.riverpod:
        _generateRiverpodDI(force);
      case StateManagement.getx:
        _generateGetXDI(force);
      case StateManagement.bloc:
        _generateBlocDI(force);
    }

    Console.success('Dependency Injection setup generated!');
    Console.info("Don't forget to run: flutter pub get");
  }

  void _generateRiverpodDI(bool force) {
    final diPath = path.join(config.corePath, 'di');
    YoUtils.ensureDirectory(diPath);

    final file = path.join(diPath, 'providers.dart');

    if (!force && YoUtils.fileExists(file)) {
      Console.warning(
        'providers.dart already exists. Use --force to overwrite.',
      );
      return;
    }

    final content = '''
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../network/dio_client.dart';
import '../network/api_client.dart';
import '../network/network_info.dart';

/// =============================================================================
/// CORE PROVIDERS
/// =============================================================================

/// Base URL provider - override this in main.dart or tests
final baseUrlProvider = Provider<String>((ref) {
  // TODO: Replace with your API base URL
  return 'https://api.example.com';
});

/// Auth token provider - can be updated when user logs in
final authTokenProvider = StateProvider<String?>((ref) => null);

/// =============================================================================
/// NETWORK PROVIDERS
/// =============================================================================

/// Dio client provider
final dioClientProvider = Provider<DioClient>((ref) {
  final baseUrl = ref.watch(baseUrlProvider);
  final token = ref.watch(authTokenProvider);

  return DioClient(
    baseUrl: baseUrl,
    authToken: token,
  );
});

/// Dio instance provider
final dioProvider = Provider<Dio>((ref) {
  return ref.watch(dioClientProvider).dio;
});

/// API client provider
final apiClientProvider = Provider<ApiClient>((ref) {
  final dio = ref.watch(dioProvider);
  return ApiClient(dio);
});

/// Network info provider
final networkInfoProvider = Provider<NetworkInfo>((ref) {
  return NetworkInfoImpl();
});

/// =============================================================================
/// REPOSITORY PROVIDERS
/// Template: Add your repository providers here
/// =============================================================================

// Example:
// final userRepositoryProvider = Provider<UserRepository>((ref) {
//   final apiClient = ref.watch(apiClientProvider);
//   final localDataSource = ref.watch(userLocalDataSourceProvider);
//   return UserRepositoryImpl(
//     remoteDataSource: UserRemoteDataSourceImpl(apiClient),
//     localDataSource: localDataSource,
//   );
// });

/// =============================================================================
/// USECASE PROVIDERS
/// Template: Add your usecase providers here
/// =============================================================================

// Example:
// final getUserUseCaseProvider = Provider<GetUserUseCase>((ref) {
//   return GetUserUseCase(ref.watch(userRepositoryProvider));
// });
''';

    YoUtils.writeFile(file, content);
    Console.info('  → Created: core/di/providers.dart (Riverpod)');
  }

  void _generateGetXDI(bool force) {
    final diPath = path.join(config.corePath, 'di');
    YoUtils.ensureDirectory(diPath);

    final file = path.join(diPath, 'injection_container.dart');

    if (!force && YoUtils.fileExists(file)) {
      Console.warning(
        'injection_container.dart already exists. Use --force to overwrite.',
      );
      return;
    }

    final content = '''
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../network/dio_client.dart';
import '../network/api_client.dart';
import '../network/network_info.dart';

/// Dependency Injection Container using GetX
class InjectionContainer {
  static const String baseUrl = 'https://api.example.com'; // TODO: Replace with your API

  /// Initialize all dependencies
  static Future<void> init() async {
    // ==========================================================
    // CORE
    // ==========================================================
    
    // Network Info
    Get.lazyPut<NetworkInfo>(() => NetworkInfoImpl(), fenix: true);

    // Dio Client
    Get.lazyPut<DioClient>(
      () => DioClient(baseUrl: baseUrl),
      fenix: true,
    );

    // Dio
    Get.lazyPut<Dio>(() => Get.find<DioClient>().dio, fenix: true);

    // API Client
    Get.lazyPut<ApiClient>(() => ApiClient(Get.find()), fenix: true);

    // ==========================================================
    // DATA SOURCES
    // Template: Add your data sources here
    // ==========================================================
    
    // Example:
    // Get.lazyPut<UserRemoteDataSource>(
    //   () => UserRemoteDataSourceImpl(Get.find()),
    // );
    // Get.lazyPut<UserLocalDataSource>(
    //   () => UserLocalDataSourceImpl(),
    // );

    // ==========================================================
    // REPOSITORIES
    // Template: Add your repositories here
    // ==========================================================
    
    // Example:
    // Get.lazyPut<UserRepository>(
    //   () => UserRepositoryImpl(
    //     remoteDataSource: Get.find(),
    //     localDataSource: Get.find(),
    //   ),
    // );

    // ==========================================================
    // USE CASES
    // Template: Add your use cases here
    // ==========================================================
    
    // Example:
    // Get.lazyPut(() => GetUserUseCase(Get.find()));
  }

  /// Update auth token
  static void updateAuthToken(String? token) {
    Get.find<DioClient>().updateToken(token);
  }

  /// Clear auth on logout
  static void clearAuth() {
    Get.find<DioClient>().clearAuth();
  }
}
''';

    YoUtils.writeFile(file, content);
    Console.info('  → Created: core/di/injection_container.dart (GetX)');
  }

  void _generateBlocDI(bool force) {
    final diPath = path.join(config.corePath, 'di');
    YoUtils.ensureDirectory(diPath);

    final file = path.join(diPath, 'injection_container.dart');

    if (!force && YoUtils.fileExists(file)) {
      Console.warning(
        'injection_container.dart already exists. Use --force to overwrite.',
      );
      return;
    }

    final content = '''
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import '../network/dio_client.dart';
import '../network/api_client.dart';
import '../network/network_info.dart';

final sl = GetIt.instance;

/// Initialize all dependencies using get_it
Future<void> initDependencies() async {
  // ==========================================================
  // CORE
  // ==========================================================
  
  // Network Info
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());

  // Dio Client
  sl.registerLazySingleton<DioClient>(
    () => DioClient(
      baseUrl: 'https://api.example.com', // TODO: Replace with your API
    ),
  );

  // Dio
  sl.registerLazySingleton<Dio>(() => sl<DioClient>().dio);

  // API Client
  sl.registerLazySingleton<ApiClient>(() => ApiClient(sl()));

  // ==========================================================
  // DATA SOURCES
  // Template: Add your data sources here
  // ==========================================================
  
  // Example:
  // sl.registerLazySingleton<UserRemoteDataSource>(
  //   () => UserRemoteDataSourceImpl(sl()),
  // );
  // sl.registerLazySingleton<UserLocalDataSource>(
  //   () => UserLocalDataSourceImpl(),
  // );

  // ==========================================================
  // REPOSITORIES
  // Template: Add your repositories here
  // ==========================================================
  
  // Example:
  // sl.registerLazySingleton<UserRepository>(
  //   () => UserRepositoryImpl(
  //     remoteDataSource: sl(),
  //     localDataSource: sl(),
  //   ),
  // );

  // ==========================================================
  // USE CASES
  // Template: Add your use cases here
  // ==========================================================
  
  // Example:
  // sl.registerLazySingleton(() => GetUserUseCase(sl()));

  // ==========================================================
  // BLOCS
  // Template: Add your blocs here
  // ==========================================================
  
  // Example:
  // sl.registerFactory(() => UserBloc(getUserUseCase: sl()));
}

/// Update auth token
void updateAuthToken(String? token) {
  sl<DioClient>().updateToken(token);
}

/// Clear auth on logout
void clearAuth() {
  sl<DioClient>().clearAuth();
}
''';

    YoUtils.writeFile(file, content);
    Console.info(
      '  → Created: core/di/injection_container.dart (Bloc + get_it)',
    );
  }
}
