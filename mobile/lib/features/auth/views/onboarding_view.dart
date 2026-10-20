import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/theme/theme_config.dart';
import '../../../core/theme/premium_interactions.dart';
import '../../../core/utils/local_storage.dart';

class OnboardingView extends GetView<AuthController> {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final List<Map<String, dynamic>> slides = [
      {
        'title': 'onboarding_title_1'.tr,
        'desc': 'onboarding_desc_1'.tr,
        'image': 'assets/images/onboarding_1.png',
        'blobColor': const Color(0xFF2563EB).withOpacity(0.08),
      },
      {
        'title': 'onboarding_title_2'.tr,
        'desc': 'onboarding_desc_2'.tr,
        'image': 'assets/images/onboarding_2.png',
        'blobColor': const Color(0xFF7C3AED).withOpacity(0.08),
      },
      {
        'title': 'onboarding_title_3'.tr,
        'desc': 'onboarding_desc_3'.tr,
        'image': 'assets/images/onboarding_3.png',
        'blobColor': const Color(0xFFEC4899).withOpacity(0.08),
      },
    ];

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 12.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'select_lang'.tr,
                    style: theme.textTheme.titleSmall
                        ?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.textTheme.bodyLarge?.color,
                        )
                        .withArabicCheck('select_lang'.tr),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: theme.dividerColor, width: 1.2),
                    ),
                    child: Obx(
                      () => DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: controller.selectedLanguage.value,
                          icon: Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: theme.primaryColor,
                            size: 20,
                          ),
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.primaryColor,
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: 'ar',
                              child: Text('العربية'),
                            ),
                            DropdownMenuItem(
                              value: 'fr',
                              child: Text('Français'),
                            ),
                            DropdownMenuItem(
                              value: 'en',
                              child: Text('English'),
                            ),
                          ],
                          onChanged: (val) {
                            if (val != null) {
                              controller.changeLanguage(val);
                              HapticHelper.lightTap();
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: PageView.builder(
                controller: controller.pageController,
                itemCount: slides.length,
                onPageChanged: (index) {
                  controller.currentStep.value = index;
                  HapticHelper.mediumTap();
                },
                itemBuilder: (context, index) {
                  final slide = slides[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            ImageFiltered(
                              imageFilter: ImageFilter.blur(
                                sigmaX: 40,
                                sigmaY: 40,
                              ),
                              child: Container(
                                width: 200,
                                height: 200,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: slide['blobColor'],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 230,
                              child: Image.asset(
                                slide['image']!,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) =>
                                    Icon(
                                      Icons.image_outlined,
                                      size: 80,
                                      color: theme.primaryColor.withOpacity(
                                        0.4,
                                      ),
                                    ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),

                        Text(
                          slide['title'],
                          textAlign: TextAlign.center,
                          style: theme.textTheme.headlineLarge
                              ?.copyWith(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                height: 1.3,
                              )
                              .withArabicCheck(slide['title']),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          slide['desc'],
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium
                              ?.copyWith(
                                color: theme.textTheme.bodySmall?.color,
                                height: 1.5,
                              )
                              .withArabicCheck(slide['desc']),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(28.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(slides.length, (index) {
                      return Obx(() {
                        final isSelected =
                            controller.currentStep.value == index;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: isSelected ? 20 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: isSelected
                                ? theme.primaryColor
                                : theme.dividerColor,
                          ),
                        );
                      });
                    }),
                  ),
                  const SizedBox(height: 36),

                  Obx(() {
                    final isLastPage =
                        controller.currentStep.value == slides.length - 1;
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            HapticHelper.lightTap();
                            LocalStorage.setOnboardingSeen();
                            Get.offAllNamed(AppRoutes.login);
                          },
                          child: Text(
                            'skip'.tr,
                            style: theme.textTheme.bodyMedium
                                ?.copyWith(
                                  color: theme.disabledColor,
                                  fontWeight: FontWeight.bold,
                                )
                                .withArabicCheck('skip'.tr),
                          ),
                        ),

                        BouncingButton(
                          onTap: () {
                            HapticHelper.mediumTap();
                            if (isLastPage) {
                              LocalStorage.setOnboardingSeen();
                              Get.offAllNamed(AppRoutes.login);
                            } else {
                              controller.pageController.nextPage(
                                duration: const Duration(milliseconds: 350),
                                curve: Curves.easeOutCubic,
                              );
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: theme.primaryColor,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: theme.primaryColor.withOpacity(0.3),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Text(
                              isLastPage ? 'start'.tr : 'next'.tr,
                              style:
                                  const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ).withArabicCheck(
                                    isLastPage ? 'start'.tr : 'next'.tr,
                                  ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
