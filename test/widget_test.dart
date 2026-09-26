import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizefit/main.dart';

void main() {
  testWidgets('SizeFitApp loads home screen with presets and action button',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: SizeFitApp(),
      ),
    );
    await tester.pumpAndSettle();

    // Verify Title and Tagline
    expect(find.text('SizeFit'), findsOneWidget);
    expect(find.text('Make any photo fit the upload limit.'), findsOneWidget);
    expect(find.text('Processed entirely on your device.'), findsOneWidget);

    // Verify Select Photo card is present
    expect(find.text('Select Photo'), findsOneWidget);

    // Verify presets are present
    expect(find.text('50 KB'), findsOneWidget);
    expect(find.text('100 KB'), findsOneWidget);
    expect(find.text('200 KB'), findsOneWidget);
    expect(find.text('500 KB'), findsOneWidget);
    expect(find.text('1 MB'), findsOneWidget);
    expect(find.text('2 MB'), findsOneWidget);
    expect(find.text('Custom...'), findsOneWidget);

    // Verify initial button text
    expect(find.text('Select Photo to Start'), findsOneWidget);

    // Tap 500 KB preset
    await tester.tap(find.text('500 KB'));
    await tester.pumpAndSettle();
  });
}
