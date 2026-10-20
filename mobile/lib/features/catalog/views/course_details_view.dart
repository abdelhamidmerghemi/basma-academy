import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/theme_config.dart';
import '../../../core/theme/premium_interactions.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/widgets/parsed_link_text.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/widgets/custom_confirmation_dialog.dart';
import '../../../core/widgets/custom_profile_avatar.dart';
import '../../../core/widgets/smart_image.dart';
import '../controllers/course_details_controller.dart';
import 'widgets/custom_video_player.dart';
import '../models/course_model.dart';
import '../../profile/controllers/profile_controller.dart';

class CourseDetailsView extends GetView<CourseDetailsController> {
  const CourseDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final course = controller.course.value;
        if (course == null) {
          return Scaffold(
            appBar: AppBar(elevation: 0, backgroundColor: Colors.transparent),
            body: Center(
              child: Text(
                'course_not_found'.tr,
                style: theme.textTheme.bodyLarge,
              ),
            ),
          );
        }

        return DefaultTabController(
          length: 2,
          child: Column(
            children: [
              Expanded(
                child: NestedScrollView(
                  headerSliverBuilder: (context, innerBoxIsScrolled) {
                    return [
                      SliverToBoxAdapter(child: _buildVideoHeader(context)),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: theme.primaryColor.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  course.academicStream.tr,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                course.title,
                                style: theme.textTheme.titleLarge
                                    ?.copyWith(fontWeight: FontWeight.bold)
                                    .withArabicCheck(course.title),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  CustomProfileAvatar(
                                    avatarUrl: course.teacherAvatarUrl,
                                    name: course.teacherName,
                                    radius: 12,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    course.teacherName,
                                    style: theme.textTheme.bodyMedium
                                        ?.copyWith(
                                          color:
                                              theme.textTheme.bodySmall?.color,
                                        )
                                        .withArabicCheck(course.teacherName),
                                  ),
                                  const Spacer(),
                                  Icon(
                                    Icons.star_rounded,
                                    color: Colors.amber,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${course.averageRating.toStringAsFixed(1)} (${course.reviewsCount})',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              if (course.description != null &&
                                  course.description!.isNotEmpty) ...[
                                const SizedBox(height: 16),
                                 ParsedLinkText(
                                   text: course.description!,
                                   style: theme.textTheme.bodyMedium?.copyWith(
                                     height: 1.5,
                                     color: theme.textTheme.bodyMedium?.color
                                         ?.withOpacity(0.8),
                                   ),
                                 ),
                              ],
                            ],
                          ),
                        ),
                      ),
                      SliverPersistentHeader(
                        pinned: true,
                        delegate: _SliverTabHeaderDelegate(
                          child: Container(
                            color: theme.scaffoldBackgroundColor,
                            child: TabBar(
                              labelColor: theme.primaryColor,
                              unselectedLabelColor:
                                  theme.textTheme.bodySmall?.color,
                              indicatorColor: theme.primaryColor,
                              indicatorSize: TabBarIndicatorSize.tab,
                              dividerColor: theme.dividerColor,
                              tabs: [
                                Tab(text: 'course_lessons'.tr),
                                Tab(text: 'course_reviews'.tr),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ];
                  },
                  body: TabBarView(
                    children: [
                      _buildLessonsTab(context),
                      _buildReviewsTab(context),
                    ],
                  ),
                ),
              ),
              _buildBottomPurchaseBar(context),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildVideoHeader(BuildContext context) {
    final theme = Theme.of(context);
    final course = controller.course.value!;

    return Obx(() {
      final isPlaying =
          controller.activeLesson.value != null &&
          controller.isPlayerReady.value;

      return Stack(
        alignment: Alignment.center,
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: isPlaying
                ? Container(
                    color: Colors.black,
                    child: CustomVideoPlayer(),
                  )
                : SmartImage(
                    imagePath: course.thumbnailPath,
                    fit: BoxFit.cover,
                    placeholder: Container(
                      color: theme.primaryColor.withOpacity(0.05),
                      child: Icon(
                        Icons.menu_book_rounded,
                        size: 64,
                        color: theme.primaryColor,
                      ),
                    ),
                  ),
          ),

          if (!isPlaying)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.black.withOpacity(0.3), Colors.transparent],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
              ),
            ),

          if (!isPlaying && course.lessons != null && course.lessons!.isNotEmpty)
            GestureDetector(
              onTap: () {
                final preview = course.lessons!.firstWhere(
                  (e) => e.isPreview,
                  orElse: () => course.lessons!.first,
                );
                if (course.isUnlocked || preview.isPreview) {
                  controller.playLesson(preview);
                } else {
                  _showLockDialog(context, course);
                }
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.play_arrow_rounded,
                  color: theme.primaryColor,
                  size: 36,
                ),
              ),
            ),

          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 16,
            child: GestureDetector(
              onTap: () => Get.back(),
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Colors.black45,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildLessonsTab(BuildContext context) {
    final theme = Theme.of(context);
    final course = controller.course.value;
    if (course == null) return const SizedBox.shrink();
    final lessons = course.lessons ?? [];

    if (lessons.isEmpty) {
      return Center(
        child: Text(
          'course_empty_lessons'.tr,
          style: theme.textTheme.bodyMedium,
        ),
      );
    }

    final isUnlocked = controller.course.value?.isUnlocked ?? false;

    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: lessons.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final lesson = lessons[index];
        return Obx(() {
          final isCurrent = controller.activeLesson.value?.id == lesson.id;
          final canPlay = isUnlocked || lesson.isPreview;

          return InkWell(
            onTap: () {
              if (canPlay) {
                controller.playLesson(lesson);
              } else {
                _showLockDialog(context, course);
              }
            },
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isCurrent
                    ? theme.primaryColor.withOpacity(0.06)
                    : theme.cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isCurrent ? theme.primaryColor : theme.dividerColor,
                  width: 1.5,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: lesson.isCompleted && !isCurrent
                          ? Colors.green.withOpacity(0.12)
                          : (isCurrent
                              ? theme.primaryColor
                              : (canPlay
                                  ? theme.primaryColor.withOpacity(0.08)
                                  : theme.dividerColor.withOpacity(0.3))),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      lesson.isCompleted && !isCurrent
                          ? Icons.check_circle_rounded
                          : (canPlay
                              ? (isCurrent && controller.isPlaying.value
                                  ? Icons.pause_rounded
                                  : Icons.play_arrow_rounded)
                              : Icons.lock_rounded),
                      color: lesson.isCompleted && !isCurrent
                          ? Colors.green
                          : (isCurrent
                              ? Colors.white
                              : (canPlay ? theme.primaryColor : Colors.grey)),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          lesson.title,
                          style: theme.textTheme.bodyMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: isCurrent ? theme.primaryColor : null,
                              )
                              .withArabicCheck(lesson.title),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              _formatDuration(lesson.durationSeconds),
                              style: theme.textTheme.bodySmall,
                            ),
                            if (lesson.isPreview && !isUnlocked) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  'course_preview'.tr,
                                  style: const TextStyle(
                                    fontSize: 9,
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  Widget _buildReviewsTab(BuildContext context) {
    final theme = Theme.of(context);
    final course = controller.course.value;
    final reviews = course?.reviews ?? [];

    if (reviews.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.rate_review_outlined,
                size: 48,
                color: theme.textTheme.bodySmall?.color?.withOpacity(0.4),
              ),
              const SizedBox(height: 12),
              Text(
                'no_reviews'.tr,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.textTheme.bodySmall?.color,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: reviews.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final review = reviews[index];
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: theme.dividerColor, width: 1.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CustomProfileAvatar(
                    avatarUrl: review.userAvatar,
                    name: review.userName,
                    radius: 18,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          review.userName,
                          style: theme.textTheme.bodyMedium
                              ?.copyWith(fontWeight: FontWeight.bold)
                              .withArabicCheck(review.userName),
                        ),
                        Row(
                          children: List.generate(
                            5,
                            (starIndex) => Icon(
                              Icons.star_rounded,
                              size: 14,
                              color: starIndex < review.rating.floor()
                                  ? Colors.amber
                                  : Colors.grey.withOpacity(0.3),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ParsedLinkText(
                text: review.comment,
                style: theme.textTheme.bodyMedium?.copyWith(height: 1.4),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAddReviewBottomSheet(BuildContext context) {
    final theme = Theme.of(context);
    final rating = 5.0.obs;
    final commentCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.55),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
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
              const SizedBox(height: 20),
              Text(
                'write_review'.tr,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'write_review_desc'.tr,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: Obx(() => Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(5, (index) {
                        final starValue = (index + 1).toDouble();
                        final isSelected = starValue <= rating.value;
                        return IconButton(
                          onPressed: () {
                            HapticHelper.lightTap();
                            rating.value = starValue;
                          },
                          icon: Icon(
                            isSelected ? Icons.star_rounded : Icons.star_outline_rounded,
                            color: isSelected ? Colors.amber : theme.disabledColor,
                            size: 36,
                          ),
                        );
                      }),
                    )),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: commentCtrl,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'comment_hint'.tr,
                  filled: true,
                  fillColor: theme.cardColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: theme.dividerColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: theme.dividerColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: theme.primaryColor, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Obx(() => PrimaryButton(
                    text: 'submit_review'.tr,
                    isLoading: controller.isSubmittingReview.value,
                    onPressed: () async {
                      final comment = commentCtrl.text.trim();
                      if (comment.isEmpty) return;
                      final success = await controller.submitReview(
                        rating: rating.value,
                        comment: comment,
                      );
                      if (success) {
                        Get.back();

                        // Show success snackbar AFTER modal pop
                        Get.snackbar(
                          'success'.tr,
                          'review_submitted'.tr,
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.green,
                          colorText: Colors.white,
                          margin: const EdgeInsets.all(16),
                          borderRadius: 12,
                        );
                      }
                    },
                  )),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomPurchaseBar(BuildContext context) {
    final theme = Theme.of(context);
    final course = controller.course.value!;

    if (course.isUnlocked) {
      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: theme.cardColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 14,
          bottom: MediaQuery.of(context).padding.bottom + 14,
        ),
        child: PrimaryButton(
          text: 'write_review'.tr,
          onPressed: () => _showAddReviewBottomSheet(context),
        ),
      );
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 16,
        bottom: MediaQuery.of(context).padding.bottom + 16,
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('price'.tr, style: theme.textTheme.bodySmall),
              const SizedBox(height: 2),
              Text(
                '${course.priceDzd.toStringAsFixed(0)} DZD',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: theme.primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(width: 24),
          Expanded(
            child: PrimaryButton(
              text: 'course_buy'.tr,
              onPressed: () {
                if (Get.isRegistered<ProfileController>()) {
                  Get.find<ProfileController>().clearPaymentForm();
                }
                Get.toNamed(AppRoutes.payment, arguments: course);
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showLockDialog(BuildContext context, CourseModel course) {
    CustomConfirmationDialog.show(
      context,
      title: 'course_locked_warning_title'.tr,
      message: 'course_locked_warning_desc'.tr,
      icon: Icons.lock_rounded,
      confirmText: 'unlock_course'.tr,
      cancelText: 'close'.tr,
      onConfirm: () {
        if (Get.isRegistered<ProfileController>()) {
          Get.find<ProfileController>().clearPaymentForm();
        }
        Get.toNamed(AppRoutes.payment, arguments: course);
      },
    );
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}

class _SliverTabHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _SliverTabHeaderDelegate({required this.child});

  @override
  double get minExtent => 48;

  @override
  double get maxExtent => 48;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return child;
  }

  @override
  bool shouldRebuild(covariant _SliverTabHeaderDelegate oldDelegate) {
    return false;
  }
}
