import 'package:flutter/material.dart';
import '../../../../core/theme/theme_config.dart';

class PromptChipWidget extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const PromptChipWidget({
    super.key,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: ThemeConfig.primaryColor.withOpacity(0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: ThemeConfig.primaryColor.withOpacity(0.2),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
            color: ThemeConfig.primaryColor,
          ),
        ),
      ),
    );
  }
}
