import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeSelector extends StatelessWidget {
  final bool isDarkActive;
  final VoidCallback onToggle;

  const ThemeSelector({
    super.key,
    required this.isDarkActive,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: theme.primaryColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.palette_outlined,
                  size: 20,
                  color: theme.primaryColor,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'theme'.tr,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _ThemeOption(
                icon: Icons.wb_sunny_rounded,
                label: 'light_mode'.tr,
                isSelected: !isDarkActive,
                onTap: isDarkActive ? onToggle : () {},
              ),
              const SizedBox(width: 8),
              _ThemeOption(
                icon: Icons.nightlight_round,
                label: 'dark_mode'.tr,
                isSelected: isDarkActive,
                onTap: !isDarkActive ? onToggle : () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ThemeOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThemeOption({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            gradient: isSelected
                ? const LinearGradient(
                    colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: isSelected
                ? null
                : (theme.inputDecorationTheme.fillColor ?? theme.scaffoldBackgroundColor),
            borderRadius: BorderRadius.circular(14),
            border: isSelected
                ? null
                : Border.all(
                    color: theme.dividerColor,
                  ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                size: 20,
                color: isSelected
                    ? Colors.white
                    : theme.textTheme.bodySmall?.color,
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: isSelected
                      ? Colors.white
                      : theme.textTheme.bodyLarge?.color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
