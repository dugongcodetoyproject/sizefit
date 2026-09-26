import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/file_size_formatter.dart';
import '../../../compression/models/compression_result.dart';

class SizeDiffHeroBadge extends StatelessWidget {
  final CompressionResult result;
  final int targetKb;

  const SizeDiffHeroBadge({
    super.key,
    required this.result,
    required this.targetKb,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final targetBytes = targetKb * 1024;
    final isUnderTarget = result.resultBytes <= targetBytes;
    final formattedTarget = FileSizeFormatter.formatKb(targetKb);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight,
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isUnderTarget
                      ? AppColors.success.withValues(alpha: 0.15)
                      : AppColors.warning.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isUnderTarget ? Icons.check_circle_rounded : Icons.info_rounded,
                      size: 15,
                      color: isUnderTarget ? AppColors.success : AppColors.warning,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      isUnderTarget ? 'FITS UPLOAD LIMIT' : 'CLOSEST FIT',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                        color:
                            isUnderTarget ? AppColors.success : AppColors.warning,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight.withValues(alpha: isDark ? 0.2 : 0.8),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '↓ ${result.reductionPercentage}% saved',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Main Hero Number: Result Size
          const Text(
            'Result Size',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 2),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                result.formattedResultSize,
                style: const TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1.2,
                  height: 1.1,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'target: < $formattedTarget',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 14),

          // Comparison Details Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _DetailColumn(
                label: 'Original',
                value: result.formattedOriginalSize,
                isDark: isDark,
              ),
              _DetailColumn(
                label: 'Resolution',
                value: result.isResolutionChanged
                    ? '${result.originalResolution}\n→ ${result.resultResolution}'
                    : '${result.resultResolution} (100%)',
                isDark: isDark,
              ),
              _DetailColumn(
                label: 'Quality Score',
                value: '${result.quality} / 100',
                isDark: isDark,
              ),
            ],
          ),

          // Quality compromise warning if applicable
          if (result.isQualityCompromised) ...[
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.warningLight.withValues(alpha: isDark ? 0.15 : 0.7),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: AppColors.warning.withValues(alpha: 0.4),
                ),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: AppColors.warning,
                    size: 18,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Very small target size may reduce image quality.',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.warning,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _DetailColumn extends StatelessWidget {
  final String label;
  final String value;
  final bool isDark;

  const _DetailColumn({
    required this.label,
    required this.value,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: isDark
                ? AppColors.textSecondaryDark
                : AppColors.textSecondaryLight,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            height: 1.25,
          ),
        ),
      ],
    );
  }
}
