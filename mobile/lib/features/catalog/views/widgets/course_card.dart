import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/theme_config.dart';
import '../../../../core/theme/premium_interactions.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/widgets/smart_image.dart';
import '../../models/course_model.dart';

class CourseCard extends StatelessWidget {
  final CourseModel course;
  final VoidCallback? onTap;

  const CourseCard({
    super.key,
    required this.course,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BouncingButton(
      onTap: onTap ??
          () {
            HapticHelper.lightTap();
            Get.toNamed(AppRoutes.COURSE_DETAILS, arguments: course.id);
          },
      child: Container(
        padding: const EdgeInsets.all(14),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: theme.dividerColor, width: 1),
        ),
        child: Row(
          children: [
            SmartImage(
              imagePath: course.thumbnailPath,
              width: 70,
              height: 70,
              fit: BoxFit.cover,
              borderRadius: BorderRadius.circular(14),
              placeholder: _coursePlaceholder(theme),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: (theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ) ?? const TextStyle()).withArabicCheck(course.title),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    course.teacherName,
                    style: (theme.textTheme.bodySmall?.copyWith(
                      fontSize: 12,
                    ) ?? const TextStyle()).withArabicCheck(course.teacherName),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.star_rounded,
                            size: 14,
                            color: ThemeConfig.accentAmber,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            course.averageRating.toStringAsFixed(1),
                            style: (theme.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ) ?? const TextStyle()).withArabicCheck(
                              course.averageRating.toStringAsFixed(1),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '${course.priceDzd.toStringAsFixed(0)} ${'dzd'.tr}',
                        style: TextStyle(
                          color: theme.primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ).withArabicCheck('dzd'.tr),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _coursePlaceholder(ThemeData theme) {
    return Container(
      width: 70,
      height: 70,
      color: theme.primaryColor.withOpacity(0.08),
      child: Icon(
        Icons.auto_stories_rounded,
        color: theme.primaryColor,
        size: 32,
      ),
    );
  }
}
