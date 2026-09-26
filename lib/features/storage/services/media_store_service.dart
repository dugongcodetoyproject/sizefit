import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:gal/gal.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class MediaStoreService {
  const MediaStoreService();

  /// Saves the compressed image to Pictures/SizeFit directory via MediaStore / Gal.
  /// Returns saved file name on success.
  Future<String> saveImage({
    required String filePath,
    required int targetKb,
  }) async {
    try {
      final now = DateTime.now();
      final timestamp = DateFormat('yyyyMMdd_HHmmss').format(now);
      final filename = 'sizefit_${targetKb}kb_$timestamp.jpg';

      // Ensure proper file naming in temp directory before saving
      final tempDir = await getTemporaryDirectory();
      final targetNamedPath = p.join(tempDir.path, filename);
      final sourceFile = File(filePath);
      await sourceFile.copy(targetNamedPath);

      // Check / request storage access through Gal (zero-permission on Android 10+)
      final hasAccess = await Gal.hasAccess();
      if (!hasAccess) {
        final granted = await Gal.requestAccess();
        if (!granted) {
          throw const FileSystemException('Storage access denied by user');
        }
      }

      await Gal.putImage(
        targetNamedPath,
        album: 'SizeFit',
      );

      // Clean up temp copy
      final tempNamedFile = File(targetNamedPath);
      if (await tempNamedFile.exists()) {
        await tempNamedFile.delete();
      }

      return filename;
    } catch (e, st) {
      debugPrint('Error saving to MediaStore: $e\n$st');
      rethrow;
    }
  }

  /// Checks if file exists on disk
  bool fileExists(String path) {
    return File(path).existsSync();
  }
}
