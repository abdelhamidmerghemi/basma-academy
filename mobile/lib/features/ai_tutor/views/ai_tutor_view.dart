import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/theme/theme_config.dart';
import '../../../../core/widgets/custom_confirmation_dialog.dart';
import '../controllers/ai_tutor_controller.dart';
import 'widgets/chat_bubble_widget.dart';
import 'widgets/prompt_chip_widget.dart';
import 'widgets/inline_voice_waveform_widget.dart';

class AiTutorView extends GetView<AiTutorController> {
  const AiTutorView({super.key});

  void _showImagePickerSheet(BuildContext context) {
    final theme = Theme.of(context);
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.dividerColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'scan_exercise_title'.tr,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: theme.textTheme.titleLarge?.color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'scan_exercise_subtitle'.tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: theme.textTheme.bodySmall?.color,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Get.back();
                      controller.pickImage(ImageSource.camera);
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: ThemeConfig.primaryColor.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: ThemeConfig.primaryColor.withOpacity(0.3),
                        ),
                      ),
                      child: Column(
                        children: [
                          const Icon(
                            CupertinoIcons.camera_fill,
                            color: ThemeConfig.primaryColor,
                            size: 32,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'take_photo'.tr,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: ThemeConfig.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Get.back();
                      controller.pickImage(ImageSource.gallery);
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceVariant,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: theme.dividerColor),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            CupertinoIcons.photo_fill_on_rectangle_fill,
                            color: theme.textTheme.bodyLarge?.color,
                            size: 32,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'from_gallery'.tr,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: theme.textTheme.bodyLarge?.color,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: ThemeConfig.primaryColor.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.smart_toy_rounded,
                color: ThemeConfig.primaryColor,
                size: 22,
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ai_tutor_title'.tr,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  'ai_tutor_status'.tr,
                  style: const TextStyle(fontSize: 11, color: Colors.green),
                ),
              ],
            ),
          ],
        ),
        elevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
        actions: [
          PopupMenuButton<String>(
            icon: Icon(
              Icons.more_vert_rounded,
              color: theme.textTheme.bodyLarge?.color,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            color: theme.cardColor,
            elevation: 3,
            onSelected: (value) {
              if (value == 'clear') {
                CustomConfirmationDialog.show(
                  context,
                  title: 'clear_chat_title'.tr,
                  message: 'clear_chat_confirm_msg'.tr,
                  icon: Icons.delete_outline_rounded,
                  iconColor: ThemeConfig.errorColor,
                  confirmText: 'clear_chat_action'.tr,
                  cancelText: 'cancel'.tr,
                  isDanger: true,
                  onConfirm: () {
                    controller.clearHistory();
                  },
                );
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem<String>(
                value: 'clear',
                child: Row(
                  children: [
                    Icon(
                      Icons.delete_outline_rounded,
                      size: 20,
                      color: ThemeConfig.errorColor,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'clear_chat_action'.tr,
                      style: TextStyle(
                        fontSize: 14,
                        color: ThemeConfig.errorColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(
              () => ListView.builder(
                controller: controller.scrollController,
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                itemCount: controller.messages.length,
                itemBuilder: (context, index) {
                  final msg = controller.messages[index];
                  return ChatBubbleWidget(message: msg);
                },
              ),
            ),
          ),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: controller.suggestedPromptChips.map((prompt) {
                return Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: PromptChipWidget(
                    label: prompt,
                    onTap: () => controller.sendUserPrompt(prompt),
                  ),
                );
              }).toList(),
            ),
          ),

          Obx(() {
            if (controller.selectedImagePath.value.isEmpty) {
              return const SizedBox.shrink();
            }
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: ThemeConfig.primaryColor.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(
                      File(controller.selectedImagePath.value),
                      width: 52,
                      height: 52,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'attached_exercise'.tr,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'ai_will_solve'.tr,
                          style: TextStyle(
                            fontSize: 11,
                            color: theme.textTheme.bodySmall?.color,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, size: 20),
                    onPressed: () => controller.clearSelectedImage(),
                  ),
                ],
              ),
            );
          }),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      CupertinoIcons.camera_viewfinder,
                      color: ThemeConfig.primaryColor,
                      size: 26,
                    ),
                    onPressed: () => _showImagePickerSheet(context),
                  ),

                  Obx(() {
                    final isListening = controller.voiceState.value == VoiceState.listening;
                    return IconButton(
                      icon: Icon(
                        isListening
                            ? CupertinoIcons.stop_circle_fill
                            : CupertinoIcons.mic_circle_fill,
                        color: isListening ? Colors.redAccent : ThemeConfig.primaryColor,
                        size: 28,
                      ),
                      onPressed: () {
                        if (isListening) {
                          controller.stopVoiceListening();
                        } else {
                          controller.startVoiceListening();
                        }
                      },
                    );
                  }),
                  const SizedBox(width: 4),

                  Expanded(
                    child: Obx(() {
                      final isListening = controller.voiceState.value == VoiceState.listening;
                      if (isListening) {
                        return InlineVoiceWaveformWidget(
                          soundLevel: controller.soundLevel.value,
                        );
                      }

                      return TextField(
                        controller: controller.textController,
                        textDirection: TextDirection.rtl,
                        decoration: InputDecoration(
                          hintText: 'ai_tutor_hint'.tr,
                          hintStyle: TextStyle(fontSize: 13, color: Colors.grey.shade500),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: theme.colorScheme.surfaceVariant,
                        ),
                        onSubmitted: (val) => controller.sendUserPrompt(val),
                      );
                    }),
                  ),
                  const SizedBox(width: 10),
                  Obx(
                    () => CircleAvatar(
                      radius: 24,
                      backgroundColor: ThemeConfig.primaryColor,
                      child: controller.isGenerating.value
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: Colors.white,
                              ),
                            )
                          : IconButton(
                              icon: const Icon(
                                Icons.send_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                              onPressed: () => controller.sendUserPrompt(
                                controller.textController.text,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
