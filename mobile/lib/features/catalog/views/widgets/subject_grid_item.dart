import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/subject_model.dart';
import '../../../../core/theme/theme_config.dart';
import '../../../../core/widgets/smart_image.dart';

class SubjectGridItem extends StatelessWidget {
  final SubjectModel sub;
  final VoidCallback onTap;

  const SubjectGridItem({
    super.key,
    required this.sub,
    required this.onTap,
  });

  Gradient _getGradientForSubject(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('math') || lower.contains('رياضيات')) {
      return const LinearGradient(
        colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    } else if (lower.contains('physic') || lower.contains('فيزياء')) {
      return const LinearGradient(
        colors: [Color(0xFF0EA5E9), Color(0xFF14B8A6)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    } else if (lower.contains('science') || lower.contains('علوم')) {
      return const LinearGradient(
        colors: [Color(0xFFD946EF), Color(0xFFEC4899)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    } else if (lower.contains('arab') || lower.contains('عربية')) {
      return const LinearGradient(
        colors: [Color(0xFFF43F5E), Color(0xFFF97316)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    } else if (lower.contains('philosoph') || lower.contains('فلسفة')) {
      return const LinearGradient(
        colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    }
    return const LinearGradient(
      colors: [Color(0xFF6366F1), Color(0xFF3B82F6)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  Color _getGlowColor(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('math') || lower.contains('رياضيات')) {
      return const Color(0xFF6366F1);
    } else if (lower.contains('physic') || lower.contains('فيزياء')) {
      return const Color(0xFF0EA5E9);
    } else if (lower.contains('science') || lower.contains('علوم')) {
      return const Color(0xFFD946EF);
    } else if (lower.contains('arab') || lower.contains('عربية')) {
      return const Color(0xFFF43F5E);
    } else if (lower.contains('philosoph') || lower.contains('فلسفة')) {
      return const Color(0xFFF59E0B);
    }
    return const Color(0xFF6366F1);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dark = theme.brightness == Brightness.dark;
    
    final subjectGradient = _getGradientForSubject(sub.name);
    final glowColor = _getGlowColor(sub.name);

    return Container(
      decoration: BoxDecoration(
        gradient: subjectGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: glowColor.withOpacity(dark ? 0.35 : 0.22),
            blurRadius: 16,
            spreadRadius: -4,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            splashColor: Colors.white.withOpacity(0.12),
            highlightColor: Colors.white.withOpacity(0.06),
            child: Stack(
              children: [
                Positioned(
                  right: -15,
                  top: -15,
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.1),
                    ),
                  ),
                ),
                
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 0.5, sigmaY: 0.5),
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: dark
                          ? Colors.black.withOpacity(0.12)
                          : Colors.white.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.18),
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withOpacity(0.25),
                              width: 1,
                            ),
                          ),
                          child: SmartImage(
                            imagePath: sub.thumbnailPath,
                            height: 22,
                            width: 22,
                            fit: BoxFit.cover,
                            borderRadius: BorderRadius.circular(8),
                            placeholder: const Icon(
                              Icons.menu_book_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          sub.name.tr,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            height: 1.25,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.25),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ).withArabicCheck(sub.name.tr),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
