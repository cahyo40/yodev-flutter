import 'dart:async';

import 'package:golden_toolkit/golden_toolkit.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  // Setup golden toolkit to load app fonts.
  // This will try to load fonts defined in pubspec.yaml so text doesn't render as square boxes in golden tests.
  await loadAppFonts();
  return testMain();
}
