import 'package:path/path.dart' as path;

import '../config.dart';
import '../utils.dart';

/// Generator for network layer (Dio client, interceptors, API client)
class NetworkGenerator {
  NetworkGenerator(this.config);
  final YoConfig config;

  /// Generate network layer
  void generate({bool force = false}) {
    final networkPath = path.join(config.corePath, 'network');
    YoUtils.ensureDirectory(networkPath);

    // Generate API Client
    _generateApiClient(networkPath, force);

    // Generate Dio Client
    _generateDioClient(networkPath, force);

    // Generate Interceptors
    _generateInterceptors(networkPath, force);

    // Generate Network Info
    _generateNetworkInfo(networkPath, force);

    Console.success('Network layer generated successfully!');
    Console.info("Don't forget to run: flutter pub get");
  }

  void _generateApiClient(String networkPath, bool force) {
    final file = path.join(networkPath, 'api_client.dart');

    if (!force && YoUtils.fileExists(file)) {
      Console.warning(
        'api_client.dart already exists. Use --force to overwrite.',
      );
      return;
    }

    final content = '''
import 'package:dio/dio.dart';

/// API Client wrapper for making HTTP requests
class ApiClient {
  final Dio _dio;

  ApiClient(this._dio);

  /// GET request
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return _dio.get<T>(
      path,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  /// POST request
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return _dio.post<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  /// PUT request
  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return _dio.put<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  /// PATCH request
  Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return _dio.patch<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  /// DELETE request
  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return _dio.delete<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  /// Upload file
  Future<Response<T>> upload<T>(
    String path, {
    required FormData formData,
    ProgressCallback? onSendProgress,
    CancelToken? cancelToken,
  }) async {
    return _dio.post<T>(
      path,
      data: formData,
      onSendProgress: onSendProgress,
      cancelToken: cancelToken,
    );
  }

  /// Download file
  Future<Response> download(
    String path,
    String savePath, {
    ProgressCallback? onReceiveProgress,
    CancelToken? cancelToken,
  }) async {
    return _dio.download(
      path,
      savePath,
      onReceiveProgress: onReceiveProgress,
      cancelToken: cancelToken,
    );
  }
}
''';

    YoUtils.writeFile(file, content);
    Console.info('  → Created: api_client.dart');
  }

  void _generateDioClient(String networkPath, bool force) {
    final file = path.join(networkPath, 'dio_client.dart');

    if (!force && YoUtils.fileExists(file)) {
      Console.warning(
        'dio_client.dart already exists. Use --force to overwrite.',
      );
      return;
    }

    final content = '''
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/logging_interceptor.dart';
import 'interceptors/error_interceptor.dart';

/// Dio client configuration and setup
class DioClient {
  static const Duration _connectTimeout = Duration(seconds: 30);
  static const Duration _receiveTimeout = Duration(seconds: 30);
  static const Duration _sendTimeout = Duration(seconds: 30);

  late final Dio _dio;

  DioClient({
    required String baseUrl,
    String? authToken,
  }) {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: _connectTimeout,
        receiveTimeout: _receiveTimeout,
        sendTimeout: _sendTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add interceptors
    _dio.interceptors.addAll([
      AuthInterceptor(token: authToken),
      ErrorInterceptor(),
      if (kDebugMode) LoggingInterceptor(),
    ]);
  }

  Dio get dio => _dio;

  /// Update auth token
  void updateToken(String? token) {
    final authInterceptor = _dio.interceptors
        .whereType<AuthInterceptor>()
        .firstOrNull;
    authInterceptor?.updateToken(token);
  }

  /// Clear all cookies and tokens
  void clearAuth() {
    updateToken(null);
  }
}
''';

    YoUtils.writeFile(file, content);
    Console.info('  → Created: dio_client.dart');
  }

  void _generateInterceptors(String networkPath, bool force) {
    final interceptorsPath = path.join(networkPath, 'interceptors');
    YoUtils.ensureDirectory(interceptorsPath);

    // Auth Interceptor
    _generateAuthInterceptor(interceptorsPath, force);

    // Logging Interceptor
    _generateLoggingInterceptor(interceptorsPath, force);

    // Error Interceptor
    _generateErrorInterceptor(interceptorsPath, force);
  }

  void _generateAuthInterceptor(String interceptorsPath, bool force) {
    final file = path.join(interceptorsPath, 'auth_interceptor.dart');

    if (!force && YoUtils.fileExists(file)) {
      return;
    }

    final content = r'''
import 'package:dio/dio.dart';

/// Interceptor for adding authentication headers
class AuthInterceptor extends Interceptor {
  String? _token;

  AuthInterceptor({String? token}) : _token = token;

  void updateToken(String? token) {
    _token = token;
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (_token != null && _token!.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $_token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      // Token expired, handle refresh or logout
      // TODO: Implement token refresh logic
    }
    handler.next(err);
  }
}
''';

    YoUtils.writeFile(file, content);
    Console.info('  → Created: interceptors/auth_interceptor.dart');
  }

