import 'dart:math' as math;
import 'package:flutter/material.dart';

class VoiceWaveformPainter extends CustomPainter {
  final double animationValue;
  final double soundLevel;
  final Color primaryColor;
  final bool isSpeaking;
  final bool isListening;

  VoiceWaveformPainter({
    required this.animationValue,
    required this.soundLevel,
    required this.primaryColor,
    required this.isSpeaking,
    required this.isListening,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final baseRadius = math.min(size.width, size.height) * 0.26;
    final normalizedLevel = soundLevel.clamp(0.0, 1.0);

    for (int i = 3; i >= 1; i--) {
      final auraRadius = baseRadius + (i * 22) + (normalizedLevel * 28) + (math.sin(animationValue * math.pi * 2 + i) * 6);
      final auraOpacity = (0.28 / i) * (isListening || isSpeaking ? 1.0 : 0.6);

      final auraPaint = Paint()
        ..color = primaryColor.withOpacity(auraOpacity.clamp(0.0, 0.5))
        ..style = PaintingStyle.fill
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 14.0 * i);

      canvas.drawCircle(center, auraRadius, auraPaint);
    }

    const int barCount = 36;
    final barPaint = Paint()
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3.5
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < barCount; i++) {
      final angle = (i * 2 * math.pi / barCount) + (animationValue * math.pi * 0.5);
      final waveOffset = math.sin((animationValue * math.pi * 4) + (i * 0.4));
      final dynamicHeight = 12 + (normalizedLevel * 38) + (waveOffset.abs() * 16);

      final innerPoint = Offset(
        center.dx + (baseRadius + 6) * math.cos(angle),
        center.dy + (baseRadius + 6) * math.sin(angle),
      );

      final outerPoint = Offset(
        center.dx + (baseRadius + 6 + dynamicHeight) * math.cos(angle),
        center.dy + (baseRadius + 6 + dynamicHeight) * math.sin(angle),
      );

      final barColor = Color.lerp(
        primaryColor,
        isSpeaking ? const Color(0xFF10B981) : (isListening ? const Color(0xFFF59E0B) : const Color(0xFF6366F1)),
        (i / barCount),
      ) ?? primaryColor;

      barPaint.color = barColor.withOpacity(0.85);
      canvas.drawLine(innerPoint, outerPoint, barPaint);
    }

    final gradient = RadialGradient(
      colors: [
        Colors.white,
        primaryColor,
        primaryColor.withOpacity(0.8),
        const Color(0xFF0F172A),
      ],
      stops: const [0.0, 0.45, 0.75, 1.0],
    );

    final corePaint = Paint()
      ..shader = gradient.createShader(
        Rect.fromCircle(center: center, radius: baseRadius),
      );

    canvas.drawCircle(center, baseRadius, corePaint);

    final innerLightRadius = baseRadius * (0.35 + (normalizedLevel * 0.25) + (math.sin(animationValue * math.pi * 4) * 0.08));
    final innerLightPaint = Paint()
      ..color = Colors.white.withOpacity(0.7)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);

    canvas.drawCircle(center, innerLightRadius, innerLightPaint);
  }

  @override
  bool shouldRepaint(covariant VoiceWaveformPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.soundLevel != soundLevel ||
        oldDelegate.isSpeaking != isSpeaking ||
        oldDelegate.isListening != isListening;
  }
}
