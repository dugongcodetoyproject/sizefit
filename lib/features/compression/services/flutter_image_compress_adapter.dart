import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'image_compressor_interface.dart';

class FlutterImageCompressAdapter implements ImageCompressorInterface {
  const FlutterImageCompressAdapter();

  CompressFormat _mapFormat(String format) {
    switch (format.toUpperCase()) {
      case 'PNG':
        return CompressFormat.png;
      case 'WEBP':
        return CompressFormat.webp;
      case 'HEIC':
        return CompressFormat.heic;
      case 'JPEG':
      case 'JPG':
      default:
        return CompressFormat.jpeg;
    }
  }

  @override
  Future<Uint8List> compressWithFile({
    required String path,
    required int minWidth,
    required int minHeight,
    required int quality,
    required String format,
    required bool autoCorrectionAngle,
    required bool keepExif,
  }) async {
    final result = await FlutterImageCompress.compressWithFile(
      path,
      minWidth: minWidth,
      minHeight: minHeight,
      quality: quality,
      format: _mapFormat(format),
      autoCorrectionAngle: autoCorrectionAngle,
      keepExif: keepExif,
    );

    if (result == null) {
      throw const FileSystemException('Native compression returned null');
    }
    return result;
  }

  @override
  Future<void> compressToFile({
    required String sourcePath,
    required String targetPath,
    required int minWidth,
    required int minHeight,
    required int quality,
    required String format,
    required bool autoCorrectionAngle,
    required bool keepExif,
  }) async {
    final result = await FlutterImageCompress.compressAndGetFile(
      sourcePath,
      targetPath,
      minWidth: minWidth,
      minHeight: minHeight,
      quality: quality,
      format: _mapFormat(format),
      autoCorrectionAngle: autoCorrectionAngle,
      keepExif: keepExif,
    );

    if (result == null) {
      throw const FileSystemException('Failed to compress image to file');
    }
  }
}
