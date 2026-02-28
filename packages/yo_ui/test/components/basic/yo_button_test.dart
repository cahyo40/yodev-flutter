import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:yo_ui/yo_ui.dart';

void main() {
  group('YoButton Golden Tests', () {
    testGoldens('YoButton varieties render correctly', (tester) async {
      final builder = GoldenBuilder.column()
        ..addScenario('Primary Default',
            YoButton.primary(text: 'Primary', onPressed: () {}))
        ..addScenario('Secondary Default',
            YoButton.secondary(text: 'Secondary', onPressed: () {}))
        ..addScenario('Outline Default',
            YoButton.outline(text: 'Outline', onPressed: () {}))
        ..addScenario(
            'Ghost Default', YoButton.ghost(text: 'Ghost', onPressed: () {}))
        ..addScenario('Disabled Primary',
            YoButton.primary(text: 'Disabled', onPressed: null))
        ..addScenario(
            'Pill Style', YoButton.pill(text: 'Pill Button', onPressed: () {}))
        ..addScenario(
            'Modern Primary', YoButton.modern(text: 'Modern', onPressed: () {}))
        ..addScenario(
            'Small Size',
            YoButton.primary(
                text: 'Small', size: YoButtonSize.small, onPressed: () {}))
        ..addScenario(
            'Large Size',
            YoButton.primary(
                text: 'Large', size: YoButtonSize.large, onPressed: () {}));

      await tester.pumpWidgetBuilder(
        builder.build(),
        // Adjust the surface size to make sure all scenarios fit nicely
        surfaceSize: const Size(400, 1000),
      );

      // This will look for a file named `yo_button_varieties.png` inside the `goldens` folder.
      await screenMatchesGolden(tester, 'yo_button_varieties');
    });
  });
}
