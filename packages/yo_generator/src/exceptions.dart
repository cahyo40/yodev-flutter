/// Typed exceptions for the yo.dart code generator
///
/// Provides specific exception types for different failure scenarios,
/// enabling structured error handling and meaningful error messages.
library;

/// Base exception for all yo.dart generator errors
class YoException implements Exception {
  YoException(this.message, {this.suggestion});
  final String message;
  final String? suggestion;

  @override
  String toString() => message;
}

/// Thrown when a command format is invalid
class InvalidCommandException extends YoException {
  InvalidCommandException(super.message, {super.suggestion});
}

/// Thrown when configuration is invalid or missing
class ConfigException extends YoException {
  ConfigException(super.message, {super.suggestion});
}

/// Thrown when a required file or directory is not found
class FileNotFoundException extends YoException {
  FileNotFoundException(super.message, {super.suggestion});
}

/// Thrown when trying to create a file that already exists (without --force)
class FileExistsException extends YoException {
  FileExistsException(super.message, {super.suggestion});
}

/// Thrown when a feature does not exist
class FeatureNotFoundException extends YoException {
  FeatureNotFoundException(String featureName)
      : super(
          'Feature "$featureName" does not exist.',
          suggestion:
              'Create it first with: dart run yo.dart page:$featureName',
        );
}

/// Thrown when a page does not exist within a feature
class PageNotFoundException extends YoException {
  PageNotFoundException(String pageName)
      : super(
          'Page "$pageName" does not exist in this feature.',
          suggestion: 'Create it first with: dart run yo.dart page:$pageName',
        );
}

/// Thrown when template generation fails
class TemplateException extends YoException {
  TemplateException(super.message, {super.suggestion});
}

/// Thrown when a required dependency is missing
class DependencyException extends YoException {
  DependencyException(super.message, {super.suggestion});
}
