import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class CustomSizeDialog extends StatefulWidget {
  final int currentKb;
  final ValueChanged<int> onApply;

  const CustomSizeDialog({
    super.key,
    required this.currentKb,
    required this.onApply,
  });

  static Future<void> show({
    required BuildContext context,
    required int currentKb,
    required ValueChanged<int> onApply,
  }) {
    return showDialog(
      context: context,
      builder: (ctx) => CustomSizeDialog(
        currentKb: currentKb,
        onApply: onApply,
      ),
    );
  }

  @override
  State<CustomSizeDialog> createState() => _CustomSizeDialogState();
}

class _CustomSizeDialogState extends State<CustomSizeDialog> {
  late final TextEditingController _controller;
  String _unit = 'KB'; // 'KB' or 'MB'
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    if (widget.currentKb >= 1000 && widget.currentKb % 1000 == 0) {
      _unit = 'MB';
      _controller = TextEditingController(
          text: (widget.currentKb ~/ 1000).toString());
    } else {
      _unit = 'KB';
      _controller =
          TextEditingController(text: widget.currentKb.toString());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final text = _controller.text.trim();
    final value = double.tryParse(text);

    if (value == null || value <= 0) {
      setState(() {
        _errorMessage = 'Please enter a valid number';
      });
      return;
    }

    final int targetKb = _unit == 'MB' ? (value * 1000).round() : value.round();

    if (targetKb < 10) {
      setState(() {
        _errorMessage = 'Minimum size is 10 KB';
      });
      return;
    }

    if (targetKb > 100000) {
      // 100MB max limit
      setState(() {
        _errorMessage = 'Maximum size is 100 MB';
      });
      return;
    }

    widget.onApply(targetKb);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AlertDialog(
      backgroundColor:
          isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text(
        'Custom Target Size',
        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  autofocus: true,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                  decoration: InputDecoration(
                    hintText: 'e.g. 750',
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    errorText: _errorMessage,
                  ),
                  onSubmitted: (_) => _submit(),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark
                        ? AppColors.cardBorderDark
                        : AppColors.cardBorderLight,
                    width: 1.5,
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _unit,
                    items: const [
                      DropdownMenuItem(
                        value: 'KB',
                        child: Text(
                          'KB',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'MB',
                        child: Text(
                          'MB',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          _unit = val;
                        });
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Target file size limit for uploads.',
            style: TextStyle(
              fontSize: 12,
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(90, 44),
            padding: const EdgeInsets.symmetric(horizontal: 18),
          ),
          onPressed: _submit,
          child: const Text('Set'),
        ),
      ],
    );
  }
}
