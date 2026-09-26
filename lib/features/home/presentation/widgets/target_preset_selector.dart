import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/file_size_formatter.dart';

class TargetPresetSelector extends StatelessWidget {
  final int selectedKb;
  final ValueChanged<int> onSelectPreset;
  final VoidCallback onOpenCustomDialog;

  const TargetPresetSelector({
    super.key,
    required this.selectedKb,
    required this.onSelectPreset,
    required this.onOpenCustomDialog,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final isCustom = !AppConstants.defaultPresetsKb.contains(selectedKb);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Target Size Limit',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.2,
              ),
            ),
            Text(
              'Must be under this limit',
              style: TextStyle(
                fontSize: 12,
                color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            ...AppConstants.defaultPresetsKb.map((kb) {
              final isSelected = selectedKb == kb;
              final label = FileSizeFormatter.formatKb(kb);

              return _PresetChip(
                label: label,
                isSelected: isSelected,
                isDark: isDark,
                onTap: () => onSelectPreset(kb),
              );
            }),
            // Custom button
            _PresetChip(
              label: isCustom
                  ? 'Custom (${FileSizeFormatter.formatKb(selectedKb)})'
                  : 'Custom...',
              isSelected: isCustom,
              isDark: isDark,
              isCustomBadge: true,
              onTap: onOpenCustomDialog,
            ),
          ],
        ),
      ],
    );
  }
}

class _PresetChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final bool isDark;
  final bool isCustomBadge;
  final VoidCallback onTap;

  const _PresetChip({
    required this.label,
    required this.isSelected,
    required this.isDark,
    this.isCustomBadge = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary
                : (isDark ? AppColors.surfaceDark : AppColors.surfaceLight),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? AppColors.primary
                  : (isDark
                      ? AppColors.cardBorderDark
                      : AppColors.cardBorderLight),
              width: isSelected ? 2 : 1.5,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.25),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    )
                  ]
                : null,
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 15,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
              color: isSelected
                  ? Colors.white
                  : (isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimaryLight),
            ),
          ),
        ),
      ),
    );
  }
}
