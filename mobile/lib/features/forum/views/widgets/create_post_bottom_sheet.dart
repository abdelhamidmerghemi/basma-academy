import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../../core/theme/premium_interactions.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../controllers/forum_controller.dart';

class CreatePostBottomSheet extends GetView<ForumController> {
  const CreatePostBottomSheet({super.key});

  static Future<void> show(BuildContext context) {
    HapticHelper.heavyTap();
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const CreatePostBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: theme.dialogBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 25,
              offset: const Offset(0, -5),
            )
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: theme.dividerColor,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: theme.primaryColor.withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      CupertinoIcons.chat_bubble_2_fill,
                      color: theme.primaryColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'create_post_title'.tr,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: Icon(Icons.close_rounded, color: theme.disabledColor),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              Text(
                'post_type_label'.tr,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 8),
              Obx(() {
                return Row(
                  children: [
                    _buildTypeChip(context, 'question', 'question_label'.tr, Colors.indigo),
                    const SizedBox(width: 8),
                    _buildTypeChip(context, 'discussion', 'discussion_label'.tr, Colors.teal),
                    const SizedBox(width: 8),
                    _buildTypeChip(context, 'resource', 'resource_label'.tr, Colors.amber.shade800),
                  ],
                );
              }),
              const SizedBox(height: 16),

              Text(
                'select_subject_optional'.tr,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 8),
              Obx(() {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: theme.dividerColor.withOpacity(0.5)),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<int?>(
                      value: controller.createSubjectId.value,
                      isExpanded: true,
                      hint: Text('all_subjects_option'.tr, style: TextStyle(color: theme.disabledColor, fontSize: 14)),
                      dropdownColor: theme.cardColor,
                      items: [
                        DropdownMenuItem<int?>(
                          value: null,
                          child: Text('all_subjects_option'.tr, style: const TextStyle(fontSize: 14)),
                        ),
                        ...controller.subjects.map((sub) {
                          return DropdownMenuItem<int?>(
                            value: sub.id,
                            child: Text(sub.nameAr, style: const TextStyle(fontSize: 14)),
                          );
                        }),
                      ],
                      onChanged: (val) => controller.setCreateSubjectId(val),
                    ),
                  ),
                );
              }),
              const SizedBox(height: 16),

              Text(
                'post_title_label'.tr,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: controller.createTitleController,
                style: const TextStyle(fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'post_title_hint'.tr,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
              const SizedBox(height: 16),

              Text(
                'post_content_label'.tr,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: controller.createContentController,
                maxLines: 4,
                style: const TextStyle(fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'post_content_hint'.tr,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
              const SizedBox(height: 16),

              Obx(() {
                final image = controller.createSelectedImage.value;
                return Row(
                  children: [
                    OutlinedButton.icon(
                      onPressed: () => controller.pickNewPostImage(),
                      icon: const Icon(CupertinoIcons.photo, size: 18),
                      label: Text(image == null ? 'attach_image'.tr : 'change_image'.tr),
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    if (image != null) ...[
                      const SizedBox(width: 12),
                      Expanded(
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(image, width: 40, height: 40, fit: BoxFit.cover),
                            ),
                            IconButton(
                              onPressed: () => controller.clearNewPostImage(),
                              icon: const Icon(Icons.cancel_rounded, color: Colors.redAccent),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                );
              }),
              const SizedBox(height: 24),

              Obx(() {
                return PrimaryButton(
                  text: 'publish_post'.tr,
                  isLoading: controller.isSubmitting.value,
                  onPressed: () async {
                    final success = await controller.submitNewPost();
                    if (success) {
                      Get.back();
                      Get.snackbar(
                        'success'.tr,
                        'post_published_success'.tr,
                        snackPosition: SnackPosition.TOP,
                        backgroundColor: theme.primaryColor,
                        colorText: Colors.white,
                      );
                    }
                  },
                );
              }),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeChip(BuildContext context, String typeKey, String label, Color color) {
    final isSelected = controller.createType.value == typeKey;
    final theme = Theme.of(context);

    return Expanded(
      child: GestureDetector(
        onTap: () => controller.setCreateType(typeKey),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? color.withOpacity(0.15) : theme.dividerColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? color : Colors.transparent,
              width: 1.5,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected ? color : theme.textTheme.bodyMedium?.color,
            ),
          ),
        ),
      ),
    );
  }
}
