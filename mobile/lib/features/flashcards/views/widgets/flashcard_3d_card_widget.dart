import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../../core/theme/theme_config.dart';
import '../../models/flashcard_model.dart';

class Flashcard3dCardWidget extends StatefulWidget {
  final FlashcardModel card;
  final bool isFlipped;
  final VoidCallback onTap;

  const Flashcard3dCardWidget({
    super.key,
    required this.card,
    required this.isFlipped,
    required this.onTap,
  });

  @override
  State<Flashcard3dCardWidget> createState() => _Flashcard3dCardWidgetState();
}

class _Flashcard3dCardWidgetState extends State<Flashcard3dCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutBack),
    );
    if (widget.isFlipped) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(Flashcard3dCardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isFlipped != oldWidget.isFlipped) {
      if (widget.isFlipped) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          final angle = _animation.value * pi;
          final isFront = angle < (pi / 2);

          return Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.0012)
              ..rotateY(angle),
            alignment: Alignment.center,
            child: isFront
                ? _buildFrontCard(theme)
                : Transform(
                    transform: Matrix4.identity()..rotateY(pi),
                    alignment: Alignment.center,
                    child: _buildBackCard(theme),
                  ),
          );
        },
      ),
    );
  }

  Widget _buildFrontCard(ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      height: 400,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  const Color(0xFF1E2638),
                  const Color(0xFF141923),
                ]
              : [
                  Colors.white,
                  const Color(0xFFF6F8FD),
                ],
        ),
        border: Border.all(
          color: theme.primaryColor.withOpacity(0.22),
          width: 1.8,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.primaryColor.withOpacity(isDark ? 0.25 : 0.12),
            blurRadius: 30,
            offset: const Offset(0, 14),
            spreadRadius: -4,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.4 : 0.06),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            bottom: -20,
            child: Opacity(
              opacity: isDark ? 0.04 : 0.06,
              child: Icon(
                CupertinoIcons.question_diamond_fill,
                size: 220,
                color: theme.primaryColor,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                      decoration: BoxDecoration(
                        color: theme.primaryColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: theme.primaryColor.withOpacity(0.25),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            CupertinoIcons.lightbulb_fill,
                            size: 14,
                            color: theme.primaryColor,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'flashcard_question_badge'.tr,
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.bold,
                              color: theme.primaryColor,
                            ).withArabicCheck('flashcard_question_badge'.tr),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      CupertinoIcons.arrow_2_squarepath,
                      size: 18,
                      color: theme.textTheme.bodySmall?.color?.withOpacity(0.6),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Text(
                        widget.card.questionText,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          height: 1.55,
                          color: theme.textTheme.titleLarge?.color,
                        ).withArabicCheck(widget.card.questionText),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.touch_app_rounded,
                      size: 16,
                      color: theme.primaryColor.withOpacity(0.7),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'flashcard_tap_to_flip'.tr,
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: theme.textTheme.bodySmall?.color,
                      ).withArabicCheck('flashcard_tap_to_flip'.tr),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackCard(ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;
    const accentColor = Color(0xFF10B981);

    return Container(
      width: double.infinity,
      height: 400,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  const Color(0xFF132A24),
                  const Color(0xFF0F1E1A),
                ]
              : [
                  const Color(0xFFECFDF5),
                  const Color(0xFFF0FDF4),
                ],
        ),
        border: Border.all(
          color: accentColor.withOpacity(0.35),
          width: 2.0,
        ),
        boxShadow: [
          BoxShadow(
            color: accentColor.withOpacity(isDark ? 0.3 : 0.15),
            blurRadius: 32,
            offset: const Offset(0, 14),
            spreadRadius: -4,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.4 : 0.06),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            left: -20,
            bottom: -20,
            child: Opacity(
              opacity: isDark ? 0.05 : 0.08,
              child: const Icon(
                CupertinoIcons.checkmark_seal_fill,
                size: 220,
                color: accentColor,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                      decoration: BoxDecoration(
                        color: accentColor.withOpacity(0.14),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: accentColor.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            CupertinoIcons.checkmark_alt_circle_fill,
                            size: 14,
                            color: accentColor,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'flashcard_answer_badge'.tr,
                            style: const TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.bold,
                              color: accentColor,
                            ).withArabicCheck('flashcard_answer_badge'.tr),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      CupertinoIcons.sparkles,
                      size: 18,
                      color: accentColor,
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Text(
                        widget.card.answerText,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 19.5,
                          fontWeight: FontWeight.w700,
                          height: 1.55,
                          color: theme.textTheme.titleLarge?.color,
                        ).withArabicCheck(widget.card.answerText),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      CupertinoIcons.star_fill,
                      size: 13,
                      color: accentColor,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'flashcard_rate_memorization'.tr,
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: theme.textTheme.bodySmall?.color,
                      ).withArabicCheck('flashcard_rate_memorization'.tr),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
