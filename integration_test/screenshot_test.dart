import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:flutter_glp1_tracker/src/app.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  Future<void> shoot(WidgetTester tester, String name) async {
    await binding.convertFlutterSurfaceToImage();
    await tester.pump(const Duration(milliseconds: 400));
    await binding.takeScreenshot(name);
  }

  testWidgets('capture PepDose flow', (tester) async {
    await tester.pumpWidget(const PepDoseApp());
    await tester.pump(const Duration(milliseconds: 600));

    // 1) Calculator tab (default)
    await shoot(tester, '01-calculator');

    // 2) Protocol library tab
    await tester.tap(find.text('Library'));
    await tester.pump(const Duration(milliseconds: 500));
    await shoot(tester, '02-library');

    // 3) Titration roadmap tab
    await tester.tap(find.text('Titration'));
    await tester.pump(const Duration(milliseconds: 500));
    await shoot(tester, '03-titration');

    // 4) Dose log tab
    await tester.tap(find.text('Log'));
    await tester.pump(const Duration(milliseconds: 500));
    await shoot(tester, '04-dose-log');
  });
}
