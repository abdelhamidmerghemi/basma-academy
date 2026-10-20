import 'package:flutter/material.dart';
import '../theme/theme_config.dart';
import '../theme/premium_interactions.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;

  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        // Resolve a finite maximum width to prevent animation interpolation crashes
        final double maxWidth = constraints.maxWidth == double.infinity
            ? MediaQuery.of(context).size.width - 56
            : constraints.maxWidth;

        return Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            width: isLoading ? 52.0 : maxWidth,
            height: 52,
            child: BouncingButton(
              onTap: isLoading ? null : onPressed,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [theme.primaryColor, theme.colorScheme.secondary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(isLoading ? 26 : 16),
                  boxShadow: [
                    BoxShadow(
                      color: theme.primaryColor.withOpacity(0.35),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Center(
                  child: isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          text,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            letterSpacing: 0.5,
                          ).withArabicCheck(text),
                        ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
