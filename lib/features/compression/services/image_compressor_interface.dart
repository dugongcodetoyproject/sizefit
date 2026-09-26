import 'dart:typed_data';

abstract class ImageCompressorInterface {
  Future<Uint8List> compressWithFile({
    required String path,
    required int minWidth,
    required int minHeight,
    required int quality,
    required String format,
    required bool autoCorrectionAngle,
    required bool keepExif,
  });

  Future<void> compressToFile({
    required String sourcePath,
    required String targetPath,
    required int minWidth,
    required int minHeight,
    required int quality,
    required String format,
    required bool autoCorrectionAngle,
    required bool keepExif,
  });
}
