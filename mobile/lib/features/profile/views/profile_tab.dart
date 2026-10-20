import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../core/widgets/custom_message_dialog.dart';
import '../../../core/theme/theme_service.dart';
import '../../../core/routes/app_routes.dart';
import '../../auth/controllers/auth_controller.dart';
import '../controllers/profile_controller.dart';
import 'widgets/profile_card.dart';
import 'widgets/settings_section.dart';
import 'widgets/settings_tile.dart';
import 'widgets/theme_selector.dart';
import 'widgets/language_selector.dart';

class ProfileTab extends GetView<ProfileController> {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authController = Get.find<AuthController>();
    final themeService = Get.find<ThemeService>();

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 8.0),
              child: Text(
                'profile'.tr,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                child: Column(
                  children: [
                    const ProfileCard(),
                    const SizedBox(height: 20),

                    SettingsSection(
                      title: 'theme'.tr,
                      children: [
                        Obx(
                          () => ThemeSelector(
                            isDarkActive: themeService.isDarkMode,
                            onToggle: () => themeService.toggleTheme(),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    SettingsSection(
                      title: 'language'.tr,
                      children: [
                        Obx(
                          () => LanguageSelector(
                            currentLang: authController.selectedLanguage.value,
                            onSelect: (lang) => authController.changeLanguage(lang),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    SettingsSection(
                      title: 'account'.tr,
                      children: [
                        SettingsTile(
                          icon: CupertinoIcons.person,
                          label: 'edit_profile'.tr,
                          onTap: () {
                            authController.initializeEditProfileForm();
                            Get.toNamed(AppRoutes.editProfile);
                          },
                        ),
                        SettingsTile(
                          icon: CupertinoIcons.bell,
                          label: 'notifications'.tr,
                          onTap: () => _showNotificationsModal(context),
                        ),
                        SettingsTile(
                          icon: CupertinoIcons.shield,
                          label: 'privacy'.tr,
                          onTap: () => _showPrivacyModal(context),
                        ),
                        SettingsTile(
                          icon: Icons.history_edu_rounded,
                          label: 'payments_tracker'.tr,
                          onTap: () => Get.toNamed(AppRoutes.paymentsTracker),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    SettingsSection(
                      title: 'info'.tr,
                      children: [
                        SettingsTile(
                          icon: CupertinoIcons.star,
                          label: 'rate_app'.tr,
                          onTap: () => _showRatingModal(context),
                        ),
                        SettingsTile(
                          icon: CupertinoIcons.info,
                          label: 'about_us'.tr,
                          onTap: () => _showAboutModal(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    GestureDetector(
                      onTap: () => authController.logout(),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: theme.cardColor,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: theme.dividerColor,
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: Colors.redAccent.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                CupertinoIcons.square_arrow_right,
                                color: Colors.redAccent,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'logout'.tr,
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: Colors.redAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 48),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPrivacyModal(BuildContext context) {
    final theme = Theme.of(context);

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          border: Border.all(color: theme.dividerColor, width: 1),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.dividerColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Icon(Icons.security_rounded, color: theme.primaryColor, size: 24),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'privacy_title'.tr,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'privacy_desc'.tr,
              style: theme.textTheme.bodyMedium?.copyWith(
                height: 1.6,
                color: theme.textTheme.bodySmall?.color,
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  void _showNotificationsModal(BuildContext context) {
    final theme = Theme.of(context);

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          border: Border.all(color: theme.dividerColor, width: 1),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.dividerColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Icon(CupertinoIcons.bell_fill, color: theme.primaryColor, size: 24),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'notifications_settings'.tr,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'notifications_active'.tr,
              style: theme.textTheme.bodyMedium?.copyWith(
                height: 1.6,
                color: theme.textTheme.bodySmall?.color,
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  void _showRatingModal(BuildContext context) {
    Get.snackbar(
      'rate_app'.tr,
      'thank_you_rating'.tr,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF6366F1),
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 16,
    );
  }

  void _showAboutModal(BuildContext context) {
    CustomMessageDialog.show(
      context,
      title: 'about_us'.tr,
      message: 'about_app_desc'.tr,
      icon: CupertinoIcons.info,
    );
  }
}
