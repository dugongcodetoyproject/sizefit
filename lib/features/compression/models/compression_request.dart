import 'package:flutter/foundation.dart';

@immutable
class CompressionRequest {
  final String inputPath;
  final int targetBytes;
  final String outputFormat; // 'JPEG', 'WEBP', 'PNG'
  final bool preserveResolution;
  final bool removeLocationMetadata;

  const CompressionRequest({
    required this.inputPath,
    required this.targetBytes,
    this.outputFormat = 'JPEG',
    this.preserveResolution = false,
    this.removeLocationMetadata = true,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CompressionRequest &&
          runtimeType == other.runtimeType &&
          inputPath == other.inputPath &&
          targetBytes == other.targetBytes &&
          outputFormat == other.outputFormat &&
          preserveResolution == other.preserveResolution &&
          removeLocationMetadata == other.removeLocationMetadata;

  @override
  int get hashCode =>
      inputPath.hashCode ^
      targetBytes.hashCode ^
      outputFormat.hashCode ^
      preserveResolution.hashCode ^
      removeLocationMetadata.hashCode;
}
