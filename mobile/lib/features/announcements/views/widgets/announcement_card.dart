import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../../core/widgets/custom_profile_avatar.dart';
import '../../../../core/widgets/smart_image.dart';
import '../../models/announcement_model.dart';
import '../../controllers/announcement_controller.dart';
import '../../../../core/widgets/parsed_link_text.dart';
import '../../../../core/theme/theme_config.dart';
import '../../../../core/routes/app_routes.dart';

class AnnouncementCard extends StatelessWidget {
  final AnnouncementModel item;
  final AnnouncementController controller;
  final VoidCallback onCommentTap;
  final VoidCallback? onLikeTap;

  const AnnouncementCard({
    super.key,
    required this.item,
    required this.controller,
    required this.onCommentTap,
    this.onLikeTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (!item.isViewed) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.recordView(item.id);
      });
    }

    final subTextColor = theme.textTheme.bodySmall?.color;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.dividerColor, width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
            child: GestureDetector(
              onTap: () {
                final targetId = item.teacherId ?? item.userId;
                debugPrint('flutter: [AnnouncementTap] Announcement ID=${item.id}, teacherName=${item.teacherName}, teacherId=${item.teacherId}, userId=${item.userId} -> Navigating to TeacherProfile ID=$targetId');
                if (targetId > 0) {
                  Get.toNamed(AppRoutes.TEACHER_PROFILE, arguments: {'id': targetId});
                }
              },
              behavior: HitTestBehavior.opaque,
              child: Row(
                children: [
                  CustomProfileAvatar(
                    avatarUrl: item.teacherAvatarUrl,
                    name: item.teacherName,
                    radius: 20,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                item.teacherName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: (theme.textTheme.bodyLarge ?? const TextStyle())
                                    .copyWith(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    )
                                    .withArabicCheck(item.teacherName),
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              CupertinoIcons.checkmark_seal_fill,
                              color: theme.primaryColor,
                              size: 16,
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Text(
                              _formatRelativeDate(item.createdAt),
                              style: theme.textTheme.bodySmall?.copyWith(fontSize: 12),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '•',
                              style: theme.textTheme.bodySmall?.copyWith(fontSize: 12),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              CupertinoIcons.globe,
                              size: 12,
                              color: subTextColor,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14.0),
            child: ParsedLinkText(
              text: item.content,
              style: (theme.textTheme.bodyMedium ?? const TextStyle()).copyWith(
                fontSize: 14.5,
                height: 1.55,
              ),
            ),
          ),

          if (item.imagePath != null && item.imagePath!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0),
              child: SmartImage(
                imagePath: item.imagePath,
                width: double.infinity,
                height: 190,
                fit: BoxFit.cover,
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ],

          const SizedBox(height: 12),
          Divider(
            height: 1,
            thickness: 1,
            color: theme.dividerColor,
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
            child: Row(
              children: [
                InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: onLikeTap ?? () => controller.likeAnnouncement(item.id),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                    child: Row(
                      children: [
                        Icon(
                          item.isLiked
                              ? CupertinoIcons.heart_fill
                              : CupertinoIcons.heart,
                          color: item.isLiked ? Colors.redAccent : subTextColor,
                          size: 20,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          '${item.likesCount}',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: item.isLiked ? Colors.redAccent : subTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: onCommentTap,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                    child: Row(
                      children: [
                        Icon(
                          CupertinoIcons.chat_bubble,
                          color: subTextColor,
                          size: 19,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          '${item.commentsCount}',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: subTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                  child: Row(
                    children: [
                      Icon(
                        CupertinoIcons.eye,
                        color: subTextColor,
                        size: 18,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        '${item.viewsCount}',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: subTextColor,
                        ),
                      ),
                    ],
                  ),
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatRelativeDate(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays >= 1) {
      if (difference.inDays == 1) {
        return 'day_ago'.tr;
      }
      return 'days_ago'.trParams({'days': '${difference.inDays}'});
    } else if (difference.inHours >= 1) {
      if (difference.inHours == 1) {
        return 'hour_ago'.tr;
      }
      return 'hours_ago'.trParams({'hours': '${difference.inHours}'});
    } else if (difference.inMinutes >= 1) {
      if (difference.inMinutes == 1) {
        return 'minute_ago'.tr;
      }
      return 'minutes_ago'.trParams({'minutes': '${difference.inMinutes}'});
    } else {
      return 'just_now'.tr;
    }
  }
}
