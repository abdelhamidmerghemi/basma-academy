import 'dart:math' as math;
import 'package:flutter/material.dart';

class InlineVoiceWaveformWidget extends StatefulWidget {
  final double soundLevel;

  const InlineVoiceWaveformWidget({
    super.key,
    required this.soundLevel,
  });

  @override
  State<InlineVoiceWaveformWidget> createState() => _InlineVoiceWaveformWidgetState();
}

class _InlineVoiceWaveformWidgetState extends State<InlineVoiceWaveformWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: primaryColor.withOpacity(0.3),
        ),
      ),
      child: Center(
        child: AnimatedBuilder(
          animation: _animController,
          builder: (context, _) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(18, (index) {
                final waveOffset = math.sin((_animController.value * math.pi * 2) + (index * 0.4));
                final height = 6 + (widget.soundLevel * 24) + (waveOffset.abs() * 12);
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2.5),
                  width: 3.5,
                  height: height.clamp(4.0, 32.0),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.85),
                    borderRadius: BorderRadius.circular(2),
                  ),
                );
              }),
            );
          },
        ),
      ),
    );
  }
}
