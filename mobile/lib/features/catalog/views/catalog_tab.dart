import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/theme_config.dart';
import '../controllers/catalog_controller.dart';
import 'widgets/course_card.dart';

class CatalogTab extends GetView<CatalogController> {
  const CatalogTab({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'search'.tr,
                    style: (theme.textTheme.headlineLarge ?? const TextStyle()).copyWith(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ).withArabicCheck('search'.tr),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: theme.dividerColor,
                        width: 1.5,
                      ),
                    ),
                    child: Obx(() {
                      final query = controller.searchQuery.value;
                      final isRtl = RegExp(r'[\u0600-\u06FF]').hasMatch(query);
                      return TextField(
                        controller: controller.searchController,
                        textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
                        style: (theme.textTheme.bodyMedium ?? const TextStyle())
                            .copyWith(fontSize: 14)
                            .withArabicCheck(query),
                        decoration: InputDecoration(
                          hintText: 'search_hint'.tr,
                          hintStyle: (theme.textTheme.bodySmall ?? const TextStyle())
                              .copyWith(fontSize: 14)
                              .withArabicCheck(query),
                          prefixIcon: Icon(
                            Icons.search_rounded,
                            color: theme.primaryColor,
                            size: 24,
                          ),
                          suffixIcon: query.isEmpty
                              ? const SizedBox.shrink()
                              : IconButton(
                                  icon: const Icon(Icons.close_rounded, size: 20),
                                  onPressed: () => controller.searchController.clear(),
                                ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            SizedBox(
              height: 48,
              child: Obx(() {
                if (controller.isLoadingSubjects.value) {
                  return const SizedBox.shrink();
                }

                final selectedId = controller.selectedSubjectId.value;

                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  itemCount: controller.subjects.length + 1,
                  itemBuilder: (context, index) {
                    final bool isAllChip = index == 0;
                    final bool isSelected = isAllChip
                        ? selectedId == null
                        : selectedId == controller.subjects[index - 1].id;

                    final String chipLabel = isAllChip
                        ? 'all'.tr
                        : controller.subjects[index - 1].name.tr;

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: ChoiceChip(
                        label: Text(
                          chipLabel,
                          style: (theme.textTheme.bodyMedium ?? const TextStyle()).copyWith(
                            fontSize: 13,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSelected ? Colors.white : theme.textTheme.bodyLarge?.color,
                          ).withArabicCheck(chipLabel),
                        ),
                        selected: isSelected,
                        onSelected: (selected) {
                          if (selected) {
                            controller.filterBySubject(
                              isAllChip ? null : controller.subjects[index - 1].id,
                            );
                          }
                        },
                        selectedColor: theme.primaryColor,
                        backgroundColor: theme.cardColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: isSelected ? theme.primaryColor : theme.dividerColor,
                            width: 1.5,
                          ),
                        ),
                        showCheckmark: false,
                      ),
                    );
                  },
                );
              }),
            ),
            const SizedBox(height: 16),

            Expanded(
              child: Obx(() {
                if (controller.isLoadingCourses.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.courses.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.school_rounded,
                            size: 72,
                            color: theme.primaryColor.withOpacity(0.4),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'no_courses_available'.tr,
                            textAlign: TextAlign.center,
                            style: (theme.textTheme.bodyLarge ?? const TextStyle()).copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ).withArabicCheck('no_courses_available'.tr),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 96),
                  itemCount: controller.courses.length,
                  itemBuilder: (context, index) {
                    final course = controller.courses[index];

                    return CourseCard(course: course);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
