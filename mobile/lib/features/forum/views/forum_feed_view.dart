import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../core/theme/premium_interactions.dart';
import '../../../core/widgets/custom_profile_avatar.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/widgets/smart_image.dart';
import '../controllers/forum_controller.dart';
import '../models/forum_post_model.dart';
import 'widgets/create_post_bottom_sheet.dart';
import 'post_details_view.dart';

class ForumFeedView extends GetView<ForumController> {
  const ForumFeedView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ForumController());
    final theme = Theme.of(context);

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => CreatePostBottomSheet.show(context),
        backgroundColor: theme.primaryColor,
        elevation: 4,
        icon: const Icon(CupertinoIcons.add, color: Colors.white),
        label: Text(
          'ask_question'.tr,
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'forum_label'.tr,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 14),

                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 52,
                          decoration: BoxDecoration(
                            color: theme.cardColor,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: theme.dividerColor, width: 1),
                          ),
                          child: TextField(
                            controller: controller.searchController,
                            onSubmitted: (_) => controller.fetchFeed(),
                            style: theme.textTheme.bodyMedium?.copyWith(fontSize: 14),
                            decoration: InputDecoration(
                              hintText: 'forum_search_hint'.tr,
                              hintStyle: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.textTheme.bodySmall?.color,
                                fontSize: 13.5,
                              ),
                              prefixIcon: Icon(
                                Icons.search_rounded,
                                color: theme.textTheme.bodySmall?.color,
                                size: 20,
                              ),
                              suffixIcon: controller.searchController.text.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(Icons.close_rounded, size: 18),
                                      onPressed: () {
                                        controller.searchController.clear();
                                        controller.fetchFeed();
                                      },
                                    )
                                  : null,
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),

                      Obx(() {
                        final hasFilters = controller.hasActiveFilters;
                        return BouncingButton(
                          onTap: () {
                            HapticHelper.selectionClick();
                            _showForumFilterSheet(context, controller);
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
                  ),
                ],
              ),
            ),

            Expanded(
              child: Obx(() {
                if (controller.isLoadingFeed.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.posts.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(CupertinoIcons.chat_bubble_text, size: 64, color: theme.disabledColor),
                        const SizedBox(height: 14),
                        Text(
                          'no_posts_found'.tr,
                          style: theme.textTheme.titleMedium?.copyWith(color: theme.disabledColor),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: PrimaryButton(
                            text: 'be_first_to_ask'.tr,
                            onPressed: () => CreatePostBottomSheet.show(context),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: controller.fetchFeed,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: controller.posts.length,
                    itemBuilder: (context, index) {
                      final post = controller.posts[index];
                      return _ForumPostCard(post: post, controller: controller);
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  void _showForumFilterSheet(BuildContext context, ForumController controller) {
    final theme = Theme.of(context);

    final sortOptions = [
      {'value': 'latest', 'label': 'sort_latest'.tr},
      {'value': 'popular', 'label': 'sort_popular'.tr},
      {'value': 'unanswered', 'label': 'sort_unanswered'.tr},
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
                  'filter_discussions'.tr,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Obx(() {
                  if (!controller.hasActiveFilters) {
                    return const SizedBox.shrink();
                  }
                  return GestureDetector(
                    onTap: () {
                      HapticHelper.lightTap();
                      controller.resetFilters();
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
                      'post_type_label'.tr,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.disabledColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Obx(() {
                      return Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _buildFilterChoiceChip(
                            context,
                            'forum_all'.tr,
                            controller.selectedType.value == 'all',
                            () => controller.filterByType('all'),
                          ),
                          _buildFilterChoiceChip(
                            context,
                            'forum_questions'.tr,
                            controller.selectedType.value == 'question',
                            () => controller.filterByType('question'),
                          ),
                          _buildFilterChoiceChip(
                            context,
                            'forum_discussions'.tr,
                            controller.selectedType.value == 'discussion',
                            () => controller.filterByType('discussion'),
                          ),
                          _buildFilterChoiceChip(
                            context,
                            'forum_resources'.tr,
                            controller.selectedType.value == 'resource',
                            () => controller.filterByType('resource'),
                          ),
                        ],
                      );
                    }),
                    const SizedBox(height: 20),

                    Text(
                      'sort_by'.tr,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.disabledColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Obx(() {
                      return Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: sortOptions.map((opt) {
                          final isSelected = controller.sortBy.value == opt['value'];
                          return _buildFilterChoiceChip(
                            context,
                            opt['label']!,
                            isSelected,
                            () => controller.setSortBy(opt['value']!),
                          );
                        }).toList(),
                      );
                    }),
                    const SizedBox(height: 20),

                    Obx(() {
                      if (controller.subjects.isEmpty) return const SizedBox.shrink();
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'select_subject_optional'.tr,
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.disabledColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              _buildFilterChoiceChip(
                                context,
                                'all_subjects'.tr,
                                controller.selectedSubjectId.value == null,
                                () => controller.filterBySubject(null),
                              ),
                              ...controller.subjects.map((sub) {
                                final isSelected = controller.selectedSubjectId.value == sub.id;
                                return _buildFilterChoiceChip(
                                  context,
                                  sub.nameAr,
                                  isSelected,
                                  () => controller.filterBySubject(sub.id),
                                );
                              }),
                            ],
                          ),
                          const SizedBox(height: 20),
                        ],
                      );
                    }),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            PrimaryButton(
              text: 'apply'.tr,
              onPressed: () => Get.back(),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildFilterChoiceChip(
    BuildContext context,
    String label,
    bool isSelected,
    VoidCallback onTap,
  ) {
    final theme = Theme.of(context);
    return ChoiceChip(
      label: Text(
        label,
        style: TextStyle(
          fontSize: 12.5,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? Colors.white : theme.textTheme.bodyMedium?.color,
        ),
      ),
      selected: isSelected,
      onSelected: (_) {
        HapticHelper.selectionClick();
        onTap();
      },
      selectedColor: theme.primaryColor,
      backgroundColor: theme.cardColor,
      checkmarkColor: Colors.white,
      side: BorderSide(
        color: isSelected ? theme.primaryColor : theme.dividerColor,
      ),
    );
  }
}

class _ForumPostCard extends StatelessWidget {
  final ForumPostModel post;
  final ForumController controller;

  const _ForumPostCard({required this.post, required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (!post.isViewed) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.recordView(post.id);
      });
    }

    Color typeColor = Colors.indigo;
    String typeLabel = 'question_label'.tr;
    if (post.type == 'discussion') {
      typeColor = Colors.teal;
      typeLabel = 'discussion_label'.tr;
    } else if (post.type == 'resource') {
      typeColor = Colors.amber.shade900;
      typeLabel = 'resource_label'.tr;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: theme.dividerColor.withOpacity(0.4)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          HapticHelper.selectionClick();
          Get.to(() => PostDetailsView(postId: post.id));
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CustomProfileAvatar(
                    avatarUrl: post.userAvatar,
                    name: post.userName,
                    radius: 20,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          post.userName,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          controller.timeAgo(post.createdAt),
                          style: theme.textTheme.bodySmall?.copyWith(color: theme.disabledColor),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: typeColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      typeLabel,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: typeColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              if (post.subjectNameAr != null) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: theme.dividerColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    post.subjectNameAr!,
                    style: TextStyle(fontSize: 11, color: theme.disabledColor),
                  ),
                ),
                const SizedBox(height: 8),
              ],

              Text(
                post.title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 6),

              Text(
                post.content,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.textTheme.bodyMedium?.color?.withOpacity(0.85),
                  height: 1.45,
                ),
              ),

              if (post.imagePath != null && post.imagePath!.isNotEmpty) ...[
                const SizedBox(height: 12),
                SmartImage(
                  imagePath: post.imagePath,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  borderRadius: BorderRadius.circular(14),
                ),
              ],

              if (post.isSolved) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.green.withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.check_circle_rounded, color: Colors.green, size: 16),
                      const SizedBox(width: 6),
                      Text(
                        'question_solved'.tr,
                        style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 14),
              Divider(height: 1, color: theme.dividerColor.withOpacity(0.3)),
              const SizedBox(height: 10),

              Row(
                children: [
                  InkWell(
                    onTap: () {
                      HapticHelper.lightTap();
                      controller.togglePostLike(post.id);
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: Row(
                        children: [
                          Icon(
                            post.isLiked ? CupertinoIcons.hand_thumbsup_fill : CupertinoIcons.hand_thumbsup,
                            size: 18,
                            color: post.isLiked ? theme.primaryColor : theme.disabledColor,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${post.likesCount}',
                            style: TextStyle(
                              fontWeight: post.isLiked ? FontWeight.bold : FontWeight.normal,
                              color: post.isLiked ? theme.primaryColor : null,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),

                  Row(
                    children: [
                      Icon(CupertinoIcons.chat_bubble, size: 18, color: theme.disabledColor),
                      const SizedBox(width: 6),
                      Text('comments_count'.trParams({'count': '${post.repliesCount}'})),
                    ],
                  ),
                  const Spacer(),

                  Row(
                    children: [
                      Icon(CupertinoIcons.eye, size: 16, color: theme.disabledColor),
                      const SizedBox(width: 4),
                      Text('${post.viewsCount}', style: TextStyle(fontSize: 12, color: theme.disabledColor)),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
