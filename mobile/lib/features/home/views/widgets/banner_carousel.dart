import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/theme_config.dart';
import '../../controllers/study_tip_controller.dart';

/// Pure reactive widget. All banner state lives in [StudyTipController].
/// No StatefulWidget, no local Timer, no local PageController.
class BannerCarousel extends GetView<StudyTipController> {
  const BannerCarousel({super.key});

  IconData _getIconData(String? iconHex) {
    if (iconHex == null || iconHex.isEmpty) return Icons.tips_and_updates_rounded;
    try {
      final int codePoint = int.parse(iconHex, radix: 16);
      // ignore: non_const_argument_for_const_parameter
      return IconData(codePoint, fontFamily: 'MaterialIcons');
    } catch (_) {
      return Icons.tips_and_updates_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Obx(() {
      final tips = controller.studyTips;
      final int slideCount = tips.isNotEmpty ? tips.length : 3;
      final activeIndex = controller.activeBannerIndex.value;

      return Column(
        children: [
          SizedBox(
            height: 110,
            child: PageView.builder(
              controller: controller.bannerPageController,
              itemCount: slideCount,
              onPageChanged: (index) => controller.activeBannerIndex.value = index,
              itemBuilder: (context, index) {
                if (tips.isNotEmpty) {
                  final tip = tips[index];
                  return _buildBannerCard(
                    title: tip.title,
                    desc: tip.content,
                    icon: _getIconData(tip.icon),
                    theme: theme,
                  );
                }
                const fallbacks = [
                  (key: 'banner_tip_title', descKey: 'banner_tip_desc', icon: Icons.lightbulb_rounded),
                  (key: 'banner_summaries_title', descKey: 'banner_summaries_desc', icon: Icons.auto_stories_rounded),
                  (key: 'banner_downloads_title', descKey: 'banner_downloads_desc', icon: Icons.cloud_download_rounded),
                ];
                final fb = fallbacks[index % fallbacks.length];
                return _buildBannerCard(
                  title: fb.key.tr,
                  desc: fb.descKey.tr,
                  icon: fb.icon,
                  theme: theme,
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              slideCount,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                height: 6,
                width: activeIndex == index ? 16 : 6,
                decoration: BoxDecoration(
                  color: activeIndex == index
                      ? theme.primaryColor
                      : theme.primaryColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildBannerCard({
    required String title,
    required String desc,
    required IconData icon,
    required ThemeData theme,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [theme.cardColor, theme.scaffoldBackgroundColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.dividerColor, width: 1.5),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: theme.primaryColor, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: (theme.textTheme.bodyMedium ?? const TextStyle()).copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: theme.textTheme.bodyLarge?.color,
                  ).withArabicCheck(title),
                ),
                const SizedBox(height: 4),
                Text(
                  desc,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: (theme.textTheme.bodySmall ?? const TextStyle()).copyWith(
                    fontSize: 11,
                    color: theme.textTheme.bodySmall?.color,
                  ).withArabicCheck(desc),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
