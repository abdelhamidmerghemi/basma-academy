import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import '../controllers/auth_controller.dart';
import '../../../core/theme/theme_config.dart';
import '../../../core/theme/premium_interactions.dart';
import '../../../core/widgets/primary_button.dart';

class OtpView extends StatefulWidget {
  const OtpView({super.key});

  @override
  State<OtpView> createState() => _OtpViewState();
}

class _OtpViewState extends State<OtpView> {
  final AuthController controller = Get.find<AuthController>();
  final StreamController<void> _shakeTrigger = StreamController<void>.broadcast();

  @override
  void initState() {
    super.initState();
    if (controller.otpSecondsRemaining.value == 0) {
      controller.startOtpTimer();
    }
  }

  @override
  void dispose() {
    _shakeTrigger.close();
    super.dispose();
  }

  void _triggerResend() {
    controller.resendOtp();
    HapticHelper.mediumTap();
  }

  void _verifyOtp() {
    if (controller.otpController.text.length < 6) {
      _shakeTrigger.add(null);
    } else {
      controller.verifyOtpAndLogin();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final targetPhone = controller.phoneController.text.trim();

    final defaultPinTheme = PinTheme(
      width: 48,
      height: 52,
      textStyle: TextStyle(
        fontFamily: 'Outfit',
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: theme.textTheme.bodyLarge?.color,
      ),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.dividerColor,
          width: 1.5,
        ),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        color: theme.cardColor,
        border: Border.all(
          color: theme.primaryColor,
          width: 2.0,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.primaryColor.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      textStyle: defaultPinTheme.textStyle!.copyWith(
        color: theme.primaryColor,
      ),
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(
          color: theme.primaryColor.withOpacity(0.5),
          width: 1.5,
        ),
      ),
    );

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: theme.primaryColor),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: FadeInTranslateCard(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: _DriftingAsset(
                      imagePath: 'assets/images/otp.png',
                      errorWidget: Container(
                        height: 160,
                        width: 160,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: theme.primaryColor.withOpacity(0.08),
                        ),
                        child: Icon(
                          Icons.mark_email_read_rounded,
                          size: 64,
                          color: theme.primaryColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  Text(
                    'verify'.tr,
                    style: theme.textTheme.headlineLarge?.copyWith(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ).withArabicCheck('verify'.tr),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '${'otp_desc'.tr} $targetPhone',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.textTheme.bodySmall?.color,
                      height: 1.4,
                    ).withArabicCheck('otp_desc'.tr),
                  ),
                  const SizedBox(height: 36),

                  _ShakeWidget(
                    trigger: _shakeTrigger.stream,
                    child: Center(
                      child: Directionality(
                        textDirection: TextDirection.ltr,
                        child: Pinput(
                          length: 6,
                          controller: controller.otpController,
                          keyboardType: TextInputType.number,
                          preFilledWidget: const SizedBox.shrink(),
                          defaultPinTheme: defaultPinTheme,
                          focusedPinTheme: focusedPinTheme,
                          submittedPinTheme: submittedPinTheme,
                          onCompleted: (pin) => _verifyOtp(),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),

                  Center(
                    child: Obx(() {
                      final seconds = controller.otpSecondsRemaining.value;
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (seconds > 0) ...[
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                SizedBox(
                                  width: 36,
                                  height: 36,
                                  child: CircularProgressIndicator(
                                    value: seconds / 59.0,
                                    strokeWidth: 3,
                                    backgroundColor: theme.dividerColor,
                                    valueColor: AlwaysStoppedAnimation<Color>(theme.primaryColor),
                                  ),
                                ),
                                Text(
                                  '${seconds}s',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 12),
                          ],
                          seconds > 0
                              ? Text(
                                  'resend_wait'.tr,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.disabledColor,
                                  ).withArabicCheck('resend_wait'.tr),
                                )
                              : BouncingButton(
                                  onTap: _triggerResend,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: theme.primaryColor.withOpacity(0.08),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      'resend_otp'.tr,
                                      style: theme.textTheme.bodyMedium?.copyWith(
                                        color: theme.primaryColor,
                                        fontWeight: FontWeight.bold,
                                      ).withArabicCheck('resend_otp'.tr),
                                    ),
                                  ),
                                ),
                        ],
                      );
                    }),
                  ),
                  const SizedBox(height: 40),

                  Obx(
                    () => PrimaryButton(
                      text: 'verify'.tr,
                      isLoading: controller.isLoading.value,
                      onPressed: _verifyOtp,
                    ),
                  ),
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

class _ShakeWidget extends StatefulWidget {
  final Widget child;
  final Stream<void> trigger;

  const _ShakeWidget({
    required this.child,
    required this.trigger,
  });

  @override
  State<_ShakeWidget> createState() => _ShakeWidgetState();
}

class _ShakeWidgetState extends State<_ShakeWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  StreamSubscription<void>? _subscription;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _subscription = widget.trigger.listen((_) {
      _controller.forward(from: 0.0);
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final double value = sin(_controller.value * pi * 4) * 8;
        return Transform.translate(
          offset: Offset(value, 0),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
