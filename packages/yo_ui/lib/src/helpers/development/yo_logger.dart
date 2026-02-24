// ignore_for_file: avoid_print

import 'dart:developer' as developer;
import 'package:intl/intl.dart';

class YoLogger {
  static bool _enable = true;
  static YoLogLevel _level = YoLogLevel.debug;

  static void enable() => _enable = true;
  static void disable() => _enable = false;
  static void setLevel(YoLogLevel level) => _level = level;

  static void debug(String message, {String? tag}) =>
      _log(YoLogLevel.debug, message, tag: tag);

  static void info(String message, {String? tag}) =>
      _log(YoLogLevel.info, message, tag: tag);

  static void warning(String message, {String? tag}) =>
      _log(YoLogLevel.warning, message, tag: tag);

  static void error(String message, {dynamic error, StackTrace? stackTrace, String? tag}) =>
      _log(YoLogLevel.error, message, error: error, stackTrace: stackTrace, tag: tag);

  static void critical(String message, {dynamic error, StackTrace? stackTrace, String? tag}) =>
      _log(YoLogLevel.critical, message, error: error, stackTrace: stackTrace, tag: tag);

  static void _log(
    YoLogLevel level,
    String message, {
    dynamic error,
    StackTrace? stackTrace,
    String? tag,
  }) {
    if (!_enable || level.index < _level.index) return;

    final time = DateFormat('HH:mm:ss').format(DateTime.now().toLocal());
    final tagText = tag != null ? '[$tag] ' : '';

    final emoji = _getEmoji(level);
    final color = _getColor(level);
    final reset = '\x1B[0m';

    final output = '$color$emoji $time $tagText$message$reset';

    developer.log(output, name: 'YoLog');

    if (error != null) {
      developer.log('$color  ↳ Error: $error$reset', name: 'YoLog');
    }
    if (stackTrace != null) {
      developer.log('$color  ↳ StackTrace: $stackTrace$reset', name: 'YoLog');
    }
  }

  static String _getEmoji(YoLogLevel level) {
    switch (level) {
      case YoLogLevel.debug:
        return '🐛';
      case YoLogLevel.info:
        return '💡';
      case YoLogLevel.warning:
        return '⚠️';
      case YoLogLevel.error:
        return '❌';
      case YoLogLevel.critical:
        return '🚨';
    }
  }

  static String _getColor(YoLogLevel level) {
    switch (level) {
      case YoLogLevel.debug:
        return '\x1B[36m'; // cyan
      case YoLogLevel.info:
        return '\x1B[32m'; // green
      case YoLogLevel.warning:
        return '\x1B[33m'; // yellow
      case YoLogLevel.error:
        return '\x1B[31m'; // red
      case YoLogLevel.critical:
        return '\x1B[35m'; // magenta
    }
  }
}

enum YoLogLevel {
  debug(0),
  info(1),
  warning(2),
  error(3),
  critical(4);

  const YoLogLevel(this.value);
  final int value;
}