import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import '../models/image_meta_info.dart';

class PhotoPickerService {
  final ImagePicker _picker;

  PhotoPickerService({ImagePicker? picker}) : _picker = picker ?? ImagePicker();

  /// Opens the system Photo Picker (no storage permissions required on Android 13+)
  Future<ImageMetaInfo?> pickPhoto() async {
    try {
      final XFile? xFile = await _picker.pickImage(
        source: ImageSource.gallery,
        requestFullMetadata: false, // Prevents unnecessary permission requests
      );

      if (xFile == null) {
        return null;
      }

      final file = File(xFile.path);
      final bytes = await file.length();
      final fileBytes = await file.readAsBytes();

      // Decode resolution
      final codec = await ui.instantiateImageCodec(fileBytes);
      final frameInfo = await codec.getNextFrame();
      final image = frameInfo.image;
      final width = image.width;
      final height = image.height;
      image.dispose();

      // Detect format from magic bytes & file extension
      final format = _detectFormat(fileBytes, xFile.path);

      return ImageMetaInfo(
        path: xFile.path,
        bytes: bytes,
        width: width,
        height: height,
        format: format,
      );
    } catch (e, stack) {
      debugPrint('Error picking photo: $e\n$stack');
      rethrow;
    }
  }

  static String _detectFormat(Uint8List bytes, String filePath) {
    if (bytes.length >= 8) {
      // PNG check: 89 50 4E 47 0D 0A 1A 0A
      if (bytes[0] == 0x89 &&
          bytes[1] == 0x50 &&
          bytes[2] == 0x4E &&
          bytes[3] == 0x47) {
        return 'PNG';
      }
      // JPEG check: FF D8 FF
      if (bytes[0] == 0xFF && bytes[1] == 0xD8 && bytes[2] == 0xFF) {
        return 'JPEG';
      }
      // WebP check: RIFF....WEBP
      if (bytes[0] == 0x52 &&
          bytes[1] == 0x49 &&
          bytes[2] == 0x46 &&
          bytes[3] == 0x46 &&
          bytes.length >= 12 &&
          bytes[8] == 0x57 &&
          bytes[9] == 0x45 &&
          bytes[10] == 0x42 &&
          bytes[11] == 0x50) {
        return 'WEBP';
      }
    }

    // Fallback to file extension
    final ext = p.extension(filePath).toLowerCase().replaceAll('.', '');
    if (ext == 'jpg' || ext == 'jpeg') return 'JPEG';
    if (ext == 'png') return 'PNG';
    if (ext == 'webp') return 'WEBP';
    if (ext == 'heic' || ext == 'heif') return 'HEIC';
    return ext.isEmpty ? 'IMAGE' : ext.toUpperCase();
  }
}
