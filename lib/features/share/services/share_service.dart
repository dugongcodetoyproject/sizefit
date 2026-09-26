import 'package:flutter/foundation.dart';
import 'package:share_plus/share_plus.dart';

class ShareService {
  const ShareService();

  /// Opens the native share sheet with the compressed file.
  Future<ShareResult> shareImage({
    required String filePath,
    String? subject,
    String? text,
  }) async {
    try {
      final xFile = XFile(filePath);
      final result = await SharePlus.instance.share(
        ShareParams(
          files: [xFile],
          subject: subject ?? 'Compressed Photo by SizeFit',
          text: text,
        ),
      );
      return result;
    } catch (e, st) {
      debugPrint('Error sharing photo: $e\n$st');
      rethrow;
    }
  }
}
