import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../core/theme/theme_config.dart';
import '../../../core/widgets/custom_profile_avatar.dart';
import '../../catalog/views/widgets/course_card.dart';
import '../controllers/teacher_profile_controller.dart';
import '../../announcements/views/widgets/announcement_card.dart';
import '../../announcements/controllers/announcement_controller.dart';
import '../../announcements/views/widgets/comments_bottom_sheet.dart';

class TeacherProfileView extends GetView<TeacherProfileController> {
  const TeacherProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final announcementCtrl = Get.put(AnnouncementController());

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Obx(
          () => Text(
            controller.teacherProfile.value?.name ?? 'teacher_profile'.tr,
            style: (theme.textTheme.titleLarge ?? const TextStyle()).copyWith(
              fontWeight: FontWeight.bold,
            ).withArabicCheck(controller.teacherProfile.value?.name ?? ''),
          ),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CupertinoActivityIndicator());
        }

        final profile = controller.teacherProfile.value;
        if (profile == null) {
          return Center(
            child: Text(
              'teacher_not_found'.tr,
              style: theme.textTheme.bodyMedium,
            ),
          );
        }

        final subTextColor = theme.textTheme.bodySmall?.color;

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 30),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: theme.dividerColor, width: 1),
                ),
                child: Column(
                  children: [
                    CustomProfileAvatar(
                      avatarUrl: profile.avatarUrl,
                      name: profile.name,
                      radius: 40,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            profile.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: (theme.textTheme.headlineSmall ?? const TextStyle())
                                .copyWith(fontWeight: FontWeight.bold)
                                .withArabicCheck(profile.name),
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(
                          CupertinoIcons.checkmark_seal_fill,
                          color: Color(0xFF007AFF),
                          size: 20,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      profile.headline,
                      textAlign: TextAlign.center,
                      style: (theme.textTheme.bodyMedium ?? const TextStyle())
                          .copyWith(
                            color: theme.primaryColor,
                            fontWeight: FontWeight.w600,
                          )
                          .withArabicCheck(profile.headline),
                    ),
                    if (profile.bio.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Text(
                        profile.bio,
                        textAlign: TextAlign.center,
                        style: (theme.textTheme.bodySmall ?? const TextStyle())
                            .copyWith(height: 1.5)
                            .withArabicCheck(profile.bio),
                      ),
                    ],

                    const SizedBox(height: 20),
                    Divider(height: 1, color: theme.dividerColor),
                    const SizedBox(height: 16),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatItem(
                          context,
                          count: '${profile.coursesCount}',
                          label: 'courses'.tr,
                          icon: CupertinoIcons.book,
                        ),
                        Container(
                          height: 30,
                          width: 1,
                          color: theme.dividerColor,
                        ),
                        _buildStatItem(
                          context,
                          count: '${profile.announcementsCount}',
                          label: 'announcements'.tr,
                          icon: CupertinoIcons.speaker_2,
                        ),
                        Container(
                          height: 30,
                          width: 1,
                          color: theme.dividerColor,
                        ),
                        _buildStatItem(
                          context,
                          count: '${profile.averageRating} ⭐',
                          label: '(${profile.reviewsCount})',
                          icon: CupertinoIcons.star,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: theme.dividerColor, width: 1),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => controller.selectedTabIndex.value = 0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: controller.selectedTabIndex.value == 0
                                  ? theme.primaryColor
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'courses'.tr,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: controller.selectedTabIndex.value == 0
                                    ? Colors.white
                                    : subTextColor,
                              ).withArabicCheck('courses'.tr),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => controller.selectedTabIndex.value = 1,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: controller.selectedTabIndex.value == 1
                                  ? theme.primaryColor
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'announcements'.tr,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: controller.selectedTabIndex.value == 1
                                    ? Colors.white
                                    : subTextColor,
                              ).withArabicCheck('announcements'.tr),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: controller.selectedTabIndex.value == 0
                    ? _buildCoursesList(context, profile.courses)
                    : _buildAnnouncementsList(
                        context, profile.announcements, announcementCtrl),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildStatItem(
    BuildContext context, {
    required String count,
    required String label,
    required IconData icon,
  }) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: theme.primaryColor),
            const SizedBox(width: 4),
            Text(
              count,
              style: (theme.textTheme.titleMedium ?? const TextStyle()).copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(fontSize: 11),
        ),
      ],
    );
  }

  Widget _buildCoursesList(BuildContext context, List courses) {
    final theme = Theme.of(context);

    if (courses.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(30),
        alignment: Alignment.center,
        child: Text(
          'no_courses_available'.tr,
          style: theme.textTheme.bodyMedium,
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: courses.length,
      itemBuilder: (context, index) {
        final course = courses[index];
        return CourseCard(course: course);
      },
    );
  }

  Widget _buildAnnouncementsList(
    BuildContext context,
    List announcements,
    AnnouncementController controller,
  ) {
    final theme = Theme.of(context);

    if (announcements.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(30),
        alignment: Alignment.center,
        child: Text(
          'no_announcements'.tr,
          style: theme.textTheme.bodyMedium,
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: announcements.length,
      itemBuilder: (context, index) {
        final item = announcements[index];
        return AnnouncementCard(
          item: item,
          controller: controller,
          onLikeTap: () => this.controller.likeAnnouncement(item.id),
          onCommentTap: () {
            controller.fetchComments(item.id);
            Get.bottomSheet(
              CommentsBottomSheet(item: item, controller: controller),
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
            );
          },
        );
      },
    );
  }
}
