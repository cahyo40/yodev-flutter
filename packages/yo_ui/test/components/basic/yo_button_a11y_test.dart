import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yo_ui/yo_ui.dart';

void main() {
  group('YoButton Accessibility (A11y) Tests', () {
    testWidgets('YoButton memenuhi standar tap target dan kontras warna',
        (tester) async {
      // Aktifkan semantics checking di test environment
      final SemanticsHandle handle = tester.ensureSemantics();

      // Render widget
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          ),
          home: Scaffold(
            body: Center(
              child: YoButton.primary(
                text: 'Submit Data',
                onPressed: () {},
              ),
            ),
          ),
        ),
      );

      // Evaluasi 1: Tap target size (Ukuran area sentuh)
      // Android merekomendasikan minimal 48x48 px, iOS minimal 44x44 px.
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));

      // Evaluasi 2: Text contrast (Kontras warna huruf dengan background)
      // Memastikan teks terbaca dengan jelas oleh penderita low vision atau buta warna.
      await expectLater(tester, meetsGuideline(textContrastGuideline));

      // Evaluasi 3: Labeled tap target
      // Memastikan widget yang bisa ditap memiliki label/teks atau semantic label.
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));

      // Bersihkan resources
      handle.dispose();
    });

    testWidgets('YoButtonIcon dengan tooltip memenuhi standar a11y',
        (tester) async {
      final SemanticsHandle handle = tester.ensureSemantics();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: YoButtonIcon.primary(
                icon: const Icon(Icons.add),
                tooltip: 'Tambah Data Baru',
                onPressed: () {},
              ),
            ),
          ),
        ),
      );

      // Labeled tap target harus lulus jika menggunakan tooltip
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));

      handle.dispose();
    });

    testWidgets('YoButton akan melempar error (Assertion) jika text kosong',
        (tester) async {
      try {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: YoButton.primary(
                text: '',
                onPressed: () {},
              ),
            ),
          ),
        );
      } catch (e) {
        // Assertions are sometimes caught during pump Widget before tester.takeException() can be called
      }

      final dynamic exception = tester.takeException();
      expect(exception, isA<AssertionError>());
    });
  });
}
