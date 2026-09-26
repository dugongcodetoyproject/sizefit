import 'package:flutter/foundation.dart';
import '../../../core/utils/file_size_formatter.dart';

@immutable
class CompressionResult {
  final int originalBytes;
  final int resultBytes;
  final int originalWidth;
  final int originalHeight;
  final int resultWidth;
  final int resultHeight;
  final int quality;
  final double scale;
  final String outputPath;
  final Uint8List? resultBytesData;
  final bool isQualityCompromised;

  const CompressionResult({
    required this.originalBytes,
    required this.resultBytes,
    required this.originalWidth,
    required this.originalHeight,
    required this.resultWidth,
    required this.resultHeight,
    required this.quality,
    required this.scale,
    required this.outputPath,
    this.resultBytesData,
    this.isQualityCompromised = false,
  });

  int get reductionPercentage =>
      FileSizeFormatter.calculateReductionPercentage(originalBytes, resultBytes);

  String get formattedOriginalSize =>
      FileSizeFormatter.formatBytes(originalBytes);

  String get formattedResultSize =>
      FileSizeFormatter.formatBytes(resultBytes);

  String get originalResolution => '$originalWidth × $originalHeight';

  String get resultResolution => '$resultWidth × $resultHeight';

  bool get isResolutionChanged =>
      originalWidth != resultWidth || originalHeight != resultHeight;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CompressionResult &&
          runtimeType == other.runtimeType &&
          originalBytes == other.originalBytes &&
          resultBytes == other.resultBytes &&
          originalWidth == other.originalWidth &&
          originalHeight == other.originalHeight &&
          resultWidth == other.resultWidth &&
          resultHeight == other.resultHeight &&
          quality == other.quality &&
          scale == other.scale &&
          outputPath == other.outputPath &&
          isQualityCompromised == other.isQualityCompromised;

  @override
  int get hashCode =>
      originalBytes.hashCode ^
      resultBytes.hashCode ^
      originalWidth.hashCode ^
      originalHeight.hashCode ^
      resultWidth.hashCode ^
      resultHeight.hashCode ^
      quality.hashCode ^
      scale.hashCode ^
      outputPath.hashCode ^
      isQualityCompromised.hashCode;
}