  void _generateLoggingInterceptor(String interceptorsPath, bool force) {
    final file = path.join(interceptorsPath, 'logging_interceptor.dart');

    if (!force && YoUtils.fileExists(file)) {
      return;
    }

    final content = r'''
import 'dart:developer' as developer;
import 'package:dio/dio.dart';

/// Interceptor for logging HTTP requests and responses
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _log('┌─────────────────────────────────────────────────────────');
    _log('│ REQUEST: ${options.method} ${options.uri}');
    _log('│ Headers: ${options.headers}');
    if (options.data != null) {
      _log('│ Body: ${options.data}');
    }
    _log('└─────────────────────────────────────────────────────────');
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _log('┌─────────────────────────────────────────────────────────');
    _log('│ RESPONSE: ${response.statusCode} ${response.requestOptions.uri}');
    _log('│ Data: ${response.data}');
    _log('└─────────────────────────────────────────────────────────');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _log('┌─────────────────────────────────────────────────────────');
    _log('│ ERROR: ${err.type} ${err.requestOptions.uri}');
    _log('│ Message: ${err.message}');
    if (err.response != null) {
      _log('│ Response: ${err.response?.data}');
    }
    _log('└─────────────────────────────────────────────────────────');
    handler.next(err);
  }

  void _log(String message) {
    developer.log(message, name: 'HTTP');
  }
}
''';

    YoUtils.writeFile(file, content);
    Console.info('  → Created: interceptors/logging_interceptor.dart');
  }

  void _generateErrorInterceptor(String interceptorsPath, bool force) {
    final file = path.join(interceptorsPath, 'error_interceptor.dart');

    if (!force && YoUtils.fileExists(file)) {
      return;
    }

    final content = r'''
import 'package:dio/dio.dart';

/// Interceptor for handling HTTP errors
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final error = _handleError(err);
    handler.next(error);
  }

  DioException _handleError(DioException err) {
    String message;

    switch (err.type) {
      case DioExceptionType.connectionTimeout:
        message = 'Connection timeout. Please check your internet connection.';
        break;
      case DioExceptionType.sendTimeout:
        message = 'Send timeout. Please try again.';
        break;
      case DioExceptionType.receiveTimeout:
        message = 'Receive timeout. Please try again.';
        break;
      case DioExceptionType.badResponse:
        message = _handleStatusCode(err.response?.statusCode);
        break;
      case DioExceptionType.cancel:
        message = 'Request was cancelled.';
        break;
      case DioExceptionType.connectionError:
        message = 'No internet connection.';
        break;
      default:
        message = 'An unexpected error occurred.';
    }

    return DioException(
      requestOptions: err.requestOptions,
      response: err.response,
      type: err.type,
      error: err.error,
      message: message,
    );
  }

  String _handleStatusCode(int? statusCode) {
    switch (statusCode) {
      case 400:
        return 'Bad request. Please check your input.';
      case 401:
        return 'Unauthorized. Please login again.';
      case 403:
        return 'Forbidden. You don\'t have permission to access this resource.';
      case 404:
        return 'Resource not found.';
      case 409:
        return 'Conflict. The resource already exists.';
      case 422:
        return 'Validation error. Please check your input.';
      case 429:
        return 'Too many requests. Please try again later.';
      case 500:
        return 'Internal server error. Please try again later.';
      case 502:
        return 'Bad gateway. Service is temporarily unavailable.';
      case 503:
        return 'Service unavailable. Please try again later.';
      case 504:
        return 'Gateway timeout. Please try again.';
      default:
        return 'Server error. Please try again later.';
    }
  }
}
''';

    YoUtils.writeFile(file, content);
    Console.info('  → Created: interceptors/error_interceptor.dart');
  }

  void _generateNetworkInfo(String networkPath, bool force) {
    final file = path.join(networkPath, 'network_info.dart');

    if (!force && YoUtils.fileExists(file)) {
      return;
    }

    final content = '''
import 'package:connectivity_plus/connectivity_plus.dart';

/// Network info for checking internet connectivity
abstract class NetworkInfo {
  Future<bool> get isConnected;
  Stream<bool> get onConnectivityChanged;
}

class NetworkInfoImpl implements NetworkInfo {
  final Connectivity _connectivity;

  NetworkInfoImpl([Connectivity? connectivity])
      : _connectivity = connectivity ?? Connectivity();

  @override
  Future<bool> get isConnected async {
    final result = await _connectivity.checkConnectivity();
    return _isConnected(result);
  }

  @override
  Stream<bool> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged.map(_isConnected);
  }

  bool _isConnected(List<ConnectivityResult> result) {
    return result.isNotEmpty && !result.contains(ConnectivityResult.none);
  }
}
''';

    YoUtils.writeFile(file, content);
    Console.info('  → Created: network_info.dart');
  }
}
