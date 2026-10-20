import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/widgets/custom_profile_avatar.dart';
import '../../models/announcement_model.dart';
import '../../controllers/announcement_controller.dart';
import '../../../../core/theme/theme_config.dart';

class CommentsBottomSheet extends StatelessWidget {
  final AnnouncementModel item;
  final AnnouncementController controller;

  const CommentsBottomSheet({
    super.key,
    required this.item,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12.0, sigmaY: 12.0),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.68,
          decoration: BoxDecoration(
            color: theme.cardColor.withOpacity(0.95),
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(32),
            ),
            border: Border.all(
              color: theme.dividerColor,
              width: 1.5,
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                height: 5,
                width: 50,
                decoration: BoxDecoration(
                  color: theme.dividerColor,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 12),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: theme.primaryColor.withOpacity(0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.chat_bubble_outline_rounded,
                        color: theme.primaryColor,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Text(
                      'comments'.tr,
                      style: (theme.textTheme.titleMedium ?? const TextStyle()).copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ).withArabicCheck('comments'.tr),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: theme.primaryColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Obx(() => Text(
                            '${controller.comments.length}',
                            style: (theme.textTheme.bodySmall ?? const TextStyle()).copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.primaryColor,
                            ),
                          )),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),

              Expanded(
                child: Obx(() {
                  if (controller.isLoadingComments.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (controller.comments.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.chat_bubble_outline_rounded,
                            size: 48,
                            color: theme.primaryColor.withOpacity(0.4),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'no_comments_yet'.tr,
                            style: (theme.textTheme.bodySmall ?? const TextStyle())
                                .copyWith(fontSize: 14)
                                .withArabicCheck('no_comments_yet'.tr),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(20.0),
                    itemCount: controller.comments.length,
                    itemBuilder: (context, idx) {
                      final comment = controller.comments[idx];

                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: theme.cardColor.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: theme.dividerColor.withOpacity(0.3),
                            width: 1.0,
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomProfileAvatar(
                              avatarUrl: comment.userAvatarUrl,
                              name: comment.userName,
                              radius: 18,
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    comment.userName,
                                    style: (theme.textTheme.bodySmall ?? const TextStyle())
                                        .copyWith(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                        )
                                        .withArabicCheck(comment.userName),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    comment.content,
                                    style: (theme.textTheme.bodyMedium ?? const TextStyle())
                                        .copyWith(
                                          fontSize: 13.5,
                                          height: 1.5,
                                        )
                                        .withArabicCheck(comment.content),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }),
              ),

              const Divider(height: 1, thickness: 1),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
                        decoration: BoxDecoration(
                          color: theme.inputDecorationTheme.fillColor ?? theme.scaffoldBackgroundColor,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: theme.dividerColor,
                            width: 1.0,
                          ),
                        ),
                        child: Obx(() {
                          final val = controller.commentTextRx.value;
                          final isRtl = RegExp(r'[\u0600-\u06FF]').hasMatch(val);
                          return TextField(
                            controller: controller.commentTextController,
                            focusNode: controller.commentFocusNode,
                            textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
                            onChanged: (v) => controller.commentTextRx.value = v,
                            style: (theme.textTheme.bodyMedium ?? const TextStyle())
                                .copyWith(fontSize: 14)
                                .withArabicCheck(val),
                            decoration: InputDecoration(
                              hintText: 'add_comment_hint'.tr,
                              hintStyle: (theme.textTheme.bodySmall ?? const TextStyle())
                                  .copyWith(fontSize: 14)
                                  .withArabicCheck(val),
                              border: InputBorder.none,
                            ),
                          );
                        }),
                      ),
                    ),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: () => controller.addComment(item.id),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Obx(() => controller.isSubmittingComment.value
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(
                                Icons.send_rounded,
                                color: Colors.white,
                                size: 18,
                              )),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
