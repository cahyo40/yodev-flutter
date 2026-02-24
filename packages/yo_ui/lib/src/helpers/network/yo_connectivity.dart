import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

class YoConnectivity {
  static final Connectivity _connectivity = Connectivity();
  static StreamSubscription<List<ConnectivityResult>>? _subscription;
  static final List<void Function(bool)> _listeners = [];
  static bool _isConnected = true;
  static List<ConnectivityResult> _lastResult = [ConnectivityResult.none];

  static Future<void> initialize() async {
    // Check initial status
    _lastResult = await _connectivity.checkConnectivity();
    _isConnected = _isResultConnected(_lastResult);

    // Listen for changes
    _subscription = _connectivity.onConnectivityChanged.listen(
      _handleConnectivityChange,
    );
  }

  static void _handleConnectivityChange(List<ConnectivityResult> result) {
    _lastResult = result;
    final newStatus = _isResultConnected(result);

    if (newStatus != _isConnected) {
      _isConnected = newStatus;
      _notifyListeners();
    }
  }

  static bool _isResultConnected(List<ConnectivityResult> results) {
    return results.any((result) => result != ConnectivityResult.none);
  }

  static void _notifyListeners() {
    for (final listener in _listeners) {
      listener(_isConnected);
    }
  }

  // Public API
  static bool get isConnected => _isConnected;

  static List<ConnectivityResult> get lastResult => _lastResult;

  static String get connectionName {
    if (_lastResult.contains(ConnectivityResult.wifi)) return 'WiFi';
    if (_lastResult.contains(ConnectivityResult.mobile)) return 'Mobile Data';
    if (_lastResult.contains(ConnectivityResult.ethernet)) return 'Ethernet';
    if (_lastResult.contains(ConnectivityResult.vpn)) return 'VPN';
    if (_lastResult.contains(ConnectivityResult.bluetooth)) return 'Bluetooth';
    if (_lastResult.contains(ConnectivityResult.other)) return 'Other';
    return 'No Connection';
  }

  static Future<bool> checkConnection() async {
    final result = await _connectivity.checkConnectivity();
    _lastResult = result;
    _isConnected = _isResultConnected(result);
    return _isConnected;
  }

  static void addListener(void Function(bool) listener) {
    _listeners.add(listener);
  }

  static void removeListener(void Function(bool) listener) {
    _listeners.remove(listener);
  }

  static Future<T> ensureConnection<T>(
    Future<T> Function() function, {
    String? errorMessage,
    Duration timeout = const Duration(seconds: 10),
  }) async {
    if (!isConnected) {
      throw YoConnectionException(errorMessage ?? 'No internet connection');
    }

    try {
      return await function().timeout(timeout);
    } on TimeoutException {
      throw YoConnectionException('Connection timeout');
    }
  }

  static void dispose() {
    _subscription?.cancel();
    _listeners.clear();
  }
}

class YoConnectionException implements Exception {
  final String message;

  YoConnectionException(this.message);

  @override
  String toString() => 'YoConnectionException: $message';
}
