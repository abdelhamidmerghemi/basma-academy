import 'package:flutter/material.dart';

class LanguageSelector extends StatelessWidget {
  final String currentLang;
  final ValueChanged<String> onSelect;

  const LanguageSelector({
    super.key,
    required this.currentLang,
    required this.onSelect,
  });

  static const _langs = [
    ('🇩🇿', 'العربية', 'ar'),
    ('🇫🇷', 'Français', 'fr'),
    ('🇬🇧', 'English', 'en'),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: List.generate(_langs.length, (i) {
        final (flag, name, langCode) = _langs[i];
        final isSelected = currentLang == langCode;

        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => onSelect(langCode),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
              child: Row(
                children: [
                  Text(flag, style: const TextStyle(fontSize: 22)),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      name,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                  if (isSelected)
                    Container(
                      width: 22,
                      height: 22,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check_rounded,
                        size: 14,
                        color: Colors.white,
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
