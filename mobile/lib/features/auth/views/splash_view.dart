import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/utils/local_storage.dart';
import '../../../core/theme/theme_config.dart';
import '../controllers/auth_controller.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> with SingleTickerProviderStateMixin {
  late final AnimationController _floatController;

  @override
  void initState() {
    super.initState();

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    Future.delayed(const Duration(milliseconds: 1800), () {
      if (mounted) {
        _onAnimationComplete();
      }
    });
  }

  @override
  void dispose() {
    _floatController.dispose();
    super.dispose();
  }

  void _onAnimationComplete() async {
    final String token = LocalStorage.getToken();
    if (token.isNotEmpty) {
      final authController = Get.find<AuthController>();
      final bool ok = await authController.checkAuthAndFetchProfile();
      if (ok) {
        Get.offAllNamed(AppRoutes.dashboard);
      } else {
        Get.offAllNamed(AppRoutes.login);
      }
    } else if (LocalStorage.hasSeenOnboarding()) {
      Get.offAllNamed(AppRoutes.login);
    } else {
      Get.offAllNamed(AppRoutes.onboarding);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF090D16), Color(0xFF0F172A)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
            AnimatedBuilder(
              animation: _floatController,
              builder: (context, child) {
                return CustomPaint(
                  size: MediaQuery.of(context).size,
                  painter: _ParticlesPainter(_floatController.value),
                );
              },
            ),

            Center(
              child: Image.asset(
                'assets/images/3d_logo.png',
                width: 160,
                height: 160,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: ThemeConfig.primaryColor.withOpacity(0.1),
                  ),
                  child: const Icon(
                    Icons.school_rounded,
                    color: ThemeConfig.primaryColor,
                    size: 64,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ParticlesPainter extends CustomPainter {
  final double animationValue;

  _ParticlesPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF7C3AED).withOpacity(0.08)
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);

    final double dy1 = size.height * 0.35 + (sin(animationValue * pi * 2) * 15);
    final double dy2 = size.height * 0.65 - (cos(animationValue * pi * 2) * 20);

    canvas.drawCircle(Offset(size.width * 0.25, dy1), 90, paint);
    canvas.drawCircle(
      Offset(size.width * 0.75, dy2),
      110,
      paint..color = const Color(0xFF2563EB).withOpacity(0.06),
    );
  }

  @override
  bool shouldRepaint(covariant _ParticlesPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
