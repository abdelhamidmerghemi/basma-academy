import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/theme_config.dart';

class BacCountdownCard extends StatelessWidget {
  const BacCountdownCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Compute dynamic BAC 2026 countdown (assuming June 7, 2026)
    final examDate = DateTime(2026, 6, 7);
    final now = DateTime.now();
    final difference = examDate.difference(now).inDays;
    final daysRemaining = difference > 0 ? difference : 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.dividerColor,
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: ThemeConfig.accentCyan.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'BAC 2026',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: ThemeConfig.accentCyan,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  'bac_countdown'.tr,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ).withArabicCheck('bac_countdown'.tr),
                ),
                const SizedBox(height: 4),
                Text(
                  'countdown_sub'.tr,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontSize: 12,
                  ).withArabicCheck('countdown_sub'.tr),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),

          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: theme.scaffoldBackgroundColor,
              border: Border.all(
                color: theme.dividerColor,
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$daysRemaining',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: ThemeConfig.accentCyan,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'days_left'.tr,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ).withArabicCheck('days_left'.tr),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
