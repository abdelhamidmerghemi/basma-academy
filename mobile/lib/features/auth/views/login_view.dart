import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/theme/theme_config.dart';
import '../../../core/theme/premium_interactions.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/widgets/primary_button.dart';

class LoginView extends GetView<AuthController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: FadeInTranslateCard(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 28.0,
                vertical: 24.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),

                  Center(
                    child: _DriftingAsset(
                      imagePath: 'assets/images/login.png',
                      errorWidget: Container(
                        height: 160,
                        width: 160,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: theme.primaryColor.withOpacity(0.08),
                        ),
                        child: Icon(
                          Icons.vpn_key_rounded,
                          size: 64,
                          color: theme.primaryColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),

                  Text(
                    'welcome_back'.tr,
                    style: theme.textTheme.headlineLarge
                        ?.copyWith(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        )
                        .withArabicCheck('welcome_back'.tr),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'login_subtitle'.tr,
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(
                          color: theme.textTheme.bodySmall?.color,
                        )
                        .withArabicCheck('login_subtitle'.tr),
                  ),
                  const SizedBox(height: 36),

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
                  const SizedBox(height: 32),

                  Obx(
                    () => PrimaryButton(
                      text: 'send_otp'.tr,
                      isLoading: controller.isLoading.value,
                      onPressed: () => controller.requestLoginOtp(),
                    ),
                  ),
                  const SizedBox(height: 32),

                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color: theme.dividerColor,
                          thickness: 1,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          'or'.tr,
                          style: theme.textTheme.bodySmall
                              ?.copyWith(
                                color: theme.disabledColor,
                                fontWeight: FontWeight.bold,
                              )
                              .withArabicCheck('or'.tr),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          color: theme.dividerColor,
                          thickness: 1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  BouncingButton(
                    onTap: () => controller.loginWithGoogle(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: theme.dividerColor,
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/google_logo.png',
                            height: 20,
                            width: 20,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(
                                  Icons.g_mobiledata_rounded,
                                  size: 24,
                                ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'sign_in_google'.tr,
                            style: theme.textTheme.bodyMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: theme.textTheme.bodyLarge?.color,
                                )
                                .withArabicCheck('sign_in_google'.tr),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'no_account'.tr,
                        style: theme.textTheme.bodyMedium
                            ?.copyWith(
                              color: theme.disabledColor,
                            )
                            .withArabicCheck('no_account'.tr),
                      ),
                      TextButton(
                        onPressed: () {
                          HapticHelper.lightTap();
                          Get.toNamed(AppRoutes.register);
                        },
                        child: Text(
                          'register_now'.tr,
                          style: theme.textTheme.bodyMedium
                              ?.copyWith(
                                color: theme.primaryColor,
                                fontWeight: FontWeight.bold,
                              )
                              .withArabicCheck('register_now'.tr),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
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
