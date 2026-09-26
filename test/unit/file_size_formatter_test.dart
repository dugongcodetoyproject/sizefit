import 'package:flutter_test/flutter_test.dart';
import 'package:sizefit/core/utils/file_size_formatter.dart';

void main() {
  group('FileSizeFormatter Tests', () {
    test('formats byte values accurately', () {
      expect(FileSizeFormatter.formatBytes(0), '0 B');
      expect(FileSizeFormatter.formatBytes(512), '512 B');
      expect(FileSizeFormatter.formatBytes(1024), '1 KB');
      expect(FileSizeFormatter.formatBytes(200 * 1024), '200 KB');
      expect(FileSizeFormatter.formatBytes((2.84 * 1024 * 1024).round()), '2.8 MB');
      expect(FileSizeFormatter.formatBytes(15 * 1024 * 1024), '15 MB');
    });

    test('formats KB values properly', () {
      expect(FileSizeFormatter.formatKb(50), '50 KB');
      expect(FileSizeFormatter.formatKb(100), '100 KB');
      expect(FileSizeFormatter.formatKb(200), '200 KB');
      expect(FileSizeFormatter.formatKb(500), '500 KB');
      expect(FileSizeFormatter.formatKb(1000), '1 MB');
      expect(FileSizeFormatter.formatKb(2000), '2 MB');
      expect(FileSizeFormatter.formatKb(1024), '1 MB');
      expect(FileSizeFormatter.formatKb(750), '750 KB');
    });

    test('calculates percentage reduction correctly', () {
      // 2.84 MB (2977955 bytes) -> 187 KB (191488 bytes)
      const orig = 2977955;
      const res = 191488;
      final reduction = FileSizeFormatter.calculateReductionPercentage(orig, res);
      expect(reduction, 94); // 약 93.6% -> 94%

      // Same size or larger -> 0%
      expect(FileSizeFormatter.calculateReductionPercentage(100, 100), 0);
      expect(FileSizeFormatter.calculateReductionPercentage(100, 120), 0);
    });

    test('kbToBytes conversion', () {
      expect(FileSizeFormatter.kbToBytes(100), 102400);
      expect(FileSizeFormatter.kbToBytes(200), 204800);
    });
  });
}
