import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme/theme_config.dart';
import '../theme/premium_interactions.dart';

class CustomConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final Color? iconColor;
  final String confirmText;
  final String? cancelText;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;
  final bool isDanger;

  const CustomConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    this.icon = Icons.info_outline_rounded,
    this.iconColor,
    required this.confirmText,
    this.cancelText,
    required this.onConfirm,
    this.onCancel,
    this.isDanger = false,
  });

  /// Static helper to display the confirmation bottom sheet anywhere in the app.
  static Future<bool?> show(
    BuildContext context, {
    required String title,
    required String message,
    IconData icon = Icons.info_outline_rounded,
    Color? iconColor,
    required String confirmText,
    String? cancelText,
    required VoidCallback onConfirm,
    VoidCallback? onCancel,
    bool isDanger = false,
  }) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.55),
      builder: (_) => CustomConfirmationDialog(
        title: title,
        message: message,
        icon: icon,
        iconColor: iconColor,
        confirmText: confirmText,
        cancelText: cancelText ?? 'cancel'.tr,
        onConfirm: onConfirm,
        onCancel: onCancel,
        isDanger: isDanger,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeIconColor = iconColor ?? (isDanger ? ThemeConfig.errorColor : ThemeConfig.primaryColor);

    return Container(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 12,
        bottom: MediaQuery.of(context).padding.bottom + 20,
      ),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.dividerColor,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          const SizedBox(height: 24),

          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: activeIconColor.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 32,
              color: activeIconColor,
            ),
          ),
          const SizedBox(height: 18),

          Text(
            title,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 10),

          Text(
            message,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.textTheme.bodySmall?.color,
              fontSize: 14,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 28),

          Row(
            children: [
              Expanded(
                child: BouncingButton(
                  onTap: () {
                    HapticHelper.lightTap();
                    Navigator.of(context).pop(false);
                    if (onCancel != null) onCancel!();
                  },
                  child: Container(
                    height: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: theme.dividerColor,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      cancelText ?? 'cancel'.tr,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 14.5,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              Expanded(
                child: BouncingButton(
                  onTap: () {
                    HapticHelper.lightTap();
                    Navigator.of(context).pop(true);
                    onConfirm();
                  },
                  child: Container(
                    height: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isDanger ? ThemeConfig.errorColor : ThemeConfig.primaryColor,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: (isDanger ? ThemeConfig.errorColor : ThemeConfig.primaryColor).withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Text(
                      confirmText,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14.5,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
