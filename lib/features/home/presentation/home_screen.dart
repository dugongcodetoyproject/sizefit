import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/file_size_formatter.dart';
import '../../image_picker/providers/selected_image_provider.dart';
import '../../compression/models/compression_request.dart';
import '../../compression/providers/compression_provider.dart';
import '../../compression/providers/target_size_provider.dart';
import '../../monetization/presentation/adaptive_banner_widget.dart';
import '../../result/presentation/result_screen.dart';
import 'widgets/custom_size_dialog.dart';
import 'widgets/photo_select_card.dart';
import 'widgets/target_preset_selector.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  Future<void> _executeCompression(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final imageState = ref.read(selectedImageProvider);
    final imageInfo = imageState.value;
    final targetKb = ref.read(targetSizeProvider);

    if (imageInfo == null) return;

    // Show progress dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return Consumer(
          builder: (context, ref, _) {
            final compState = ref.watch(compressionNotifierProvider);
            final isDark = Theme.of(context).brightness == Brightness.dark;

            return AlertDialog(
              backgroundColor:
                  isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              content: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(strokeWidth: 3),
                    const SizedBox(height: 20),
                    Text(
                      compState.statusText.isEmpty
                          ? 'Optimizing...'
                          : compState.statusText,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: compState.progress > 0 ? compState.progress : null,
                      backgroundColor: Colors.grey.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Processed entirely on your device.',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    final request = CompressionRequest(
      inputPath: imageInfo.path,
      targetBytes: targetKb * 1024,
      outputFormat: imageInfo.isPng ? 'PNG' : 'JPEG',
    );

    final result = await ref
        .read(compressionNotifierProvider.notifier)
        .compress(request);

    // Dismiss progress dialog
    if (context.mounted) {
      Navigator.of(context, rootNavigator: true).pop();
    }

    if (result != null && context.mounted) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => ResultScreen(
            result: result,
            originalPath: imageInfo.path,
            targetKb: targetKb,
            onCompressAnother: () {
              ref.read(selectedImageProvider.notifier).clear();
            },
          ),
        ),
      );
    } else if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: const Text(
            "Couldn't process this photo. Please try another image.",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageState = ref.watch(selectedImageProvider);
    final targetKb = ref.watch(targetSizeProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final imageInfo = imageState.value;
    final isLoadingImage = imageState.isLoading;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'SizeFit',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                  letterSpacing: -0.5,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Photo Compressor',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
              ),
            ),
          ],
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
                    // Tagline & Value proposition
                    const Text(
                      'Make any photo fit the upload limit.',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Privacy badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.surfaceDark
                            : AppColors.successLight,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppColors.success.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.lock_rounded,
                            size: 13,
                            color: AppColors.success,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            AppConstants.privacyNotice,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.success,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Step 1: Photo selection
                    PhotoSelectCard(
                      imageInfo: imageInfo,
                      isLoading: isLoadingImage,
                      onSelectPhoto: () {
                        ref.read(selectedImageProvider.notifier).pickPhoto();
                      },
                      onChangePhoto: () {
                        ref.read(selectedImageProvider.notifier).pickPhoto();
                      },
                    ),
                    const SizedBox(height: 28),

                    // Step 2: Target Size Selection
                    TargetPresetSelector(
                      selectedKb: targetKb,
                      onSelectPreset: (kb) {
                        ref.read(targetSizeProvider.notifier).setTargetKb(kb);
                      },
                      onOpenCustomDialog: () {
                        CustomSizeDialog.show(
                          context: context,
                          currentKb: targetKb,
                          onApply: (kb) {
                            ref
                                .read(targetSizeProvider.notifier)
                                .setTargetKb(kb);
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // Bottom Action Area
            Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.surfaceDark
                    : AppColors.surfaceLight,
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
                  ElevatedButton(
                    onPressed: () {
                      if (imageInfo == null) {
                        ref
                            .read(selectedImageProvider.notifier)
                            .pickPhoto();
                      } else {
                        _executeCompression(context, ref);
                      }
                    },
                    child: Text(
                      imageInfo == null
                          ? 'Select Photo to Start'
                          : 'Fit under ${FileSizeFormatter.formatKb(targetKb)}',
                    ),
                  ),
                  const SizedBox(height: 8),
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
