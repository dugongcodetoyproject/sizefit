import 'package:flutter/foundation.dart';
import '../../../core/utils/file_size_formatter.dart';

@immutable
class ImageMetaInfo {
  final String path;
  final int bytes;
  final int width;
  final int height;
  final String format; // JPEG, PNG, WEBP, HEIC, etc.

  const ImageMetaInfo({
    required this.path,
    required this.bytes,
    required this.width,
    required this.height,
    required this.format,
  });

  String get formattedSize => FileSizeFormatter.formatBytes(bytes);

  String get resolutionString => '$width × $height';

  bool get isPng => format.toUpperCase() == 'PNG';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ImageMetaInfo &&
          runtimeType == other.runtimeType &&
          path == other.path &&
          bytes == other.bytes &&
          width == other.width &&
          height == other.height &&
          format == other.format;

  @override
  int get hashCode =>
      path.hashCode ^
      bytes.hashCode ^
      width.hashCode ^
      height.hashCode ^
      format.hashCode;
}
