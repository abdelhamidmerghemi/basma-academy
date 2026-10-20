import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../controllers/dashboard_controller.dart';
import '../../home/views/home_tab.dart';
import '../../catalog/views/catalog_tab.dart';
import '../../forum/views/forum_feed_view.dart';
import '../../announcements/views/announcements_tab.dart';
import '../../profile/views/profile_tab.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final List<Widget> pages = [
      const HomeTab(),
      const CatalogTab(),
      const ForumFeedView(),
      const AnnouncementsTab(),
      const ProfileTab(),
    ];

    return Scaffold(
      body: Stack(
        children: [
          Obx(() => IndexedStack(
                index: controller.currentIndex.value,
                children: pages,
              )),

          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14.0, 0, 14.0, 18.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24.0),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 12.0, sigmaY: 12.0),
                  child: Obx(() => Container(
                        height: 76,
                        decoration: BoxDecoration(
                          color: theme.cardColor.withOpacity(0.88),
                          borderRadius: BorderRadius.circular(24.0),
                          border: Border.all(
                            color: theme.dividerColor.withOpacity(0.6),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildNavItem(
                              index: 0,
                              icon: controller.currentIndex.value == 0
                                  ? CupertinoIcons.house_fill
                                  : CupertinoIcons.house,
                              label: 'home'.tr,
                              isActive: controller.currentIndex.value == 0,
                              theme: theme,
                            ),
                            _buildNavItem(
                              index: 1,
                              icon: CupertinoIcons.search,
                              label: 'search'.tr,
                              isActive: controller.currentIndex.value == 1,
                              theme: theme,
                            ),
                            _buildNavItem(
                              index: 2,
                              icon: controller.currentIndex.value == 2
                                  ? CupertinoIcons.chat_bubble_2_fill
                                  : CupertinoIcons.chat_bubble_2,
                              label: 'forum_label'.tr,
                              isActive: controller.currentIndex.value == 2,
                              theme: theme,
                            ),
                            _buildNavItem(
                              index: 3,
                              icon: controller.currentIndex.value == 3
                                  ? CupertinoIcons.news_solid
                                  : CupertinoIcons.news,
                              label: 'feed'.tr,
                              isActive: controller.currentIndex.value == 3,
                              theme: theme,
                            ),
                            _buildNavItem(
                              index: 4,
                              icon: controller.currentIndex.value == 4
                                  ? CupertinoIcons.person_fill
                                  : CupertinoIcons.person,
                              label: 'profile'.tr,
                              isActive: controller.currentIndex.value == 4,
                              theme: theme,
                            ),
                          ],
                        ),
                      )),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required String label,
    required bool isActive,
    required ThemeData theme,
  }) {
    final activeColor = theme.primaryColor;
    final inactiveColor = theme.textTheme.bodySmall?.color ?? Colors.grey;

    return InkWell(
      onTap: () => controller.changeTab(index),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedScale(
              scale: isActive ? 1.15 : 1.0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutBack,
              child: Icon(
                icon,
                color: isActive ? activeColor : inactiveColor,
                size: 24,
              ),
            ),
            const SizedBox(height: 4),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  color: isActive ? activeColor : inactiveColor,
                ),
              ),
            ),
            const SizedBox(height: 2),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: 4,
              width: isActive ? 4 : 0,
              decoration: BoxDecoration(
                color: activeColor,
                shape: BoxShape.circle,
                boxShadow: isActive
                    ? [
                        BoxShadow(
                          color: activeColor.withOpacity(0.5),
                          blurRadius: 4,
                          spreadRadius: 1,
                        ),
                      ]
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
