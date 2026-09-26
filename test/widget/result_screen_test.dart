import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sizefit/features/compression/models/compression_result.dart';
import 'package:sizefit/features/result/presentation/result_screen.dart';

void main() {
  testWidgets('ResultScreen renders result size, before/after, and actions',
      (WidgetTester tester) async {
    final tempDir = Directory.systemTemp;
    final dummyFile = File('${tempDir.path}/test_dummy.jpg');
    dummyFile.writeAsBytesSync([0xFF, 0xD8, 0xFF, 0xE0]); // dummy jpeg header

    final result = CompressionResult(
      originalBytes: 2977955, // 2.84 MB
      resultBytes: 191488, // 187 KB
      originalWidth: 4032,
      originalHeight: 3024,
      resultWidth: 2560,
      resultHeight: 1920,
      quality: 82,
      scale: 0.85,
      outputPath: dummyFile.path,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: ResultScreen(
          result: result,
          originalPath: dummyFile.path,
          targetKb: 200,
          onCompressAnother: () {},
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Verify Prominent Result Size is visible
    expect(find.text('187 KB'), findsWidgets);

    // Verify Target limit text
    expect(find.text('target: < 200 KB'), findsOneWidget);

    // Verify Status badge
    expect(find.text('FITS UPLOAD LIMIT'), findsOneWidget);

    // Verify Save & Share buttons
    expect(find.text('Save to Gallery'), findsOneWidget);
    expect(find.text('Share'), findsOneWidget);
    expect(find.text('Compress Another Photo'), findsOneWidget);

    if (dummyFile.existsSync()) {
      dummyFile.deleteSync();
    }
  });
}
