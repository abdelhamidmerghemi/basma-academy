import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../../../core/theme/theme_config.dart';
import '../../../core/theme/premium_interactions.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/widgets/primary_button.dart';

class RegisterView extends GetView<AuthController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final List<Map<String, dynamic>> streamsList = [
      {
        'value': 'BAC_Sciences',
        'label': 'BAC_Sciences'.tr,
        'icon': Icons.science_rounded,
      },
      {
        'value': 'BAC_Maths',
        'label': 'BAC_Maths'.tr,
        'icon': Icons.calculate_rounded,
      },
      {
        'value': 'BAC_Technique',
        'label': 'BAC_Technique'.tr,
        'icon': Icons.settings_suggest_rounded,
      },
      {
        'value': 'BAC_Lettres',
        'label': 'BAC_Lettres'.tr,
        'icon': Icons.history_edu_rounded,
      },
      {
        'value': 'BAC_Languages',
        'label': 'BAC_Languages'.tr,
        'icon': Icons.translate_rounded,
      },
      {
        'value': 'BAC_Gestion',
        'label': 'BAC_Gestion'.tr,
        'icon': Icons.analytics_rounded,
      },
    ];

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Obx(
          () => controller.registerStep.value == 1
              ? IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: theme.primaryColor,
                  ),
                  onPressed: () {
                    HapticHelper.lightTap();
                    controller.goToPreviousRegisterStep();
                  },
                )
              : IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: theme.primaryColor,
                  ),
                  onPressed: () {
                    HapticHelper.lightTap();
                    Get.back();
                  },
                ),
        ),
      ),
      body: SafeArea(
        child: FadeInTranslateCard(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 28.0,
                vertical: 12.0,
              ),
              child: Obx(
                () => AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  switchInCurve: Curves.easeOutCubic,
                  switchOutCurve: Curves.easeInCubic,
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0.05, 0),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      ),
                    );
                  },
                  child: controller.registerStep.value == 0
                      ? _buildStep1(context, theme)
                      : _buildStep2(context, theme, streamsList),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStep1(
    BuildContext context,
    ThemeData theme,
  ) {
    return Column(
      key: const ValueKey<int>(0),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: _DriftingAsset(
            imagePath: 'assets/images/register.png',
            errorWidget: Container(
              height: 160,
              width: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.primaryColor.withOpacity(0.08),
              ),
              child: Icon(
                Icons.school_rounded,
                size: 64,
                color: theme.primaryColor,
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),

        Text(
          'create_account'.tr,
          style: theme.textTheme.headlineLarge
              ?.copyWith(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                height: 1.2,
              )
              .withArabicCheck('create_account'.tr),
        ),
        const SizedBox(height: 8),
        Text(
          'register_subtitle'.tr,
          style: theme.textTheme.bodyMedium
              ?.copyWith(
                color: theme.textTheme.bodySmall?.color,
              )
              .withArabicCheck('register_subtitle'.tr),
        ),
        const SizedBox(height: 32),

        CustomTextField(
          controller: controller.nameController,
          labelText: 'name'.tr,
          hintText: 'name_hint'.tr,
          prefixIcon: Icons.person_outline_rounded,
        ),
        const SizedBox(height: 24),

        Obx(() {
          final isGoogle = controller.isGoogleRegistration.value;
          return CustomTextField(
            controller: controller.emailController,
            labelText: 'email'.tr,
            hintText: 'email_hint'.tr,
            prefixIcon: Icons.email_outlined,
            readOnly: isGoogle,
            enabled: !isGoogle,
            keyboardType: TextInputType.emailAddress,
          );
        }),
        const SizedBox(height: 24),

        Obx(() {
          if (controller.isGoogleRegistration.value) {
            return const SizedBox.shrink();
          }
          return Column(
            children: [
              CustomTextField(
                controller: controller.passwordController,
                labelText: 'password'.tr,
                hintText: 'password_hint'.tr,
                prefixIcon: Icons.lock_outline_rounded,
                keyboardType: TextInputType.visiblePassword,
                obscureText: !controller.isPasswordVisible.value,
                suffixIcon: IconButton(
                  icon: Icon(
                    controller.isPasswordVisible.value
                        ? Icons.visibility_rounded
                        : Icons.visibility_off_rounded,
                    color: theme.primaryColor,
                  ),
                  onPressed: () => controller.togglePasswordVisibility(),
                ),
              ),
              const SizedBox(height: 24),
            ],
          );
        }),

        CustomTextField(
          controller: controller.phoneController,
          labelText: 'phone_number'.tr,
          hintText: 'phone_hint'.tr,
          prefixIcon: Icons.phone_iphone_rounded,
          prefix: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Text(
              '🇩🇿 +213 ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: theme.textTheme.bodyLarge?.color,
              ),
            ),
          ),
          keyboardType: TextInputType.phone,
          textDirection: TextDirection.ltr,
        ),
        const SizedBox(height: 36),

        Obx(
          () => PrimaryButton(
            text: 'next'.tr,
            isLoading: controller.isLoading.value,
            onPressed: () => controller.goToNextRegisterStep(),
          ),
        ),
        const SizedBox(height: 28),

        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'already_have_account'.tr,
                style: theme.textTheme.bodyMedium
                    ?.copyWith(
                      color: theme.disabledColor,
                    )
                    .withArabicCheck('already_have_account'.tr),
              ),
              TextButton(
                onPressed: () {
                  HapticHelper.lightTap();
                  Get.back();
                },
                child: Text(
                  'login'.tr,
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(
                        color: theme.primaryColor,
                        fontWeight: FontWeight.bold,
                      )
                      .withArabicCheck('login'.tr),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildStep2(
    BuildContext context,
    ThemeData theme,
    List<Map<String, dynamic>> streamsList,
  ) {
    return Column(
      key: const ValueKey<int>(1),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: _DriftingAsset(
            imagePath: 'assets/images/register.png',
            errorWidget: Container(
              height: 140,
              width: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.primaryColor.withOpacity(0.08),
              ),
              child: Icon(
                Icons.school_rounded,
                size: 56,
                color: theme.primaryColor,
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),

        Text(
          'academic_year'.tr,
          style: theme.textTheme.headlineLarge
              ?.copyWith(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                height: 1.2,
              )
              .withArabicCheck('academic_year'.tr),
        ),
        const SizedBox(height: 8),
        Text(
          'select_stream'.tr,
          style: theme.textTheme.bodyMedium
              ?.copyWith(
                color: theme.textTheme.bodySmall?.color,
              )
              .withArabicCheck('select_stream'.tr),
        ),
        const SizedBox(height: 28),

        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 14,
            crossAxisSpacing: 14,
            childAspectRatio: 1.5,
          ),
          itemCount: streamsList.length,
          itemBuilder: (context, index) {
            final stream = streamsList[index];
            return Obx(() {
              final isSelected =
                  controller.selectedStream.value == stream['value'];
              return BouncingButton(
                onTap: () {
                  controller.selectedStream.value = stream['value'];
                  HapticHelper.selectionClick();
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOutCubic,
                  transform: isSelected
                      ? Matrix4.translationValues(0, -6, 0)
                      : Matrix4.identity(),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? theme.primaryColor.withOpacity(0.06)
                        : theme.cardColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected
                          ? theme.primaryColor
                          : theme.dividerColor,
                      width: isSelected ? 2.0 : 1.2,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: theme.primaryColor.withOpacity(0.12),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ]
                        : [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.02),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        stream['icon'],
                        color: isSelected
                            ? theme.primaryColor
                            : theme.iconTheme.color?.withOpacity(0.7),
                        size: 26,
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          stream['label'],
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyMedium
                              ?.copyWith(
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.w500,
                                color: isSelected
                                    ? theme.primaryColor
                                    : theme.textTheme.bodyLarge?.color,
                              )
                              .withArabicCheck(stream['label']),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            });
          },
        ),
        const SizedBox(height: 44),

        Obx(
          () => PrimaryButton(
            text: 'send_otp'.tr,
            isLoading: controller.isLoading.value,
            onPressed: () => controller.requestRegisterOtp(),
          ),
        ),
      ],
    );
  }
}

class _DriftingAsset extends StatefulWidget {
  final String imagePath;
  final Widget errorWidget;

  const _DriftingAsset({
    required this.imagePath,
    required this.errorWidget,
  });

  @override
  State<_DriftingAsset> createState() => _DriftingAssetState();
}

class _DriftingAssetState extends State<_DriftingAsset>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: -6.0, end: 6.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _animation.value),
          child: child,
        );
      },
      child: Image.asset(
        widget.imagePath,
        height: 160,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => widget.errorWidget,
      ),
    );
  }
}
