import 'dart:math' as math;

abstract final class FileSizeFormatter {
  /// Formats byte count into human readable string (e.g. "2.84 MB", "187 KB", "45 B")
  static String formatBytes(int bytes, {int decimals = 1}) {
    if (bytes <= 0) return '0 B';
    const suffixes = ['B', 'KB', 'MB', 'GB'];
    final i = (math.log(bytes) / math.log(1024)).floor();
    final clampedIndex = i.clamp(0, suffixes.length - 1);
    final value = bytes / math.pow(1024, clampedIndex);
    
    // For Bytes or whole integers, omit unnecessary decimals
    if (clampedIndex == 0) {
      return '$bytes B';
    }
    
    // If exact integer after rounding, display integer
    final formatted = value.toStringAsFixed(decimals);
    if (formatted.endsWith('.0')) {
      return '${formatted.substring(0, formatted.length - 2)} ${suffixes[clampedIndex]}';
    }
    return '$formatted ${suffixes[clampedIndex]}';
  }

  /// Formats KB value (e.g. 50 -> "50 KB", 1000 -> "1 MB", 2000 -> "2 MB")
  static String formatKb(int kb) {
    if (kb >= 1000 && kb % 1000 == 0) {
      return '${kb ~/ 1000} MB';
    }
    if (kb >= 1024 && kb % 1024 == 0) {
      return '${kb ~/ 1024} MB';
    }
    return '$kb KB';
  }

  /// Converts KB value to exact bytes
  static int kbToBytes(int kb) => kb * 1024;

  /// Converts bytes to KB (rounded down)
  static int bytesToKb(int bytes) => (bytes / 1024).round();

  /// Calculates percentage reduction (e.g. 2.8MB -> 187KB = 93%)
  static int calculateReductionPercentage(int originalBytes, int resultBytes) {
    if (originalBytes <= 0 || resultBytes >= originalBytes) return 0;
    final diff = originalBytes - resultBytes;
    return ((diff / originalBytes) * 100).round();
  }
}
