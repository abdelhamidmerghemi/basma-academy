import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../../core/widgets/custom_profile_avatar.dart';
import 'package:image_picker/image_picker.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/widgets/primary_button.dart';

class EditProfileView extends GetView<AuthController> {
  const EditProfileView({super.key});

  static const List<String> _streamOptions = [
    'BAC_Sciences',
    'BAC_Maths',
    'BAC_Gestion',
    'BAC_Languages',
    'BAC_Lettres',
  ];

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await ImagePicker().pickImage(
        source: source,
        maxWidth: 1000,
        maxHeight: 1000,
        imageQuality: 80,
      );
      if (pickedFile != null) {
        controller.profileAvatarFile.value = File(pickedFile.path);
      }
    } catch (e) {
      debugPrint('Error picking profile image: $e');
    }
  }

  void _showImageSourcePicker(BuildContext context) {
    final theme = Theme.of(context);

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          border: Border.all(color: theme.dividerColor, width: 1),
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
            const SizedBox(height: 24),
            Text(
              'choose_image'.tr,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Get.back();
                      _pickImage(ImageSource.camera);
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                        color: theme.primaryColor.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: theme.primaryColor.withOpacity(0.2),
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            CupertinoIcons.camera_fill,
                            color: theme.primaryColor,
                            size: 28,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'camera'.tr,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Get.back();
                      _pickImage(ImageSource.gallery);
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                        color: theme.primaryColor.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: theme.primaryColor.withOpacity(0.2),
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            CupertinoIcons.photo_fill,
                            color: theme.primaryColor,
                            size: 28,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'gallery'.tr,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showStreamPicker(BuildContext context) {
    final theme = Theme.of(context);

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          border: Border.all(color: theme.dividerColor, width: 1),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.dividerColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'academic_year'.tr,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: _streamOptions.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final streamKey = _streamOptions[index];

                  return Obx(() {
                    final isSelected =
                        streamKey == controller.selectedStream.value;

                    return InkWell(
                      onTap: () {
                        controller.selectedStream.value = streamKey;
                        Get.back();
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? theme.primaryColor.withOpacity(0.08)
                              : theme.inputDecorationTheme.fillColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? theme.primaryColor
                                : theme.dividerColor,
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                streamKey.tr,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  color: isSelected
                                      ? theme.primaryColor
                                      : theme.textTheme.bodyLarge?.color,
                                ),
                              ),
                            ),
                            if (isSelected)
                              Icon(
                                Icons.check_circle_rounded,
                                color: theme.primaryColor,
                                size: 20,
                              ),
                          ],
                        ),
                      ),
                    );
                  });
                },
              ),
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
        title: Text(
          'edit_profile'.tr,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: GestureDetector(
                        onTap: () => _showImageSourcePicker(context),
                        child: Stack(
                          children: [
                            Obx(() {
                              final localFile =
                                  controller.profileAvatarFile.value;
                              final user = controller.currentUser.value;

                              return CustomProfileAvatar(
                                avatarUrl: user?.avatarUrl,
                                localFile: localFile,
                                name: user?.name,
                                radius: 48,
                                showBorder: true,
                              );
                            }),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: theme.primaryColor,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: theme.scaffoldBackgroundColor,
                                    width: 1.5,
                                  ),
                                ),
                                child: const Icon(
                                  CupertinoIcons.camera_fill,
                                  color: Colors.white,
                                  size: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Center(
                      child: Obx(
                        () => Text(
                          controller.currentUser.value?.email ?? '',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.textTheme.bodySmall?.color,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 36),

                    CustomTextField(
                      controller: controller.nameController,
                      labelText: 'name'.tr,
                      prefixIcon: CupertinoIcons.person,
                    ),
                    const SizedBox(height: 24),

                    CustomTextField(
                      controller: controller.phoneController,
                      labelText: 'phone_number'.tr,
                      prefixIcon: CupertinoIcons.phone,
                      enabled: false,
                      suffixIcon: Icon(
                        CupertinoIcons.lock_fill,
                        color: theme.textTheme.bodySmall?.color?.withOpacity(
                          0.4,
                        ),
                        size: 16,
                      ),
                    ),
                    const SizedBox(height: 24),

                    CustomTextField(
                      controller: controller.emailController,
                      labelText: 'email'.tr,
                      prefixIcon: CupertinoIcons.mail,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 24),

                    GestureDetector(
                      onTap: () => _showStreamPicker(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          color: theme.inputDecorationTheme.fillColor,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: theme.dividerColor,
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.school_outlined,
                              color: theme.primaryColor,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Obx(
                                () => Text(
                                  controller.selectedStream.value.tr,
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            Icon(
                              CupertinoIcons.chevron_down,
                              color: theme.textTheme.bodySmall?.color,
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    CustomTextField(
                      controller: controller.schoolNameController,
                      labelText: 'school_name'.tr,
                      hintText: 'school_name_hint'.tr,
                      prefixIcon: CupertinoIcons.building_2_fill,
                    ),
                    const SizedBox(height: 24),

                    CustomTextField(
                      controller: controller.wilayaCodeController,
                      labelText: 'wilaya_code'.tr,
                      hintText: 'select_wilaya'.tr,
                      prefixIcon: CupertinoIcons.location_solid,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 24),

                    Obx(
                      () => CustomTextField(
                        controller: controller.passwordController,
                        labelText: 'password'.tr,
                        prefixIcon: CupertinoIcons.lock,
                        obscureText: controller.isObscureProfilePassword.value,
                        suffixIcon: IconButton(
                          icon: Icon(
                            controller.isObscureProfilePassword.value
                                ? CupertinoIcons.eye_slash_fill
                                : CupertinoIcons.eye_fill,
                            color: theme.textTheme.bodySmall?.color
                                ?.withOpacity(0.6),
                            size: 20,
                          ),
                          onPressed: controller.toggleProfilePasswordVisibility,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Obx(
                () => PrimaryButton(
                  text: 'save_changes'.tr,
                  isLoading: controller.isLoading.value,
                  onPressed: () async {
                    if (controller.nameController.text.trim().isEmpty) {
                      Get.snackbar(
                        'error'.tr,
                        'name_required'.tr,
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.redAccent,
                        colorText: Colors.white,
                      );
                      return;
                    }

                    final success = await controller.updateProfile(
                      name: controller.nameController.text.trim(),
                      email: controller.emailController.text.trim().isNotEmpty
                          ? controller.emailController.text.trim()
                          : null,
                      schoolName:
                          controller.schoolNameController.text.trim().isNotEmpty
                          ? controller.schoolNameController.text.trim()
                          : null,
                      wilayaCode: int.tryParse(
                        controller.wilayaCodeController.text.trim(),
                      ),
                      password: controller.passwordController.text.isNotEmpty
                          ? controller.passwordController.text
                          : null,
                      stream: controller.selectedStream.value,
                      avatar: controller.profileAvatarFile.value,
                    );

                    if (success) {
                      Get.back();
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
