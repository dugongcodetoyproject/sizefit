import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../compression/models/compression_result.dart';
import '../../monetization/presentation/adaptive_banner_widget.dart';
import '../../share/services/share_service.dart';
import '../../storage/services/media_store_service.dart';
import 'widgets/before_after_preview.dart';
import 'widgets/size_diff_hero_badge.dart';

class ResultScreen extends StatefulWidget {
  final CompressionResult result;
  final String originalPath;
  final int targetKb;
  final VoidCallback onCompressAnother;

  const ResultScreen({
    super.key,
    required this.result,
    required this.originalPath,
    required this.targetKb,
    required this.onCompressAnother,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  final MediaStoreService _mediaStoreService = const MediaStoreService();
  final ShareService _shareService = const ShareService();

  bool _isSaving = false;
  bool _isSaved = false;

  Future<void> _handleSave() async {
    if (_isSaving || _isSaved) return;

    setState(() {
      _isSaving = true;
    });

    try {
      final filename = await _mediaStoreService.saveImage(
        filePath: widget.result.outputPath,
        targetKb: widget.targetKb,
      );

      if (mounted) {
        setState(() {
          _isSaving = false;
          _isSaved = true;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            content: Row(
              children: [
                const Icon(Icons.check_circle_outline, color: Colors.white),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Saved to Pictures/SizeFit\n($filename)',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            content: const Text(
              'Failed to save image. Please check storage permissions.',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            ),
          ),
        );
      }
    }
  }

  Future<void> _handleShare() async {
    try {
      await _shareService.shareImage(
        filePath: widget.result.outputPath,
        text: 'Compressed with SizeFit (${widget.result.formattedResultSize})',
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            content: const Text('Failed to open share sheet.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Result'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Size Difference Hero
                    SizeDiffHeroBadge(
                      result: widget.result,
                      targetKb: widget.targetKb,
                    ),
                    const SizedBox(height: 20),

                    // Before / After Visual Comparison
                    BeforeAfterPreview(
                      originalPath: widget.originalPath,
                      resultPath: widget.result.outputPath,
                      originalSizeText: widget.result.formattedOriginalSize,
                      resultSizeText: widget.result.formattedResultSize,
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // Bottom Actions (Save, Share, Compress Another)
            Container(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 12),
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                border: Border(
                  top: BorderSide(
                    color: isDark
                        ? AppColors.cardBorderDark
                        : AppColors.cardBorderLight,
                    width: 1.5,
                  ),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      // Save Button
                      Expanded(
                        flex: 3,
                        child: ElevatedButton.icon(
                          onPressed: _isSaving ? null : _handleSave,
                          icon: _isSaving
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Icon(
                                  _isSaved
                                      ? Icons.check_circle_rounded
                                      : Icons.download_rounded,
                                ),
                          label: Text(
                            _isSaved ? 'Saved to Gallery' : 'Save to Gallery',
                          ),
                          style: _isSaved
                              ? ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.success,
                                )
                              : null,
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Share Button
                      Expanded(
                        flex: 2,
                        child: OutlinedButton.icon(
                          onPressed: _handleShare,
                          icon: const Icon(Icons.share_rounded, size: 20),
                          label: const Text('Share'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Compress Another Photo
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        widget.onCompressAnother();
                      },
                      child: const Text(
                        'Compress Another Photo',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const AdaptiveBannerWidget(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
