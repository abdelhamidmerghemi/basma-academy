import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../core/widgets/custom_profile_avatar.dart';
import '../../../core/theme/premium_interactions.dart';
import '../../../core/theme/theme_config.dart';
import '../../../core/routes/app_routes.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../dashboard/controllers/dashboard_controller.dart';
import '../../catalog/controllers/catalog_controller.dart';
import '../../catalog/models/subject_model.dart';
import '../../notifications/views/notifications_sheet.dart';
import '../../notifications/controllers/notification_controller.dart';
import '../../catalog/views/widgets/course_card.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authController = Get.find<AuthController>();
    final catalogController = Get.find<CatalogController>();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopHeader(context, theme, authController),
              const SizedBox(height: 20),
              _buildSearchPill(context, theme, catalogController),
              const SizedBox(height: 24),
              _buildHeroBanner(context, theme, catalogController),
              const SizedBox(height: 28),
              _buildSectionHeader(
                theme,
                title: 'subjects'.tr,
                actionLabel: 'view_all'.tr,
                onTapAction: () {
                  HapticHelper.lightTap();
                  Get.find<DashboardController>().changeTab(1);
                },
              ),
              const SizedBox(height: 16),
              _buildSubjectsRow(theme, catalogController),
              const SizedBox(height: 28),
              _buildSectionHeader(
                theme,
                title: 'study_tools'.tr,
                actionLabel: '',
                onTapAction: () {},
              ),
              const SizedBox(height: 14),
              _buildStudyToolsRow(theme),

              const SizedBox(height: 28),
              _buildSectionHeader(
                theme,
                title: 'popular_courses'.tr,
                actionLabel: 'view_all'.tr,
                onTapAction: () {
                  HapticHelper.lightTap();
                  Get.find<DashboardController>().changeTab(1);
                },
              ),
              const SizedBox(height: 16),
              _buildPopularCourses(theme, catalogController),
              const SizedBox(height: 140),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopHeader(
    BuildContext context,
    ThemeData theme,
    AuthController authController,
  ) {
    return Obx(() {
      final name = authController.currentUser.value?.name ?? '';
      final avatarUrl = authController.currentUser.value?.avatarUrl ?? '';

      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Avatar + greeting
          Row(
            children: [
              CustomProfileAvatar(
                avatarUrl: avatarUrl,
                name: name,
                radius: 24,
                showBorder: true,
                onTap: () {
                  HapticHelper.lightTap();
                  Get.find<DashboardController>().changeTab(4);
                },
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Get.find<CatalogController>().currentGreetingKey.tr,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontSize: 12,
                      color: theme.textTheme.bodySmall?.color,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.3,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Bell with unread badge
          _NotificationBell(theme: theme),
        ],
      );
    });
  }

  Widget _buildSearchPill(
    BuildContext context,
    ThemeData theme,
    CatalogController catalogController,
  ) {
    return Row(
      children: [
        Expanded(
          child: BouncingButton(
            onTap: () {
              HapticHelper.lightTap();
              Get.find<DashboardController>().changeTab(1);
            },
            child: Container(
              height: 52,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: theme.dividerColor, width: 1),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.search_rounded,
                    color: theme.textTheme.bodySmall?.color,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'search_placeholder'.tr,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.textTheme.bodySmall?.color,
                      fontSize: 13.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Obx(() {
          final hasFilters = catalogController.hasActiveFilters;
          return BouncingButton(
            onTap: () {
              HapticHelper.selectionClick();
              _showFilterSheet(context, catalogController);
            },
            child: Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: hasFilters
                    ? theme.primaryColor
                    : theme.primaryColor.withOpacity(0.08),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: theme.primaryColor.withOpacity(0.18),
                  width: 1,
                ),
              ),
              child: Icon(
                Icons.tune_rounded,
                color: hasFilters ? Colors.white : theme.primaryColor,
                size: 20,
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildHeroBanner(
    BuildContext context,
    ThemeData theme,
    CatalogController catalogController,
  ) {
    return Container(
      width: double.infinity,
      height: 180,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [ThemeConfig.primaryColor, ThemeConfig.secondaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: ThemeConfig.primaryColor.withOpacity(0.25),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Subtle pattern overlay
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Opacity(
                opacity: 0.06,
                child: Image.asset(
                  'assets/images/pattern_bg.png',
                  fit: BoxFit.cover,
                  errorBuilder: (ctx, err, stack) => const SizedBox.shrink(),
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(22.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'ai_banner_title'.tr,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.52,
                  child: Text(
                    'ai_banner_desc'.tr,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.35,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                BouncingButton(
                  onTap: () {
                    HapticHelper.lightTap();
                    Get.toNamed(AppRoutes.aiTutor);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 9,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      'ask_ai_now'.tr,
                      style: TextStyle(
                        color: ThemeConfig.primaryColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 3D character mascot (Directional layout prevents text overlay in Arabic RTL)
          PositionedDirectional(
            end: -10,
            bottom: -5,
            child: Image.asset(
              'assets/images/ai_robot_idea.png',
              height: 185,
              fit: BoxFit.contain,
              errorBuilder: (ctx, err, stack) => const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(
    ThemeData theme, {
    required String title,
    required String actionLabel,
    required VoidCallback onTapAction,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 17,
            letterSpacing: -0.2,
          ),
        ),
        if (actionLabel.isNotEmpty)
          GestureDetector(
            onTap: onTapAction,
            child: Text(
              actionLabel,
              style: TextStyle(
                color: theme.primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSubjectsRow(
    ThemeData theme,
    CatalogController catalogController,
  ) {
    return Obx(() {
      if (catalogController.isLoadingSubjects.value) {
        return SizedBox(
          height: 88,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: 6,
            separatorBuilder: (_, index) => const SizedBox(width: 12),
            itemBuilder: (_, index) => _SubjectSkeleton(theme: theme),
          ),
        );
      }

      final subjects = catalogController.subjects;

      if (subjects.isEmpty) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Text('no_subjects'.tr, style: theme.textTheme.bodySmall),
          ),
        );
      }

      final displayList = subjects.take(7).toList();
      final showViewAll = subjects.length > 7;

      return SizedBox(
        height: 90,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: displayList.length + (showViewAll ? 1 : 0),
          separatorBuilder: (_, index) => const SizedBox(width: 12),
          itemBuilder: (context, index) {
            if (showViewAll && index == displayList.length) {
              return BouncingButton(
                onTap: () {
                  HapticHelper.lightTap();
                  Get.find<DashboardController>().changeTab(1);
                },
                child: _SubjectChip(
                  icon: Icons.apps_rounded,
                  color: theme.primaryColor,
                  label: 'view_all'.tr,
                  theme: theme,
                ),
              );
            }

            final SubjectModel subject = displayList[index];

            return BouncingButton(
              onTap: () {
                HapticHelper.selectionClick();
                catalogController.filterBySubject(subject.id);
                Get.find<DashboardController>().changeTab(1);
              },
              child: _SubjectChip(
                icon: subject.iconData,
                color: subject.iconColor,
                label: subject.name,
                theme: theme,
              ),
            );
          },
        ),
      );
    });
  }

  Widget _buildStudyToolsRow(ThemeData theme) {
    final tools = [
      (
        labelKey: 'ai_tutor_label',
        icon: CupertinoIcons.sparkles,
        onTap: () {
          HapticHelper.selectionClick();
          Get.toNamed(AppRoutes.aiTutor);
        },
      ),
      (
        labelKey: 'quiz',
        icon: CupertinoIcons.doc_text_fill,
        onTap: () {
          HapticHelper.selectionClick();
          Get.toNamed(AppRoutes.quiz, arguments: 1);
        },
      ),
      (
        labelKey: 'flashcards_label',
        icon: CupertinoIcons.layers_fill,
        onTap: () {
          HapticHelper.selectionClick();
          Get.toNamed(AppRoutes.flashcards);
        },
      ),
      (
        labelKey: 'announcements_label',
        icon: CupertinoIcons.speaker_2_fill,
        onTap: () {
          HapticHelper.selectionClick();
          Get.find<DashboardController>().changeTab(3);
        },
      ),
    ];

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: tools.map((tool) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: BouncingButton(
                onTap: tool.onTap,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 4,
                  ),
                  decoration: BoxDecoration(
                    color: theme.primaryColor.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: theme.primaryColor.withOpacity(0.15),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(tool.icon, color: theme.primaryColor, size: 20),
                      const SizedBox(height: 5),
                      Text(
                        tool.labelKey.tr,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.primaryColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 10.5,
                          height: 1.15,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPopularCourses(
    ThemeData theme,
    CatalogController catalogController,
  ) {
    return Obx(() {
      if (catalogController.isLoadingCourses.value) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0),
            child: CircularProgressIndicator(),
          ),
        );
      }

      if (catalogController.courses.isEmpty) {
        return const SizedBox.shrink();
      }

      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: catalogController.courses.length.clamp(0, 3),
        separatorBuilder: (_, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final course = catalogController.courses[index];
          return CourseCard(course: course);
        },
      );
    });
  }

  void _showFilterSheet(
    BuildContext context,
    CatalogController catalogController,
  ) {
    final theme = Theme.of(context);

    final sortOptions = [
      {'value': 'newest', 'label': '🆕 الأحدث'},
      {'value': 'popular', 'label': '🔥 الأكثر شعبية'},
      {'value': 'rating', 'label': '⭐ الأعلى تقييماً'},
    ];

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.dividerColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'filter_courses'.tr,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Obx(() {
                  if (!catalogController.hasActiveFilters) {
                    return const SizedBox.shrink();
                  }
                  return GestureDetector(
                    onTap: () {
                      HapticHelper.lightTap();
                      catalogController.resetFilters();
                    },
                    child: Text(
                      'reset'.tr,
                      style: TextStyle(
                        color: theme.colorScheme.error,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  );
                }),
              ],
            ),
            const SizedBox(height: 18),

            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'subject'.tr,
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Obx(() {
                      final subjects = catalogController.subjects;
                      final isAllSelected =
                          catalogController.selectedSubjectId.value == null;
                      return Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          ChoiceChip(
                            label: Text('all'.tr),
                            selected: isAllSelected,
                            onSelected: (_) {
                              catalogController.selectedSubjectId.value = null;
                            },
                            selectedColor: theme.primaryColor,
                            backgroundColor: theme.cardColor,
                            checkmarkColor: Colors.white,
                            side: BorderSide(
                              color: isAllSelected
                                  ? theme.primaryColor
                                  : theme.dividerColor,
                            ),
                            labelStyle: TextStyle(
                              color: isAllSelected
                                  ? Colors.white
                                  : theme.textTheme.bodyMedium?.color,
                              fontWeight: isAllSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              fontSize: 12.5,
                            ),
                          ),
                          ...subjects.map((s) {
                            final isSelected =
                                catalogController.selectedSubjectId.value ==
                                s.id;
                            return ChoiceChip(
                              label: Text(s.name),
                              selected: isSelected,
                              onSelected: (_) {
                                catalogController.filterBySubject(s.id);
                              },
                              selectedColor: theme.primaryColor,
                              backgroundColor: theme.cardColor,
                              checkmarkColor: Colors.white,
                              side: BorderSide(
                                color: isSelected
                                    ? theme.primaryColor
                                    : theme.dividerColor,
                              ),
                              labelStyle: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : theme.textTheme.bodyMedium?.color,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                fontSize: 12.5,
                              ),
                            );
                          }),
                        ],
                      );
                    }),
                    const SizedBox(height: 20),

                    Text(
                      'sort_by'.tr,
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Obx(() {
                      return Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: sortOptions.map((opt) {
                          final isSelected =
                              catalogController.sortBy.value == opt['value'];
                          return ChoiceChip(
                            label: Text(opt['label']!),
                            selected: isSelected,
                            onSelected: (_) {
                              catalogController.sortBy.value = opt['value']!;
                            },
                            selectedColor: theme.primaryColor,
                            backgroundColor: theme.cardColor,
                            checkmarkColor: Colors.white,
                            side: BorderSide(
                              color: isSelected
                                  ? theme.primaryColor
                                  : theme.dividerColor,
                            ),
                            labelStyle: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : theme.textTheme.bodyMedium?.color,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              fontSize: 12.5,
                            ),
                          );
                        }).toList(),
                      );
                    }),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            BouncingButton(
              onTap: () {
                HapticHelper.lightTap();
                catalogController.fetchCourses();
                Get.back();
              },
              child: Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  color: theme.primaryColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.center,
                child: Text(
                  'apply_filters'.tr,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationBell extends StatelessWidget {
  const _NotificationBell({required this.theme});
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final unreadCount = Get.isRegistered<NotificationController>()
          ? Get.find<NotificationController>().unreadCount.value
          : 0;

      return BouncingButton(
        onTap: () {
          HapticHelper.lightTap();
          showNotificationsSheet(context);
        },
        child: Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: theme.dividerColor, width: 1),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(
                CupertinoIcons.bell,
                color: theme.textTheme.bodyLarge?.color,
                size: 22,
              ),
              if (unreadCount > 0)
                Positioned(
                  top: 8,
                  right: 8,
                  child: _PulseDot(color: ThemeConfig.errorColor),
                ),
            ],
          ),
        ),
      );
    });
  }
}

class _PulseDot extends StatefulWidget {
  const _PulseDot({required this.color});
  final Color color;

  @override
  State<_PulseDot> createState() => _PulseDotState();
}

class _PulseDotState extends State<_PulseDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _scale = Tween<double>(
      begin: 0.85,
      end: 1.15,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          color: widget.color,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: widget.color.withOpacity(0.5),
              blurRadius: 4,
              spreadRadius: 1,
            ),
          ],
        ),
      ),
    );
  }
}

class _SubjectChip extends StatelessWidget {
  const _SubjectChip({
    required this.icon,
    required this.color,
    required this.label,
    required this.theme,
  });

  final IconData icon;
  final Color color;
  final String label;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 68,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: color.withOpacity(0.18), width: 1),
            ),
            child: Icon(icon, size: 26, color: color),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelSmall?.copyWith(
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _SubjectSkeleton extends StatefulWidget {
  const _SubjectSkeleton({required this.theme});
  final ThemeData theme;

  @override
  State<_SubjectSkeleton> createState() => _SubjectSkeletonState();
}

class _SubjectSkeletonState extends State<_SubjectSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _opacity = Tween<double>(
      begin: 0.3,
      end: 0.7,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _opacity,
      builder: (ctx, _) => Opacity(
        opacity: _opacity.value,
        child: SizedBox(
          width: 68,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: widget.theme.cardColor,
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              const SizedBox(height: 6),
              Container(
                width: 44,
                height: 9,
                decoration: BoxDecoration(
                  color: widget.theme.cardColor,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
