import 'dart:math';
import 'package:flutter/material.dart';

class RadialCountdownIndicator extends StatefulWidget {
  final double progress;
  final double size;
  final Widget child;

  const RadialCountdownIndicator({
    super.key,
    required this.progress,
    required this.size,
    required this.child,
  });

  @override
  State<RadialCountdownIndicator> createState() => _RadialCountdownIndicatorState();
}

class _RadialCountdownIndicatorState extends State<RadialCountdownIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _animation = Tween<double>(begin: 0.0, end: widget.progress).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant RadialCountdownIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.progress != widget.progress) {
      _animation = Tween<double>(begin: _animation.value, end: widget.progress).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOut),
      );
      _controller.forward(from: 0.0);
    }
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
        return CustomPaint(
          size: Size(widget.size, widget.size),
          painter: _RadialCountdownPainter(
            progress: _animation.value,
            primaryColor: Colors.white,
            glowColor: Colors.white.withOpacity(0.5),
            trackColor: Colors.white.withOpacity(0.15),
          ),
          child: SizedBox(
            width: widget.size,
            height: widget.size,
            child: Center(child: widget.child),
          ),
        );
      },
    );
  }
}

class _RadialCountdownPainter extends CustomPainter {
  final double progress;
  final Color primaryColor;
  final Color glowColor;
  final Color trackColor;

  _RadialCountdownPainter({
    required this.progress,
    required this.primaryColor,
    required this.glowColor,
    required this.trackColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width / 2, size.height / 2) - 6;

    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, trackPaint);

    final glowPaint = Paint()
      ..color = glowColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);

    // Arc starts from top (-pi / 2)
    const startAngle = -pi / 2;
    final sweepAngle = 2 * pi * progress;

    if (progress > 0.0) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        glowPaint,
      );

      final activePaint = Paint()
        ..color = primaryColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        activePaint,
      );

      final knobAngle = startAngle + sweepAngle;
      final knobX = center.dx + radius * cos(knobAngle);
      final knobY = center.dy + radius * sin(knobAngle);

      final knobGlowPaint = Paint()
        ..color = primaryColor
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

      canvas.drawCircle(Offset(knobX, knobY), 6, knobGlowPaint);
      canvas.drawCircle(Offset(knobX, knobY), 4, Paint()..color = Colors.white);
    }
  }

  @override
  bool shouldRepaint(covariant _RadialCountdownPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.primaryColor != primaryColor ||
        oldDelegate.glowColor != glowColor ||
        oldDelegate.trackColor != trackColor;
  }
}
